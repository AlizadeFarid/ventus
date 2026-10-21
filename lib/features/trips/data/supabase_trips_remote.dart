import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/trip.dart';
import '../domain/trip_stop.dart';

/// The server refused to delete a trip because the signed-in user does not own
/// it (an invited collaborator, for instance).
///
/// Row-level security makes such a delete a silent no-op rather than an error,
/// so [SupabaseTripsRemote.delete] detects it and throws this instead.
class TripDeleteForbiddenException implements Exception {
  const TripDeleteForbiddenException();

  @override
  String toString() => 'Only the owner can delete this trip.';
}

/// Thin Supabase wrapper for the `trips` table and its `trip_stops` children.
///
/// All reads/writes are scoped to the signed-in user; row-level security on the
/// server enforces the same boundary. Errors propagate to the caller, which
/// keeps the local-first copy as the source of truth even if a push fails.
class SupabaseTripsRemote {
  static const _table = 'trips';
  static const _stopsTable = 'trip_stops';

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Fetches every trip belonging to the current user, with its route stops
  /// hydrated and ordered by position.
  Future<List<Trip>> fetchAll() async {
    final uid = _userId;
    if (uid == null) return const [];

    final tripRows = await _client.from(_table).select();
    final stopRows = await _client.from(_stopsTable).select().order('position');

    // Group stops by trip once, so attaching them is a single pass.
    final stopsByTrip = <String, List<TripStop>>{};
    for (final row in stopRows) {
      final stop = TripStop.fromJson(row);
      (stopsByTrip[stop.tripId] ??= []).add(stop);
    }

    return tripRows
        .map(Trip.fromJson)
        .map((t) => t.copyWith(stops: stopsByTrip[t.id] ?? const []))
        .toList();
  }

  /// Inserts or updates [trip] for the current user (id is the conflict key),
  /// then replaces its set of route stops.
  Future<void> upsert(Trip trip) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_table).upsert({
      ...trip.toJson(),
      if (trip.userId == null) 'user_id': uid,
    });
    await _replaceStops(uid, trip);
  }

  /// Deletes [id] on the server. Its stops (and every other child row) go with
  /// it through the `on delete cascade` foreign keys, so nothing is removed
  /// piecemeal first — a refused delete must not leave a half-deleted trip.
  ///
  /// Throws [TripDeleteForbiddenException] when the row survives: RLS filters
  /// a forbidden delete to zero rows without raising any error, which used to
  /// make this look successful while the trip came straight back on the next
  /// sync.
  Future<void> delete(String id) async {
    if (_userId == null) return;
    final deleted = await _client
        .from(_table)
        .delete()
        .eq('id', id)
        .select('id');
    if (deleted.isNotEmpty) return;
    final survivor = await _client
        .from(_table)
        .select('id')
        .eq('id', id)
        .maybeSingle();
    if (survivor != null) throw const TripDeleteForbiddenException();
  }

  /// Overwrites the stored stops of a trip with [Trip.stops] — delete then
  /// insert, so removed stops disappear and order stays authoritative.
  Future<void> _replaceStops(String uid, Trip trip) async {
    await _client.from(_stopsTable).delete().eq('trip_id', trip.id);
    if (trip.stops.isEmpty) return;
    final ownerId = trip.userId ?? uid;
    await _client.from(_stopsTable).insert([
      for (final stop in trip.stops) {...stop.toJson(), 'user_id': ownerId},
    ]);
  }
}
