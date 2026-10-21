/// Compile-time configuration injected via `--dart-define-from-file=env.json`.
///
/// Keys live in a git-ignored `env.json` (see `env.example.json`), so secrets
/// never land in source control. When the values are absent (e.g. plain
/// `flutter test`), [isConfigured] is false and the app falls back to its
/// in-memory fakes instead of hitting Supabase.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Google OAuth web client ID — used as `serverClientId` so the ID token's
  /// audience matches what Supabase verifies. Get it from Google Cloud Console
  /// (the "Web application" OAuth client) and add it to the Supabase Google
  /// provider too. Empty when not configured → Google sign-in stays unavailable.
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  /// Google OAuth iOS client ID (the "iOS" OAuth client). Also goes into
  /// `ios/Runner/Info.plist` as `GIDClientID` + a reversed-client-id URL scheme.
  static const googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );

  /// Sentry DSN — the only thing crash reporting needs.
  ///
  /// Get it from sentry.io → your Flutter project → Settings → Client Keys.
  /// It looks like `https://<key>@<org>.ingest.sentry.io/<id>`. Empty (the
  /// default) turns reporting off entirely; see [CrashReporting].
  ///
  /// A DSN is a write-only ingest endpoint, not a secret that grants access to
  /// your data — but it lives in the git-ignored `env.json` with the rest of
  /// the config anyway, so there is one place to look.
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Whether native Google sign-in has the client IDs it needs.
  static bool get isGoogleConfigured => googleWebClientId.isNotEmpty;

  /// Whether crash reporting has a DSN to send to.
  static bool get isSentryConfigured => sentryDsn.isNotEmpty;
}
