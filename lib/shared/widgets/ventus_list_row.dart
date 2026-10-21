import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_spacing.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';

/// Result / picker row: leading widget, title, optional subtitle, trailing
/// check when [selected]. Shared by every "pick one from a list" sheet.
class VentusListRow extends StatelessWidget {
  const VentusListRow({
    super.key,
    required this.title,
    required this.onTap,
    this.leading,
    this.subtitle,
    this.selected = false,
    this.destructive = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool selected;

  /// Paints the title in the danger colour (delete-style actions).
  final bool destructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    return VentusTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s3,
          horizontal: AppSpacing.s1,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.s3),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: type.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: destructive ? colors.danger : colors.ink,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      style: type.caption.copyWith(color: colors.muted),
                    ),
                ],
              ),
            ),
            if (selected)
              VentusIcon(VentusIcons.check, size: 18, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
