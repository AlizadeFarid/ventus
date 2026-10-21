import 'app_notification.dart';

/// Contract for the user's activity-feed storage, independent of any backend.
///
/// Local-first like the trip sub-features: rows are read from on-device Drift
/// (so the feed works offline) and mirrored to Supabase when configured.
abstract interface class NotificationsRepository {
  /// Streams the user's notifications (newest first), re-emitting on change.
  Stream<List<AppNotification>> watch();

  /// Inserts [notification] locally, then pushes to the remote. Best-effort —
  /// producers call this as a side effect and shouldn't fail their main action.
  Future<void> add(AppNotification notification);

  /// Marks a single notification as read, locally and on the remote.
  Future<void> markRead(String id);

  /// Marks every notification as read, locally and on the remote.
  Future<void> markAllRead();

  /// Pulls the user's remote notifications into local storage. No-op without a
  /// configured backend.
  Future<void> sync();

  /// Deletes a single notification, locally and on the remote.
  Future<void> delete(String id);

  /// Deletes every notification, locally and on the remote.
  Future<void> deleteAll();
}
