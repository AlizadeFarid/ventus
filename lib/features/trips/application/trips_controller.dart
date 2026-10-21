import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cover_picker.dart';
import '../data/trip_cover_storage.dart';
import '../domain/trip.dart';
import 'trips_providers.dart';
import '../../../core/storage/app_storage.dart';

/// Drives trip write actions (save / delete / sync) and exposes their loading +
/// error state. Reads remain reactive through [tripsProvider]; this only owns
/// the mutations so screens can show spinners and surface failures.
class TripsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save(Trip trip) =>
      _run(() => ref.read(tripsRepositoryProvider).saveTrip(trip));

  Future<bool> delete(String id) =>
      _run(() => ref.read(tripsRepositoryProvider).deleteTrip(id));

  /// Sets, replaces or removes [trip]'s cover photo: uploads [picked] to the
  /// `trip-covers` bucket (or clears the path when [remove]), persists the new
  /// path on the trip, then best-effort deletes the previous object.
  Future<bool> changeCover({
    required Trip trip,
    PickedCover? picked,
    bool remove = false,
  }) => _run(() async {
    final storage = ref.read(tripCoverStorageProvider);
    final old = trip.coverImagePath;
    String? newPath = old;
    if (remove) {
      newPath = null;
    } else if (picked != null) {
      newPath =
          await storage.upload(
            tripId: trip.id,
            bytes: picked.bytes,
            contentType: picked.contentType,
          ) ??
          old;
    }
    await ref
        .read(tripsRepositoryProvider)
        .saveTrip(
          trip.copyWith(coverImagePath: newPath, updatedAt: DateTime.now()),
        );
    // Only clean up objects we actually own. A cover inherited from a
    // Discover card is an external URL, not something in our bucket.
    if (old != null && old != newPath && !AppStorage.isAbsoluteUrl(old)) {
      await storage.delete(old);
    }
  });

  Future<bool> refresh() =>
      _run(() => ref.read(tripsRepositoryProvider).sync());

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final tripsControllerProvider = AsyncNotifierProvider<TripsController, void>(
  TripsController.new,
);
