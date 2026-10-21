import 'package:freezed_annotation/freezed_annotation.dart';

import 'traveler_type.dart';
import 'trip_stop.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// A planned or past journey — the core entity of the Home / My Trips feature.
///
/// This is the backend-agnostic domain model. It is mapped to/from the Drift
/// row (local-first storage) and to/from JSON for the Supabase `trips` table.
/// JSON keys are snake_case to match the Postgres columns.
@freezed
abstract class Trip with _$Trip {
  const Trip._();

  const factory Trip({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    required String title,
    required String country,

    /// Object path inside the `trip-covers` bucket (e.g. `{userId}/{id}.jpg`).
    /// The public URL is derived at read time via `AppStorage.publicUrl`.
    @JsonKey(name: 'cover_image_path') String? coverImagePath,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'planned_percent') @Default(0) int plannedPercent,
    @Default(2) int adults,
    @Default(0) int children,
    @JsonKey(name: 'traveler_type') TravelerType? travelerType,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// Route stops, ordered by position. Stored in a separate `trip_stops`
    /// table, so this is hydrated by the data layer — never serialized onto the
    /// `trips` row itself.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(<TripStop>[])
    List<TripStop> stops,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  /// Whole days from today until the trip starts. Negative once it has begun.
  int get daysToGo {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    return start.difference(today).inDays;
  }

  /// True once the trip's end date has passed (date-only comparison).
  bool get isPast {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return end.isBefore(today);
  }

  bool get isUpcoming => !isPast;

  /// Number of nights between start and end (date-only, never negative).
  int get nights {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return end.difference(start).inDays.clamp(0, 1 << 31);
  }
}
