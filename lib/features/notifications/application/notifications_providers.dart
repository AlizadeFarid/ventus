import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../trips/application/trips_providers.dart';
import '../data/drift_notifications_repository.dart';
import '../data/supabase_notifications_remote.dart';
import '../domain/app_notification.dart';
import '../domain/notifications_repository.dart';

/// Binds [NotificationsRepository] to the local-first Drift implementation,
/// sharing the app database with the trip repositories and attaching a Supabase
/// remote only when the backend is configured.
final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseNotificationsRemote() : null;
  return DriftNotificationsRepository(db, remote: remote);
});

/// Pulls the user's remote notifications into Drift once, when the feed opens.
final notificationsSyncProvider = FutureProvider.autoDispose<void>((ref) {
  return ref.watch(notificationsRepositoryProvider).sync();
});

/// Live list of the user's notifications (newest first), backed by Drift.
final notificationsProvider = StreamProvider.autoDispose<List<AppNotification>>(
  (ref) {
    return ref.watch(notificationsRepositoryProvider).watch();
  },
);

/// Number of unread notifications, for the Profile menu's "N new" chip.
final unreadNotificationsCountProvider = Provider.autoDispose<int>((ref) {
  final list = ref.watch(notificationsProvider).asData?.value;
  if (list == null) return 0;
  return list.where((n) => !n.read).length;
});
