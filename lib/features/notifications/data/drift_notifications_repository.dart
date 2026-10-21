import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/app_notification.dart';
import '../domain/notification_type.dart';
import '../domain/notifications_repository.dart';
import 'supabase_notifications_remote.dart';

/// Local-first [NotificationsRepository]: Drift is the source of truth the feed
/// reads from, so it works offline. Writes hit Drift first (instant, reactive)
/// then the remote; [sync] pulls remote changes back into Drift.
class DriftNotificationsRepository implements NotificationsRepository {
  DriftNotificationsRepository(this._db, {SupabaseNotificationsRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseNotificationsRemote? _remote;

  /// Key used in [AppDatabase.markPendingSync] et al. for this table.
  static const _table = 'notifications';

  @override
  Stream<List<AppNotification>> watch() {
    final query = _db.select(_db.notifications)
      ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> add(AppNotification notification) async {
    await _db.transaction(() async {
      await _db
          .into(_db.notifications)
          .insertOnConflictUpdate(_toCompanion(notification));
      await _db.markPendingSync(_table, notification.id);
    });
    if (_remote == null) return;
    await _remote.upsert(notification);
    await _db.clearPendingSync(_table, notification.id);
  }

  @override
  Future<void> markRead(String id) async {
    await (_db.update(_db.notifications)..where((n) => n.id.equals(id))).write(
      const NotificationsCompanion(read: Value(true)),
    );
    await _remote?.markRead(id);
  }

  @override
  Future<void> markAllRead() async {
    await (_db.update(_db.notifications)..where((n) => n.read.equals(false)))
        .write(const NotificationsCompanion(read: Value(true)));
    await _remote?.markAllRead();
  }

  @override
  Future<void> sync() async {
    final remote = _remote;
    if (remote == null) return;
    // Fetch first; if the network fails this throws before we touch local data,
    // so an offline open keeps the existing local copy intact.
    final items = await remote.fetchAll();
    // Notifications with unpushed local changes (e.g. just added while
    // offline) are never wiped/overwritten here.
    final pendingIds = await _db.pendingSyncIds(_table);
    final serverItems = items.where((n) => !pendingIds.contains(n.id)).toList();
    await _db.transaction(() async {
      if (pendingIds.isEmpty) {
        await _db.delete(_db.notifications).go();
      } else {
        await (_db.delete(
          _db.notifications,
        )..where((n) => n.id.isNotIn(pendingIds))).go();
      }
      await _db.batch((batch) {
        batch.insertAll(
          _db.notifications,
          serverItems.map(_toCompanion).toList(),
        );
      });
    });
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.notifications)..where((n) => n.id.equals(id))).go();
    await _remote?.delete(id);
    await _db.clearPendingSync(_table, id);
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.notifications).go();
    await _remote?.deleteAll();
  }
}

AppNotification _toDomain(NotificationRow row) => AppNotification(
  id: row.id,
  userId: row.userId,
  kind: notificationTypeFromName(row.kind),
  tripId: row.tripId,
  tripTitle: row.tripTitle,
  subject: row.subject,
  read: row.read,
  createdAt: row.createdAt,
);

NotificationsCompanion _toCompanion(AppNotification n) =>
    NotificationsCompanion.insert(
      id: n.id,
      userId: Value(n.userId),
      kind: Value(n.kind.name),
      tripId: Value(n.tripId),
      tripTitle: Value(n.tripTitle),
      subject: Value(n.subject),
      read: Value(n.read),
      createdAt: n.createdAt,
    );
