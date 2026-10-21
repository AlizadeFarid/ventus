import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/observability/crash_reporting.dart';
import 'core/startup/install_guard.dart';
import 'core/theme/app_typography.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Everything below runs inside Sentry's error zone, so an uncaught error
  // anywhere in the app — including one thrown during startup — is reported.
  // Without a `SENTRY_DSN` in env.json this just calls [_startApp] directly.
  await CrashReporting.guard(_startApp);
}

Future<void> _startApp() async {
  try {
    // Load locale-aware date formatting (needed for az/tr month names in
    // DateFormat, which otherwise only ships en_US data).
    await initializeDateFormatting().timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        throw Exception('initializeDateFormatting timed out');
      },
    );

    // Initialize Supabase only when configured (via --dart-define-from-file).
    // Without keys the app still runs against the in-memory fakes.
    if (Env.isConfigured) {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        // The legacy anon JWT is passed here; `anonKey` is deprecated in favour
        // of `publishableKey` but remains the correct param for this key format.
        // ignore: deprecated_member_use
        anonKey: Env.supabaseAnonKey,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception(
            'Supabase.initialize timed out. Check VPN or Network!',
          );
        },
      );
    }

    // Wipe a stale PIN left over from a previous install before anything can
    // read it — iOS Keychain survives app deletion, so without this a
    // reinstalled app would still be locked by a PIN the user can't recall.
    await clearPinOnFreshInstall();

    // Drift opens lazily via `appDatabaseProvider`, so there's nothing to
    // initialize here; the trips feature bootstraps (sync + demo seed) on first
    // read of `tripsBootstrapProvider`.
    runApp(const ProviderScope(child: VentusApp()));
  } catch (e, stack) {
    CrashReporting.recordError(e, stack, reason: 'Launch failure', fatal: true);
    runApp(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Text(
                'Launch Error:\\n$e\\n$stack',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: AppFontSize.sm,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
