import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// The big title at the top of each primary tab (Home, Trips, Tools, Profile).
///
/// One widget and one [style] so the four tabs share the same size, face and
/// spacing; changing either here changes every tab.
class VentusTabTitle extends StatelessWidget {
  const VentusTabTitle(this.text, {super.key});

  final String text;

  /// Title text style. Public so Home, whose title sits in a richer header row,
  /// can match it without duplicating the numbers.
  static TextStyle style(BuildContext context) => context.typography.h1
      .copyWith(fontSize: AppFontSize.h1, color: context.colors.ink);

  /// Padding around a standalone title.
  static const EdgeInsets padding = EdgeInsets.fromLTRB(
    AppSpacing.screen,
    6,
    AppSpacing.screen,
    12,
  );

  @override
  Widget build(BuildContext context) {
    // Full width and start-aligned, so the title sits on the left edge no
    // matter how the parent lays out its children (a centred Column used to
    // shrink-wrap and centre it).
    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: style(context),
        ),
      ),
    );
  }
}
