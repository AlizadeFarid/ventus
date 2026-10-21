import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/document.dart';
import '../domain/document_type.dart';
import '../domain/documents_repository.dart';
import 'supabase_documents_remote.dart';

/// Local-first [DocumentsRepository]: Drift is the source of truth the UI reads
/// document metadata from (so the list works offline). The file binaries live
/// only in the private `trip-docs` Storage bucket, reached through the remote.
///
/// Writes hit Storage (binary) + Drift (metadata) + the remote table; deletes
/// remove the object then the rows; [syncTrip] pulls remote metadata into Drift.
class DriftDocumentsRepository implements DocumentsRepository {
  DriftDocumentsRepository(this._db, {SupabaseDocumentsRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseDocumentsRemote? _remote;

  /// Key used in [AppDatabase.markPendingSync] et al. for this table.
  static const _table = 'documents';

  @override
  Stream<List<TripDocument>> watch(String tripId) {
    final query = _db.select(_db.documents)
      ..where((d) => d.tripId.equals(tripId))
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> upload(
    TripDocument doc,
    Uint8List bytes, {
    String? contentType,
  }) async {
    // Push the binary first; if the upload fails we don't leave a dangling
    // metadata row pointing at a missing object.
    await _remote?.uploadObject(
      doc.storagePath,
      bytes,
      contentType: contentType,
    );
    await _db.transaction(() async {
      await _db.into(_db.documents).insertOnConflictUpdate(_toCompanion(doc));
      await _db.markPendingSync(_table, doc.id);
    });
    if (_remote == null) return;
    await _remote.upsert(doc);
    await _db.clearPendingSync(_table, doc.id);
  }

  @override
  Future<void> update(TripDocument doc) async {
    await _db.transaction(() async {
      await _db.into(_db.documents).insertOnConflictUpdate(_toCompanion(doc));
      await _db.markPendingSync(_table, doc.id);
    });
    if (_remote == null) return;
    await _remote.upsert(doc);
    await _db.clearPendingSync(_table, doc.id);
  }

  @override
  Future<void> delete(TripDocument doc) async {
    await _remote?.removeObject(doc.storagePath);
    await (_db.delete(_db.documents)..where((d) => d.id.equals(doc.id))).go();
    await _remote?.deleteRow(doc.id);
    await _db.clearPendingSync(_table, doc.id);
  }

  @override
  Future<void> syncTrip(String tripId) async {
    final remote = _remote;
    if (remote == null) return;
    // Fetch first; if the network fails this throws before we touch local data,
    // so an offline open keeps the existing local copy intact.
    final docs = await remote.fetchForTrip(tripId);
    // Docs with unpushed local changes are never wiped/overwritten here.
    final pendingIds = await _db.pendingSyncIds(_table);
    final serverDocs = docs.where((d) => !pendingIds.contains(d.id)).toList();
    await _db.transaction(() async {
      if (pendingIds.isEmpty) {
        await (_db.delete(
          _db.documents,
        )..where((d) => d.tripId.equals(tripId))).go();
      } else {
        await (_db.delete(
              _db.documents,
            )..where((d) => d.tripId.equals(tripId) & d.id.isNotIn(pendingIds)))
            .go();
      }
      await _db.batch((batch) {
        batch.insertAll(_db.documents, serverDocs.map(_toCompanion).toList());
      });
    });
  }

  @override
  Future<Uint8List?> fileBytes(TripDocument doc) =>
      _remote?.download(doc.storagePath) ?? Future.value(null);

  @override
  Future<String?> signedUrl(TripDocument doc) =>
      _remote?.signedUrl(doc.storagePath) ?? Future.value(null);
}

TripDocument _toDomain(DocumentRow row) => TripDocument(
  id: row.id,
  tripId: row.tripId,
  name: row.name,
  type: _typeFromName(row.type),
  storagePath: row.storagePath,
  ext: row.ext,
  mimeType: row.mimeType,
  sizeBytes: row.sizeBytes,
  day: row.day,
  createdAt: row.createdAt,
);

DocumentsCompanion _toCompanion(TripDocument doc) => DocumentsCompanion.insert(
  id: doc.id,
  tripId: doc.tripId,
  name: doc.name,
  type: Value(doc.type.name),
  storagePath: doc.storagePath,
  ext: Value(doc.ext),
  mimeType: Value(doc.mimeType),
  sizeBytes: Value(doc.sizeBytes),
  day: Value(doc.day),
  createdAt: doc.createdAt,
);

/// Parses the stored [DocumentType] name, tolerating null/unknown values.
DocumentType _typeFromName(String? name) {
  for (final type in DocumentType.values) {
    if (type.name == name) return type;
  }
  return DocumentType.other;
}
