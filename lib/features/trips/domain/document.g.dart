// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripDocument _$TripDocumentFromJson(Map<String, dynamic> json) =>
    _TripDocument(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      userId: json['user_id'] as String?,
      name: json['name'] as String,
      type:
          $enumDecodeNullable(_$DocumentTypeEnumMap, json['type']) ??
          DocumentType.other,
      storagePath: json['storage_path'] as String,
      ext: json['ext'] as String?,
      mimeType: json['mime_type'] as String?,
      sizeBytes: (json['size_bytes'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$TripDocumentToJson(_TripDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'user_id': instance.userId,
      'name': instance.name,
      'type': _$DocumentTypeEnumMap[instance.type]!,
      'storage_path': instance.storagePath,
      'ext': instance.ext,
      'mime_type': instance.mimeType,
      'size_bytes': instance.sizeBytes,
      'day': instance.day,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.ticket: 'ticket',
  DocumentType.stay: 'stay',
  DocumentType.id: 'id',
  DocumentType.other: 'other',
};
