/// Backend-agnostic classification of an authentication failure.
///
/// Repositories map provider-specific errors to one of these codes; the
/// presentation layer maps the code to a localized, user-facing message
/// (see `AuthErrorL10n`). This keeps error text out of the domain/data layers.
enum AuthErrorCode {
  invalidCredentials,
  emailAlreadyExists,
  emailNotConfirmed,
  googleComingSoon,
  appleComingSoon,
  weakPassword,
  samePassword,
  invalidOtp,
  rateLimitExceeded,

  /// The user dismissed a sign-in sheet (Google/Apple) — not a real error, so
  /// the UI stays silent instead of showing a failure message.
  cancelled,
  unknown,
}

/// A user-facing authentication error, identified by a [AuthErrorCode].
class AuthException implements Exception {
  const AuthException(this.code, {this.debugMessage});

  final AuthErrorCode code;

  /// Raw backend/plugin detail (e.g. the Supabase or GoogleSignIn error
  /// message). Never shown to end users — only surfaced in debug builds,
  /// appended to the snackbar, so a device build over USB (no attached
  /// console) can still be diagnosed without Crashlytics.
  final String? debugMessage;

  @override
  String toString() =>
      'AuthException(${code.name}'
      '${debugMessage != null ? ', $debugMessage' : ''})';
}
