import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';
import '../../core/theme/app_typography.dart';

/// The "Ask Ventus" shortcut into the AI planner: soft-coral pill, sparkle,
/// short [label], chevron. One component for every place the planner is
/// offered, so it never looks different from screen to screen.
class VentusAiPill extends StatelessWidget {
  const VentusAiPill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.primarySoft,
          borderRadius: AppRadius.brFull,
        ),
        child: Row(
          children: [
            VentusIcon(VentusIcons.sparkle, size: 17, color: colors.primary),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: context.primaryFill,
                ),
              ),
            ),
            VentusIcon(
              VentusIcons.chevronRight,
              size: 16,
              color: colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
