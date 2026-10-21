import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';

/// Round control that sits on a collapsing photo header (back / share / more /
/// heart): a dark translucent disc over the photo, easing into the standard
/// surface disc with a shadow (never an outline) as the header collapses.
/// [collapse] is 0 when the photo is fully shown and 1 when collapsed.
class VentusHeroIconButton extends StatelessWidget {
  const VentusHeroIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.collapse,
    this.semanticLabel,
    this.activeColor,
  });

  final String icon;
  final VoidCallback onTap;
  final ValueListenable<double> collapse;
  final String? semanticLabel;

  /// Keeps the glyph this colour at every scroll position (e.g. a saved heart
  /// stays coral); otherwise it eases white → ink.
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: ValueListenableBuilder<double>(
        valueListenable: collapse,
        builder: (context, t, _) {
          final fill = Color.lerp(const Color(0x52141008), colors.surface, t)!;
          final iconColor =
              activeColor ?? Color.lerp(Colors.white, colors.ink, t)!;
          return Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10 * t),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: VentusIcon(icon, size: 19, color: iconColor),
          );
        },
      ),
    );
  }
}
