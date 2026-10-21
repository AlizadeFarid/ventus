import 'package:flutter/material.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_spacing.dart';

/// Title + single trailing action for a Trip Hub tab's content (replaces the
/// title/action slot each module screen used to get from `VentusAppBar` when
/// it was its own route).
class ModuleHeaderRow extends StatelessWidget {
  const ModuleHeaderRow({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return VentusSectionHeader(
      title: title,
      trailing: action,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        14,
        AppSpacing.screen,
        4,
      ),
    );
  }
}
