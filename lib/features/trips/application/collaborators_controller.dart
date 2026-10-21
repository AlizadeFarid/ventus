import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id.dart';

import '../domain/collaborator.dart';
import '../domain/collaborator_role.dart';
import 'collaborators_providers.dart';
import 'trips_providers.dart';

/// Drives collaborator write actions (invite / change role / remove) and
/// exposes their loading + error state. Reads stay reactive through
/// [collaboratorsProvider]; this only owns the mutations.
class CollaboratorsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Invites [email] to [tripId] with [role] as a pending collaborator.
  Future<bool> invite({
    required String tripId,
    required String email,
    required CollaboratorRole role,
  }) {
    final collaborator = Collaborator(
      id: newId(),
      tripId: tripId,
      email: email.trim(),
      role: role,
      status: CollaboratorStatus.pending,
      createdAt: DateTime.now().toUtc(),
    );
    return _run(() async {
      await ref.read(collaboratorsRepositoryProvider).save(collaborator);
    });
  }

  /// Accepts an invite for the given [tripId].
  Future<bool> acceptInvite(String tripId) => _run(() async {
    await ref.read(collaboratorsRepositoryProvider).acceptInvite(tripId);
    await ref.read(tripsRepositoryProvider).sync();
  });

  /// Changes an existing collaborator's role and persists it.
  Future<bool> changeRole(Collaborator collaborator, CollaboratorRole role) =>
      _run(
        () => ref
            .read(collaboratorsRepositoryProvider)
            .save(collaborator.copyWith(role: role)),
      );

  Future<bool> remove(String id) =>
      _run(() => ref.read(collaboratorsRepositoryProvider).remove(id));

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

final collaboratorsControllerProvider =
    AsyncNotifierProvider<CollaboratorsController, void>(
      CollaboratorsController.new,
    );
