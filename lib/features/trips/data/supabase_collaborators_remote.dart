import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/collaborator.dart';

/// Thin Supabase wrapper for a trip's `trip_collaborators`.
///
/// All reads/writes are scoped to the signed-in user (the trip owner);
/// row-level security on the server enforces the same boundary. Errors
/// propagate so the local-first Drift copy stays the source of truth.
class SupabaseCollaboratorsRemote {
  static const _table = 'trip_collaborators';

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Fetches every collaborator of [tripId] for the current user.
  Future<List<Collaborator>> fetchForTrip(String tripId) async {
    final uid = _userId;
    if (uid == null) return const [];
    final rows = await _client.from(_table).select().eq('trip_id', tripId);
    return rows.map(Collaborator.fromJson).toList();
  }

  /// Inserts or updates [collaborator] for the current user (id is the key).
  Future<void> upsert(Collaborator collaborator) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).upsert({
      ...collaborator.toJson(),
      if (collaborator.userId == null) 'user_id': uid,
    });
  }

  /// Accepts an invite by setting status to active.
  Future<void> acceptInvite(String tripId) async {
    final uid = _userId;
    if (uid == null) return;
    await _client
        .from(_table)
        .update({'status': 'active'})
        .eq('trip_id', tripId)
        .eq('invited_user_id', uid);
  }

  Future<void> remove(String id) async {
    if (_userId == null) return;
    await _client.from(_table).delete().eq('id', id);
  }
}
