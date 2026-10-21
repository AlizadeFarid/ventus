import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/storage/app_storage.dart';
import '../../../core/utils/id.dart';
import '../domain/profile_repository.dart';

/// Real [ProfileRepository] backed by Supabase Auth metadata + Storage.
///
/// The display name and avatar path are stored on the auth user's
/// `user_metadata`; the avatar image goes to the owner-scoped `avatars` bucket.
/// The client is read lazily so this can be constructed before Supabase init.
class SupabaseProfileRepository implements ProfileRepository {
  supabase.SupabaseClient get _client => supabase.Supabase.instance.client;

  @override
  Future<void> updateProfile({
    required String name,
    String? avatarPath,
    bool avatarCleared = false,
  }) async {
    try {
      await _client.auth.updateUser(
        supabase.UserAttributes(
          // Passing `avatar_path: null` explicitly clears a removed avatar.
          data: {
            'name': name,
            'avatar_path': avatarPath,
            'avatar_cleared': avatarCleared,
          },
        ),
      );
    } on supabase.AuthException {
      throw const ProfileException(ProfileErrorCode.network);
    } catch (_) {
      throw const ProfileException(ProfileErrorCode.unknown);
    }
  }

  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    String? contentType,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const ProfileException(ProfileErrorCode.notConfigured);
    }
    // Unique filename per upload so a public CDN never serves a stale image.
    final ext = _extFor(contentType);
    final path = AppStorage.userScopedPath(userId, 'avatar_${newId()}.$ext');
    try {
      await _client.storage
          .from(StorageBuckets.avatars)
          .uploadBinary(
            path,
            bytes,
            fileOptions: supabase.FileOptions(
              contentType: contentType,
              upsert: true,
            ),
          );
      return path;
    } on supabase.StorageException {
      throw const ProfileException(ProfileErrorCode.network);
    } catch (_) {
      throw const ProfileException(ProfileErrorCode.unknown);
    }
  }

  @override
  Future<void> deleteAvatar(String path) async {
    try {
      await _client.storage.from(StorageBuckets.avatars).remove([path]);
    } catch (_) {
      // Best-effort cleanup — a leftover object is harmless and shouldn't fail
      // the save the user already saw succeed.
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

/// Offline / fake-auth fallback: profile editing needs a real backend, so every
/// call reports [ProfileErrorCode.notConfigured].
class UnavailableProfileRepository implements ProfileRepository {
  const UnavailableProfileRepository();

  @override
  Future<void> updateProfile({
    required String name,
    String? avatarPath,
    bool avatarCleared = false,
  }) async {
    throw const ProfileException(ProfileErrorCode.notConfigured);
  }

  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    String? contentType,
  }) async {
    throw const ProfileException(ProfileErrorCode.notConfigured);
  }

  @override
  Future<void> deleteAvatar(String path) async {}
}
