import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import 'ventus_list_row.dart';

/// The one way to open a bottom sheet: scroll-controlled (so the keyboard can
/// push it up), surface background, [AppRadius.xl] top corners. Content should
/// start with a [VentusSheetHandle] and wrap its body in [VentusSheetFrame]
/// when it needs the standard padding + keyboard inset.
Future<T?> showVentusSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  Color? backgroundColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor ?? context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: builder,
  );
}

/// Grab handle at the top of a sheet.
class VentusSheetHandle extends StatelessWidget {
  const VentusSheetHandle({super.key, this.bottom = 14});

  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: EdgeInsets.only(bottom: bottom),
        decoration: BoxDecoration(
          color: context.colors.lineStrong,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Standard sheet body: handle, optional centred [title], then [child], with
/// the shared padding and the keyboard inset applied.
class VentusSheetFrame extends StatelessWidget {
  const VentusSheetFrame({
    super.key,
    required this.child,
    this.title,
    this.maxHeightFactor,
    this.fixedHeight = false,
  });

  final Widget child;
  final String? title;

  /// Caps the sheet at this fraction of the screen height when set.
  final double? maxHeightFactor;

  /// Makes the sheet exactly [maxHeightFactor] tall (shrinking only to clear
  /// the keyboard), so a search sheet doesn't grow as results arrive.
  final bool fixedHeight;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        height: fixedHeight && maxHeightFactor != null
            ? (media.size.height * maxHeightFactor!).clamp(
                0,
                media.size.height - media.viewInsets.bottom - 80,
              )
            : null,
        constraints: !fixedHeight && maxHeightFactor != null
            ? BoxConstraints(maxHeight: media.size.height * maxHeightFactor!)
            : null,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VentusSheetHandle(),
            if (title != null) ...[
              Center(
                child: Text(
                  title!,
                  style: context.typography.h3.copyWith(
                    color: context.colors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Flexible(
              fit: fixedHeight ? FlexFit.tight : FlexFit.loose,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// One row of [showVentusOptionSheet].
class VentusSheetOption<T> {
  const VentusSheetOption({
    required this.value,
    required this.label,
    this.icon,
    this.selected = false,
    this.destructive = false,
  });

  final T value;
  final String label;

  /// A [VentusIcons] name shown before the label.
  final String? icon;

  /// Shows the trailing check (pick-one lists).
  final bool selected;
  final bool destructive;
}

/// The one "choose from a short list" sheet: action menus ("…" → change cover,
/// delete) and pick-one lists (which day?). Same handle, rows and press
/// feedback as every other sheet; resolves to the tapped option's value, or
/// null when dismissed.
Future<T?> showVentusOptionSheet<T>(
  BuildContext context, {
  required List<VentusSheetOption<T>> options,
  String? title,
}) {
  return showVentusSheet<T>(
    context,
    isScrollControlled: false,
    builder: (sheetContext) {
      final colors = sheetContext.colors;
      return VentusSheetFrame(
        title: title,
        maxHeightFactor: 0.7,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final o in options)
              VentusListRow(
                title: o.label,
                selected: o.selected,
                destructive: o.destructive,
                leading: o.icon == null
                    ? null
                    : VentusIcon(
                        o.icon!,
                        size: 22,
                        color: o.destructive ? colors.danger : colors.ink2,
                      ),
                onTap: () => Navigator.of(sheetContext).pop(o.value),
              ),
          ],
        ),
      );
    },
  );
}
