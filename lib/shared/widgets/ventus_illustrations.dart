import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';

/// Empty-state illustration: a suitcase with a dotted route up to a map pin.
///
/// Drawn in code from theme colours, so it follows light/dark and needs no
/// asset. Authored on a 160×120 canvas and scaled to [width].
class VentusTravelIllustration extends StatelessWidget {
  const VentusTravelIllustration({super.key, this.width = 168});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(width, width * 120 / 160),
        painter: _TravelPainter(
          soft: colors.primarySoft,
          primary: colors.primary,
          primaryDeep: colors.primaryPress,
          accent: colors.amber,
          ink: colors.ink,
          surface: colors.surface,
        ),
      ),
    );
  }
}

class _TravelPainter extends CustomPainter {
  _TravelPainter({
    required this.soft,
    required this.primary,
    required this.primaryDeep,
    required this.accent,
    required this.ink,
    required this.surface,
  });

  final Color soft;
  final Color primary;
  final Color primaryDeep;
  final Color accent;
  final Color ink;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 160, size.height / 120);

    // Backdrop.
    canvas.drawCircle(const Offset(80, 66), 50, Paint()..color = soft);

    // Dotted route from the suitcase up to the pin.
    final route = Path()
      ..moveTo(106, 66)
      ..quadraticBezierTo(136, 66, 124, 38);
    final dot = Paint()..color = primary.withValues(alpha: 0.55);
    for (final metric in route.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 7) {
        final p = metric.getTangentForOffset(d)!.position;
        canvas.drawCircle(p, 1.6, dot);
      }
    }

    // Suitcase: handle behind, body, straps, wheels.
    final handle = Paint()
      ..color = ink.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(69, 36, 26, 20),
        const Radius.circular(7),
      ),
      handle,
    );
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(50, 50, 62, 50),
      const Radius.circular(12),
    );
    canvas.drawRRect(body, Paint()..color = primary);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(50, 50, 62, 12),
        const Radius.circular(12),
      ),
      Paint()..color = primaryDeep.withValues(alpha: 0.35),
    );
    final strap = Paint()..color = surface.withValues(alpha: 0.42);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(64, 50, 5, 50),
        const Radius.circular(2.5),
      ),
      strap,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(93, 50, 5, 50),
        const Radius.circular(2.5),
      ),
      strap,
    );
    final wheel = Paint()..color = ink.withValues(alpha: 0.78);
    canvas.drawCircle(const Offset(63, 103), 3.4, wheel);
    canvas.drawCircle(const Offset(99, 103), 3.4, wheel);

    // Map pin.
    final pin = Path()
      ..moveTo(124, 54)
      ..cubicTo(112, 42, 112, 24, 124, 24)
      ..cubicTo(136, 24, 136, 42, 124, 54)
      ..close();
    canvas.drawPath(pin, Paint()..color = accent);
    canvas.drawCircle(const Offset(124, 35), 4.6, Paint()..color = surface);

    // Sparkles.
    _sparkle(canvas, const Offset(34, 40), 6, primary.withValues(alpha: 0.7));
    _sparkle(canvas, const Offset(138, 92), 4.5, accent.withValues(alpha: 0.8));
    _sparkle(
      canvas,
      const Offset(28, 88),
      3.5,
      primary.withValues(alpha: 0.45),
    );
  }

  void _sparkle(Canvas canvas, Offset c, double r, Color color) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final radius = i.isEven ? r : r * 0.32;
      final p = c + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path..close(), Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TravelPainter old) =>
      old.primary != primary || old.soft != soft || old.ink != ink;
}

/// Empty-state illustration for trip history: a passport with a travel stamp.
///
/// Same construction as [VentusTravelIllustration] — drawn in code from theme
/// colours on a 160×120 canvas — so the two read as one family.
class VentusPassportIllustration extends StatelessWidget {
  const VentusPassportIllustration({super.key, this.width = 168});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(width, width * 120 / 160),
        painter: _PassportPainter(
          soft: colors.primarySoft,
          primary: colors.primary,
          primaryDeep: colors.primaryPress,
          accent: colors.amber,
          ink: colors.ink,
          surface: colors.surface,
        ),
      ),
    );
  }
}

class _PassportPainter extends CustomPainter {
  _PassportPainter({
    required this.soft,
    required this.primary,
    required this.primaryDeep,
    required this.accent,
    required this.ink,
    required this.surface,
  });

  final Color soft;
  final Color primary;
  final Color primaryDeep;
  final Color accent;
  final Color ink;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 160, size.height / 120);

    // Backdrop.
    canvas.drawCircle(const Offset(80, 64), 50, Paint()..color = soft);

    // Passport: cover, spine, emblem and two text lines.
    final cover = RRect.fromRectAndRadius(
      const Rect.fromLTWH(54, 20, 54, 78),
      const Radius.circular(9),
    );
    canvas.drawRRect(cover, Paint()..color = primary);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(54, 20, 8, 78),
        topLeft: const Radius.circular(9),
        bottomLeft: const Radius.circular(9),
      ),
      Paint()..color = primaryDeep.withValues(alpha: 0.4),
    );

    final line = Paint()
      ..color = surface.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    const emblem = Offset(85, 52);
    canvas.drawCircle(emblem, 13, line);
    canvas.drawOval(
      Rect.fromCenter(center: emblem, width: 13, height: 26),
      line..strokeWidth = 1.8,
    );
    canvas.drawLine(
      emblem - const Offset(13, 0),
      emblem + const Offset(13, 0),
      line,
    );

    final text = Paint()..color = surface.withValues(alpha: 0.6);
    for (final y in [78.0, 86.0]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(72, y, y == 78 ? 26 : 18, 3.6),
          const Radius.circular(1.8),
        ),
        text,
      );
    }

    // Stamp overlapping the bottom-right corner.
    canvas.save();
    canvas.translate(110, 84);
    canvas.rotate(-0.28);
    final stamp = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset.zero, 15, stamp..strokeWidth = 3.2);
    canvas.drawCircle(Offset.zero, 9.5, stamp..strokeWidth = 1.6);
    final check = Path()
      ..moveTo(-4.5, 0.5)
      ..lineTo(-1, 4)
      ..lineTo(5, -3.5);
    canvas.drawPath(check, stamp..strokeWidth = 3);
    canvas.restore();

    // Sparkles.
    _sparkle(canvas, const Offset(34, 38), 6, primary.withValues(alpha: 0.7));
    _sparkle(
      canvas,
      const Offset(130, 34),
      4.5,
      accent.withValues(alpha: 0.85),
    );
    _sparkle(
      canvas,
      const Offset(30, 90),
      3.5,
      primary.withValues(alpha: 0.45),
    );
  }

  void _sparkle(Canvas canvas, Offset c, double r, Color color) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final radius = i.isEven ? r : r * 0.32;
      final p = c + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path..close(), Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PassportPainter old) =>
      old.primary != primary || old.soft != soft || old.surface != surface;
}
