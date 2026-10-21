import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';

/// Standard grouped-rows card: surface fill, [AppRadius.lg], soft shadow, no
/// outline. Pass the rows as [children].
class VentusCard extends StatelessWidget {
  const VentusCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Column(children: children),
    );
  }
}
