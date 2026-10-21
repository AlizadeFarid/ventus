import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/checklist_item.dart';
import 'checklist_providers.dart';

/// Drives checklist write actions (save / toggle / delete) and exposes their
/// loading + error state. Reads stay reactive through [checklistProvider]; this
/// only owns the mutations so screens can show spinners and surface failures.
class ChecklistController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save(ChecklistItem item) =>
      _run(() => ref.read(checklistRepositoryProvider).save(item));

  /// Flips an item's done flag and persists it.
  Future<bool> toggle(ChecklistItem item) =>
      save(item.copyWith(done: !item.done));

  Future<bool> delete(String id) =>
      _run(() => ref.read(checklistRepositoryProvider).delete(id));

  /// Seeds a new trip's default checklist in one batch. Best-effort: a failure
  /// never blocks trip creation.
  Future<bool> seedDefaults(List<ChecklistItem> items) =>
      _run(() => ref.read(checklistRepositoryProvider).saveAll(items));

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

final checklistControllerProvider =
    AsyncNotifierProvider<ChecklistController, void>(ChecklistController.new);
