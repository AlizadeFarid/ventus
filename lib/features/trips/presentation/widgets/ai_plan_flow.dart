import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/ai_planner_controller.dart';
import '../../domain/ai_planner_repository.dart';
import '../../domain/trip.dart';
import '../../../../core/theme/app_typography.dart';

/// Generates an AI day-by-day plan for [trip]: shows a blocking progress dialog,
/// calls the planner controller, then reports the result. On success the
/// itinerary stream repopulates and the hub flips to its filled state.
Future<void> generateTripPlan(
  BuildContext context,
  WidgetRef ref,
  Trip trip,
) async {
  final l10n = context.l10n;
  final navigator = Navigator.of(context, rootNavigator: true);

  if (trip.stops.isEmpty) {
    showVentusError(context, l10n.aiNeedsDestination);
    return;
  }

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _GeneratingDialog(message: l10n.aiGenerating),
  );

  final error = await ref
      .read(aiPlannerControllerProvider.notifier)
      .generatePlan(trip, language: context.languageCode);

  navigator.pop(); // dismiss the progress dialog

  if (!context.mounted) return;
  if (error == null) {
    showVentusSuccess(context, l10n.aiPlanReady);
  } else {
    showVentusError(
      context,
      _aiErrorMessage(l10n, error.code),
      onRetry: () => generateTripPlan(context, ref, trip),
    );
  }
}

/// Maps an [AiPlannerErrorCode] to a localised, user-facing message.
String _aiErrorMessage(AppLocalizations l10n, AiPlannerErrorCode? code) {
  switch (code) {
    case AiPlannerErrorCode.notConfigured:
      return l10n.aiPlanUnavailable;
    case AiPlannerErrorCode.network:
      return l10n.aiPlanNetworkError;
    case AiPlannerErrorCode.empty:
      return l10n.aiPlanEmpty;
    case AiPlannerErrorCode.unknown:
    case null:
      return l10n.aiPlanFailed;
  }
}

/// Small modal shown while a plan is being generated.
class _GeneratingDialog extends StatelessWidget {
  const _GeneratingDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VentusSpinner(size: 22, color: colors.primary),
            const SizedBox(width: 18),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
