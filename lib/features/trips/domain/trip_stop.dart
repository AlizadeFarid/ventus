import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_stop.freezed.dart';
part 'trip_stop.g.dart';

/// A single place on a trip's route (e.g. Istanbul, then Cappadocia).
///
/// Stops are stored in their own `trip_stops` table — local-first in Drift and
/// mirrored to Supabase — and ordered by [position]. JSON keys are snake_case to
/// match the Postgres columns.
@freezed
abstract class TripStop with _$TripStop {
  const factory TripStop({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    required String name,
    required String country,
    @Default(0) int position,
    // Geographic coordinates from the Photon/OSM autocomplete. Null when the
    // stop predates the Map feature or was a custom place Photon couldn't
    // resolve — such stops just don't appear on the map.
    double? lat,
    double? lon,
  }) = _TripStop;

  const TripStop._();

  /// Whether this stop has a point that can be plotted on the map.
  bool get hasCoords => lat != null && lon != null;

  factory TripStop.fromJson(Map<String, dynamic> json) =>
      _$TripStopFromJson(json);
}
