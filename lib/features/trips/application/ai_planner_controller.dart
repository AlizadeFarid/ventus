import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/utils/id.dart';
import '../../notifications/application/notifications_controller.dart';
import '../domain/ai_planner_repository.dart';
import '../domain/itinerary_item.dart';
import '../domain/trip.dart';
import 'ai_planner_providers.dart';
import 'itinerary_providers.dart';
import 'trip_geocode_controller.dart';

/// Drives AI plan generation and exposes its loading + error state so the Trip
/// Hub can show a spinner and surface failures. Reads stay reactive through
/// [itineraryProvider]; this only orchestrates the generate → persist flow.
class AiPlannerController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Generates a plan for [trip] and saves it through the itinerary repository
  /// (so it lands in Drift + Supabase and the hub flips to its filled state).
  /// Returns null on success, or the [AiPlannerException] to localise on failure.
  Future<AiPlannerException?> generatePlan(
    Trip trip, {
    required String language,
  }) async {
    state = const AsyncLoading();
    try {
      final drafts = await ref
          .read(aiPlannerRepositoryProvider)
          .generateItinerary(trip, language: language);

      final items = _toItems(trip, drafts);
      await ref.read(itineraryRepositoryProvider).saveAll(items);

      // Best-effort activity-feed entry; never fails the generation.
      await ref
          .read(notificationsControllerProvider.notifier)
          .notifyAiPlanReady(tripId: trip.id, tripTitle: trip.title);

      state = const AsyncData(null);

      // The plan comes back as free text ("Wat Pho"), so the Map tab has
      // nothing to draw until those places are geocoded. Start that now rather
      // than making the user wait for it: it runs in the background, and the
      // Map tab shares the same run if it's opened meanwhile. Failures are
      // silent — the map simply offers "Find places" instead.
      unawaited(
        ref
            .read(tripGeocodeControllerProvider.notifier)
            .resolveMissing(trip.id)
            .catchError(
              (_) => const GeocodeOutcome(located: 0, stillMissing: 0),
            ),
      );
      return null;
    } on AiPlannerException catch (e, st) {
      state = AsyncError(e, st);
      return e;
    } catch (e, st) {
      state = AsyncError(e, st);
      return AiPlannerException('$e', code: AiPlannerErrorCode.unknown);
    }
  }

  /// Turns the AI drafts into persistable [ItineraryItem]s, assigning ids and a
  /// per-day [position] (in the order returned, which Gemini keeps chronological).
  List<ItineraryItem> _toItems(Trip trip, List<GeneratedActivity> drafts) {
    final userId = Env.isConfigured
        ? Supabase.instance.client.auth.currentUser?.id
        : null;
    final now = DateTime.now();
    final positionByDay = <int, int>{};

    return [
      for (final d in drafts)
        ItineraryItem(
          id: newId(),
          tripId: trip.id,
          userId: userId,
          day: d.day,
          startMinutes: d.startMinutes,
          title: d.title,
          place: d.place,
          kind: d.kind,
          position: positionByDay.update(
            d.day,
            (p) => p + 1,
            ifAbsent: () => 0,
          ),
          createdAt: now,
        ),
    ];
  }
}

final aiPlannerControllerProvider =
    AsyncNotifierProvider<AiPlannerController, void>(AiPlannerController.new);
