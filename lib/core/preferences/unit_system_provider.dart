import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Measurement system for distances and temperature.
/// - [metric]: kilometres + °C.
/// - [imperial]: miles + °F.
enum UnitSystem { metric, imperial }

/// The user's measurement system. Currently drives the Weather tool's
/// temperature unit; persisted on-device and hydrated asynchronously.
class UnitSystemController extends Notifier<UnitSystem> {
  static const _key = 'pref_units';
  final _storage = const FlutterSecureStorage();

  @override
  UnitSystem build() {
    _hydrate();
    return UnitSystem.metric;
  }

  Future<void> _hydrate() async {
    final value = await _storage.read(key: _key);
    if (value == UnitSystem.imperial.name) {
      state = UnitSystem.imperial;
    } else if (value == UnitSystem.metric.name) {
      state = UnitSystem.metric;
    }
  }

  Future<void> set(UnitSystem system) async {
    state = system;
    await _storage.write(key: _key, value: system.name);
  }
}

final unitSystemProvider = NotifierProvider<UnitSystemController, UnitSystem>(
  UnitSystemController.new,
);
