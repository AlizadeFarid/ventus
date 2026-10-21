// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collaborator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Collaborator {

 String get id;@JsonKey(name: 'trip_id') String get tripId;@JsonKey(name: 'user_id') String? get userId; String get email; String? get name; CollaboratorRole get role; CollaboratorStatus get status;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of Collaborator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollaboratorCopyWith<Collaborator> get copyWith => _$CollaboratorCopyWithImpl<Collaborator>(this as Collaborator, _$identity);

  /// Serializes this Collaborator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Collaborator&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,userId,email,name,role,status,createdAt);

@override
String toString() {
  return 'Collaborator(id: $id, tripId: $tripId, userId: $userId, email: $email, name: $name, role: $role, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CollaboratorCopyWith<$Res>  {
  factory $CollaboratorCopyWith(Collaborator value, $Res Function(Collaborator) _then) = _$CollaboratorCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, String email, String? name, CollaboratorRole role, CollaboratorStatus status,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$CollaboratorCopyWithImpl<$Res>
    implements $CollaboratorCopyWith<$Res> {
  _$CollaboratorCopyWithImpl(this._self, this._then);

  final Collaborator _self;
  final $Res Function(Collaborator) _then;

/// Create a copy of Collaborator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = null,Object? userId = freezed,Object? email = null,Object? name = freezed,Object? role = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CollaboratorRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollaboratorStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Collaborator].
extension CollaboratorPatterns on Collaborator {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Collaborator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Collaborator() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Collaborator value)  $default,){
final _that = this;
switch (_that) {
case _Collaborator():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Collaborator value)?  $default,){
final _that = this;
switch (_that) {
case _Collaborator() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String email,  String? name,  CollaboratorRole role,  CollaboratorStatus status, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Collaborator() when $default != null:
return $default(_that.id,_that.tripId,_that.userId,_that.email,_that.name,_that.role,_that.status,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String email,  String? name,  CollaboratorRole role,  CollaboratorStatus status, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Collaborator():
return $default(_that.id,_that.tripId,_that.userId,_that.email,_that.name,_that.role,_that.status,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String email,  String? name,  CollaboratorRole role,  CollaboratorStatus status, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Collaborator() when $default != null:
return $default(_that.id,_that.tripId,_that.userId,_that.email,_that.name,_that.role,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Collaborator implements Collaborator {
  const _Collaborator({required this.id, @JsonKey(name: 'trip_id') required this.tripId, @JsonKey(name: 'user_id') this.userId, required this.email, this.name, this.role = CollaboratorRole.viewer, this.status = CollaboratorStatus.pending, @JsonKey(name: 'created_at') required this.createdAt});
  factory _Collaborator.fromJson(Map<String, dynamic> json) => _$CollaboratorFromJson(json);

@override final  String id;
@override@JsonKey(name: 'trip_id') final  String tripId;
@override@JsonKey(name: 'user_id') final  String? userId;
@override final  String email;
@override final  String? name;
@override@JsonKey() final  CollaboratorRole role;
@override@JsonKey() final  CollaboratorStatus status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of Collaborator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollaboratorCopyWith<_Collaborator> get copyWith => __$CollaboratorCopyWithImpl<_Collaborator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollaboratorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Collaborator&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,userId,email,name,role,status,createdAt);

@override
String toString() {
  return 'Collaborator(id: $id, tripId: $tripId, userId: $userId, email: $email, name: $name, role: $role, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CollaboratorCopyWith<$Res> implements $CollaboratorCopyWith<$Res> {
  factory _$CollaboratorCopyWith(_Collaborator value, $Res Function(_Collaborator) _then) = __$CollaboratorCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, String email, String? name, CollaboratorRole role, CollaboratorStatus status,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$CollaboratorCopyWithImpl<$Res>
    implements _$CollaboratorCopyWith<$Res> {
  __$CollaboratorCopyWithImpl(this._self, this._then);

  final _Collaborator _self;
  final $Res Function(_Collaborator) _then;

/// Create a copy of Collaborator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = null,Object? userId = freezed,Object? email = null,Object? name = freezed,Object? role = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_Collaborator(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CollaboratorRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollaboratorStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
