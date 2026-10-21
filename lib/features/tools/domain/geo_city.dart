/// A city resolved from the Open-Meteo geocoding API, used by both the Weather
/// and World-clock tools. Carries coordinates (for weather) and the IANA
/// timezone + UTC offset (for the clock).
class GeoCity {
  const GeoCity({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.utcOffsetSeconds,
  });

  final String name;
  final String country;
  final double lat;
  final double lon;

  /// IANA timezone id (e.g. `Europe/Istanbul`).
  final String timezone;

  /// Offset from UTC in seconds at the resolved time (handles DST).
  final int utcOffsetSeconds;

  /// Current wall-clock time in this city, derived from its UTC offset.
  DateTime get localTime =>
      DateTime.now().toUtc().add(Duration(seconds: utcOffsetSeconds));

  factory GeoCity.fromJson(Map<String, dynamic> json) => GeoCity(
    name: (json['name'] as String?)?.trim() ?? '',
    country: (json['country'] as String?)?.trim() ?? '',
    lat: (json['latitude'] as num?)?.toDouble() ?? 0,
    lon: (json['longitude'] as num?)?.toDouble() ?? 0,
    timezone: (json['timezone'] as String?) ?? 'UTC',
    utcOffsetSeconds: (json['utc_offset_seconds'] as num?)?.toInt() ?? 0,
  );

  /// Mirrors [GeoCity.fromJson]'s keys so a pinned city round-trips through
  /// on-device storage (used to persist the World-clock list).
  Map<String, dynamic> toJson() => {
    'name': name,
    'country': country,
    'latitude': lat,
    'longitude': lon,
    'timezone': timezone,
    'utc_offset_seconds': utcOffsetSeconds,
  };
}
