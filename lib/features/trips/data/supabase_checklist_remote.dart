import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/checklist_item.dart';

/// Thin Supabase wrapper for a trip's `checklist_items`.
///
/// All reads/writes are scoped to the signed-in user; row-level security on the
/// server enforces the same boundary. Errors propagate to the caller, so the
/// local-first Drift copy stays the source of truth even if a push fails.
class SupabaseChecklistRemote {
  static const _table = 'checklist_items';

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Fetches every checklist item of [tripId] for the current user.
  Future<List<ChecklistItem>> fetchForTrip(String tripId) async {
    final uid = _userId;
    if (uid == null) return const [];
    final rows = await _client.from(_table).select().eq('trip_id', tripId);
    return rows.map(ChecklistItem.fromJson).toList();
  }

  /// Inserts or updates [item] for the current user (id is the conflict key).
  Future<void> upsert(ChecklistItem item) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).upsert({
      ...item.toJson(),
      if (item.userId == null) 'user_id': uid,
    });
  }

  /// Inserts or updates several [items] for the current user in one request.
  Future<void> upsertAll(List<ChecklistItem> items) async {
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
