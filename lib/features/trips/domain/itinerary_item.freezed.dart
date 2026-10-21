// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItineraryItem {

 String get id;@JsonKey(name: 'trip_id') String get tripId;@JsonKey(name: 'user_id') String? get userId; int get day;@JsonKey(name: 'start_minutes') int? get startMinutes; String get title; String? get place; ActivityKind get kind; int get position; double? get lat; double? get lon;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ItineraryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItineraryItemCopyWith<ItineraryItem> get copyWith => _$ItineraryItemCopyWithImpl<ItineraryItem>(this as ItineraryItem, _$identity);

  /// Serializes this ItineraryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItineraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.day, day) || other.day == day)&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.title, title) || other.title == title)&&(identical(other.place, place) || other.place == place)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,userId,day,startMinutes,title,place,kind,position,lat,lon,createdAt);

@override
String toString() {
  return 'ItineraryItem(id: $id, tripId: $tripId, userId: $userId, day: $day, startMinutes: $startMinutes, title: $title, place: $place, kind: $kind, position: $position, lat: $lat, lon: $lon, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ItineraryItemCopyWith<$Res>  {
  factory $ItineraryItemCopyWith(ItineraryItem value, $Res Function(ItineraryItem) _then) = _$ItineraryItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, int day,@JsonKey(name: 'start_minutes') int? startMinutes, String title, String? place, ActivityKind kind, int position, double? lat, double? lon,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$ItineraryItemCopyWithImpl<$Res>
    implements $ItineraryItemCopyWith<$Res> {
  _$ItineraryItemCopyWithImpl(this._self, this._then);

  final ItineraryItem _self;
  final $Res Function(ItineraryItem) _then;

/// Create a copy of ItineraryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = null,Object? userId = freezed,Object? day = null,Object? startMinutes = freezed,Object? title = null,Object? place = freezed,Object? kind = null,Object? position = null,Object? lat = freezed,Object? lon = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,startMinutes: freezed == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ActivityKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ItineraryItem].
extension ItineraryItemPatterns on ItineraryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItineraryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItineraryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItineraryItem value)  $default,){
final _that = this;
switch (_that) {
case _ItineraryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItineraryItem value)?  $default,){
final _that = this;
switch (_that) {
case _ItineraryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  int day, @JsonKey(name: 'start_minutes')  int? startMinutes,  String title,  String? place,  ActivityKind kind,  int position,  double? lat,  double? lon, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItineraryItem() when $default != null:
return $default(_that.id,_that.tripId,_that.userId,_that.day,_that.startMinutes,_that.title,_that.place,_that.kind,_that.position,_that.lat,_that.lon,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  int day, @JsonKey(name: 'start_minutes')  int? startMinutes,  String title,  String? place,  ActivityKind kind,  int position,  double? lat,  double? lon, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ItineraryItem():
return $default(_that.id,_that.tripId,_that.userId,_that.day,_that.startMinutes,_that.title,_that.place,_that.kind,_that.position,_that.lat,_that.lon,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  int day, @JsonKey(name: 'start_minutes')  int? startMinutes,  String title,  String? place,  ActivityKind kind,  int position,  double? lat,  double? lon, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ItineraryItem() when $default != null:
return $default(_that.id,_that.tripId,_that.userId,_that.day,_that.startMinutes,_that.title,_that.place,_that.kind,_that.position,_that.lat,_that.lon,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItineraryItem extends ItineraryItem {
  const _ItineraryItem({required this.id, @JsonKey(name: 'trip_id') required this.tripId, @JsonKey(name: 'user_id') this.userId, required this.day, @JsonKey(name: 'start_minutes') this.startMinutes, required this.title, this.place, this.kind = ActivityKind.activity, this.position = 0, this.lat, this.lon, @JsonKey(name: 'created_at') required this.createdAt}): super._();
  factory _ItineraryItem.fromJson(Map<String, dynamic> json) => _$ItineraryItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'trip_id') final  String tripId;
@override@JsonKey(name: 'user_id') final  String? userId;
@override final  int day;
@override@JsonKey(name: 'start_minutes') final  int? startMinutes;
@override final  String title;
@override final  String? place;
@override@JsonKey() final  ActivityKind kind;
@override@JsonKey() final  int position;
@override final  double? lat;
@override final  double? lon;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ItineraryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItineraryItemCopyWith<_ItineraryItem> get copyWith => __$ItineraryItemCopyWithImpl<_ItineraryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItineraryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItineraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.day, day) || other.day == day)&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.title, title) || other.title == title)&&(identical(other.place, place) || other.place == place)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,userId,day,startMinutes,title,place,kind,position,lat,lon,createdAt);

@override
String toString() {
  return 'ItineraryItem(id: $id, tripId: $tripId, userId: $userId, day: $day, startMinutes: $startMinutes, title: $title, place: $place, kind: $kind, position: $position, lat: $lat, lon: $lon, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ItineraryItemCopyWith<$Res> implements $ItineraryItemCopyWith<$Res> {
  factory _$ItineraryItemCopyWith(_ItineraryItem value, $Res Function(_ItineraryItem) _then) = __$ItineraryItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, int day,@JsonKey(name: 'start_minutes') int? startMinutes, String title, String? place, ActivityKind kind, int position, double? lat, double? lon,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$ItineraryItemCopyWithImpl<$Res>
    implements _$ItineraryItemCopyWith<$Res> {
  __$ItineraryItemCopyWithImpl(this._self, this._then);

  final _ItineraryItem _self;
  final $Res Function(_ItineraryItem) _then;

/// Create a copy of ItineraryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = null,Object? userId = freezed,Object? day = null,Object? startMinutes = freezed,Object? title = null,Object? place = freezed,Object? kind = null,Object? position = null,Object? lat = freezed,Object? lon = freezed,Object? createdAt = null,}) {
  return _then(_ItineraryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,startMinutes: freezed == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ActivityKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
