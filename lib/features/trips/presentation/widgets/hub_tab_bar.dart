import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../shared/widgets/ventus_edge_fade.dart';
import '../../../../core/theme/app_typography.dart';

/// Scrollable underline tab strip for the Trip Hub (İcmal / Marşrut / Xəritə /
/// Büdcə / Sənədlər / Yoxlama siyahısı). Borderless per the design system: no
/// Material divider line under the strip, just the primary-coloured indicator
/// under the active label.
class HubTabBar extends StatelessWidget implements PreferredSizeWidget {
  const HubTabBar({super.key, required this.controller, required this.labels});

  final TabController controller;
  final List<String> labels;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bar = TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      // Outer padding + labelPadding must sum to 22 on each side to line up
      // with the 22px horizontal margin every card/section below it uses.
      padding: const EdgeInsets.symmetric(horizontal: 8),
      labelPadding: const EdgeInsets.symmetric(horizontal: 14),
      dividerColor: Colors.transparent,
      indicatorColor: colors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: colors.ink,
      unselectedLabelColor: colors.muted,
      labelStyle: const TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w600,
      ),
      tabs: [for (final label in labels) Tab(text: label)],
    );
    // The strip scrolls; fade its right edge so a clipped label reads as
    // "more this way" rather than as truncated text.
    return VentusEdgeFade(color: colors.surface, child: bar);
  }
}
