import 'dart:typed_data';

/// Why a save failed, kept backend-agnostic so the UI maps codes → localized
/// text (mirrors the auth/AI repositories' error-code pattern).
enum ProfileErrorCode {
  /// No configured backend (offline / fake auth) — editing isn't available.
  notConfigured,

  /// Network / storage / auth call failed.
  network,

  /// Anything we didn't classify.
  unknown,
}

/// A domain error raised by [ProfileRepository], carrying a [ProfileErrorCode].
class ProfileException implements Exception {
  const ProfileException(this.code);

  final ProfileErrorCode code;

  @override
  String toString() => 'ProfileException($code)';
}

/// Contract for reading and updating the signed-in user's profile, independent
/// of any backend. The display name + avatar path live on the auth user's
/// metadata; the avatar image itself lives in the `avatars` Storage bucket.
abstract interface class ProfileRepository {
  /// Persists the display [name] and the [avatarPath] (the stored object path,
  /// or `null` to clear the avatar) onto the user's metadata.
  ///
  /// [avatarCleared] records that the user removed their photo on purpose, so
  /// the picture an identity provider (Google / Apple) put on the metadata is
  /// not shown in its place.
  Future<void> updateProfile({
    required String name,
    String? avatarPath,
    bool avatarCleared = false,
  });

  /// Uploads avatar image [bytes] to the owner-scoped path in the `avatars`
  /// bucket and returns the stored object path (to save via [updateProfile]).
  Future<String> uploadAvatar({required Uint8List bytes, String? contentType});

  /// Best-effort removal of a previously uploaded avatar object at [path].
  Future<void> deleteAvatar(String path);
}
