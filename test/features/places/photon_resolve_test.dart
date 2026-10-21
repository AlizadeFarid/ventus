import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ventus/features/places/data/photon_places_repository.dart';

/// One Photon GeoJSON feature.
Map<String, dynamic> _feature(String name, double lat, double lon) => {
  'geometry': {
    'type': 'Point',
    'coordinates': [lon, lat],
  },
  'properties': {'name': name, 'country': 'Thailand'},
};

String _body(List<Map<String, dynamic>> features) =>
    jsonEncode({'type': 'FeatureCollection', 'features': features});

/// Bangkok, the bias point used across these tests.
const _bkkLat = 13.7563;
const _bkkLon = 100.5018;

void main() {
  group('query language', () {
    test(
      'search asks for English labels even in an unsupported locale',
      () async {
        late Uri requested;
        final repo = PhotonPlacesRepository(
          client: MockClient((req) async {
            requested = req.url;
            return http.Response(_body(const []), 200);
          }),
        );

        await repo.search('Bakı', languageCode: 'az');

        // Without a `lang` Photon answers in each place's own script.
        expect(requested.queryParameters['lang'], 'en');
      },
    );

    test('a locale Photon supports is passed through', () async {
      late Uri requested;
      final repo = PhotonPlacesRepository(
        client: MockClient((req) async {
          requested = req.url;
          return http.Response(_body(const []), 200);
        }),
      );

      await repo.search('Bakı', languageCode: 'fr');

      expect(requested.queryParameters['lang'], 'fr');
    });

    test('a local place name is sent in its international spelling', () async {
      late Uri requested;
      final repo = PhotonPlacesRepository(
        client: MockClient((req) async {
          requested = req.url;
          return http.Response(_body(const []), 200);
        }),
      );

      await repo.search('Vyetnam', languageCode: 'az');

      expect(requested.queryParameters['q'], 'Vietnam');
    });
  });

  test('resolve keeps Photon\'s ranking among in-area hits', () async {
    late Uri requested;
    final repo = PhotonPlacesRepository(
      client: MockClient((req) async {
        requested = req.url;
        return http.Response(
          _body([
            _feature('Wat Pho', 13.7465, 100.4917),
            _feature('Wat Pho school', 13.7500, 100.5000),
          ]),
          200,
        );
      }),
    );

    final hit = await repo.resolve(
      'Wat Pho',
      nearLat: _bkkLat,
      nearLon: _bkkLon,
    );

    expect(hit!.lat, closeTo(13.7465, 0.0001));
    // A bias point must restrict the search area, not merely nudge the ranking.
    expect(requested.queryParameters['bbox'], isNotNull);
  });

  test(
    'resolve rejects a same-named place on the other side of the world',
    () async {
      var calls = 0;
      final repo = PhotonPlacesRepository(
        client: MockClient((_) async {
          calls++;
          // Berlin — far outside the bias radius, so it must not be accepted
          // even though it is the only result.
          return http.Response(
            _body([_feature('Wat Pho', 52.52, 13.405)]),
            200,
          );
        }),
      );

      final hit = await repo.resolve(
        'Wat Pho',
        nearLat: _bkkLat,
        nearLon: _bkkLon,
        context: 'Bangkok',
      );

      expect(hit, isNull);
      // Rejecting the biased hit triggers the "<query> <city>" retry.
      expect(calls, 2);
    },
  );

  test('resolve without a bias point takes Photon\'s first hit', () async {
    final repo = PhotonPlacesRepository(
      client: MockClient(
        (_) async => http.Response(
          _body([
            _feature('Grand Palace', 13.7500, 100.4913),
            _feature('Grand Palace', 52.52, 13.405),
          ]),
          200,
        ),
      ),
    );

    final hit = await repo.resolve('Grand Palace');

    expect(hit!.lat, closeTo(13.75, 0.0001));
  });

  test(
    'resolve returns null for empty input without calling the network',
    () async {
      var calls = 0;
      final repo = PhotonPlacesRepository(
        client: MockClient((_) async {
          calls++;
          return http.Response(_body(const []), 200);
        }),
      );

      expect(await repo.resolve('   '), isNull);
      expect(calls, 0);
    },
  );
}
