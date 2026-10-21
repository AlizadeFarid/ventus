import 'itinerary_item.dart';

/// Contract for a trip's day-by-day plan storage, independent of any backend.
///
/// Local-first like [TripsRepository]: items are read from on-device Drift (so
/// the plan works offline) and mirrored to Supabase when configured. The
/// presentation layer depends only on this interface.
abstract interface class ItineraryRepository {
  /// Streams a trip's activities (all days), re-emitting on any local change.
  /// Ordering (day, then time, then position) is applied by the implementation.
  Stream<List<ItineraryItem>> watch(String tripId);

  /// Inserts or updates [item] locally, then pushes it to the remote (if any).
  Future<void> save(ItineraryItem item);

  /// Inserts or updates many activities at once (e.g. an AI-generated plan),
  /// in a single local batch and one remote round trip. No-op when empty.
  Future<void> saveAll(List<ItineraryItem> items);

  /// Deletes an activity locally, then on the remote (if any).
  Future<void> delete(String id);

  /// Pulls a trip's remote activities into local storage. No-op without a
  /// configured backend.
  Future<void> syncTrip(String tripId);
}
