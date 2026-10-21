import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/traveler_type.dart';
import '../domain/trip.dart';
import '../domain/trip_stop.dart';
import '../domain/trips_repository.dart';
import 'supabase_trips_remote.dart';

/// Local-first [TripsRepository]: Drift is the source of truth the UI reads
/// from, so the app works offline. Writes hit Drift first (instant, reactive)
/// and then the remote; [sync] pulls remote changes back into Drift.
class DriftTripsRepository implements TripsRepository {
  DriftTripsRepository(this._db, {SupabaseTripsRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseTripsRemote? _remote;

  /// Key used in [AppDatabase.markPendingSync] et al. for this table.
  static const _table = 'trips';

  /// Same bookkeeping table, separate key: trips deleted locally whose server
  /// delete has not gone through yet. Without it, [sync] would pull the
  /// still-existing server copy straight back into the list.
  static const _deleteKey = 'trips:delete';

  @override
  Stream<List<Trip>> watchTrips() {
    final query = _db.select(_db.trips)
      ..orderBy([(t) => OrderingTerm.asc(t.startDate)]);
    // The dashboard only needs title/country/dates/cover, so stops are left
    // empty here to avoid an extra query per row. [getTrip] hydrates them.
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Trip?> getTrip(String id) async {
    final row = await (_db.select(
      _db.trips,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _toDomain(row).copyWith(stops: await _stopsOf(id));
  }

  @override
  Future<void> saveTrip(Trip trip) async {
    await _db.transaction(() async {
      await _db.into(_db.trips).insertOnConflictUpdate(_toCompanion(trip));
      await _writeStops(trip);
      // Mark before attempting the remote push: if the push fails or never
      // completes (offline), this row must survive the next sync() instead
      // of being wiped as a stale local row. Cleared below once the push to
      // the server actually succeeds.
      await _db.markPendingSync(_table, trip.id);
    });
    if (_remote == null) return;
    await _remote.upsert(trip);
    await _db.clearPendingSync(_table, trip.id);
  }

  @override
  Future<void> deleteTrip(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.tripStops)..where((s) => s.tripId.equals(id))).go();
      await (_db.delete(_db.trips)..where((t) => t.id.equals(id))).go();
      await _db.clearPendingSync(_table, id);
      await _db.markPendingSync(_deleteKey, id);
    });
    final remote = _remote;
    if (remote == null) return;
    try {
      await remote.delete(id);
      await _db.clearPendingSync(_deleteKey, id);
    } on TripDeleteForbiddenException {
      // Not ours to delete: forget the local deletion and bring the trip back.
      await _db.clearPendingSync(_deleteKey, id);
      try {
        await sync();
      } catch (_) {}
      rethrow;
    } catch (_) {
      // Offline or a transient failure: the deletion stays queued and is
      // retried by the next [sync], so from the user's side it is done.
    }
  }

  /// Retries queued server deletes. Returns the ids that are still waiting.
  Future<Set<String>> _flushPendingDeletes(SupabaseTripsRemote remote) async {
    final queued = await _db.pendingSyncIds(_deleteKey);
    final stillPending = <String>{};
    for (final id in queued) {
      try {
        await remote.delete(id);
        await _db.clearPendingSync(_deleteKey, id);
      } on TripDeleteForbiddenException {
        await _db.clearPendingSync(_deleteKey, id);
      } catch (_) {
        stillPending.add(id);
      }
    }
    return stillPending;
  }

  @override
  Future<void> sync() async {
    final remote = _remote;
    if (remote == null) return;
    // Fetch first; if the network fails this throws before we touch local data,
    // so an offline start keeps the existing local copy intact.
    final undeleted = await _flushPendingDeletes(remote);
    final trips = (await remote.fetchAll())
        .where((t) => !undeleted.contains(t.id))
        .toList();
    // Rows with unpushed local changes (offline-created, or edited since the
    // last successful push) are never wiped or overwritten here — the
    // server's copy of them is either missing or stale. Everything else is
    // mirrored exactly from the server, same as before.
    final pendingIds = await _db.pendingSyncIds(_table);
    final serverTrips = trips.where((t) => !pendingIds.contains(t.id)).toList();

    await _db.transaction(() async {
      if (pendingIds.isEmpty) {
        await _db.delete(_db.tripStops).go();
        await _db.delete(_db.trips).go();
      } else {
        await (_db.delete(
          _db.trips,
        )..where((t) => t.id.isNotIn(pendingIds))).go();
        await (_db.delete(
          _db.tripStops,
        )..where((s) => s.tripId.isNotIn(pendingIds))).go();
      }
      await _db.batch((batch) {
        batch.insertAll(_db.trips, serverTrips.map(_toCompanion).toList());
        batch.insertAll(_db.tripStops, [
          for (final t in serverTrips) ...t.stops.map(_toStopCompanion),
        ]);
      });
    });
  }

  @override
  Future<void> seedDemoIfEmpty() async {
    final existing = await (_db.select(_db.trips)..limit(1)).get();
    if (existing.isNotEmpty) return;
    final now = DateTime.now();
    final demo = [
      Trip(
        id: 'demo-istanbul',
        title: 'Istanbul',
        country: 'Türkiye',
        startDate: DateTime(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 14)),
        endDate: DateTime(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 17)),
        plannedPercent: 35,
        createdAt: now,
        updatedAt: now,
      ),
      Trip(
        id: 'demo-dubai',
        title: 'Dubai',
        country: 'UAE',
        startDate: DateTime(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 60)),
        endDate: DateTime(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 66)),
        plannedPercent: 10,
        createdAt: now,
        updatedAt: now,
      ),
      Trip(
        id: 'demo-paris',
        title: 'Paris',
        country: 'France',
        startDate: DateTime(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 120)),
        endDate: DateTime(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 126)),
        plannedPercent: 0,
        createdAt: now,
        updatedAt: now,
      ),
    ];
    await _db.batch((batch) {
      batch.insertAll(_db.trips, demo.map(_toCompanion).toList());
    });
  }

  /// Reads a trip's stops, ordered by position.
  Future<List<TripStop>> _stopsOf(String tripId) async {
    final rows =
        await (_db.select(_db.tripStops)
              ..where((s) => s.tripId.equals(tripId))
              ..orderBy([(s) => OrderingTerm.asc(s.position)]))
            .get();
    return rows.map(_stopToDomain).toList();
  }

  /// Replaces a trip's stored stops with [Trip.stops] (delete then insert).
  Future<void> _writeStops(Trip trip) async {
    await (_db.delete(
      _db.tripStops,
    )..where((s) => s.tripId.equals(trip.id))).go();
    if (trip.stops.isEmpty) return;
    await _db.batch((batch) {
      batch.insertAll(_db.tripStops, trip.stops.map(_toStopCompanion).toList());
    });
  }
}

Trip _toDomain(TripRow row) => Trip(
  id: row.id,
  userId: row.userId,
  title: row.title,
  country: row.country,
  coverImagePath: row.coverImagePath,
  startDate: row.startDate,
  endDate: row.endDate,
  plannedPercent: row.plannedPercent,
  adults: row.adults,
  children: row.children,
  travelerType: _travelerTypeFromName(row.travelerType),
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

TripsCompanion _toCompanion(Trip trip) => TripsCompanion.insert(
  id: trip.id,
  userId: Value(trip.userId),
  title: trip.title,
  country: trip.country,
  coverImagePath: Value(trip.coverImagePath),
  startDate: trip.startDate,
  endDate: trip.endDate,
  plannedPercent: Value(trip.plannedPercent),
  adults: Value(trip.adults),
  children: Value(trip.children),
  travelerType: Value(trip.travelerType?.name),
  createdAt: trip.createdAt,
  updatedAt: trip.updatedAt,
);

TripStop _stopToDomain(TripStopRow row) => TripStop(
  id: row.id,
  tripId: row.tripId,
  name: row.name,
  country: row.country,
  position: row.position,
  lat: row.lat,
  lon: row.lon,
);

TripStopsCompanion _toStopCompanion(TripStop stop) => TripStopsCompanion.insert(
  id: stop.id,
  tripId: stop.tripId,
  name: stop.name,
  country: stop.country,
  position: Value(stop.position),
  lat: Value(stop.lat),
  lon: Value(stop.lon),
);

/// Parses the stored [TravelerType] name, tolerating null/unknown values.
TravelerType? _travelerTypeFromName(String? name) {
  if (name == null) return null;
  for (final type in TravelerType.values) {
    if (type.name == name) return type;
  }
  return null;
}
