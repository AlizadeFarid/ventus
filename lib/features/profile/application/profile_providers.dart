import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/config/env.dart';
import '../../../core/storage/app_storage.dart';
import '../data/supabase_profile_repository.dart';
import '../domain/profile_repository.dart';

/// Lightweight view of the signed-in user for the profile screen.
class ProfileInfo {
  const ProfileInfo({
    required this.name,
    required this.email,
    this.userId,
    this.avatarPath,
    this.providerPhotoUrl,
  });

  final String name;
  final String email;

  /// The signed-in account's id, or null when signed out / running without a
  /// backend. Compared with a trip's `user_id` to tell its owner apart from an
  /// invited collaborator.
  final String? userId;

  /// Stored object path of the avatar inside the `avatars` bucket, or null.
  final String? avatarPath;

  /// Photo URL supplied by the identity provider (Google / Apple) on sign-in,
  /// or null when signing in with email — or once the user removed it.
  final String? providerPhotoUrl;

  /// Public URL for the avatar image, or null when there is none / offline.
  /// An avatar the user uploaded themselves wins over the provider's photo.
  String? get avatarUrl =>
      AppStorage.publicUrl(StorageBuckets.avatars, avatarPath) ??
      providerPhotoUrl;

  /// Up to two uppercase initials from the name, for the fallback avatar.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return 'V';
    final letters = parts.take(2).map((p) => p.characters.first).join();
    return letters.toUpperCase();
  }
}

/// Supabase auth events (sign-in, sign-out, user updated). Only created when a
/// backend is configured — see [profileProvider].
final _authStateProvider = StreamProvider<supabase.AuthState>(
  (ref) => supabase.Supabase.instance.client.auth.onAuthStateChange,
);

/// Current user's display name + email + avatar. Reads Supabase auth metadata
/// when configured; falls back to a placeholder for offline/dev (fake backend).
final profileProvider = Provider<ProfileInfo>((ref) {
  if (Env.isConfigured) {
    // Rebuild when the session behind the profile changes, so signing in with
    // Google shows that account's name and photo without an app restart.
    ref.watch(_authStateProvider);
    final user = supabase.Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata ?? const <String, dynamic>{};
    final meta = metadata['name'] ?? metadata['full_name'];
    final name = (meta is String && meta.trim().isNotEmpty)
        ? meta.trim()
        : 'Traveller';
    final avatar = metadata['avatar_path'];
    return ProfileInfo(
      name: name,
      email: user?.email ?? '',
      userId: user?.id,
      avatarPath: (avatar is String && avatar.isNotEmpty) ? avatar : null,
      providerPhotoUrl: _providerPhotoUrl(metadata),
    );
  }
  return const ProfileInfo(name: 'Traveller', email: 'traveller@ventus.app');
});

/// Reads the photo Google / Apple put on the auth user's metadata at sign-in.
/// Supabase stores it as `avatar_url` (Google also sends `picture`). Returns
/// null once the user removed their photo in Edit Profile, so the removal isn't
/// undone by the provider's copy.
String? _providerPhotoUrl(Map<String, dynamic> metadata) {
  if (metadata['avatar_cleared'] == true) return null;
  for (final key in const ['avatar_url', 'picture']) {
    final value = metadata[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}

/// Binds the [ProfileRepository] — real Supabase when configured, otherwise an
/// offline stub that reports profile editing is unavailable.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return Env.isConfigured
      ? SupabaseProfileRepository()
      : const UnavailableProfileRepository();
});
