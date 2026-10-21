import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/l10n/locale_provider.dart';
import '../../../core/preferences/unit_system_provider.dart';
import '../data/currency_repository.dart';
import '../data/ip_location_repository.dart';
import '../data/open_meteo_repository.dart';
import '../domain/currency_rates.dart';
import '../domain/geo_city.dart';
import '../domain/weather.dart';

/// A sensible default city so Weather + Clock show something on first open
/// (Istanbul — a common Ventus destination). Users can search to change it.
const kDefaultCity = GeoCity(
  name: 'Istanbul',
  country: 'Türkiye',
  lat: 41.0082,
  lon: 28.9784,
  timezone: 'Europe/Istanbul',
  utcOffsetSeconds: 10800,
);

final openMeteoRepositoryProvider = Provider<OpenMeteoRepository>((ref) {
  final repo = OpenMeteoRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final repo = CurrencyRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

final ipLocationRepositoryProvider = Provider<IpLocationRepository>((ref) {
  final repo = IpLocationRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

/// Live exchange rates (against USD), fetched once and kept for the session.
final currencyRatesProvider = FutureProvider<CurrencyRates>((ref) {
  return ref.watch(currencyRepositoryProvider).fetchRates();
});

/// City search for the Weather + Clock pickers (Open-Meteo geocoding).
final citySearchProvider = FutureProvider.autoDispose
    .family<List<GeoCity>, String>((ref, query) {
      if (query.trim().length < 2) return Future.value(const []);
      final lang = ref.watch(localeProvider)?.languageCode ?? 'en';
      return ref
          .watch(openMeteoRepositoryProvider)
          .searchCities(query.trim(), language: lang);
    });

/// The city's name in the app language. A detected city (IP lookup) or the
/// built-in default only carries an English name ("Baku"), so this re-resolves
/// it through the geocoder in the user's language ("Bakı") and falls back to
/// the original name whenever that fails or finds nothing nearby.
final cityDisplayNameProvider = FutureProvider.autoDispose
    .family<String, ({String name, double lat, double lon})>((ref, city) async {
      final lang = ref.watch(localeProvider)?.languageCode ?? 'en';
      try {
        final matches = await ref
            .watch(openMeteoRepositoryProvider)
            .searchCities(city.name, language: lang);
        for (final m in matches) {
          if ((m.lat - city.lat).abs() < 0.5 &&
              (m.lon - city.lon).abs() < 0.5 &&
              m.name.isNotEmpty) {
            return m.name;
          }
        }
      } catch (_) {}
      return city.name;
    });

/// 5-day weather for a location, keyed by coordinates (records give the family
/// a stable, value-equal key).
final weatherProvider = FutureProvider.autoDispose
    .family<Weather, ({double lat, double lon})>((ref, coords) {
      final imperial = ref.watch(unitSystemProvider) == UnitSystem.imperial;
      return ref
          .watch(openMeteoRepositoryProvider)
          .fetchWeather(coords.lat, coords.lon, imperial: imperial);
    });

/// The city the Weather tool is showing. Defaults to the user's detected
/// location (IP-based, no GPS permission); falls back to [kDefaultCity] when the
/// lookup fails. Changeable via search — a manual pick is never overwritten by a
/// late-arriving location.
final weatherCityProvider =
    AsyncNotifierProvider<WeatherCityController, GeoCity>(
      WeatherCityController.new,
    );

class WeatherCityController extends AsyncNotifier<GeoCity> {
  bool _userPicked = false;

  @override
  Future<GeoCity> build() async {
    try {
      final detected = await ref
          .watch(ipLocationRepositoryProvider)
          .fetchCurrentLocation();
      // If the user picked a city while the lookup was in flight, keep it.
      if (_userPicked) return state.asData?.value ?? detected;
      return detected;
    } catch (_) {
      return _userPicked ? (state.asData?.value ?? kDefaultCity) : kDefaultCity;
    }
  }

  void set(GeoCity city) {
    _userPicked = true;
    state = AsyncData(city);
  }
}

/// Cities pinned in the World-clock tool (alongside the device's home time).
final clockCitiesProvider =
    NotifierProvider<ClockCitiesController, List<GeoCity>>(
      ClockCitiesController.new,
    );

class ClockCitiesController extends Notifier<List<GeoCity>> {
  static const _key = 'clock_cities';
  final _storage = const FlutterSecureStorage();

  @override
  List<GeoCity> build() {
    // Start with no pinned cities (the device's home time is always shown
    // separately), then replace from disk once it loads so the user's pinned
    // cities survive restarts.
    _hydrate();
    return const [];
  }

  Future<void> _hydrate() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return;
    try {
      state = [
        for (final c in jsonDecode(raw) as List)
          if (c is Map<String, dynamic>) GeoCity.fromJson(c),
      ];
    } catch (_) {
      // Ignore a corrupt cache and keep the default.
    }
    _refreshOffsets();
  }

  /// Re-resolves every pinned city's UTC offset in the background. Repairs
  /// any city saved before offsets were looked up correctly (they'd be stuck
  /// at 0 / UTC), and keeps offsets correct across future DST transitions
  /// without the user having to remove and re-add a city.
  Future<void> _refreshOffsets() async {
    if (state.isEmpty) return;
    final repo = ref.read(openMeteoRepositoryProvider);
    final updated = <GeoCity>[];
    var changed = false;
    for (final city in state) {
      try {
        final offset = await repo.fetchUtcOffsetSeconds(city.lat, city.lon);
        if (offset != city.utcOffsetSeconds) {
          changed = true;
          updated.add(
            GeoCity(
              name: city.name,
              country: city.country,
              lat: city.lat,
              lon: city.lon,
              timezone: city.timezone,
              utcOffsetSeconds: offset,
            ),
          );
        } else {
          updated.add(city);
        }
      } catch (_) {
        updated.add(city); // Keep the cached value if the lookup fails.
      }
    }
    if (changed) {
      state = updated;
      _persist();
    }
  }

  Future<void> _persist() async {
    await _storage.write(
      key: _key,
      value: jsonEncode([for (final c in state) c.toJson()]),
    );
  }

  /// Drops every pinned city, on disk and in memory. Called on sign-in so a
  /// previous account's cities never leak into the next session — this list
  /// lives in secure storage, outside the Drift store the auth flow wipes.
  Future<void> clear() async {
    state = const [];
    await _storage.delete(key: _key);
  }

  void add(GeoCity city) {
    final exists = state.any(
      (c) =>
          c.name.toLowerCase() == city.name.toLowerCase() &&
          c.timezone == city.timezone,
    );
    if (exists) return;
    state = [...state, city];
    _persist();
  }

  /// Puts [city] back at [index] (used to undo a removal in place).
  void insertAt(int index, GeoCity city) {
    final next = [...state];
    next.insert(index.clamp(0, next.length), city);
    state = next;
    _persist();
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;
    state = [...state]..removeAt(index);
    _persist();
  }

  /// Moves the city at [index] to the front, so it becomes the featured card
  /// (index 0 is always what the World-clock screen shows large, next to
  /// Home). No-op if it's already featured.
  void featureAt(int index) {
    if (index <= 0 || index >= state.length) return;
    final next = [...state];
    final city = next.removeAt(index);
    next.insert(0, city);
    state = next;
    _persist();
  }
}
