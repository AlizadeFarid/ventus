import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/avatar_picker.dart';
import '../domain/profile_repository.dart';
import 'profile_providers.dart';

/// Drives the Edit Profile save action and exposes its loading state.
///
/// Orchestrates the repository primitives (upload → write metadata → clean up
/// the old image) and refreshes [profileProvider] so the Profile screen and
/// avatar update immediately. Returns a [ProfileErrorCode] on failure, or null
/// on success, mirroring the auth/AI controllers.
class ProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<ProfileErrorCode?> save({
    required String name,
    PickedAvatar? newAvatar,
    bool removeAvatar = false,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(profileRepositoryProvider);
    final previousPath = ref.read(profileProvider).avatarPath;

    try {
      // Decide the avatar path to persist: a fresh upload, an explicit removal,
      // or keep whatever was there before.
      String? avatarPath;
      if (removeAvatar) {
        avatarPath = null;
      } else if (newAvatar != null) {
        avatarPath = await repo.uploadAvatar(
          bytes: newAvatar.bytes,
          contentType: newAvatar.contentType,
        );
      } else {
        avatarPath = previousPath;
      }

      await repo.updateProfile(
        name: name.trim(),
        avatarPath: avatarPath,
        // A removal has to stick even when the sign-in provider supplied a
        // photo; picking a new one lifts the flag again.
        avatarCleared: removeAvatar,
      );

      // Best-effort: drop the old image when it was replaced or removed.
      if (previousPath != null && previousPath != avatarPath) {
        await repo.deleteAvatar(previousPath);
      }

      ref.invalidate(profileProvider);
      state = const AsyncData(null);
      return null;
    } on ProfileException catch (e, st) {
      state = AsyncError(e, st);
      return e.code;
    } catch (e, st) {
      state = AsyncError(e, st);
      return ProfileErrorCode.unknown;
    }
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, void>(ProfileController.new);
