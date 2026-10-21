import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/saved_place.dart';

/// Thin Supabase wrapper for `saved_places`, scoped to the signed-in user.
class SupabaseSavedPlacesRemote {
  static const _table = 'saved_places';

  SupabaseClient get _client => Supabase.instance.client;
  String? get _userId => _client.auth.currentUser?.id;

  Future<List<SavedPlace>> fetchAll() async {
    final uid = _userId;
    if (uid == null) return const [];
    final rows = await _client
        .from(_table)
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return rows.map(SavedPlace.fromJson).toList();
  }

  Future<void> upsert(SavedPlace place) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).upsert({...place.toJson(), 'user_id': uid});
  }

  Future<void> remove(String destinationId) async {
    final uid = _userId;
    if (uid == null) return;
    await _client
        .from(_table)
        .delete()
        .eq('user_id', uid)
        .eq('destination_id', destinationId);
  }
}
