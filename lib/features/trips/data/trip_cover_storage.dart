import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/storage/app_storage.dart';
import '../../../core/utils/id.dart';

/// Uploads/removes trip cover images in the owner-scoped `trip-covers` bucket.
///
/// Mirrors the avatar upload pattern: a unique filename per upload so the public
/// CDN never serves a stale image, with best-effort cleanup of the old object.
/// No-ops (returns null) when there's no configured backend / signed-in user.
class TripCoverStorage {
  supabase.SupabaseClient get _client => supabase.Supabase.instance.client;

  /// Uploads [bytes] as [tripId]'s cover and returns the stored object path, or
  /// null when offline / not signed in (caller keeps the existing cover).
  Future<String?> upload({
    required String tripId,
    required Uint8List bytes,
    String? contentType,
  }) async {
    final userId = AppStorage.currentUserId;
    if (userId == null) return null;
    final ext = _extFor(contentType);
    final path = AppStorage.userScopedPath(userId, '${tripId}_${newId()}.$ext');
    await _client.storage
        .from(StorageBuckets.tripCovers)
        .uploadBinary(
          path,
          bytes,
          fileOptions: supabase.FileOptions(
            contentType: contentType,
            upsert: true,
          ),
        );
    return path;
  }

  /// Best-effort delete of a previous cover object — a leftover is harmless and
  /// must not fail the save the user already saw succeed.
  Future<void> delete(String path) async {
    try {
      await _client.storage.from(StorageBuckets.tripCovers).remove([path]);
    } catch (_) {
      // ignore
    }
  }

  String _extFor(String? contentType) {
    switch (contentType) {
      case 'image/png':
        return 'png';
      case 'image/webp':
        return 'webp';
      case 'image/heic':
        return 'heic';
      default:
        return 'jpg';
    }
  }
}

final tripCoverStorageProvider = Provider<TripCoverStorage>(
  (ref) => TripCoverStorage(),
);
