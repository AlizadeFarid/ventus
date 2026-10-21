// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Destination _$DestinationFromJson(Map<String, dynamic> json) => _Destination(
  id: json['id'] as String,
  name: Map<String, String>.from(json['name'] as Map),
  country: Map<String, String>.from(json['country'] as Map),
  description:
      (json['description'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  imageUrl: json['image_url'] as String?,
  currency:
      (json['currency'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  language:
      (json['language'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  bestTime:
      (json['best_time'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  timezone: json['timezone'] as String?,
  tips:
      (json['tips'] as List<dynamic>?)
          ?.map((e) => DestinationTip.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DestinationTip>[],
);

Map<String, dynamic> _$DestinationToJson(_Destination instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'currency': instance.currency,
      'language': instance.language,
      'best_time': instance.bestTime,
      'timezone': instance.timezone,
      'tips': instance.tips,
    };

_DestinationTip _$DestinationTipFromJson(Map<String, dynamic> json) =>
    _DestinationTip(
      icon: json['icon'] as String? ?? 'note',
      title:
          (json['title'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      body:
          (json['body'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$DestinationTipToJson(_DestinationTip instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'title': instance.title,
      'body': instance.body,
    };
