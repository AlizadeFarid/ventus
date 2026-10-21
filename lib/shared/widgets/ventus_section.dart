import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_tap.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Small uppercase eyebrow that labels a group of rows (settings, feeds,
/// lists). The one replacement for the per-screen `_SectionLabel` copies.
class VentusSectionLabel extends StatelessWidget {
  const VentusSectionLabel(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.fromLTRB(4, 0, 4, 10),
  });

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text.toUpperCase(),
        style: context.typography.eyebrow.copyWith(color: context.colors.muted),
      ),
    );
  }
}

/// Section title with an optional text action ("See all") or custom
/// [trailing] widget (e.g. a [VentusAddButton]).
class VentusSectionHeader extends StatelessWidget {
  const VentusSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      0,
      AppSpacing.screen,
      12,
    ),
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: context.typography.h2.copyWith(
                fontSize: AppFontSize.h3,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
          ),
          if (actionLabel != null)
            VentusTap(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: context.typography.sm.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.primaryFill,
                ),
              ),
            ),
          ?trailing,
        ],
      ),
    );
  }
}
