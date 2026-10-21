import 'checklist_item.dart';

/// Contract for a trip's checklist storage, independent of any backend.
///
/// Local-first like [ItineraryRepository]: items are read from on-device Drift
/// (so the checklist works offline) and mirrored to Supabase when configured.
abstract interface class ChecklistRepository {
  /// Streams a trip's checklist items (ordered), re-emitting on any local change.
  Stream<List<ChecklistItem>> watch(String tripId);

  /// Inserts or updates [item] locally, then pushes it to the remote (if any).
  /// Also used to toggle [ChecklistItem.done].
  Future<void> save(ChecklistItem item);

  /// Inserts or updates several [items] at once (used to seed a new trip's
  /// default checklist). Local batch first, then a single remote push.
  Future<void> saveAll(List<ChecklistItem> items);

  /// Deletes an item locally, then on the remote (if any).
  Future<void> delete(String id);

  /// Pulls a trip's remote checklist into local storage. No-op without a
  /// configured backend.
  Future<void> syncTrip(String tripId);
}
