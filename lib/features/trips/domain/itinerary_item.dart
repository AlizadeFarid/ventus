import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_kind.dart';

part 'itinerary_item.freezed.dart';
part 'itinerary_item.g.dart';

/// A single activity on a trip's day-by-day plan (prototype `TripHub.jsx` →
/// TimelineItem).
///
/// Belongs to a trip via [tripId] and to a specific [day] (1-based index into
/// the trip's date range). [startMinutes] is the optional start time as minutes
/// from midnight (null = no fixed time). Stored local-first in Drift and
/// mirrored to the Supabase `itinerary_items` table; JSON keys are snake_case to
/// match the Postgres columns.
@freezed
abstract class ItineraryItem with _$ItineraryItem {
  const factory ItineraryItem({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'user_id') String? userId,
    required int day,
    @JsonKey(name: 'start_minutes') int? startMinutes,
    required String title,
    String? place,
    @Default(ActivityKind.activity) ActivityKind kind,
    @Default(0) int position,
    // Coordinates of [place] once the geocoder has resolved it; null means the
    // activity has no pin on the map yet.
    double? lat,
    double? lon,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ItineraryItem;

  const ItineraryItem._();

  /// Whether this activity has a point that can be plotted on the map.
  bool get hasCoords => lat != null && lon != null;

  /// The text the geocoder should look up: the explicit place when set, the
  /// title otherwise (AI plans often put the venue straight in the title).
  String get geocodeQuery => (place != null && place!.trim().isNotEmpty)
      ? place!.trim()
      : title.trim();

  factory ItineraryItem.fromJson(Map<String, dynamic> json) =>
      _$ItineraryItemFromJson(json);
}
