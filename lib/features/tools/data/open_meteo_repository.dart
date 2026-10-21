import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/geo_city.dart';
import '../domain/weather.dart';

/// Raised when a Tools network call can't complete (network / bad response).
class ToolsException implements Exception {
  ToolsException(this.message);
  final String message;
  @override
  String toString() => 'ToolsException: $message';
}

/// Open-Meteo backs both the Weather and World-clock tools — it's free and
/// key-less. Geocoding resolves a city (coords + timezone name, but no UTC
/// offset); the forecast endpoint returns current + hourly + daily weather,
/// and also carries the location's current UTC offset ([fetchUtcOffsetSeconds]).
class OpenMeteoRepository {
  OpenMeteoRepository({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static const _geoHost = 'https://geocoding-api.open-meteo.com/v1/search';
  static const _forecastHost = 'https://api.open-meteo.com/v1/forecast';

  /// Searches cities by [query] (used by both tools' city pickers).
  Future<List<GeoCity>> searchCities(
    String query, {
    String language = 'en',
  }) async {
    final uri = Uri.parse(_geoHost).replace(
      queryParameters: {
        'name': query,
        'count': '8',
        'language': language,
        'format': 'json',
      },
    );
    final res = await _client
        .get(uri)
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw ToolsException('Geocoding request timed out'),
        );
    if (res.statusCode != 200) {
      throw ToolsException('Geocoding failed (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (body['results'] as List?) ?? const [];
    return [
      for (final r in results)
        // Only populated places (PPL*): the geocoder also returns countries
        // (PCLI) and regions (ADM*), which aren't a place you can have a
        // local time or weather for.
        if (r is Map<String, dynamic> &&
            ((r['feature_code'] as String?)?.startsWith('PPL') ?? true))
          GeoCity.fromJson(r),
    ];
  }

  /// Fetches current + hourly + today and the following 5 days for a location.
  Future<Weather> fetchWeather(
    double lat,
    double lon, {
    bool imperial = false,
  }) async {
    final uri = Uri.parse(_forecastHost).replace(
      queryParameters: {
        'latitude': '$lat',
        'longitude': '$lon',
        'current':
            'temperature_2m,weather_code,apparent_temperature,relative_humidity_2m,wind_speed_10m',
        'hourly': 'temperature_2m,weather_code',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max',
        'timezone': 'auto',
        'forecast_days': '6',
        if (imperial) ...{
          'temperature_unit': 'fahrenheit',
          'wind_speed_unit': 'mph',
        },
      },
    );
    final res = await _client
        .get(uri)
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw ToolsException('Weather request timed out'),
        );
    if (res.statusCode != 200) {
      throw ToolsException('Weather failed (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;

    final current = body['current'] as Map<String, dynamic>? ?? const {};
    final hourly = body['hourly'] as Map<String, dynamic>? ?? const {};
    final daily = body['daily'] as Map<String, dynamic>? ?? const {};

    // The API's times are wall-clock at the *forecast location*, so "now"
    // must come from the response, not the device (they differ for any city
    // outside the user's own time zone).
    final localNow = DateTime.tryParse('${current['time']}') ?? DateTime.now();
    final thisHour = DateTime(
      localNow.year,
      localNow.month,
      localNow.day,
      localNow.hour,
    );

    final hTimes = (hourly['time'] as List?) ?? const [];
    final hTemps = (hourly['temperature_2m'] as List?) ?? const [];
    final hCodes = (hourly['weather_code'] as List?) ?? const [];
    final hourForecasts = <HourForecast>[];
    for (var i = 0; i < hTimes.length; i++) {
      final t = DateTime.tryParse('${hTimes[i]}');
      if (t == null || t.isBefore(thisHour)) continue;
      hourForecasts.add(
        HourForecast(
          time: t,
          temp: (hTemps[i] as num?)?.toDouble() ?? 0,
          code: (hCodes[i] as num?)?.toInt() ?? 0,
        ),
      );
      if (hourForecasts.length >= 5) break;
    }

    final dTimes = (daily['time'] as List?) ?? const [];
    final dCodes = (daily['weather_code'] as List?) ?? const [];
    final dHigh = (daily['temperature_2m_max'] as List?) ?? const [];
    final dLow = (daily['temperature_2m_min'] as List?) ?? const [];
    final dRise = (daily['sunrise'] as List?) ?? const [];
    final dSet = (daily['sunset'] as List?) ?? const [];
    final dRain = (daily['precipitation_probability_max'] as List?) ?? const [];
    final dayForecasts = <DayForecast>[];
    for (var i = 0; i < dTimes.length; i++) {
      final d = DateTime.tryParse('${dTimes[i]}');
      if (d == null) continue;
      dayForecasts.add(
        DayForecast(
          date: d,
          code: (dCodes[i] as num?)?.toInt() ?? 0,
          high: (dHigh[i] as num?)?.toDouble() ?? 0,
          low: (dLow[i] as num?)?.toDouble() ?? 0,
          sunrise: i < dRise.length ? DateTime.tryParse('${dRise[i]}') : null,
          sunset: i < dSet.length ? DateTime.tryParse('${dSet[i]}') : null,
          rainChance: i < dRain.length ? (dRain[i] as num?)?.toInt() : null,
        ),
      );
    }
    if (dayForecasts.isEmpty) {
      throw ToolsException('Weather response had no daily data');
    }

    final currentTemp = (current['temperature_2m'] as num?)?.toDouble() ?? 0;
    return Weather(
      localNow: localNow,
      currentTemp: currentTemp,
      currentCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      feelsLike:
          (current['apparent_temperature'] as num?)?.toDouble() ?? currentTemp,
      humidity: (current['relative_humidity_2m'] as num?)?.round() ?? 0,
      windSpeed: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0,
      today: dayForecasts.first,
      hourly: hourForecasts,
      daily: dayForecasts.skip(1).toList(),
    );
  }

  /// Fetches the current UTC offset (seconds, DST-aware) for a location. The
  /// geocoding endpoint used by [searchCities] only returns a timezone name,
  /// not an offset, so the World-clock tool calls this right after a city is
  /// picked to fill in the real value.
  Future<int> fetchUtcOffsetSeconds(double lat, double lon) async {
    final uri = Uri.parse(_forecastHost).replace(
      queryParameters: {
        'latitude': '$lat',
        'longitude': '$lon',
        'timezone': 'auto',
        'forecast_days': '1',
        'hourly': 'temperature_2m',
      },
    );
    final res = await _client
        .get(uri)
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw ToolsException('Timezone lookup timed out'),
        );
    if (res.statusCode != 200) {
      throw ToolsException('Timezone lookup failed (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['utc_offset_seconds'] as num?)?.toInt() ?? 0;
  }

  void dispose() => _client.close();
}
