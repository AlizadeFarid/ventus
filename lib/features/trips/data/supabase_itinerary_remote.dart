import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/itinerary_item.dart';

/// Thin Supabase wrapper for a trip's `itinerary_items`.
///
/// All reads/writes are scoped to the signed-in user; row-level security on the
/// server enforces the same boundary. Errors propagate to the caller, so the
/// local-first Drift copy stays the source of truth even if a push fails.
class SupabaseItineraryRemote {
  static const _table = 'itinerary_items';

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Fetches every activity of [tripId] for the current user.
  Future<List<ItineraryItem>> fetchForTrip(String tripId) async {
    final uid = _userId;
    if (uid == null) return const [];
    final rows = await _client.from(_table).select().eq('trip_id', tripId);
    return rows.map(ItineraryItem.fromJson).toList();
  }

  /// Inserts or updates [item] for the current user (id is the conflict key).
  Future<void> upsert(ItineraryItem item) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).upsert({
      ...item.toJson(),
      if (item.userId == null) 'user_id': uid,
    });
  }

  /// Inserts or updates many activities in one request (id is the conflict key).
  Future<void> upsertMany(List<ItineraryItem> items) async {
    final uid = _userId;
    if (uid == null || items.isEmpty) return;
    await _client.from(_table).upsert([
      for (final item in items)
        {...item.toJson(), if (item.userId == null) 'user_id': uid},
    ]);
  }

  Future<void> delete(String id) async {
    if (_userId == null) return;
    await _client.from(_table).delete().eq('id', id);
  }
}
