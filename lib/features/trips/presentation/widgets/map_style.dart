import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr;

/// The vector basemap under Ventus's pins.
///
/// Vector, not raster, for one concrete reason: labels. Ready-made tile
/// *images* bake OpenStreetMap's local-language `name` into the picture, so a
/// Bangkok trip came back written in Thai and a Tokyo one would come back in
/// Japanese. With vector tiles the text is drawn on the device from the raw
/// data, which lets [withLatinLabels] pick the field — we render `name:latin`,
/// readable everywhere the app is used.
///
/// Tiles and styles come from OpenFreeMap: OpenStreetMap data, no API key, no
/// billing, no account. Attribution is required and shown on the map.
enum MapBasemap {
  /// Light sheet (OpenFreeMap "Liberty") for the app's light theme.
  liberty('https://tiles.openfreemap.org/styles/liberty'),

  /// Muted blue-grey sheet for dark mode, so the map doesn't glare.
  fiord('https://tiles.openfreemap.org/styles/fiord');

  const MapBasemap(this.styleUrl);

  /// URL of the MapLibre style document describing how to draw the tiles.
  final String styleUrl;

  /// The sheet matching the app's current theme.
  static MapBasemap of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? fiord : liberty;
}

/// A loaded basemap: what to draw ([theme]), where the tiles come from
/// ([providers]) and the icon atlas the style refers to ([sprites]).
class VentusMapStyle {
  const VentusMapStyle({
    required this.theme,
    required this.providers,
    this.sprites,
  });

  final vtr.Theme theme;
  final TileProviders providers;
  final SpriteStyle? sprites;
}

/// Loads (and then keeps) a basemap style. Not `autoDispose`: the style
/// document is the same for every trip, so it's fetched once per app run and
/// shared by every map the user opens.
final mapStyleProvider = FutureProvider.family<VentusMapStyle, MapBasemap>((
  ref,
  basemap,
) async {
  // Two reads of the same (cached, ~40 KB) document on purpose: the package's
  // StyleReader resolves the tile sources and sprite atlas for us, while the
  // theme is rebuilt here from a copy with the label fields rewritten.
  final style = await StyleReader(uri: basemap.styleUrl).read();
  final theme = await _latinTheme(basemap.styleUrl);

  return VentusMapStyle(
    theme: theme ?? style.theme,
    providers: style.providers,
    sprites: style.sprites,
  );
});

/// Re-reads the style document and builds a theme that labels everything in
/// Latin script. Returns null if that fails, so the caller falls back to the
/// style's own labels rather than losing the map.
Future<vtr.Theme?> _latinTheme(String styleUrl) async {
  try {
    final res = await http
        .get(Uri.parse(styleUrl))
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) return null;
    final json = jsonDecode(res.body);
    if (json is! Map<String, dynamic>) return null;
    return vtr.ThemeReader().read(withLatinLabels(json));
  } catch (_) {
    return null;
  }
}

@visibleForTesting
/// Rewrites every place-name label in [style] to prefer the Latin spelling.
///
/// OpenMapTiles ships each feature's name several times — `name` (local
/// script), `name:latin`, `name_en` — and the stock styles print the local one,
/// often concatenated with the Latin one. Labels that carry no name (road
/// shields, which use `ref`) are left alone.
Map<String, dynamic> withLatinLabels(Map<String, dynamic> style) {
  const latinField = [
    'coalesce',
    ['get', 'name:latin'],
    ['get', 'name_en'],
    ['get', 'name'],
  ];

  final layers = style['layers'];
  if (layers is! List) return style;
  for (final layer in layers) {
    if (layer is! Map) continue;
    final layout = layer['layout'];
    if (layout is! Map) continue;
    final field = layout['text-field'];
    if (field == null) continue;
    // Only name-bearing labels; `{ref}` shields stay as they are.
    if (!jsonEncode(field).contains('name')) continue;
    layout['text-field'] = latinField;
  }
  return style;
}
