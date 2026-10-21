/// A place returned by autocomplete search — a city, region, or country the
/// user can add as a trip stop. Backend-agnostic (mapped from the geocoder).
class PlaceSuggestion {
  const PlaceSuggestion({
    required this.name,
    required this.country,
    this.lat,
    this.lon,
  });

  final String name;
  final String country;

  /// Coordinates, when the provider returns them (kept for future map use).
  final double? lat;
  final double? lon;
}
