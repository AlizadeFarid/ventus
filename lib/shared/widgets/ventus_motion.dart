import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Fades and slides [child] up into place the first time it is built.
///
/// [index] staggers siblings: each one starts `index * step` after the first,
/// so a column of cards arrives in sequence instead of all at once. Skipped
/// entirely when the OS asks to reduce motion.
class VentusReveal extends StatefulWidget {
  const VentusReveal({
    super.key,
    required this.child,
    this.index = 0,
    this.step = const Duration(milliseconds: 70),
  });

  final Widget child;
  final int index;
  final Duration step;

  @override
  State<VentusReveal> createState() => _VentusRevealState();
}

class _VentusRevealState extends State<VentusReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  Timer? _delay;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }
    // Cap the stagger so a long list never makes the last row wait.
    final delay = widget.step * math.min(widget.index, 6);
    _delay = Timer(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(_curve),
        child: widget.child,
      ),
    );
  }
}

/// A number that counts up from zero when first shown, and animates between
/// values afterwards. Renders as plain text when motion is reduced.
class VentusCountUp extends StatelessWidget {
  const VentusCountUp({
    super.key,
    required this.value,
    required this.style,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 800),
  });

  final int value;
  final TextStyle style;
  final String suffix;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Text('$value$suffix', style: style, maxLines: 1);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => Text(
        '${v.round()}$suffix',
        style: style.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        maxLines: 1,
      ),
    );
  }
}

/// One-shot confetti burst painted over [child] — a small celebration for a
/// finished plan. Particles are deterministic, so it looks the same each time.
class VentusConfetti extends StatefulWidget {
  const VentusConfetti({super.key, required this.child, required this.colors});

  final Widget child;
  final List<Color> colors;

  @override
  State<VentusConfetti> createState() => _VentusConfettiState();
}

class _VentusConfettiState extends State<VentusConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!MediaQuery.disableAnimationsOf(context)) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) => CustomPaint(
                  painter: _ConfettiPainter(_controller.value, widget.colors),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.colors);

  final double t;
  final List<Color> colors;

  static const _count = 22;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    final random = math.Random(11);
    final origin = Offset(size.width * 0.18, size.height * 0.5);
    for (var i = 0; i < _count; i++) {
      final angle = -math.pi * (0.15 + random.nextDouble() * 0.7);
      final speed = 120 + random.nextDouble() * 220;
      final spin = random.nextDouble() * math.pi * 2;
      final color = colors[i % colors.length];
      final eased = Curves.easeOutCubic.transform(t);
      final dx = math.cos(angle) * speed * eased;
      // Launch upward, then let gravity pull the piece back down.
      final dy = math.sin(angle) * speed * eased + 260 * t * t;
      final fade = (1 - t).clamp(0.0, 1.0);
      final paint = Paint()..color = color.withValues(alpha: fade);
      canvas.save();
      canvas.translate(origin.dx + dx, origin.dy + dy);
      canvas.rotate(spin + t * 6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-3, -2, 7, 4),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
