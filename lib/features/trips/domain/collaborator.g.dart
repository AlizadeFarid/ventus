// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Collaborator _$CollaboratorFromJson(Map<String, dynamic> json) =>
    _Collaborator(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      userId: json['user_id'] as String?,
      email: json['email'] as String,
      name: json['name'] as String?,
      role:
          $enumDecodeNullable(_$CollaboratorRoleEnumMap, json['role']) ??
          CollaboratorRole.viewer,
      status:
          $enumDecodeNullable(_$CollaboratorStatusEnumMap, json['status']) ??
          CollaboratorStatus.pending,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CollaboratorToJson(_Collaborator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'user_id': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'role': _$CollaboratorRoleEnumMap[instance.role]!,
      'status': _$CollaboratorStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$CollaboratorRoleEnumMap = {
  CollaboratorRole.editor: 'editor',
  CollaboratorRole.viewer: 'viewer',
};

const _$CollaboratorStatusEnumMap = {
  CollaboratorStatus.pending: 'pending',
  CollaboratorStatus.active: 'active',
};
