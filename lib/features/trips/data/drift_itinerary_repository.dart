import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../../core/database/app_database.dart';
import '../domain/activity_kind.dart';
import '../domain/itinerary_item.dart';
import '../domain/itinerary_repository.dart';
import 'supabase_itinerary_remote.dart';

/// Local-first [ItineraryRepository]: Drift is the source of truth the UI reads
/// from, so the plan works offline. Writes hit Drift first (instant, reactive)
/// then the remote; [syncTrip] pulls remote changes back into Drift.
class DriftItineraryRepository implements ItineraryRepository {
  DriftItineraryRepository(this._db, {SupabaseItineraryRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseItineraryRemote? _remote;

  /// Key used in [AppDatabase.markPendingSync] et al. for this table.
  static const _table = 'itinerary_items';

  @override
  Stream<List<ItineraryItem>> watch(String tripId) {
    final query = _db.select(_db.itineraryItems)
      ..where((i) => i.tripId.equals(tripId));
    // Sort in Dart so untimed activities fall to the end of their day (SQL
    // NULLS ordering is finicky): day, then the manual position, then time.
    return query.watch().map(
      (rows) => (rows.map(_toDomain).toList())..sort(byDayThenPosition),
    );
  }

  @override
  Future<void> save(ItineraryItem item) async {
    await _db.transaction(() async {
      await _db
          .into(_db.itineraryItems)
          .insertOnConflictUpdate(_toCompanion(item));
      await _db.markPendingSync(_table, item.id);
    });
    // The local write above already succeeded, and the plan is read from
    // Drift, so a failed push (offline, or a server-side problem) is not a
    // failed save: the row stays marked pending and [syncTrip] retries it.
    // Reporting it as an error left the sheet open on an activity that had in
    // fact been added.
    try {
      await _remote?.upsert(item);
      if (_remote != null) await _db.clearPendingSync(_table, item.id);
    } catch (e) {
      debugPrint('Itinerary push deferred: $e');
    }
  }

  @override
  Future<void> saveAll(List<ItineraryItem> items) async {
    if (items.isEmpty) return;
    await _db.transaction(() async {
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.itineraryItems,
          items.map(_toCompanion).toList(),
        );
      });
      for (final item in items) {
        await _db.markPendingSync(_table, item.id);
      }
    });
    try {
      await _remote?.upsertMany(items);
      if (_remote != null) {
        for (final item in items) {
          await _db.clearPendingSync(_table, item.id);
        }
      }
    } catch (e) {
      debugPrint('Itinerary batch push deferred: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.itineraryItems)..where((i) => i.id.equals(id))).go();
    await _remote?.delete(id);
    await _db.clearPendingSync(_table, id);
  }

  @override
  Future<void> syncTrip(String tripId) async {
    final remote = _remote;
    if (remote == null) return;
    // Retry pushes that failed earlier, so a deferred save reaches the server
    // as soon as it can; whatever still fails stays pending (and protected
    // from the mirror below).
    final queued = await _db.pendingSyncIds(_table);
    if (queued.isNotEmpty) {
      final rows = await (_db.select(
        _db.itineraryItems,
      )..where((i) => i.tripId.equals(tripId) & i.id.isIn(queued))).get();
      if (rows.isNotEmpty) {
        try {
          await remote.upsertMany(rows.map(_toDomain).toList());
          for (final row in rows) {
            await _db.clearPendingSync(_table, row.id);
          }
        } catch (e) {
          debugPrint('Itinerary retry failed: $e');
        }
      }
    }
    // Fetch first; if the network fails this throws before we touch local data,
    // so an offline open keeps the existing local copy intact.
    final items = await remote.fetchForTrip(tripId);
    // Items with unpushed local changes are never wiped/overwritten here.
    final pendingIds = await _db.pendingSyncIds(_table);
    final serverItems = items.where((i) => !pendingIds.contains(i.id)).toList();
    await _db.transaction(() async {
      if (pendingIds.isEmpty) {
        await (_db.delete(
          _db.itineraryItems,
        )..where((i) => i.tripId.equals(tripId))).go();
      } else {
        await (_db.delete(
              _db.itineraryItems,
            )..where((i) => i.tripId.equals(tripId) & i.id.isNotIn(pendingIds)))
            .go();
      }
      await _db.batch((batch) {
        batch.insertAll(
          _db.itineraryItems,
          serverItems.map(_toCompanion).toList(),
        );
      });
    });
  }
}

/// Orders activities within a trip: by day, then the manual position, then
/// start time (untimed last), then a stable creation tiebreak.
///
/// Position leads rather than time so a drag actually sticks. Time is not
/// ignored — [positionForNewItem] seeds a new activity's position from its
/// start time, so adding a 09:00 stop to a day that already has a 14:00 one
/// still drops it in the right place without the user touching anything.
int byDayThenPosition(ItineraryItem a, ItineraryItem b) {
  if (a.day != b.day) return a.day.compareTo(b.day);
  if (a.position != b.position) return a.position.compareTo(b.position);
  final at = a.startMinutes ?? 1 << 30;
  final bt = b.startMinutes ?? 1 << 30;
  if (at != bt) return at.compareTo(bt);
  return a.createdAt.compareTo(b.createdAt);
}

/// Where a new activity should sit among [dayItems] (already ordered).
///
/// Timed activities slot in ahead of the first later-or-untimed one; untimed
/// activities go to the end of the day.
int positionForNewItem(List<ItineraryItem> dayItems, int? startMinutes) {
  if (startMinutes == null) return dayItems.length;
  for (var i = 0; i < dayItems.length; i++) {
    final other = dayItems[i].startMinutes;
    if (other == null || other > startMinutes) return i;
  }
  return dayItems.length;
}

ItineraryItem _toDomain(ItineraryItemRow row) => ItineraryItem(
  id: row.id,
  tripId: row.tripId,
  day: row.day,
  startMinutes: row.startMinutes,
  title: row.title,
  place: row.place,
  kind: _kindFromName(row.kind),
  position: row.position,
  lat: row.lat,
  lon: row.lon,
  createdAt: row.createdAt,
);

ItineraryItemsCompanion _toCompanion(ItineraryItem item) =>
    ItineraryItemsCompanion.insert(
      id: item.id,
      tripId: item.tripId,
      day: item.day,
      startMinutes: Value(item.startMinutes),
      title: item.title,
      place: Value(item.place),
      kind: Value(item.kind.name),
      position: Value(item.position),
      lat: Value(item.lat),
      lon: Value(item.lon),
      createdAt: item.createdAt,
    );

/// Parses the stored [ActivityKind] name, tolerating null/unknown values.
ActivityKind _kindFromName(String? name) {
  for (final kind in ActivityKind.values) {
    if (kind.name == name) return kind;
  }
  return ActivityKind.activity;
}
