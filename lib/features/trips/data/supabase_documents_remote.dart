import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/storage/app_storage.dart';
import '../domain/document.dart';

/// Thin Supabase wrapper for a trip's documents — both the `documents` metadata
/// table and the binary objects in the private `trip-docs` Storage bucket.
///
/// All reads/writes are scoped to the signed-in user; row-level security and the
/// owner storage policies enforce the same boundary on the server. Errors
/// propagate to the caller, so the local-first Drift copy stays authoritative
/// for metadata even if a push fails.
class SupabaseDocumentsRemote {
  static const _table = 'documents';

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Fetches every document of [tripId] for the current user.
  Future<List<TripDocument>> fetchForTrip(String tripId) async {
    final uid = _userId;
    if (uid == null) return const [];
    final rows = await _client.from(_table).select().eq('trip_id', tripId);
    return rows.map(TripDocument.fromJson).toList();
  }

  /// Inserts or updates [doc]'s metadata for the current user.
  Future<void> upsert(TripDocument doc) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).upsert({...doc.toJson(), 'user_id': uid});
  }

  Future<void> deleteRow(String id) async {
    if (_userId == null) return;
    await _client.from(_table).delete().eq('id', id);
  }

  /// Uploads [bytes] to the `trip-docs` bucket at [path].
  Future<void> uploadObject(
    String path,
    Uint8List bytes, {
    String? contentType,
  }) async {
    if (_userId == null) return;
    await _client.storage
        .from(StorageBuckets.tripDocs)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: true),
        );
  }

  /// Removes the object at [path] from the `trip-docs` bucket.
  Future<void> removeObject(String path) async {
    if (_userId == null || path.isEmpty) return;
    await _client.storage.from(StorageBuckets.tripDocs).remove([path]);
  }

  /// Downloads the file's bytes from the `trip-docs` bucket.
  Future<Uint8List?> download(String path) async {
    if (_userId == null || path.isEmpty) return null;
    return _client.storage.from(StorageBuckets.tripDocs).download(path);
  }

  /// A short-lived signed URL to the object (for inline image preview).
  Future<String?> signedUrl(String path) =>
      AppStorage.signedUrl(StorageBuckets.tripDocs, path);
}
