import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/database/app_database.dart';
import '../data/drift_trips_repository.dart';
import '../data/supabase_trips_remote.dart';
import '../domain/trip.dart';
import '../domain/trips_repository.dart';

/// The shared on-device database, closed when the provider is disposed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Binds [TripsRepository] to the local-first Drift implementation, attaching a
/// Supabase remote only when the backend is configured. This single line is the
/// only place the storage strategy is chosen.
final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseTripsRemote() : null;
  return DriftTripsRepository(db, remote: remote);
});

/// One-time startup: pull remote trips into Drift, then seed demo content if
/// still empty so the dashboard isn't blank on a fresh install.
final tripsBootstrapProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(tripsRepositoryProvider);
  await repo.sync();
  // Demo trips are an offline-dev convenience only — never seed a real,
  // backend-backed account, so a new user correctly lands on the empty state.
  if (!Env.isConfigured) {
    await repo.seedDemoIfEmpty();
  }
});

/// Live list of the user's trips (sorted by start date), backed by Drift.
final tripsProvider = StreamProvider<List<Trip>>((ref) {
  return ref.watch(tripsRepositoryProvider).watchTrips();
});

/// User's manual override for the Home hero trip (set via the trip switcher
/// sheet). Null means "no override" — [featuredTripProvider] falls back to the
/// soonest upcoming trip. Cleared implicitly whenever the chosen trip is no
/// longer upcoming (e.g. it was deleted or finished).
class SelectedTripIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  /// Pins [id] as the Home hero trip. Exposed as a method so callers never
  /// touch `.state` from outside the notifier (which Riverpod treats as a
  /// protected member).
  void select(String id) => state = id;

  /// Drops the manual override, letting [featuredTripProvider] fall back to
  /// the soonest upcoming trip.
  void clear() => state = null;
}

final selectedTripIdProvider =
    NotifierProvider<SelectedTripIdNotifier, String?>(
      SelectedTripIdNotifier.new,
    );

/// The featured trip on Home: the user's manually-picked trip (if still
/// upcoming), else the soonest upcoming one.
final featuredTripProvider = Provider<Trip?>((ref) {
  final trips = ref.watch(tripsProvider).asData?.value ?? const [];
  final upcoming = trips.where((t) => t.isUpcoming).toList()
    ..sort((a, b) => a.startDate.compareTo(b.startDate));
  if (upcoming.isEmpty) return null;
  final selectedId = ref.watch(selectedTripIdProvider);
  if (selectedId != null) {
    for (final t in upcoming) {
      if (t.id == selectedId) return t;
    }
  }
  return upcoming.first;
});

/// Upcoming trips excluding the featured one — the "Your trips" row.
final otherTripsProvider = Provider<List<Trip>>((ref) {
  final trips = ref.watch(tripsProvider).asData?.value ?? const [];
  final featured = ref.watch(featuredTripProvider);
  return trips.where((t) => t.isUpcoming && t.id != featured?.id).toList()
    ..sort((a, b) => a.startDate.compareTo(b.startDate));
});

/// All upcoming trips (soonest first) — the "All trips" Upcoming section.
final upcomingTripsProvider = Provider<List<Trip>>((ref) {
  final trips = ref.watch(tripsProvider).asData?.value ?? const [];
  return trips.where((t) => t.isUpcoming).toList()
    ..sort((a, b) => a.startDate.compareTo(b.startDate));
});

/// All finished trips (most recent first) — the "All trips" Past section.
final pastTripsProvider = Provider<List<Trip>>((ref) {
  final trips = ref.watch(tripsProvider).asData?.value ?? const [];
  return trips.where((t) => t.isPast).toList()
    ..sort((a, b) => b.endDate.compareTo(a.endDate));
});
