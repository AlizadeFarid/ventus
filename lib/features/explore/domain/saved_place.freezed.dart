// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedPlace {

@JsonKey(name: 'destination_id') String get destinationId;@JsonKey(name: 'user_id') String? get userId; String get name; String get country;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of SavedPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedPlaceCopyWith<SavedPlace> get copyWith => _$SavedPlaceCopyWithImpl<SavedPlace>(this as SavedPlace, _$identity);

  /// Serializes this SavedPlace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedPlace&&(identical(other.destinationId, destinationId) || other.destinationId == destinationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,destinationId,userId,name,country,imageUrl,createdAt);

@override
String toString() {
  return 'SavedPlace(destinationId: $destinationId, userId: $userId, name: $name, country: $country, imageUrl: $imageUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SavedPlaceCopyWith<$Res>  {
  factory $SavedPlaceCopyWith(SavedPlace value, $Res Function(SavedPlace) _then) = _$SavedPlaceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'destination_id') String destinationId,@JsonKey(name: 'user_id') String? userId, String name, String country,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$SavedPlaceCopyWithImpl<$Res>
    implements $SavedPlaceCopyWith<$Res> {
  _$SavedPlaceCopyWithImpl(this._self, this._then);

  final SavedPlace _self;
  final $Res Function(SavedPlace) _then;

/// Create a copy of SavedPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? destinationId = null,Object? userId = freezed,Object? name = null,Object? country = null,Object? imageUrl = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
destinationId: null == destinationId ? _self.destinationId : destinationId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedPlace].
extension SavedPlacePatterns on SavedPlace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedPlace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedPlace value)  $default,){
final _that = this;
switch (_that) {
case _SavedPlace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedPlace value)?  $default,){
final _that = this;
switch (_that) {
case _SavedPlace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'destination_id')  String destinationId, @JsonKey(name: 'user_id')  String? userId,  String name,  String country, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedPlace() when $default != null:
return $default(_that.destinationId,_that.userId,_that.name,_that.country,_that.imageUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'destination_id')  String destinationId, @JsonKey(name: 'user_id')  String? userId,  String name,  String country, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SavedPlace():
return $default(_that.destinationId,_that.userId,_that.name,_that.country,_that.imageUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'destination_id')  String destinationId, @JsonKey(name: 'user_id')  String? userId,  String name,  String country, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SavedPlace() when $default != null:
return $default(_that.destinationId,_that.userId,_that.name,_that.country,_that.imageUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedPlace implements SavedPlace {
  const _SavedPlace({@JsonKey(name: 'destination_id') required this.destinationId, @JsonKey(name: 'user_id') this.userId, required this.name, required this.country, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'created_at') required this.createdAt});
  factory _SavedPlace.fromJson(Map<String, dynamic> json) => _$SavedPlaceFromJson(json);

@override@JsonKey(name: 'destination_id') final  String destinationId;
@override@JsonKey(name: 'user_id') final  String? userId;
@override final  String name;
@override final  String country;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of SavedPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedPlaceCopyWith<_SavedPlace> get copyWith => __$SavedPlaceCopyWithImpl<_SavedPlace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedPlaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedPlace&&(identical(other.destinationId, destinationId) || other.destinationId == destinationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,destinationId,userId,name,country,imageUrl,createdAt);

@override
String toString() {
  return 'SavedPlace(destinationId: $destinationId, userId: $userId, name: $name, country: $country, imageUrl: $imageUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SavedPlaceCopyWith<$Res> implements $SavedPlaceCopyWith<$Res> {
  factory _$SavedPlaceCopyWith(_SavedPlace value, $Res Function(_SavedPlace) _then) = __$SavedPlaceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'destination_id') String destinationId,@JsonKey(name: 'user_id') String? userId, String name, String country,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$SavedPlaceCopyWithImpl<$Res>
    implements _$SavedPlaceCopyWith<$Res> {
  __$SavedPlaceCopyWithImpl(this._self, this._then);

  final _SavedPlace _self;
  final $Res Function(_SavedPlace) _then;

/// Create a copy of SavedPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? destinationId = null,Object? userId = freezed,Object? name = null,Object? country = null,Object? imageUrl = freezed,Object? createdAt = null,}) {
  return _then(_SavedPlace(
destinationId: null == destinationId ? _self.destinationId : destinationId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
