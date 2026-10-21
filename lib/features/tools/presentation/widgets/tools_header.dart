import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Back button + title + optional subtitle, shared by the full tool screens
/// (prototype `Tools.jsx` → ToolsHeader).
class ToolsHeader extends StatelessWidget {
  const ToolsHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        6,
        AppSpacing.screen,
        14,
      ),
      child: Row(
        children: [
          VentusIconButton(
            icon: VentusIcons.arrowLeft,
            semanticLabel: context.l10n.back,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSize.h3,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: colors.ink,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
