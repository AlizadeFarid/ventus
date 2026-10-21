import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../domain/saved_place.dart';
import 'saved_providers.dart';

/// Write actions for saved places: toggle / save / remove.
class SavedController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Saves [place] if not already saved, otherwise removes it. Returns the new
  /// saved state (true = now saved).
  Future<bool> toggle(SavedPlace place) async {
    final saved = ref.read(savedIdsProvider).contains(place.destinationId);
    if (saved) {
      await _run(
        () =>
            ref.read(savedPlacesRepositoryProvider).remove(place.destinationId),
      );
      return false;
    }
    final userId = Env.isConfigured
        ? Supabase.instance.client.auth.currentUser?.id
        : null;
    await _run(
      () => ref
          .read(savedPlacesRepositoryProvider)
          .save(place.copyWith(userId: userId)),
    );
    return true;
  }

  Future<void> remove(String destinationId) =>
      _run(() => ref.read(savedPlacesRepositoryProvider).remove(destinationId));

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final savedControllerProvider = AsyncNotifierProvider<SavedController, void>(
  SavedController.new,
);
