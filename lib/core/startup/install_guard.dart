import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../features/auth/application/pin_service.dart';

/// Clears the quick-unlock PIN on the first launch after a fresh install.
///
/// The PIN lives in [PinService] (the platform keychain/keystore), which on iOS
/// **survives app deletion** — so a reinstalled app would otherwise still be
/// locked by an old PIN the user can't recall. A marker file in the app-support
/// directory does *not* survive deletion, so its absence reliably signals a
/// reinstall: when it's missing we wipe the stale PIN and (re)create the marker.
///
/// Best-effort and silent — a convenience lock must never block startup.
Future<void> clearPinOnFreshInstall() async {
  try {
    final dir = await getApplicationSupportDirectory();
    final marker = File('${dir.path}/.ventus_installed');
    if (await marker.exists()) return;
    await PinService().clear();
    await marker.create(recursive: true);
  } catch (_) {
    // Ignore — never let install bookkeeping stop the app from launching.
  }
}
