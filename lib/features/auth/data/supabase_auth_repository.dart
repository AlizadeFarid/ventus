import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/config/env.dart';
import '../../../core/observability/crash_reporting.dart';
import '../domain/auth_exception.dart';
import '../domain/auth_repository.dart';

/// Real [AuthRepository] backed by Supabase Auth (email + password).
///
/// Supabase/gotrue errors are translated into the domain [AuthException] so the
/// UI stays decoupled from the backend. The client is read lazily so this class
/// can be constructed before — or without — Supabase being initialized.
class SupabaseAuthRepository implements AuthRepository {
  supabase.SupabaseClient get _client => supabase.Supabase.instance.client;

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on supabase.AuthException catch (e) {
      throw AuthException(_codeFor(e.message), debugMessage: e.message);
    } catch (e) {
      throw AuthException(AuthErrorCode.unknown, debugMessage: '$e');
    }
  }

  @override
  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      // When "Confirm email" is OFF, Supabase rejects a duplicate with an
      // AuthException (handled below). When it's ON, a duplicate instead comes
      // back as a user with an empty `identities` list — treat that as existing.
      if (res.user?.identities?.isEmpty ?? false) {
        throw const AuthException(AuthErrorCode.emailAlreadyExists);
      }
      // With "Confirm email" ON a brand-new signup has no session yet — the user
      // must confirm via the emailed link first. Report that back to the caller
      // (which routes to the verify-email screen) instead of failing.
      return res.session == null;
    } on supabase.AuthException catch (e) {
      throw AuthException(_codeFor(e.message), debugMessage: e.message);
    }
  }

  @override
  Future<void> resendConfirmation(String email) async {
    try {
      await _client.auth.resend(type: supabase.OtpType.signup, email: email);
    } on supabase.AuthException catch (e) {
      throw AuthException(_codeFor(e.message), debugMessage: e.message);
    } catch (e) {
      throw AuthException(AuthErrorCode.unknown, debugMessage: '$e');
    }
  }

  /// Maps a few known backend messages to a domain [AuthErrorCode].
  AuthErrorCode _codeFor(String message) {
    debugPrint('[Supabase Auth Error] $message');
    CrashReporting.log('[Supabase Auth Error] $message');
    final lower = message.toLowerCase();
    if (lower.contains('already registered') ||
        lower.contains('already exists')) {
      return AuthErrorCode.emailAlreadyExists;
    }
    if (lower.contains('invalid login credentials')) {
      return AuthErrorCode.invalidCredentials;
    }
    if (lower.contains('not confirmed') || lower.contains('not verified')) {
      return AuthErrorCode.emailNotConfirmed;
    }
    if (lower.contains('different from the old') ||
        lower.contains('should be different')) {
      return AuthErrorCode.samePassword;
    }
    if (lower.contains('at least') || lower.contains('weak')) {
      return AuthErrorCode.weakPassword;
    }
    if (lower.contains('rate limit')) {
      return AuthErrorCode.rateLimitExceeded;
    }
    return AuthErrorCode.unknown;
  }

  @override
  Future<bool> hasPasswordLogin() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;
    final identities = user.identities;
    // No identity list at all (older sessions) → assume the classic
    // email+password account, which is what every pre-OAuth user is.
    if (identities == null || identities.isEmpty) return true;
    if (identities.any((i) => i.provider == 'email')) return true;
    // updateUser(password:) sets the password but never links an `email`
    // identity (a known Supabase Auth gap: supabase/auth#2085), so a
    // password set from an OAuth account is tracked via this metadata flag
    // instead — see changePassword below.
    return user.userMetadata?['has_password'] == true;
  }

  @override
  Future<void> changePassword({
    required String? currentPassword,
    required String newPassword,
  }) async {
    final email = _client.auth.currentUser?.email;
    if (email == null) {
      throw const AuthException(AuthErrorCode.unknown);
    }
    // Re-verify the current password before allowing a change — skipped only
    // for an OAuth-only account, which has no password to verify against.
    if (currentPassword != null) {
      try {
        await _client.auth.signInWithPassword(
          email: email,
          password: currentPassword,
        );
      } on supabase.AuthException {
        throw const AuthException(AuthErrorCode.invalidCredentials);
      }
    } else if (await hasPasswordLogin()) {
      // Defence in depth: never let a null current password through for an
      // account that does have one.
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }
    // Set the new password on the now-verified session, and flag it in
    // metadata since updateUser doesn't link an `email` identity on its own
    // (see hasPasswordLogin above).
    try {
      final metadata = {..._client.auth.currentUser?.userMetadata ?? {}};
      metadata['has_password'] = true;
      await _client.auth.updateUser(
        supabase.UserAttributes(password: newPassword, data: metadata),
      );
    } on supabase.AuthException catch (e) {
      throw AuthException(_codeFor(e.message));
    } catch (_) {
      throw const AuthException(AuthErrorCode.unknown);
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (_) {
      throw const AuthException(AuthErrorCode.unknown);
    }
  }

  @override
  Future<void> resetPasswordWithToken({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    // Verify the emailed recovery code → this opens a short-lived session.
    try {
      await _client.auth.verifyOTP(
        type: supabase.OtpType.recovery,
        email: email,
        token: token,
      );
    } on supabase.AuthException {
      throw const AuthException(AuthErrorCode.invalidOtp);
    }
    // Set the new password on the now-verified session, and flag it in
    // metadata since updateUser doesn't link an `email` identity on its own
    // (see hasPasswordLogin above).
    try {
      final metadata = {..._client.auth.currentUser?.userMetadata ?? {}};
      metadata['has_password'] = true;
      await _client.auth.updateUser(
        supabase.UserAttributes(password: newPassword, data: metadata),
      );
    } on supabase.AuthException catch (e) {
      throw AuthException(_codeFor(e.message));
    } catch (_) {
      throw const AuthException(AuthErrorCode.unknown);
    }
  }

  @override
  Future<void> verifySession() async {
    try {
      final res = await _client.auth.getUser();
      if (res.user == null) {
        throw const AuthException(AuthErrorCode.unknown);
      }
    } catch (_) {
      throw const AuthException(AuthErrorCode.unknown);
    }
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<void> deleteAccount() async {
    try {
      // The Edge Function verifies our session JWT (sent automatically) and
      // deletes the user with the service role; then we clear the local session.
      await _client.functions.invoke('delete-account');
      await _client.auth.signOut();
    } on supabase.FunctionException catch (_) {
      throw const AuthException(AuthErrorCode.unknown);
    } catch (_) {
      throw const AuthException(AuthErrorCode.unknown);
    }
  }

  // `GoogleSignIn.instance.initialize` must be called exactly once per process
  // (the plugin's own contract — calling it twice is "undefined behavior"), so
  // this guards against re-initializing on a second sign-in attempt.
  bool _googleSignInInitialized = false;

  Future<GoogleSignIn> _ensureGoogleSignIn() async {
    final instance = GoogleSignIn.instance;
    if (!_googleSignInInitialized) {
      // The web client ID is the `serverClientId` so the token's audience
      // matches Supabase; the iOS client ID is also picked up from Info.plist
      // (GIDClientID) but is passed explicitly here too.
      await instance.initialize(
        clientId: Env.googleIosClientId.isEmpty ? null : Env.googleIosClientId,
        serverClientId: Env.googleWebClientId,
      );
      _googleSignInInitialized = true;
    }
    return instance;
  }

  @override
  Future<void> signInWithGoogle() async {
    if (!Env.isGoogleConfigured) {
      throw const AuthException(AuthErrorCode.googleComingSoon);
    }
    try {
      // Native Google sheet → ID token → Supabase session.
      final googleSignIn = await _ensureGoogleSignIn();
      final account = await googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        final msg =
            '[GoogleSignIn] idToken is null — check serverClientId '
            '(GOOGLE_WEB_CLIENT_ID).';
        debugPrint(msg);
        CrashReporting.recordError(
          const AuthException(AuthErrorCode.unknown),
          StackTrace.current,
          reason: msg,
        );
        throw AuthException(AuthErrorCode.unknown, debugMessage: msg);
      }
      await _client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: idToken,
      );
    } on AuthException {
      rethrow;
    } on GoogleSignInException catch (e, st) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException(AuthErrorCode.cancelled);
      }
      final msg = '[GoogleSignIn] ${e.code}: ${e.description}';
      debugPrint(msg);
      CrashReporting.recordError(e, st, reason: 'GoogleSignIn exception');
      throw AuthException(AuthErrorCode.unknown, debugMessage: msg);
    } on supabase.AuthException catch (e, st) {
      final msg =
          '[GoogleSignIn] Supabase rejected the token: '
          'status=${e.statusCode} message="${e.message}"';
      debugPrint(msg);
      CrashReporting.recordError(e, st, reason: 'GoogleSignIn token rejected');
      throw AuthException(_codeFor(e.message), debugMessage: msg);
    } catch (e, st) {
      final msg = '[GoogleSignIn] unexpected ${e.runtimeType}: $e';
      debugPrint('$msg\n$st');
      CrashReporting.recordError(
        e,
        st,
        reason: 'GoogleSignIn unexpected error',
      );
      throw AuthException(AuthErrorCode.unknown, debugMessage: msg);
    }
  }

  @override
  Future<void> signInWithApple() async {
    try {
      // A nonce binds Apple's ID token to this request: the SHA-256 hash goes to
      // Apple, the raw value to Supabase, which re-hashes and compares.
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException(AuthErrorCode.unknown);
      }
      await _client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthException(AuthErrorCode.cancelled);
      }
      throw AuthException(
        AuthErrorCode.unknown,
        debugMessage: '${e.code}: ${e.message}',
      );
    } on AuthException {
      rethrow;
    } on supabase.AuthException catch (e) {
      throw AuthException(_codeFor(e.message), debugMessage: e.message);
    } catch (e) {
      throw AuthException(AuthErrorCode.unknown, debugMessage: '$e');
    }
  }

  /// Cryptographically-random nonce for the Apple sign-in challenge.
  String _generateNonce([int length = 32]) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
