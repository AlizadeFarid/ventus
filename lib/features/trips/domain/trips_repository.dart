import 'trip.dart';

/// Contract for trip storage, independent of any backend.
///
/// The presentation layer depends only on this interface. The concrete
/// implementation is local-first ([Trip]s are read from on-device Drift so the
/// app works offline) and syncs to Supabase when configured. Swapping or
/// faking the backend therefore touches one binding, not the screens.
abstract interface class TripsRepository {
  /// Streams the user's trips, sorted by start date. Emits again on any local
  /// change (create / update / delete / sync), so the UI stays live.
  Stream<List<Trip>> watchTrips();

  /// Reads a single trip by [id], or null if it does not exist locally.
  Future<Trip?> getTrip(String id);

  /// Inserts or updates [trip] locally, then pushes it to the remote (if any).
  Future<void> saveTrip(Trip trip);

  /// Deletes a trip locally, then on the remote (if any).
  Future<void> deleteTrip(String id);

  /// Pulls remote trips and upserts them into local storage. No-op without a
  /// configured backend.
  Future<void> sync();

  /// Seeds a few demo trips when local storage is empty, so the design is
  /// visible before any real trip exists.
  ///
  /// TODO(trips): remove once trip creation lands — this is dev-only content.
  Future<void> seedDemoIfEmpty();
}
