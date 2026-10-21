import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';

/// What a toast is telling the user. Drives the leading glyph and its tint.
enum VentusSnackKind { info, success, error }

/// Shows a Ventus-styled toast.
///
/// Call sites used to build `SnackBar(content: Text(...))` by hand in 23
/// screens, which meant three things: the toast picked up stock Material
/// styling, a failure looked exactly like a success, and a failed action left
/// the user with a dead-end message and no way to try again. This wraps the
/// three of those.
///
/// Pass [onRetry] whenever the action can simply be repeated — a failed save,
/// upload or sync. The retry label is localized for you.
void showVentusSnack(
  BuildContext context,
  String message, {
  VentusSnackKind kind = VentusSnackKind.info,
  VoidCallback? onRetry,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration,
}) {
  final colors = context.colors;
  final l10n = context.l10n;
  // Each kind is a soft tinted card with a solid badge, not the stock dark
  // toast: the message stays in the ink colour so it is always readable, and
  // success / error / info are told apart by tint and glyph at a glance.
  final (Color fill, Color badge, String glyph) = switch (kind) {
    VentusSnackKind.info => (colors.surface, colors.primary, VentusIcons.note),
    VentusSnackKind.success => (
      colors.successSoft,
      colors.success,
      VentusIcons.check,
    ),
    VentusSnackKind.error => (
      colors.dangerSoft,
      colors.danger,
      VentusIcons.close,
    ),
  };
  // Errors need longer than a confirmation: there is usually something to read
  // and, when [onRetry] is set, something to decide.
  final shown =
      duration ??
      (kind == VentusSnackKind.error
          ? const Duration(seconds: 6)
          : const Duration(seconds: 4));

  final messenger = ScaffoldMessenger.of(context);
  final (String? label, VoidCallback? handler) = switch ((onRetry, onAction)) {
    (final VoidCallback retry, _) => (l10n.tryAgain, retry),
    (_, final VoidCallback act) when actionLabel != null => (actionLabel, act),
    _ => (null, null),
  };

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: shown,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: AppRadius.brMd,
            boxShadow: context.shadows.pop,
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badge,
                  borderRadius: AppRadius.brFull,
                ),
                child: VentusIcon(
                  glyph,
                  size: 14,
                  stroke: 2.6,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: context.typography.sm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
              ),
              if (label != null) ...[
                const SizedBox(width: 10),
                VentusTap(
                  onTap: () {
                    messenger.hideCurrentSnackBar();
                    handler!();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      label,
                      style: context.typography.sm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: kind == VentusSnackKind.error
                            ? colors.danger
                            : context.primaryFill,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
}

/// Shorthand for the common "that worked" confirmation.
void showVentusSuccess(BuildContext context, String message) =>
    showVentusSnack(context, message, kind: VentusSnackKind.success);

/// Shorthand for a failure. Prefer passing [onRetry] when the action is
/// repeatable.
void showVentusError(
  BuildContext context,
  String message, {
  VoidCallback? onRetry,
}) => showVentusSnack(
  context,
  message,
  kind: VentusSnackKind.error,
  onRetry: onRetry,
);
