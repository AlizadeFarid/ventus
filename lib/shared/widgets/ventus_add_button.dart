import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';
import '../../core/theme/app_typography.dart';

/// The one "add" affordance for module headers: a small filled coral circle
/// with a plus, the same language as the bottom nav's centre button. Replaces
/// the bare plus glyphs and per-screen extended FABs.
class VentusAddButton extends StatelessWidget {
  const VentusAddButton({
    super.key,
    required this.onTap,
    this.semanticLabel,
    this.size = 36,
  });

  final VoidCallback onTap;
  final String? semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.primaryFill.withValues(alpha: 0.28),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: VentusIcon(
          VentusIcons.plus,
          size: size * 0.5,
          stroke: 2.4,
          color: colors.onPrimary,
        ),
      ),
    );
  }
}

/// Inline "add" row for the end of a list or an empty day/section: a soft sand
/// pill with a coral plus and label. The one in-content counterpart of
/// [VentusAddButton].
class VentusAddRow extends StatelessWidget {
  const VentusAddRow({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: AppRadius.brLg,
          color: colors.surfaceSand.withValues(alpha: 0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VentusIcon(VentusIcons.plus, size: 18, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.typography.body.copyWith(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
                color: context.primaryFill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
