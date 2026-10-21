import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// How strongly a [VentusTap] responds to a press.
enum VentusTapFeedback {
  /// Subtle scale-in. The default for cards, rows and tiles.
  scale,

  /// Scale plus a short fade. For photo tiles and other large surfaces where
  /// scale alone is hard to notice.
  scaleFade,

  /// No visual change — only the haptic. For controls that already animate
  /// their own state (checkboxes, hearts, segmented pills).
  none,
}

/// The standard tappable wrapper for Ventus.
///
/// The app used to reach for a bare [GestureDetector] everywhere, which gave
/// ~120 tappable surfaces (trip cards, module tiles, tool rows, menu rows,
/// discover cards …) **no press feedback at all**: a finger went down, nothing
/// moved, and the next screen simply appeared. Material's [InkWell] ripple is
/// the wrong fix here — the design system is borderless and shadow-based, and
/// a ripple reads as stock Android. This gives the same affordance the way the
/// design intends: a small scale-in plus a haptic tick, matching the press
/// interaction [VentusButton] already had.
///
/// Drop-in for the old pattern:
/// ```dart
/// GestureDetector(
///   onTap: ...,
///   behavior: HitTestBehavior.opaque,
///   child: ...,
/// )
/// ```
/// becomes `VentusTap(onTap: ..., child: ...)`.
///
/// A null [onTap] (and null [onLongPress]) disables the whole thing: no
/// feedback, no haptic, no hit testing.
class VentusTap extends StatefulWidget {
  const VentusTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.feedback = VentusTapFeedback.scale,
    this.haptics = true,
    this.pressedScale,
    this.padding,
    this.semanticLabel,
    this.isButton = true,
    this.excludeChildSemantics = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VentusTapFeedback feedback;

  /// Whether pressing fires a selection tick. Turn off for surfaces the user
  /// drags across (list rows inside a reorderable list) or when the action
  /// already plays its own, stronger haptic.
  final bool haptics;

  /// Overrides the scale the child shrinks to while pressed. Defaults to a
  /// size-aware value — large surfaces need a smaller delta than small ones to
  /// read as the same amount of movement.
  final double? pressedScale;

  /// Extra hit area around [child]. Use it to bring small glyph-only targets
  /// up to the 44×44 minimum without changing how the glyph looks.
  final EdgeInsetsGeometry? padding;

  /// Accessibility label. Set this whenever [child] is icon-only — a bare icon
  /// is invisible to a screen reader.
  final String? semanticLabel;

  /// Whether to announce this as a button. Set false for tappable regions that
  /// are not buttons (a whole card that opens a detail page is still a button;
  /// a "tap to dismiss" backdrop is not).
  final bool isButton;

  /// Drops the child's own semantics in favour of [semanticLabel]. Useful when
  /// the child renders decorative text that would otherwise be read twice.
  final bool excludeChildSemantics;

  @override
  State<VentusTap> createState() => _VentusTapState();
}

class _VentusTapState extends State<VentusTap> {
  bool _pressed = false;

  bool get _enabled => widget.onTap != null || widget.onLongPress != null;

  /// Bigger surfaces move less: a 0.97 scale on a full-width hero card is a
  /// large, distracting jump, while the same value on a 40px icon is barely
  /// visible. Resolved from the laid-out width at press time.
  double _resolveScale() {
    if (widget.pressedScale != null) return widget.pressedScale!;
    if (widget.feedback == VentusTapFeedback.none) return 1;
    final width = (context.findRenderObject() as RenderBox?)?.size.width ?? 0;
    if (width >= 280) return 0.985;
    if (width >= 120) return 0.972;
    return 0.94;
  }

  double _scale = 1;

  void _setPressed(bool value) {
    if (!mounted) return;
    setState(() {
      _pressed = value;
      if (value) _scale = _resolveScale();
    });
  }

  void _handleTap() {
    if (widget.haptics) HapticFeedback.selectionClick();
    widget.onTap!.call();
  }

  void _handleLongPress() {
    // A long press is a heavier, more deliberate action than a tap, so it gets
    // the heavier tick even when [haptics] only asked for the light one.
    HapticFeedback.mediumImpact();
    widget.onLongPress!.call();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;
    if (widget.padding != null) {
      content = Padding(padding: widget.padding!, child: content);
    }

    if (_enabled && widget.feedback != VentusTapFeedback.none) {
      content = AnimatedScale(
        scale: _pressed ? _scale : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.feedback == VentusTapFeedback.scaleFade
            ? AnimatedOpacity(
                opacity: _pressed ? 0.86 : 1,
                duration: const Duration(milliseconds: 110),
                child: content,
              )
            : content,
      );
    }

    return Semantics(
      button: widget.isButton && _enabled,
      enabled: _enabled,
      label: widget.semanticLabel,
      excludeSemantics: widget.excludeChildSemantics,
      child: GestureDetector(
        // Opaque so the whole padded box is tappable, not just the painted
        // pixels of the child.
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: _enabled ? () => _setPressed(false) : null,
        onTap: widget.onTap == null ? null : _handleTap,
        onLongPress: widget.onLongPress == null ? null : _handleLongPress,
        child: content,
      ),
    );
  }
}
