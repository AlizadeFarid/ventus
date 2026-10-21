// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      kind:
          $enumDecodeNullable(_$NotificationTypeEnumMap, json['kind']) ??
          NotificationType.generic,
      tripId: json['trip_id'] as String?,
      tripTitle: json['trip_title'] as String?,
      subject: json['subject'] as String?,
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'kind': _$NotificationTypeEnumMap[instance.kind]!,
      'trip_id': instance.tripId,
      'trip_title': instance.tripTitle,
      'subject': instance.subject,
      'read': instance.read,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.welcome: 'welcome',
  NotificationType.collaboratorInvited: 'collaboratorInvited',
  NotificationType.aiPlanReady: 'aiPlanReady',
  NotificationType.generic: 'generic',
};
