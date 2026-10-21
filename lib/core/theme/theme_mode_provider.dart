import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds the app-wide [ThemeMode]. Defaults to following the system setting.
///
/// The user's choice is persisted on-device so it survives restarts. State
/// starts at [ThemeMode.system] and is hydrated asynchronously from storage, so
/// the UI never blocks on disk at startup.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'app_theme_mode';
  final _storage = const FlutterSecureStorage();

  @override
  ThemeMode build() {
    _hydrate();
    return ThemeMode.system;
  }

  Future<void> _hydrate() async {
    final raw = await _storage.read(key: _key);
    final mode = _decode(raw);
    if (mode != null) state = mode;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await _storage.write(key: _key, value: mode.name);
  }

  /// Cycles system → light → dark → system. Handy for the design gallery.
  void cycle() {
    set(switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    });
  }

  ThemeMode? _decode(String? raw) => switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    'system' => ThemeMode.system,
    _ => null,
  };
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
