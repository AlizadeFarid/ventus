// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItineraryItem _$ItineraryItemFromJson(Map<String, dynamic> json) =>
    _ItineraryItem(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      userId: json['user_id'] as String?,
      day: (json['day'] as num).toInt(),
      startMinutes: (json['start_minutes'] as num?)?.toInt(),
      title: json['title'] as String,
      place: json['place'] as String?,
      kind:
          $enumDecodeNullable(_$ActivityKindEnumMap, json['kind']) ??
          ActivityKind.activity,
      position: (json['position'] as num?)?.toInt() ?? 0,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ItineraryItemToJson(_ItineraryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'user_id': instance.userId,
      'day': instance.day,
      'start_minutes': instance.startMinutes,
      'title': instance.title,
      'place': instance.place,
      'kind': _$ActivityKindEnumMap[instance.kind]!,
      'position': instance.position,
      'lat': instance.lat,
      'lon': instance.lon,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ActivityKindEnumMap = {
  ActivityKind.flight: 'flight',
  ActivityKind.stay: 'stay',
  ActivityKind.food: 'food',
  ActivityKind.sight: 'sight',
  ActivityKind.transport: 'transport',
  ActivityKind.activity: 'activity',
};
