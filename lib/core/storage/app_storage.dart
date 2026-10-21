import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';

/// Names of the Supabase Storage buckets, kept in one place so paths/URLs are
/// never spelled out ad-hoc across features.
///
/// Convention — buckets are split by **access level**, not by feature:
/// - [destinations] / [publicAssets]: public, admin-managed curated content.
/// - [tripCovers] / [avatars]: per-user content, guarded by owner RLS using
///   `{userId}/...` object paths (see [AppStorage.userScopedPath]).
abstract final class StorageBuckets {
  /// Public, admin-managed Discover destination images.
  static const destinations = 'destinations';

  /// Public, admin-managed app chrome (banners, category art, etc.).
  static const publicAssets = 'public-assets';

  /// Private per-user trip cover photos.
  static const tripCovers = 'trip-covers';

  /// Private per-user trip documents (tickets, vouchers, IDs). Owner-only;
  /// because it is private, reads go through [AppStorage.signedUrl], not
  /// [AppStorage.publicUrl].
  static const tripDocs = 'trip-docs';

  /// Per-user profile pictures.
  static const avatars = 'avatars';
}

/// Central helpers for turning stored object paths into usable URLs, and for
/// building the per-user path convention. The database always stores the object
/// *path* (e.g. `rome.jpg`); the URL is derived here at read time.
abstract final class AppStorage {
  /// Public URL for [path] inside [bucket], or `null` when there is no path or
  /// no configured backend (offline/dev) — callers fall back to a placeholder.
  ///
  /// A stored value that is already an absolute `http(s)` URL is returned
  /// unchanged. Curated Discover imagery is hosted outside our buckets, so a
  /// trip started from a Discover card carries that URL as its cover instead of
  /// an object path; everything downstream just asks for "the cover URL" and
  /// does not care which of the two it is.
  static String? publicUrl(String bucket, String? path) {
    if (path == null || path.isEmpty) return null;
    if (isAbsoluteUrl(path)) return path;
    if (!Env.isConfigured) return null;
    return Supabase.instance.client.storage.from(bucket).getPublicUrl(path);
  }

  /// Whether [value] is an already-usable absolute URL rather than an object
  /// path inside one of our buckets.
  static bool isAbsoluteUrl(String value) =>
      value.startsWith('http://') || value.startsWith('https://');

  /// A time-limited signed URL for [path] inside a **private** [bucket] (e.g.
  /// `trip-docs`), or `null` with no path / no configured backend. Use this for
  /// owner-only files where [publicUrl] would be rejected. [expiresIn] is in
  /// seconds (default one hour).
  static Future<String?> signedUrl(
    String bucket,
    String? path, {
    int expiresIn = 3600,
  }) async {
    if (path == null || path.isEmpty) return null;
    if (!Env.isConfigured) return null;
    return Supabase.instance.client.storage
        .from(bucket)
        .createSignedUrl(path, expiresIn);
  }

  /// Owner-scoped object path `{userId}/{name}`, matching the per-user RLS
  /// convention `(storage.foldername(name))[1] = auth.uid()`.
  static String userScopedPath(String userId, String name) => '$userId/$name';

  /// The signed-in user's id, used to build owner-scoped object paths. Null
  /// offline / when no backend is configured.
  static String? get currentUserId =>
      Env.isConfigured ? Supabase.instance.client.auth.currentUser?.id : null;
}
