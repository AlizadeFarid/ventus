import 'package:flutter_test/flutter_test.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr;
import 'package:ventus/features/trips/presentation/widgets/map_style.dart';

/// A cut-down MapLibre style shaped like the OpenFreeMap ones: a place label
/// that prints the local script, one that concatenates Latin + local, and a
/// road shield that carries no name at all.
Map<String, dynamic> _style() => {
  'version': 8,
  'sources': {
    'openmaptiles': {'type': 'vector', 'url': 'https://example.test/planet'},
  },
  'layers': [
    {
      'id': 'place-city',
      'type': 'symbol',
      'source': 'openmaptiles',
      'source-layer': 'place',
      'layout': {
        'text-field': ['get', 'name'],
        'text-size': 12,
      },
    },
    {
      'id': 'place-town',
      'type': 'symbol',
      'source': 'openmaptiles',
      'source-layer': 'place',
      'layout': {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin'],
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name'],
          ],
        ],
      },
    },
    {
      'id': 'road-shield',
      'type': 'symbol',
      'source': 'openmaptiles',
      'source-layer': 'transportation_name',
      'layout': {
        'text-field': [
          'to-string',
          ['get', 'ref'],
        ],
      },
    },
    {
      'id': 'water',
      'type': 'fill',
      'source': 'openmaptiles',
      'source-layer': 'water',
      'paint': {'fill-color': '#a0c8f0'},
    },
  ],
};

void main() {
  const latin = [
    'coalesce',
    ['get', 'name:latin'],
    ['get', 'name_en'],
    ['get', 'name'],
  ];

  test('name labels are rewritten to the Latin spelling', () {
    final layers = withLatinLabels(_style())['layers'] as List;

    expect(layers[0]['layout']['text-field'], latin);
    expect(layers[1]['layout']['text-field'], latin);
  });

  test('road shields and unlabelled layers are left alone', () {
    final layers = withLatinLabels(_style())['layers'] as List;

    expect(layers[2]['layout']['text-field'], [
      'to-string',
      ['get', 'ref'],
    ]);
    expect(layers[3].containsKey('layout'), isFalse);
  });

  test('other layout properties survive the rewrite', () {
    final layers = withLatinLabels(_style())['layers'] as List;

    expect(layers[0]['layout']['text-size'], 12);
  });

  test('the rewrite costs the renderer no layers', () {
    // The renderer drops layers it can't use, so the meaningful check is that
    // it accepts exactly as much of the patched style as of the original.
    final original = vtr.ThemeReader().read(_style());
    final patched = vtr.ThemeReader().read(withLatinLabels(_style()));

    expect(patched.layers, isNotEmpty);
    expect(patched.layers.length, original.layers.length);
  });
}
