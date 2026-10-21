import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/collaborator.dart';
import '../domain/collaborator_role.dart';
import '../domain/collaborators_repository.dart';
import 'supabase_collaborators_remote.dart';

/// Local-first [CollaboratorsRepository]: Drift is the source of truth the UI
/// reads from, so the list works offline. Writes hit Drift first (instant,
/// reactive) then the remote; [syncTrip] pulls remote changes back into Drift.
class DriftCollaboratorsRepository implements CollaboratorsRepository {
  DriftCollaboratorsRepository(this._db, {SupabaseCollaboratorsRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseCollaboratorsRemote? _remote;

  /// Key used in [AppDatabase.markPendingSync] et al. for this table.
  static const _table = 'collaborators';

  @override
  Stream<List<Collaborator>> watch(String tripId) {
    final query = _db.select(_db.collaborators)
      ..where((c) => c.tripId.equals(tripId))
      ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> save(Collaborator collaborator) async {
    await _db.transaction(() async {
      await _db
          .into(_db.collaborators)
          .insertOnConflictUpdate(_toCompanion(collaborator));
      await _db.markPendingSync(_table, collaborator.id);
    });
    if (_remote == null) return;
    await _remote.upsert(collaborator);
    await _db.clearPendingSync(_table, collaborator.id);
  }

  @override
  Future<void> remove(String id) async {
    await (_db.delete(_db.collaborators)..where((c) => c.id.equals(id))).go();
    await _remote?.remove(id);
    await _db.clearPendingSync(_table, id);
  }

  @override
  Future<void> syncTrip(String tripId) async {
    final remote = _remote;
    if (remote == null) return;
    // Fetch first; if the network fails this throws before we touch local data,
    // so an offline open keeps the existing local copy intact.
    final items = await remote.fetchForTrip(tripId);
    // Rows with unpushed local changes are never wiped/overwritten here.
    final pendingIds = await _db.pendingSyncIds(_table);
    final serverItems = items.where((c) => !pendingIds.contains(c.id)).toList();
    await _db.transaction(() async {
      if (pendingIds.isEmpty) {
        await (_db.delete(
          _db.collaborators,
        )..where((c) => c.tripId.equals(tripId))).go();
      } else {
        await (_db.delete(
              _db.collaborators,
            )..where((c) => c.tripId.equals(tripId) & c.id.isNotIn(pendingIds)))
            .go();
      }
      await _db.batch((batch) {
        batch.insertAll(
          _db.collaborators,
          serverItems.map(_toCompanion).toList(),
        );
      });
    });
  }

  @override
  Future<void> acceptInvite(String tripId) async {
    final remote = _remote;
    if (remote == null) return;
    await remote.acceptInvite(tripId);
    await syncTrip(tripId);
  }
}

Collaborator _toDomain(CollaboratorRow row) => Collaborator(
  id: row.id,
  tripId: row.tripId,
  userId: row.userId,
  email: row.email,
  name: row.name,
  role: collaboratorRoleFromName(row.role),
  status: collaboratorStatusFromName(row.status),
  createdAt: row.createdAt,
);

CollaboratorsCompanion _toCompanion(Collaborator c) =>
    CollaboratorsCompanion.insert(
      id: c.id,
      tripId: c.tripId,
      userId: Value(c.userId),
      email: c.email,
      name: Value(c.name),
      role: Value(c.role.name),
      status: Value(c.status.name),
      createdAt: c.createdAt,
    );
