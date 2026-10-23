import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';

/// A single checklist row (prototype `TripHub.jsx` → CheckRow): a square check
/// box plus a label that strikes through when done.
///
/// Without [onEdit] the whole row toggles. With it the row splits the way
/// Reminders does: the box toggles, the text opens the editor — so there is no
/// pencil button repeated on every line.
class CheckRow extends StatelessWidget {
  const CheckRow({
    super.key,
    required this.label,
    required this.done,
    required this.onTap,
    this.onEdit,
    this.dueLabel,
    this.trailing,
    this.verticalPadding = 11,
  });

  final String label;
  final bool done;
  final VoidCallback onTap;

  /// Opens rename/edit when the label is tapped.
  final VoidCallback? onEdit;

  /// Optional reminder text (e.g. "Do by Jun 14"), shown as an amber badge
  /// under the label while the item is still open.
  final String? dueLabel;

  /// Optional trailing widget (e.g. a "From itinerary" badge).
  final Widget? trailing;

  /// Space above and below the row; the hit areas grow with it.
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showDue = dueLabel != null && !done;

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: done ? colors.primary : colors.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: done ? colors.primary : colors.lineStrong,
          width: 1.5,
        ),
      ),
      child: done
          ? VentusIcon(VentusIcons.check, size: 14, color: colors.onPrimary)
          : null,
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.body,
            fontWeight: FontWeight.w600,
            color: done ? colors.muted : colors.ink,
            decoration: done ? TextDecoration.lineThrough : null,
            decorationColor: colors.muted,
          ),
        ),
        if (showDue) ...[
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VentusIcon(VentusIcons.bell, size: 13, color: colors.amber),
              const SizedBox(width: 5),
              Text(
                dueLabel!,
                style: TextStyle(
                  fontSize: AppFontSize.caption,
                  fontWeight: FontWeight.w700,
                  color: colors.amber,
                ),
              ),
            ],
          ),
        ],
      ],
    );

    if (onEdit == null) {
      return VentusTap(
        onTap: onTap,
        // The box animates its own tick; scaling the whole row on top of that
        // reads as two competing responses to one tap.
        feedback: VentusTapFeedback.none,
        semanticLabel: label,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Row(
            children: [
              box,
              const SizedBox(width: 12),
              Expanded(child: text),
              if (trailing != null) ...[const SizedBox(width: 10), trailing!],
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        // Toggle target: the box with padding up to a 44px hit area.
        VentusTap(
          onTap: onTap,
          feedback: VentusTapFeedback.none,
          semanticLabel: label,
          padding: EdgeInsets.fromLTRB(0, verticalPadding, 11, verticalPadding),
          child: box,
        ),
        Expanded(
          child: VentusTap(
            onTap: onEdit,
            feedback: VentusTapFeedback.none,
            semanticLabel: context.l10n.edit,
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Align(alignment: Alignment.centerLeft, child: text),
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 10), trailing!],
      ],
    );
  }
}
