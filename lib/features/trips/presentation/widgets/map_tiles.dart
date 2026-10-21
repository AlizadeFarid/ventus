import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// The raster fallback sheet, used while the vector style in [map_style.dart]
/// is still loading and whenever it can't be fetched at all (offline).
///
/// CARTO's styles over OpenStreetMap data: pale roads and soft landcover, so a
/// teal route line and numbered pins stay readable on top. Keyless and free,
/// like the vector sheet — nothing in the map stack needs an account or a
/// billing profile. Its one shortcoming is what pushed the map to vector
/// tiles: the labels are painted into the images in the local language.
enum MapRasterSheet {
  /// Warm, low-contrast street map for the app's light theme.
  voyager(
    'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
  ),

  /// Near-monochrome dark sheet, so the map doesn't glare in dark mode.
  darkMatter(
    'https://basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}{r}.png',
  );

  const MapRasterSheet(this.urlTemplate);

  final String urlTemplate;

  /// The sheet matching the app's current theme.
  static MapRasterSheet of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkMatter : voyager;
}

/// The fallback tile layer at the screen's pixel density — CARTO serves `@2x`
/// sheets, which is what keeps labels crisp on a phone.
TileLayer mapTileLayer(BuildContext context) => TileLayer(
  urlTemplate: MapRasterSheet.of(context).urlTemplate,
  retinaMode: RetinaMode.isHighDensity(context),
  userAgentPackageName: 'com.ventus.app',
  tileProvider: NetworkTileProvider(),
);
