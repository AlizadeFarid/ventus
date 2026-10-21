import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/l10n/l10n_extension.dart';

/// Asks the user to confirm an action, returning true when they do.
///
/// Six near-identical confirm dialogs were copy-pasted across the app, each
/// re-styling its own title, body and buttons — so they drifted (two had no
/// body text, one had no explicit colours and rendered in stock Material). This
/// is the single confirm. [destructive] tints the confirm action with
/// [AppColors.danger] and makes Cancel the safer-looking default.
///
/// ```dart
/// final ok = await confirmVentusAction(
///   context,
///   title: l10n.deleteTripTitle,
///   body: l10n.deleteTripBody,
///   confirmLabel: l10n.deleteConfirm,
///   destructive: true,
/// );
/// if (!ok) return;
/// ```
Future<bool> confirmVentusAction(
  BuildContext context, {
  required String title,
  String? body,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final colors = context.colors;
  final l10n = context.l10n;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      // Destructive choices should never be one stray tap away, so Cancel
      // keeps the resting emphasis and the confirm carries the warning colour.
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          style: TextButton.styleFrom(foregroundColor: colors.muted),
          child: Text(cancelLabel ?? l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: destructive ? colors.danger : colors.primary,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
