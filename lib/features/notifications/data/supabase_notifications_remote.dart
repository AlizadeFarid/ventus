import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/app_notification.dart';

/// Thin Supabase wrapper for the user's `notifications`.
///
/// All reads/writes are scoped to the signed-in user; row-level security on the
/// server enforces the same boundary. Errors propagate so the local-first Drift
/// copy stays the source of truth.
class SupabaseNotificationsRemote {
  static const _table = 'notifications';

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Fetches every notification for the current user, newest first.
  Future<List<AppNotification>> fetchAll() async {
    final uid = _userId;
    if (uid == null) return const [];
    final rows = await _client
        .from(_table)
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return rows.map(AppNotification.fromJson).toList();
  }

  /// Inserts or updates [notification] for the current user (id is the key).
  Future<void> upsert(AppNotification notification) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).upsert({
      ...notification.toJson(),
      'user_id': uid,
    });
  }

  Future<void> markRead(String id) async {
    if (_userId == null) return;
    await _client.from(_table).update({'read': true}).eq('id', id);
  }

  Future<void> markAllRead() async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).update({'read': true}).eq('user_id', uid);
  }

  Future<void> delete(String id) async {
    if (_userId == null) return;
    await _client.from(_table).delete().eq('id', id);
  }

  Future<void> deleteAll() async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).delete().eq('user_id', uid);
  }
}
