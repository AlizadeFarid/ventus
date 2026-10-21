import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/utils/id.dart';
import '../domain/app_notification.dart';
import '../domain/notification_type.dart';
import 'notifications_providers.dart';

/// Drives notification mutations: the "mark read" actions the feed exposes, and
/// the producer helpers that other features call to emit an activity entry.
///
/// Producers are **best-effort**: emitting a notification must never break the
/// action that triggered it (an invite or AI plan still succeeds even if the
/// notification write fails), so [_emit] swallows its own errors.
class NotificationsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> markAllRead() =>
      _run(() => ref.read(notificationsRepositoryProvider).markAllRead());

  Future<void> markRead(String id) async {
    try {
      await ref.read(notificationsRepositoryProvider).markRead(id);
    } catch (_) {
      // A failed read-flag is non-critical; the feed stays usable.
    }
  }

  Future<bool> delete(String id) =>
      _run(() => ref.read(notificationsRepositoryProvider).delete(id));

  Future<bool> deleteAll() =>
      _run(() => ref.read(notificationsRepositoryProvider).deleteAll());

  /// Producer: a first-run welcome greeting. Guarded on an empty feed so it
  /// fires exactly once for a brand-new account and never duplicates for
  /// returning users — including a returning user signing in on a device
  /// that has never seen this account before.
  ///
  /// This is called on every sign-in, right after [AuthController] wipes the
  /// local Drift store for the incoming user, so the local feed always looks
  /// empty at this point regardless of account age or device. Checking it
  /// directly would welcome the user again on every login within the old
  /// "just registered" time window, or on any second device. [sync] first,
  /// so a returning account's already-synced notifications (from any device)
  /// are the ones actually being checked here.
  Future<void> notifyWelcomeIfNew() async {
    final repo = ref.read(notificationsRepositoryProvider);
    try {
      await repo.sync();
      final existing = await repo.watch().first;
      if (existing.isNotEmpty) return;
    } catch (_) {
      return; // Couldn't confirm the feed is really empty → skip rather than risk a duplicate.
    }
    await _emit(NotificationType.welcome);
  }

  /// Producer: Ventus AI finished drafting a trip's plan.
  Future<void> notifyAiPlanReady({
    required String tripId,
    required String tripTitle,
  }) =>
      _emit(NotificationType.aiPlanReady, tripId: tripId, tripTitle: tripTitle);

  /// Producer: someone was invited to co-plan a trip.
  Future<void> notifyCollaboratorInvited({
    required String tripId,
    String? tripTitle,
    required String email,
  }) => _emit(
    NotificationType.collaboratorInvited,
    tripId: tripId,
    tripTitle: tripTitle,
    subject: email,
  );

  Future<void> _emit(
    NotificationType kind, {
    String? tripId,
    String? tripTitle,
    String? subject,
  }) async {
    final userId = Env.isConfigured
        ? Supabase.instance.client.auth.currentUser?.id
        : null;
    final notification = AppNotification(
      id: newId(),
      userId: userId,
      kind: kind,
      tripId: tripId,
      tripTitle: tripTitle,
      subject: subject,
      createdAt: DateTime.now().toUtc(),
    );
    try {
      await ref.read(notificationsRepositoryProvider).add(notification);
    } catch (_) {
      // Best-effort: never surface a notification failure to the caller.
    }
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

final notificationsControllerProvider =
    AsyncNotifierProvider<NotificationsController, void>(
      NotificationsController.new,
    );
