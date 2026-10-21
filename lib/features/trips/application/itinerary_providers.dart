import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/drift_itinerary_repository.dart';
import '../data/supabase_itinerary_remote.dart';
import '../domain/itinerary_item.dart';
import '../domain/itinerary_repository.dart';
import 'trips_providers.dart';

/// Binds [ItineraryRepository] to the local-first Drift implementation, sharing
/// the app database with the trips repository and attaching a Supabase remote
/// only when the backend is configured.
final itineraryRepositoryProvider = Provider<ItineraryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseItineraryRemote() : null;
  return DriftItineraryRepository(db, remote: remote);
});

/// Pulls a trip's remote activities into Drift once, when its plan is first
/// shown. Keyed by trip id; `autoDispose` so it re-runs on a fresh visit.
final itinerarySyncProvider = FutureProvider.autoDispose.family<void, String>((
  ref,
  tripId,
) {
  return ref.watch(itineraryRepositoryProvider).syncTrip(tripId);
});

/// Live list of a trip's activities (all days, ordered), backed by Drift.
final itineraryProvider = StreamProvider.autoDispose
    .family<List<ItineraryItem>, String>((ref, tripId) {
      return ref.watch(itineraryRepositoryProvider).watch(tripId);
    });
