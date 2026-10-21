import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_spacing.dart';
import 'ventus_search_field.dart';
import 'ventus_sheet.dart';

/// Shell of every "search and pick" sheet (city, currency, time zone…): title,
/// the shared [VentusSearchField], then [child] (the results). Pass
/// [message] instead of [child] for an empty / error line.
class VentusSearchSheet extends StatelessWidget {
  const VentusSearchSheet({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.child,
  });

  final String title;
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final Widget child;

  /// A muted line for the empty / offline states.
  static Widget message(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.all(AppSpacing.s4),
    child: Text(
      text,
      style: context.typography.body.copyWith(color: context.colors.muted),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return VentusSheetFrame(
      title: title,
      maxHeightFactor: 0.78,
      fixedHeight: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VentusSearchField(
            controller: controller,
            hintText: hintText,
            onChanged: onChanged,
          ),
          const SizedBox(height: AppSpacing.s2),
          Flexible(child: child),
        ],
      ),
    );
  }
}
