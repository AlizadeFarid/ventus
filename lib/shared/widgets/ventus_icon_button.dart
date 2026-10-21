import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';

/// Round 42px icon button on a surface disc with the card shadow (header
/// bell, back button…). [badge] shows the small unread dot.
class VentusIconButton extends StatelessWidget {
  const VentusIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onTap,
    this.badge = false,
  });

  final String icon;

  /// Spoken name for the button — the glyph alone tells a screen reader
  /// nothing.
  final String semanticLabel;
  final bool badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      semanticLabel: semanticLabel,
      // The circle stays 42 for looks; 1px of padding clears the 44 minimum.
      padding: const EdgeInsets.all(1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
              boxShadow: context.shadows.card,
            ),
            child: VentusIcon(icon, size: 20, color: colors.ink),
          ),
          if (badge)
            Positioned(
              top: 8,
              right: 9,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
