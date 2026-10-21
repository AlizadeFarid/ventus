import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/geo_city.dart';
import 'open_meteo_repository.dart' show ToolsException;

/// Resolves the user's approximate location (city-level) from their IP address
/// via the free, key-less `ipwho.is` service. Used to seed the Weather tool with
/// the zone the user is actually in, without GPS permissions. Accuracy is
/// region/city level — good enough for weather; users can still search to change
/// the city.
class IpLocationRepository {
  IpLocationRepository({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static const _host = 'https://ipwho.is/';

  /// Looks up the current location and maps it to a [GeoCity]. Throws a
  /// [ToolsException] when the lookup fails or the response is unusable.
  Future<GeoCity> fetchCurrentLocation() async {
    final res = await _client
        .get(Uri.parse(_host))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () =>
              throw ToolsException('IP location request timed out'),
        );
    if (res.statusCode != 200) {
      throw ToolsException('IP location failed (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['success'] != true) {
      throw ToolsException('IP location lookup unsuccessful');
    }

    final tz = body['timezone'] as Map<String, dynamic>? ?? const {};
    final name = (body['city'] as String?)?.trim();
    final lat = (body['latitude'] as num?)?.toDouble();
    final lon = (body['longitude'] as num?)?.toDouble();
    if (name == null || name.isEmpty || lat == null || lon == null) {
      throw ToolsException('IP location missing fields');
    }

    return GeoCity(
      name: name,
      country: (body['country'] as String?)?.trim() ?? '',
      lat: lat,
      lon: lon,
      timezone: (tz['id'] as String?) ?? 'UTC',
      utcOffsetSeconds: (tz['offset'] as num?)?.toInt() ?? 0,
    );
  }

  void dispose() => _client.close();
}
