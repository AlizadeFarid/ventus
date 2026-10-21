// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedPlace _$SavedPlaceFromJson(Map<String, dynamic> json) => _SavedPlace(
  destinationId: json['destination_id'] as String,
  userId: json['user_id'] as String?,
  name: json['name'] as String,
  country: json['country'] as String,
  imageUrl: json['image_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SavedPlaceToJson(_SavedPlace instance) =>
    <String, dynamic>{
      'destination_id': instance.destinationId,
      'user_id': instance.userId,
      'name': instance.name,
      'country': instance.country,
      'image_url': instance.imageUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
