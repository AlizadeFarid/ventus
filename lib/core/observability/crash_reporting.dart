import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/env.dart';

/// Crash and error reporting, backed by Sentry.
///
/// The app previously had **no** reporting at all: a launch failure rendered a
/// raw stack trace on screen and nothing else, and every feature's silent
/// `catch (_) { ... }` fallback (offline degrade, fake-data fallback, …)
/// discarded the underlying error with no record anywhere. This class is the
/// single entry point for fixing that.
///
/// Sentry rather than Firebase Crashlytics: Ventus's backend is Supabase, so
/// pulling in the whole Firebase SDK to report crashes meant carrying a second
/// platform's native dependencies for one feature. Sentry is a single-purpose
/// dependency, is configured entirely from Dart (one DSN string — no native
/// config files, no `flutterfire configure` step), and still installs native
/// handlers, so a hard crash that kills the process is written to disk and
/// uploaded on the next launch.
///
/// Setup (one-time):
///   1. Create a free account at sentry.io and a **Flutter** project.
///   2. Copy the DSN it shows you (`https://…@…ingest.sentry.io/…`).
///   3. Put it in `env.json` as `SENTRY_DSN`.
///
/// Without a DSN everything here is a no-op and [guard] just runs the app —
/// same graceful-degradation pattern as `Env.isConfigured` for Supabase.
abstract final class CrashReporting {
  /// Whether reporting is actually initialized and sending events.
  ///
  /// Read from the SDK rather than tracked in a local flag: [guard] runs the
  /// app *inside* `SentryFlutter.init`, so anything that reported an error
  /// during startup — including `main`'s own "Launch failure" handler — saw a
  /// flag that had not been set yet and dropped the event silently.
  static bool get isEnabled => Env.isSentryConfigured && Sentry.isEnabled;

  /// Runs the app with error reporting installed around it.
  ///
  /// Sentry has to own the zone the app runs in so it can catch errors that
  /// escape the framework, which is why this wraps `runApp` instead of being a
  /// plain `init()` called beside it.
  static Future<void> guard(FutureOr<void> Function() appRunner) async {
    if (!Env.isSentryConfigured) {
      await appRunner();
      return;
    }
    try {
      await SentryFlutter.init((options) {
        options.dsn = Env.sentryDsn;
        options.environment = kReleaseMode ? 'production' : 'development';
        // Errors only. Performance tracing bills against the same quota and
        // buys nothing while the app is pre-launch.
        options.tracesSampleRate = 0;
        // Never ship request bodies, headers or device identifiers. The only
        // thing tied to a person is the Supabase user id set by [setUserId],
        // which is an opaque UUID.
        options.sendDefaultPii = false;
        options.attachScreenshot = false;
        // Local noise (hot reload, debugger pauses) is not worth quota.
        options.beforeSend = (event, hint) => kReleaseMode ? event : null;
      }, appRunner: appRunner);
    } catch (_) {
      // A malformed DSN or an offline first run must never stop the app from
      // starting — fall back to running it unreported.
      await appRunner();
    }
  }

  /// Record a caught (non-fatal) error from anywhere in the app — most usefully
  /// from a `catch` block that would otherwise discard the error silently
  /// (this codebase has ~27 of those). No-ops if not [isEnabled].
  static void recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) {
    if (!isEnabled) return;
    unawaited(
      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.level = fatal ? SentryLevel.fatal : SentryLevel.error;
          // Searchable in Sentry's UI, so "all GoogleSignIn failures" is one
          // filter rather than a manual scan.
          if (reason != null) scope.setTag('reason', reason);
        },
      ),
    );
  }

  /// Breadcrumb-style log line attached to the next error report.
  static void log(String message) {
    if (!isEnabled) return;
    unawaited(Sentry.addBreadcrumb(Breadcrumb(message: message)));
  }

  /// Tags subsequent reports with the signed-in user's id (or clears it on
  /// sign-out). Not PII on its own — just the Supabase auth uid.
  static Future<void> setUserId(String? userId) async {
    if (!isEnabled) return;
    await Sentry.configureScope(
      (scope) => scope.setUser(userId == null ? null : SentryUser(id: userId)),
    );
  }
}
