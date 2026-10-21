import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_overlay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/extensions/theme_context_extension.dart';
import '../../../../../../core/l10n/l10n_extension.dart';
import '../../../../../../core/preferences/preferred_currency_provider.dart';
import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/widgets.dart';
import '../../../../application/ai_planner_controller.dart';
import '../../../../application/budget_controller.dart';
import '../../../../application/checklist_controller.dart';
import '../../../../application/checklist_defaults.dart';
import '../../../../application/collaborators_controller.dart';
import '../../../../application/create_trip_controller.dart';
import '../../../../application/trips_controller.dart';
import '../../../../data/cover_picker.dart';
import '../../../../domain/ai_planner_repository.dart';
import '../../../../domain/collaborator_role.dart';
import '../../../../domain/traveler_type.dart';
import '../../../../domain/trip.dart';
import '../../../../domain/trip_budget.dart';
import '../../../widgets/cover_source_sheet.dart';
import '../../../widgets/trip_photo.dart';
import '../create_chrome.dart';
import '../../../../../../core/theme/app_typography.dart';

/// Step 4 — review the trip and create it (empty for now, or hand off to AI).
class ReviewStep extends ConsumerStatefulWidget {
  const ReviewStep({super.key, required this.onBack, required this.onEdit});

  final VoidCallback onBack;

  /// Jump back to a specific step (0 Destination · 1 Travelers · 2 Dates).
  final ValueChanged<int> onEdit;

  @override
  ConsumerState<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  /// A freshly picked cover awaiting upload — applied after the trip is saved
  /// (the upload path needs the new trip id).
  PickedCover? _picked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = context.languageCode;
    final state = ref.watch(createTripControllerProvider);
    final saving = ref.watch(tripsControllerProvider).isLoading;

    final stopCount = state.stops.length;
    final route = state.stops.map((s) => s.name).join(' → ');
    final travelers = _travelersValue(context, state);
    final dates = _datesValue(context, state, lang);

    return CreateStepScaffold(
      header: CreateTitleHeader(title: l10n.reviewTitle, onBack: widget.onBack),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VentusButton(
            label: l10n.buildPlanWithAi,
            full: true,
            iconLeft: VentusIcons.sparkle,
            loading: saving,
            onPressed: () => _buildWithAi(context, ref),
          ),
          const SizedBox(height: 10),
          VentusButton(
            label: l10n.createEmptyTrip,
            variant: VentusButtonVariant.secondary,
            full: true,
            loading: saving,
            onPressed: () => _create(context, ref),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reviewFootnote,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSize.caption,
              color: context.colors.muted,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Cover(
            imageUrl: state.coverPreviewUrl,
            previewImage: _picked == null ? null : MemoryImage(_picked!.bytes),
            stopCount: stopCount,
            onCamera: _pickCover,
            seed: state.effectiveTitle,
          ),
          const SizedBox(height: 18),
          Text(
            state.effectiveTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSize.h1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.75,
              color: context.colors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: context.colors.line),
          _SummaryRow(
            icon: VentusIcons.mapPin,
            label: l10n.routeLabel,
            value: route,
            onEdit: () => widget.onEdit(0),
          ),
          Container(height: 1, color: context.colors.line),
          _SummaryRow(
            icon: VentusIcons.user,
            label: l10n.travelersLabel,
            value: travelers,
            onEdit: () => widget.onEdit(1),
          ),
          Container(height: 1, color: context.colors.line),
          _SummaryRow(
            icon: VentusIcons.calendar,
            label: l10n.datesLabel,
            value: dates,
            onEdit: () => widget.onEdit(2),
          ),
        ],
      ),
    );
  }

  String _travelersValue(BuildContext context, CreateTripState state) {
    final l10n = context.l10n;
    final type = switch (state.travelerType) {
      TravelerType.solo => l10n.travelerSolo,
      TravelerType.couple => l10n.travelerCouple,
      TravelerType.family => l10n.travelerFamily,
      TravelerType.friends => l10n.travelerFriends,
    };
    final parts = <String>[
      l10n.adultsCount(state.adults),
      if (state.children > 0) l10n.childrenCount(state.children),
      type,
    ];
    return parts.join(' · ');
  }

  String _datesValue(BuildContext context, CreateTripState state, String lang) {
    if (!state.hasDates) return context.l10n.selectDates;
    final s = state.startDate!;
    final e = state.endDate!;
    final startFmt = DateFormat.MMMd(lang).format(s);
    final endFmt = s.month == e.month
        ? DateFormat.d(lang).format(e)
        : DateFormat.MMMd(lang).format(e);
    return '$startFmt – $endFmt · ${context.l10n.nightsCount(state.nights)}';
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final router = GoRouter.of(context);
    final createdText = l10n.tripCreated;
    final failedText = l10n.somethingWentWrong;

    final trip = ref.read(createTripControllerProvider.notifier).buildTrip();
    final ok = await ref.read(tripsControllerProvider.notifier).save(trip);
    if (ok && _picked != null) {
      await ref
          .read(tripsControllerProvider.notifier)
          .changeCover(trip: trip, picked: _picked);
    }
    if (ok) {
      // Give the new trip a useful starter checklist instead of an empty one.
      await ref
          .read(checklistControllerProvider.notifier)
          .seedDefaults(defaultChecklistItems(tripId: trip.id, l10n: l10n));
      await _inviteCompanions(ref, trip.id);
      await _applyAiBudget(ref, trip);
    }

    if (!context.mounted) return;
    if (ok) {
      showVentusSuccess(context, createdText);
    } else {
      showVentusError(context, failedText);
    }
    if (ok) router.go(AppRoutes.home);
  }

  /// Sets the trip's budget from the amount the AI read out of the description
  /// (if it found one). Best-effort, like the invites.
  Future<void> _applyAiBudget(WidgetRef ref, Trip trip) async {
    final draft = ref.read(createTripControllerProvider);
    final amount = draft.budgetAmount;
    if (amount == null || amount <= 0) return;
    await ref
        .read(budgetControllerProvider.notifier)
        .saveBudget(
          TripBudget(
            tripId: trip.id,
            userId: trip.userId,
            currency: kSupportedCurrencies.contains(draft.budgetCurrency)
                ? draft.budgetCurrency!
                : ref.read(preferredCurrencyProvider),
            total: amount,
          ),
        );
  }

  /// Writes any companion emails collected in the draft as pending collaborators
  /// on the freshly-created trip. Best-effort: a failed invite never blocks the
  /// trip creation.
  Future<void> _inviteCompanions(WidgetRef ref, String tripId) async {
    final invites = ref.read(createTripControllerProvider).invites;
    for (final email in invites) {
      await ref
          .read(collaboratorsControllerProvider.notifier)
          .invite(tripId: tripId, email: email, role: CollaboratorRole.editor);
    }
  }

  /// Pick / replace / remove the cover photo (held locally until the trip is
  /// saved, then uploaded with the new trip id).
  Future<void> _pickCover() async {
    final action = await showCoverSourceSheet(
      context,
      canRemove: _picked != null,
    );
    if (action == null || !mounted) return;
    switch (action) {
      case CoverSourceAction.camera:
      case CoverSourceAction.gallery:
        final picked = action == CoverSourceAction.camera
            ? await CoverPicker.fromCamera()
            : await CoverPicker.fromGallery();
        if (picked == null || !mounted) return;
        setState(() => _picked = picked);
      case CoverSourceAction.remove:
        setState(() => _picked = null);
    }
  }

  /// Creates the trip, then generates an AI day-by-day plan for it and opens the
  /// trip hub. The trip is saved first, so even if generation fails the user
  /// lands on a real trip and can retry "Generate my plan" there.
  Future<void> _buildWithAi(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final lang = context.languageCode;
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);

    final trip = ref.read(createTripControllerProvider.notifier).buildTrip();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _BuildingDialog(message: l10n.aiGenerating),
    );

    final ok = await ref.read(tripsControllerProvider.notifier).save(trip);
    if (!ok) {
      navigator.pop();
      if (!context.mounted) return;
      showVentusError(context, l10n.somethingWentWrong);
      return;
    }

    if (_picked != null) {
      await ref
          .read(tripsControllerProvider.notifier)
          .changeCover(trip: trip, picked: _picked);
    }

    // Seed the starter checklist alongside the AI-generated itinerary.
    await ref
        .read(checklistControllerProvider.notifier)
        .seedDefaults(defaultChecklistItems(tripId: trip.id, l10n: l10n));
    await _inviteCompanions(ref, trip.id);
    await _applyAiBudget(ref, trip);

    final error = await ref
        .read(aiPlannerControllerProvider.notifier)
        .generatePlan(trip, language: lang);

    navigator.pop();
    if (!context.mounted) return;
    if (error == null) {
      showVentusSuccess(context, l10n.aiPlanReady);
    } else {
      showVentusError(context, _buildErrorMessage(l10n, error.code));
    }
    router.go(AppRoutes.tripDetail(trip.id));
  }
}

/// Maps an [AiPlannerErrorCode] to a localised message for the build-with-AI
/// flow. Generation failures are non-fatal — the trip is still created.
String _buildErrorMessage(AppLocalizations l10n, AiPlannerErrorCode? code) {
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

/// Blocking progress modal shown while the trip is created + planned.
class _BuildingDialog extends StatelessWidget {
  const _BuildingDialog({required this.message});

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

/// Trip cover with the stop-count glass pill and a (deferred) camera button.
class _Cover extends StatelessWidget {
  const _Cover({
    required this.imageUrl,
    required this.previewImage,
    required this.stopCount,
    required this.onCamera,
    required this.seed,
  });

  final String? imageUrl;
  final ImageProvider? previewImage;
  final int stopCount;
  final VoidCallback onCamera;
  final String seed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TripPhoto(
      imageUrl: imageUrl,
      image: previewImage,
      seed: seed,
      height: 150,
      borderRadius: AppRadius.brLg,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x33000000), Color(0x00000000)],
                  stops: [0.0, 0.4],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppOverlay.glassFill,
                borderRadius: AppRadius.brFull,
                border: Border.all(color: AppOverlay.glassStroke),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VentusIcon(VentusIcons.route, size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    l10n.stopsCount(stopCount),
                    style: const TextStyle(
                      fontSize: AppFontSize.caption,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: VentusTap(
              onTap: onCamera,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  shape: BoxShape.circle,
                  boxShadow: context.shadows.card,
                ),
                child: VentusIcon(
                  VentusIcons.camera,
                  size: 20,
                  color: context.colors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String icon;
  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          VentusLeadIcon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.48,
                    color: colors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.body,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                    letterSpacing: -0.16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          VentusTap(
            onTap: onEdit,
            child: Text(
              context.l10n.editAction,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w700,
                color: context.primaryFill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
