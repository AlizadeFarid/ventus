import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/itinerary_item.dart';
import 'itinerary_providers.dart';

/// Drives itinerary write actions (save / delete) and exposes their loading +
/// error state. Reads stay reactive through [itineraryProvider]; this only owns
/// the mutations so screens can show spinners and surface failures.
class ItineraryController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save(ItineraryItem item) =>
      _run(() => ref.read(itineraryRepositoryProvider).save(item));

  Future<bool> delete(String id) =>
      _run(() => ref.read(itineraryRepositoryProvider).delete(id));

  /// Persists a drag-reorder: rewrites [dayItems]'s positions to their new
  /// index, in one batch. Items whose position is already correct are skipped,
  /// so a short drag doesn't push the whole day to the server.
  Future<bool> reorder(List<ItineraryItem> dayItems) {
    final changed = <ItineraryItem>[
      for (var i = 0; i < dayItems.length; i++)
        if (dayItems[i].position != i) dayItems[i].copyWith(position: i),
    ];
    if (changed.isEmpty) return Future.value(true);
    return _run(() => ref.read(itineraryRepositoryProvider).saveAll(changed));
  }

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

final itineraryControllerProvider =
    AsyncNotifierProvider<ItineraryController, void>(ItineraryController.new);
