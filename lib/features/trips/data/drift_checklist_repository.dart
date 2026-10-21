import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/checklist_category.dart';
import '../domain/checklist_item.dart';
import '../domain/checklist_repository.dart';
import 'supabase_checklist_remote.dart';

/// Local-first [ChecklistRepository]: Drift is the source of truth the UI reads
/// from, so the checklist works offline. Writes hit Drift first (instant,
/// reactive) then the remote; [syncTrip] pulls remote changes back into Drift.
class DriftChecklistRepository implements ChecklistRepository {
  DriftChecklistRepository(this._db, {SupabaseChecklistRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseChecklistRemote? _remote;

  /// Key used in [AppDatabase.markPendingSync] et al. for this table.
  static const _table = 'checklist_items';

  @override
  Stream<List<ChecklistItem>> watch(String tripId) {
    final query = _db.select(_db.checklistItems)
      ..where((c) => c.tripId.equals(tripId))
      ..orderBy([
        (c) => OrderingTerm.asc(c.position),
        (c) => OrderingTerm.asc(c.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> save(ChecklistItem item) async {
    await _db.transaction(() async {
      await _db
          .into(_db.checklistItems)
          .insertOnConflictUpdate(_toCompanion(item));
      await _db.markPendingSync(_table, item.id);
    });
    if (_remote == null) return;
    await _remote.upsert(item);
    await _db.clearPendingSync(_table, item.id);
  }

  @override
  Future<void> saveAll(List<ChecklistItem> items) async {
    if (items.isEmpty) return;
    await _db.transaction(() async {
      await _db.batch((batch) {
        batch.insertAll(
          _db.checklistItems,
          items.map(_toCompanion).toList(),
          mode: InsertMode.insertOrReplace,
        );
      });
      for (final item in items) {
        await _db.markPendingSync(_table, item.id);
      }
    });
    if (_remote == null) return;
    await _remote.upsertAll(items);
    for (final item in items) {
      await _db.clearPendingSync(_table, item.id);
    }
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.checklistItems)..where((c) => c.id.equals(id))).go();
    await _remote?.delete(id);
    // Success (or nothing was pending): tidy up the marker. If the remote
    // delete above threw, this line is never reached, which correctly keeps
    // the item excluded from being resurrected by the next syncTrip().
    await _db.clearPendingSync(_table, id);
  }

  @override
  Future<void> syncTrip(String tripId) async {
    final remote = _remote;
    if (remote == null) return;
    // Fetch first; if the network fails this throws before we touch local data,
    // so an offline open keeps the existing local copy intact.
    final items = await remote.fetchForTrip(tripId);
    // Items with unpushed local changes are never wiped/overwritten here.
    final pendingIds = await _db.pendingSyncIds(_table);
    final serverItems = items.where((i) => !pendingIds.contains(i.id)).toList();
    await _db.transaction(() async {
      if (pendingIds.isEmpty) {
        await (_db.delete(
          _db.checklistItems,
        )..where((c) => c.tripId.equals(tripId))).go();
      } else {
        await (_db.delete(
              _db.checklistItems,
            )..where((c) => c.tripId.equals(tripId) & c.id.isNotIn(pendingIds)))
            .go();
      }
      await _db.batch((batch) {
        batch.insertAll(
          _db.checklistItems,
          serverItems.map(_toCompanion).toList(),
        );
      });
    });
  }
}

ChecklistItem _toDomain(ChecklistItemRow row) => ChecklistItem(
  id: row.id,
  tripId: row.tripId,
  title: row.title,
  done: row.done,
  category: _categoryFromName(row.category),
  dueDate: row.dueDate,
  position: row.position,
  createdAt: row.createdAt,
);

ChecklistItemsCompanion _toCompanion(ChecklistItem item) =>
    ChecklistItemsCompanion.insert(
      id: item.id,
      tripId: item.tripId,
      title: item.title,
      done: Value(item.done),
      category: Value(item.category.name),
      dueDate: Value(item.dueDate),
      position: Value(item.position),
      createdAt: item.createdAt,
    );

/// Parses the stored [ChecklistCategory] name, tolerating null/unknown values.
ChecklistCategory _categoryFromName(String? name) {
  for (final category in ChecklistCategory.values) {
    if (category.name == name) return category;
  }
  return ChecklistCategory.beforeYouGo;
}
