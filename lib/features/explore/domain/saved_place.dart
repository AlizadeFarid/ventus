import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_place.freezed.dart';
part 'saved_place.g.dart';

/// A destination the user hearted in Explore. Display fields are denormalised
/// (snapshotted at save time, in the active language) so the Saved tab works
/// offline and even if the destination later disappears. Keyed by
/// [destinationId] per user. JSON keys are snake_case for Supabase.
@freezed
abstract class SavedPlace with _$SavedPlace {
  const factory SavedPlace({
    @JsonKey(name: 'destination_id') required String destinationId,
    @JsonKey(name: 'user_id') String? userId,
    required String name,
    required String country,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _SavedPlace;

  factory SavedPlace.fromJson(Map<String, dynamic> json) =>
      _$SavedPlaceFromJson(json);
}
