import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_spacing.dart';
import 'ventus_icon.dart';
import '../../core/theme/app_typography.dart';

/// Centred "nothing here yet" block: bare muted icon (or a custom
/// [leading] such as an illustration), optional title, body and one [action]
/// (usually a [VentusButton]). Replaces the per-screen `_Empty…` classes.
class VentusEmptyState extends StatelessWidget {
  const VentusEmptyState({
    super.key,
    this.icon,
    this.leading,
    this.title,
    required this.body,
    this.action,
  }) : assert(icon != null || leading != null);

  /// A [VentusIcons] name shown as a bare glyph.
  final String? icon;

  /// Replaces the icon badge when set.
  final Widget? leading;
  final String? title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading ?? VentusIcon(icon!, size: 36, color: colors.muted),
            const SizedBox(height: 18),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: type.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              body,
              textAlign: TextAlign.center,
              style: type.body.copyWith(
                fontSize: AppFontSize.sm,
                color: colors.muted,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 22), action!],
          ],
        ),
      ),
    );
  }
}
