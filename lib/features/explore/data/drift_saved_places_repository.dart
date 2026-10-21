import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/saved_place.dart';
import '../domain/saved_places_repository.dart';
import 'supabase_saved_places_remote.dart';

/// Local-first [SavedPlacesRepository]: Drift is the source of truth the UI
/// reads (works offline); writes hit Drift then the remote, and [sync] mirrors
/// the remote back into Drift.
class DriftSavedPlacesRepository implements SavedPlacesRepository {
  DriftSavedPlacesRepository(this._db, {SupabaseSavedPlacesRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseSavedPlacesRemote? _remote;

  /// Key used in [AppDatabase.markPendingSync] et al. for this table.
  static const _table = 'saved_places';

  @override
  Stream<List<SavedPlace>> watch() {
    final query = _db.select(_db.savedPlaces)
      ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> save(SavedPlace place) async {
    await _db.transaction(() async {
      await _db
          .into(_db.savedPlaces)
          .insertOnConflictUpdate(_toCompanion(place));
      await _db.markPendingSync(_table, place.destinationId);
    });
    if (_remote == null) return;
    await _remote.upsert(place);
    await _db.clearPendingSync(_table, place.destinationId);
  }

  @override
  Future<void> remove(String destinationId) async {
    await (_db.delete(
      _db.savedPlaces,
    )..where((p) => p.destinationId.equals(destinationId))).go();
    await _remote?.remove(destinationId);
    await _db.clearPendingSync(_table, destinationId);
  }

  @override
  Future<void> sync() async {
    final remote = _remote;
    if (remote == null) return;
    final places = await remote.fetchAll();
    // Rows with unpushed local changes (just-hearted places not yet pushed)
    // are never wiped/overwritten here.
    final pendingIds = await _db.pendingSyncIds(_table);
    final serverPlaces = places
        .where((p) => !pendingIds.contains(p.destinationId))
        .toList();
    await _db.transaction(() async {
      if (pendingIds.isEmpty) {
        await _db.delete(_db.savedPlaces).go();
      } else {
        await (_db.delete(
          _db.savedPlaces,
        )..where((p) => p.destinationId.isNotIn(pendingIds))).go();
      }
      await _db.batch((batch) {
        batch.insertAll(
          _db.savedPlaces,
          serverPlaces.map(_toCompanion).toList(),
        );
      });
    });
  }
}

SavedPlace _toDomain(SavedPlaceRow row) => SavedPlace(
  destinationId: row.destinationId,
  userId: row.userId,
  name: row.name,
  country: row.country,
  imageUrl: row.imageUrl,
  createdAt: row.createdAt,
);

SavedPlacesCompanion _toCompanion(SavedPlace p) => SavedPlacesCompanion.insert(
  destinationId: p.destinationId,
  userId: Value(p.userId),
  name: p.name,
  country: p.country,
  imageUrl: Value(p.imageUrl),
  createdAt: p.createdAt,
);
