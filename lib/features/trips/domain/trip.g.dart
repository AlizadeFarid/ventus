// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
  id: json['id'] as String,
  userId: json['user_id'] as String?,
  title: json['title'] as String,
  country: json['country'] as String,
  coverImagePath: json['cover_image_path'] as String?,
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
  plannedPercent: (json['planned_percent'] as num?)?.toInt() ?? 0,
  adults: (json['adults'] as num?)?.toInt() ?? 2,
  children: (json['children'] as num?)?.toInt() ?? 0,
  travelerType: $enumDecodeNullable(
    _$TravelerTypeEnumMap,
    json['traveler_type'],
  ),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'title': instance.title,
  'country': instance.country,
  'cover_image_path': instance.coverImagePath,
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
  'planned_percent': instance.plannedPercent,
  'adults': instance.adults,
  'children': instance.children,
  'traveler_type': _$TravelerTypeEnumMap[instance.travelerType],
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$TravelerTypeEnumMap = {
  TravelerType.solo: 'solo',
  TravelerType.couple: 'couple',
  TravelerType.family: 'family',
  TravelerType.friends: 'friends',
};
