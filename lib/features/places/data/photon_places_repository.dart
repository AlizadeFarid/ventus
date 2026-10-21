import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/utils/geo.dart';
import '../domain/place_aliases.dart';
import '../domain/place_suggestion.dart';
import '../domain/places_repository.dart';

/// [PlacesRepository] backed by Photon (https://photon.komoot.io) — a free,
/// key-less, OpenStreetMap-based geocoder built for as-you-type autocomplete.
///
/// We keep only place-like results (cities, regions, countries) and drop
/// streets/buildings/POIs, then de-duplicate by name+country.
class PhotonPlacesRepository implements PlacesRepository {
  PhotonPlacesRepository({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static const _endpoint = 'https://photon.komoot.io/api/';

  /// OSM top-level keys that represent destinations worth suggesting.
  static const _placeKeys = {'place', 'boundary'};

  /// The languages Photon can label results in. Anything else (Azerbaijani,
  /// Turkish) falls back to English rather than to no `lang` at all — without
  /// the parameter Photon answers in each place's own script, which is how a
  /// search for Bangkok came back as "กรุงเทพมหานคร" and Chinese cities in Han
  /// characters.
  static const _supportedLangs = {'en', 'de', 'fr', 'it'};

  static String _lang(String? languageCode) =>
      _supportedLangs.contains(languageCode) ? languageCode! : 'en';

  /// How far a biased [resolve] hit may sit from the trip's area before we
  /// treat it as the wrong place. Generous enough for a day trip out of the
  /// city, tight enough to reject a same-named venue on another continent.
  static const _maxBiasDistanceKm = 150.0;

  @override
  Future<List<PlaceSuggestion>> search(
    String query, {
    String? languageCode,
  }) async {
    // "Fransa", "Vyetnam", "Vyana" aren't in Photon's index — send the
    // international spelling instead. See [resolvePlaceAlias].
    final params = <String, String>{
      'q': resolvePlaceAlias(query) ?? query,
      'limit': '10',
      'lang': _lang(languageCode),
    };

    final uri = Uri.parse(_endpoint).replace(queryParameters: params);

    final res = await _client
        .get(
          uri,
          headers: {
            // Photon's usage policy asks for an identifying User-Agent.
            'User-Agent': 'Ventus/1.0 (travel planner app)',
          },
        )
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw PlacesException('Photon request timed out'),
        );
    if (res.statusCode != 200) {
      throw PlacesException('Photon returned ${res.statusCode}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final features = (body['features'] as List?) ?? const [];

    final seen = <String>{};
    final out = <PlaceSuggestion>[];
    for (final raw in features) {
      final feature = raw as Map<String, dynamic>;
      final props = feature['properties'] as Map<String, dynamic>?;
      if (props == null) continue;

      final osmKey = props['osm_key'] as String?;
      if (osmKey != null && !_placeKeys.contains(osmKey)) continue;

      final name = (props['name'] as String?)?.trim();
      if (name == null || name.isEmpty) continue;
      final country = (props['country'] as String?)?.trim() ?? '';

      final key = '${name.toLowerCase()}|${country.toLowerCase()}';
      if (!seen.add(key)) continue;

      final coords =
          (feature['geometry'] as Map<String, dynamic>?)?['coordinates']
              as List?;
      final hasCoords = coords != null && coords.length == 2;

      out.add(
        PlaceSuggestion(
          name: name,
          country: country,
          lon: hasCoords ? (coords[0] as num).toDouble() : null,
          lat: hasCoords ? (coords[1] as num).toDouble() : null,
        ),
      );
    }
    return out;
  }

  @override
  Future<PlaceSuggestion?> resolve(
    String query, {
    String? languageCode,
    double? nearLat,
    double? nearLon,
    String? context,
  }) async {
    final q = resolvePlaceAlias(query) ?? query.trim();
    if (q.isEmpty) return null;

    final hit = await _resolveOnce(
      q,
      languageCode: languageCode,
      nearLat: nearLat,
      nearLon: nearLon,
    );
    if (hit != null) return hit;

    // Nothing plausible nearby: retry with the city spelled out, which rescues
    // short venue names Photon can't place from the bias alone ("Wat Pho" →
    // "Wat Pho Bangkok").
    final hint = context?.trim();
    if (hint == null ||
        hint.isEmpty ||
        q.toLowerCase().contains(hint.toLowerCase())) {
      return null;
    }
    return _resolveOnce(
      '$q $hint',
      languageCode: languageCode,
      nearLat: nearLat,
      nearLon: nearLon,
    );
  }

  /// One Photon lookup for [query], returning the best acceptable feature.
  ///
  /// Unlike [search] this keeps every OSM kind (a museum and a temple are
  /// exactly what a day plan points at). With a bias point it sends a [bbox]
  /// around it — Photon's `lat`/`lon` bias alone only nudges the ranking and
  /// still happily returns a same-named place on another continent, whereas
  /// the box actually restricts the search to the trip's area. Photon's own
  /// relevance order then decides, with the distance check as a last guard.
  Future<PlaceSuggestion?> _resolveOnce(
    String query, {
    String? languageCode,
    double? nearLat,
    double? nearLon,
  }) async {
    final biased = nearLat != null && nearLon != null;
    final params = <String, String>{
      'q': query,
      'limit': '5',
      if (biased) ...{
        'lat': '$nearLat',
        'lon': '$nearLon',
        ...?_bboxParam(nearLat, nearLon),
      },
    };
    params['lang'] = _lang(languageCode);

    final uri = Uri.parse(_endpoint).replace(queryParameters: params);
    final res = await _client
        .get(uri, headers: {'User-Agent': 'Ventus/1.0 (travel planner app)'})
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw PlacesException('Photon request timed out'),
        );
    if (res.statusCode != 200) {
      throw PlacesException('Photon returned ${res.statusCode}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final features = (body['features'] as List?) ?? const [];

    for (final raw in features) {
      if (raw is! Map<String, dynamic>) continue;
      final props = raw['properties'] as Map<String, dynamic>?;
      final coords =
          (raw['geometry'] as Map<String, dynamic>?)?['coordinates'] as List?;
      if (props == null || coords == null || coords.length != 2) continue;

      final lon = (coords[0] as num).toDouble();
      final lat = (coords[1] as num).toDouble();
      if (biased &&
          distanceKm(nearLat, nearLon, lat, lon) > _maxBiasDistanceKm) {
        continue;
      }

      return PlaceSuggestion(
        name: (props['name'] as String?)?.trim() ?? query,
        country: (props['country'] as String?)?.trim() ?? '',
        lat: lat,
        lon: lon,
      );
    }
    return null;
  }

  /// A `minLon,minLat,maxLon,maxLat` box roughly [_maxBiasDistanceKm] around
  /// the anchor. Skipped near the poles or the antimeridian, where the naive
  /// degree padding would wrap into an invalid box — the distance check still
  /// covers those.
  Map<String, String>? _bboxParam(double lat, double lon) {
    const pad = 1.5; // degrees ≈ 165 km of latitude
    if (lat.abs() > 80 || lon.abs() > 178) return null;
    final minLat = (lat - pad).clamp(-90.0, 90.0);
    final maxLat = (lat + pad).clamp(-90.0, 90.0);
    return {'bbox': '${lon - pad},$minLat,${lon + pad},$maxLat'};
  }

  void dispose() => _client.close();
}

/// Raised when a place search can't complete (network / bad response).
class PlacesException implements Exception {
  PlacesException(this.message);
  final String message;

  @override
  String toString() => 'PlacesException: $message';
}
