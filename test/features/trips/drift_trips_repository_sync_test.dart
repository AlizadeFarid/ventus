import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ventus/core/database/app_database.dart';
import 'package:ventus/features/trips/data/drift_trips_repository.dart';
import 'package:ventus/features/trips/data/supabase_trips_remote.dart';
import 'package:ventus/features/trips/domain/trip.dart';

/// In-memory stand-in for [SupabaseTripsRemote] that never touches Supabase.
/// [SupabaseTripsRemote] isn't behind an interface, so this subclasses it and
/// overrides every method the repository calls — the base class's Supabase
/// client is never invoked because none of the overrides call `super`.
class _FakeTripsRemote extends SupabaseTripsRemote {
  final Map<String, Trip> store = {};

  /// When true, [upsert] throws instead of writing — simulates an offline or
  /// failed push so tests can assert the local row survives a later sync.
  bool failUpserts = false;

  /// When set, [delete] throws it — simulates an offline failure
  /// (any exception) or a refusal by row-level security
  /// ([TripDeleteForbiddenException]).
  Object? deleteError;

  @override
  Future<List<Trip>> fetchAll() async => store.values.toList();

  @override
  Future<void> upsert(Trip trip) async {
    if (failUpserts) {
      throw Exception('simulated network failure');
    }
    store[trip.id] = trip;
  }

  @override
  Future<void> delete(String id) async {
    if (deleteError != null) throw deleteError!;
    store.remove(id);
  }
}

Trip _trip(String id, {String title = 'Trip'}) {
  final now = DateTime(2026, 1, 1);
  return Trip(
    id: id,
    title: title,
    country: 'Testland',
    startDate: now,
    endDate: now.add(const Duration(days: 3)),
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late AppDatabase db;
  late _FakeTripsRemote remote;
  late DriftTripsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    remote = _FakeTripsRemote();
    repo = DriftTripsRepository(db, remote: remote);
  });

  tearDown(() => db.close());

  test(
    'a trip created while offline (remote push fails) survives a later sync()',
    () async {
      remote.failUpserts = true;
      await expectLater(repo.saveTrip(_trip('offline-1')), throwsException);

      // The local write itself must have succeeded despite the remote failing.
      expect(await repo.getTrip('offline-1'), isNotNull);

      // The remote never received it, so fetchAll() comes back empty — a naive
      // full-mirror sync would wipe the trip here. It must not.
      remote.failUpserts = false;
      await repo.sync();

      expect(
        await repo.getTrip('offline-1'),
        isNotNull,
        reason: 'offline-created trip must not be deleted by sync()',
      );
    },
  );

  test('a trip that successfully pushes is cleared to sync normally', () async {
    await repo.saveTrip(_trip('synced-1'));
    expect(remote.store.containsKey('synced-1'), isTrue);

    // Simulate the trip being deleted on another device: the server no
    // longer has it, and since our local copy is clean (already pushed),
    // sync() should mirror that deletion locally.
    remote.store.remove('synced-1');
    await repo.sync();

    expect(await repo.getTrip('synced-1'), isNull);
  });

  test('an offline edit to an already-synced trip is not clobbered by a '
      'stale server copy during sync()', () async {
    // Get a clean, synced trip onto both sides.
    await repo.saveTrip(_trip('edit-1', title: 'Original'));
    expect(remote.store['edit-1']?.title, 'Original');

    // Edit it locally while the push fails (offline edit).
    remote.failUpserts = true;
    await expectLater(
      repo.saveTrip(_trip('edit-1', title: 'Edited offline')),
      throwsException,
    );

    // The server still only knows about the old title.
    remote.failUpserts = false;
    final trip = await repo.getTrip('edit-1');
    expect(trip?.title, 'Edited offline');

    // sync() must not overwrite the pending local edit with the stale
    // server copy.
    await repo.sync();
    final afterSync = await repo.getTrip('edit-1');
    expect(afterSync?.title, 'Edited offline');
  });

  test('a clean second trip is still replaced by the server copy during '
      'sync() even while another trip is pending', () async {
    await repo.saveTrip(_trip('clean-1', title: 'Clean'));
    remote.failUpserts = true;
    await expectLater(repo.saveTrip(_trip('dirty-1')), throwsException);
    remote.failUpserts = false;

    // Server-side title change on the clean trip.
    remote.store['clean-1'] = _trip('clean-1', title: 'Renamed on server');
    await repo.sync();

    expect((await repo.getTrip('clean-1'))?.title, 'Renamed on server');
    expect(
      await repo.getTrip('dirty-1'),
      isNotNull,
      reason: 'the still-pending trip must survive alongside the mirrored one',
    );
  });

  test('a trip deleted while the server delete fails stays deleted after '
      'sync() and is removed from the server once it can be', () async {
    await repo.saveTrip(_trip('del-1'));
    remote.deleteError = Exception('offline');

    // The user's delete succeeds locally even though the server call fails.
    await repo.deleteTrip('del-1');
    expect(await repo.getTrip('del-1'), isNull);

    // Still failing: the server copy must not be pulled back.
    await repo.sync();
    expect(
      await repo.getTrip('del-1'),
      isNull,
      reason: 'a queued delete must not be undone by the mirror',
    );
    expect(remote.store.containsKey('del-1'), isTrue);

    // Back online: the queued delete goes through on the next sync.
    remote.deleteError = null;
    await repo.sync();
    expect(remote.store.containsKey('del-1'), isFalse);
    expect(await repo.getTrip('del-1'), isNull);
  });

  test(
    'deleting a trip the user may not delete restores it and reports it',
    () async {
      await repo.saveTrip(_trip('not-mine'));
      remote.deleteError = const TripDeleteForbiddenException();

      await expectLater(
        repo.deleteTrip('not-mine'),
        throwsA(isA<TripDeleteForbiddenException>()),
      );

      expect(
        await repo.getTrip('not-mine'),
        isNotNull,
        reason: 'the refused delete must not leave the trip hidden locally',
      );
      expect(remote.store.containsKey('not-mine'), isTrue);
    },
  );
}
