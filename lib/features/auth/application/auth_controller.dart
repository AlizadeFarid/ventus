import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/observability/crash_reporting.dart';
import '../../notifications/application/notifications_controller.dart';
import '../../tools/application/tools_providers.dart';
import '../../trips/application/trips_providers.dart';
import '../domain/auth_exception.dart';
import 'auth_providers.dart';
import 'pin_gate.dart';
import 'pin_service.dart';

/// Outcome of a sign-up attempt, so the screen knows where to go next.
enum SignUpResult {
  /// Session created immediately (email confirmation disabled) → PIN setup.
  confirmed,

  /// No session yet — the user must confirm via the emailed link → verify screen.
  needsVerification,

  /// The attempt failed; read the error from [authControllerProvider].
  failed,
}

/// Drives the async auth actions (sign in / sign up / reset) and exposes their
/// loading + error state to the screens.
///
/// Each action returns `true` on success so the caller can navigate, while the
/// notifier's [AsyncValue] state powers button spinners and error banners.
class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> signIn({required String email, required String password}) async {
    final ok = await _run(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email.trim(), password: password),
    );
    if (ok) await _enterSession();
    return ok;
  }

  /// Called after any successful authentication. The user just proved themselves
  /// with credentials, so mark the convenience-PIN gate unlocked for this
  /// session (don't also demand the PIN), and drop a one-time welcome for a
  /// brand-new account. Both are best-effort and never block the sign-in.
  Future<void> _enterSession() async {
    // Start the new session from a clean local store: drop any data left by a
    // previous user, then force every module's repo + sync to rebuild so they
    // re-pull for this user (otherwise the prior user's trips, etc. flash in).
    await ref.read(appDatabaseProvider).clearAllData();
    await ref.read(clockCitiesProvider.notifier).clear();

    ref.read(pinGateProvider).unlock();
    await ref
        .read(notificationsControllerProvider.notifier)
        .notifyWelcomeIfNew();
  }

  /// Native Google sign-in. Returns whether a session was created; a cancelled
  /// sheet returns false without surfacing an error.
  Future<bool> signInWithGoogle() =>
      _runOAuth(() => ref.read(authRepositoryProvider).signInWithGoogle());

  /// Native Apple sign-in. Same contract as [signInWithGoogle].
  Future<bool> signInWithApple() =>
      _runOAuth(() => ref.read(authRepositoryProvider).signInWithApple());

  /// Like [_run], but treats a user-cancelled sheet as a silent no-op (no error
  /// state) so the screen doesn't flash a failure when the user just backs out.
  Future<bool> _runOAuth(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      await _enterSession();
      return true;
    } on AuthException catch (e, st) {
      if (e.code == AuthErrorCode.cancelled) {
        state = const AsyncData(null);
        return false;
      }
      state = AsyncError(e, st);
      return false;
    } catch (e, st) {
      state = AsyncError(const AuthException(AuthErrorCode.unknown), st);
      return false;
    }
  }

  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final needsVerification = await ref
          .read(authRepositoryProvider)
          .signUpWithEmail(
            name: name.trim(),
            email: email.trim(),
            password: password,
          );
      state = const AsyncData(null);
      // Confirmation OFF → a session exists now, so enter it immediately. With
      // confirmation ON there's no session yet; the welcome + unlock land on the
      // first sign-in after the user verifies (see [signIn]).
      if (!needsVerification) await _enterSession();
      return needsVerification
          ? SignUpResult.needsVerification
          : SignUpResult.confirmed;
    } on AuthException catch (e, st) {
      debugPrint('SignUp AuthException: $e\\n$st');
      CrashReporting.recordError(e, st, reason: 'SignUp AuthException');
      state = AsyncError(e, st);
      return SignUpResult.failed;
    } catch (e, st) {
      debugPrint('SignUp Unknown Exception: $e\\n$st');
      CrashReporting.recordError(e, st, reason: 'SignUp unknown exception');
      state = AsyncError(const AuthException(AuthErrorCode.unknown), st);
      return SignUpResult.failed;
    }
  }

  Future<bool> resendConfirmation(String email) {
    return _run(
      () => ref.read(authRepositoryProvider).resendConfirmation(email.trim()),
    );
  }

  Future<bool> sendReset(String email) {
    return _run(
      () => ref.read(authRepositoryProvider).sendPasswordReset(email.trim()),
    );
  }

  Future<bool> resetPasswordWithToken({
    required String email,
    required String token,
    required String newPassword,
  }) {
    return _run(
      () => ref
          .read(authRepositoryProvider)
          .resetPasswordWithToken(
            email: email.trim(),
            token: token.trim(),
            newPassword: newPassword,
          ),
    );
  }

  Future<bool> changePassword({
    required String? currentPassword,
    required String newPassword,
  }) {
    return _run(
      () => ref
          .read(authRepositoryProvider)
          .changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
    );
  }

  /// Verifies the session and returns false (and signs out) if it is invalid.
  Future<bool> verifySession() async {
    try {
      await ref.read(authRepositoryProvider).verifySession();
      return true;
    } catch (_) {
      await signOut();
      return false;
    }
  }

  Future<void> signOut() async {
    // Wipe this user's local-first data so it can't show under the next user.
    await ref.read(appDatabaseProvider).clearAllData();
    await ref.read(clockCitiesProvider.notifier).clear();
    // Re-lock so the next session must re-enter the PIN on cold start.
    ref.read(pinGateProvider).relock();
    await ref.read(authRepositoryProvider).signOut();
  }

  /// Permanently deletes the account: clears the on-device PIN, re-locks, then
  /// asks the backend to remove the user (which also ends the session). Returns
  /// whether it succeeded so the screen can route to the welcome flow.
  Future<bool> deleteAccount() async {
    await ref.read(appDatabaseProvider).clearAllData();
    await ref.read(clockCitiesProvider.notifier).clear();
    await ref.read(pinServiceProvider).clear();
    ref.read(pinGateProvider).relock();
    return _run(() => ref.read(authRepositoryProvider).deleteAccount());
  }

  /// Runs an action, mapping it onto [state] and returning whether it succeeded.
  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on AuthException catch (e, st) {
      state = AsyncError(e, st);
      return false;
    } catch (e, st) {
      state = AsyncError(const AuthException(AuthErrorCode.unknown), st);
      return false;
    }
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

/// Whether the signed-in account has an email+password login at all.
///
/// False for a Google/Apple-only account, which has no password to verify —
/// see [AuthRepository.hasPasswordLogin]. The Privacy & security screen uses
/// this to offer "set a password" instead of "change password".
final hasPasswordLoginProvider = FutureProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).hasPasswordLogin();
});
