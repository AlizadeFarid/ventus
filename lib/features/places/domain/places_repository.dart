import 'place_suggestion.dart';

/// Contract for place autocomplete, independent of any geocoding provider.
///
/// The presentation layer depends only on this interface, so swapping the
/// free OSM provider for another (or a paid one) touches a single binding.
abstract interface class PlacesRepository {
  /// Returns city/region/country suggestions matching [query]. Throws on a
  /// transport/parse failure so the UI can offer a manual fallback.
  Future<List<PlaceSuggestion>> search(String query, {String? languageCode});

  /// Resolves a single free-text place (a venue, museum, district — not just a
  /// city) to one point, or null when nothing plausible matches.
  ///
  /// [nearLat]/[nearLon] bias the search towards the trip's area so "Wat Pho"
  /// lands in Bangkok rather than in an unrelated country; [context] is an
  /// extra hint (usually the city name) appended on a retry when the biased
  /// lookup finds nothing. Used to plot a trip's day-by-day plan on the map.
  Future<PlaceSuggestion?> resolve(
    String query, {
    String? languageCode,
    double? nearLat,
    double? nearLon,
    String? context,
  });
}
