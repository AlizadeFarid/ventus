import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_locales.dart';

/// Holds the user's chosen [Locale]; `null` means "follow the device".
///
/// The choice is persisted on-device so it survives restarts. Before a first
/// choice is ever made, the app defaults to Azerbaijani rather than the
/// device locale (product decision — most users are Azerbaijani-speaking and
/// shouldn't land on English just because their phone's system language is).
/// State starts as [AppLocales.az] and is hydrated asynchronously from
/// storage, so the UI never blocks on disk at startup.
class LocaleController extends Notifier<Locale?> {
  static const _key = 'app_locale';

  /// Sentinel stored when the user explicitly picks "System default", so it
  /// can be told apart from "no choice made yet" (an absent key) — the latter
  /// resolves to the [AppLocales.az] default instead of the device locale.
  static const _systemSentinel = 'system';
  final _storage = const FlutterSecureStorage();

  @override
  Locale? build() {
    _hydrate();
    return AppLocales.az;
  }

  Future<void> _hydrate() async {
    final code = await _storage.read(key: _key);
    if (code == null) return; // no choice saved yet — keep the az default
    if (code == _systemSentinel) {
      state = null;
      return;
    }
    if (AppLocales.isSupported(code)) {
      state = Locale(code);
    }
  }

  /// Sets the app language. Pass `null` to explicitly follow the device
  /// locale (recorded as such, so it isn't confused with "no choice yet" on
  /// the next cold start).
  Future<void> set(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _storage.write(key: _key, value: _systemSentinel);
    } else {
      await _storage.write(key: _key, value: locale.languageCode);
    }
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);
