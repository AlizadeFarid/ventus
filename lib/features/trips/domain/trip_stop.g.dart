// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripStop _$TripStopFromJson(Map<String, dynamic> json) => _TripStop(
  id: json['id'] as String,
  tripId: json['trip_id'] as String,
  name: json['name'] as String,
  country: json['country'] as String,
  position: (json['position'] as num?)?.toInt() ?? 0,
  lat: (json['lat'] as num?)?.toDouble(),
  lon: (json['lon'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TripStopToJson(_TripStop instance) => <String, dynamic>{
  'id': instance.id,
  'trip_id': instance.tripId,
  'name': instance.name,
  'country': instance.country,
  'position': instance.position,
  'lat': instance.lat,
  'lon': instance.lon,
};
