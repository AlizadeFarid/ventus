// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      userId: json['user_id'] as String?,
      title: json['title'] as String,
      done: json['done'] as bool? ?? false,
      category:
          $enumDecodeNullable(_$ChecklistCategoryEnumMap, json['category']) ??
          ChecklistCategory.beforeYouGo,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      position: (json['position'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'user_id': instance.userId,
      'title': instance.title,
      'done': instance.done,
      'category': _$ChecklistCategoryEnumMap[instance.category]!,
      'due_date': instance.dueDate?.toIso8601String(),
      'position': instance.position,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ChecklistCategoryEnumMap = {
  ChecklistCategory.beforeYouGo: 'beforeYouGo',
  ChecklistCategory.pack: 'pack',
  ChecklistCategory.onArrival: 'onArrival',
};
