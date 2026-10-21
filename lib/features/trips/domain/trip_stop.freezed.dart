// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_stop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripStop {

 String get id;@JsonKey(name: 'trip_id') String get tripId; String get name; String get country; int get position; double? get lat; double? get lon;
/// Create a copy of TripStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripStopCopyWith<TripStop> get copyWith => _$TripStopCopyWithImpl<TripStop>(this as TripStop, _$identity);

  /// Serializes this TripStop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripStop&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.position, position) || other.position == position)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,name,country,position,lat,lon);

@override
String toString() {
  return 'TripStop(id: $id, tripId: $tripId, name: $name, country: $country, position: $position, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class $TripStopCopyWith<$Res>  {
  factory $TripStopCopyWith(TripStop value, $Res Function(TripStop) _then) = _$TripStopCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId, String name, String country, int position, double? lat, double? lon
});




}
/// @nodoc
class _$TripStopCopyWithImpl<$Res>
    implements $TripStopCopyWith<$Res> {
  _$TripStopCopyWithImpl(this._self, this._then);

  final TripStop _self;
  final $Res Function(TripStop) _then;

/// Create a copy of TripStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = null,Object? name = null,Object? country = null,Object? position = null,Object? lat = freezed,Object? lon = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TripStop].
extension TripStopPatterns on TripStop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripStop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripStop value)  $default,){
final _that = this;
switch (_that) {
case _TripStop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripStop value)?  $default,){
final _that = this;
switch (_that) {
case _TripStop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId,  String name,  String country,  int position,  double? lat,  double? lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripStop() when $default != null:
return $default(_that.id,_that.tripId,_that.name,_that.country,_that.position,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId,  String name,  String country,  int position,  double? lat,  double? lon)  $default,) {final _that = this;
switch (_that) {
case _TripStop():
return $default(_that.id,_that.tripId,_that.name,_that.country,_that.position,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'trip_id')  String tripId,  String name,  String country,  int position,  double? lat,  double? lon)?  $default,) {final _that = this;
switch (_that) {
case _TripStop() when $default != null:
return $default(_that.id,_that.tripId,_that.name,_that.country,_that.position,_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripStop extends TripStop {
  const _TripStop({required this.id, @JsonKey(name: 'trip_id') required this.tripId, required this.name, required this.country, this.position = 0, this.lat, this.lon}): super._();
  factory _TripStop.fromJson(Map<String, dynamic> json) => _$TripStopFromJson(json);

@override final  String id;
@override@JsonKey(name: 'trip_id') final  String tripId;
@override final  String name;
@override final  String country;
@override@JsonKey() final  int position;
@override final  double? lat;
@override final  double? lon;

/// Create a copy of TripStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripStopCopyWith<_TripStop> get copyWith => __$TripStopCopyWithImpl<_TripStop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripStopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripStop&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.position, position) || other.position == position)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,name,country,position,lat,lon);

@override
String toString() {
  return 'TripStop(id: $id, tripId: $tripId, name: $name, country: $country, position: $position, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$TripStopCopyWith<$Res> implements $TripStopCopyWith<$Res> {
  factory _$TripStopCopyWith(_TripStop value, $Res Function(_TripStop) _then) = __$TripStopCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId, String name, String country, int position, double? lat, double? lon
});




}
/// @nodoc
class __$TripStopCopyWithImpl<$Res>
    implements _$TripStopCopyWith<$Res> {
  __$TripStopCopyWithImpl(this._self, this._then);

  final _TripStop _self;
  final $Res Function(_TripStop) _then;

/// Create a copy of TripStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = null,Object? name = null,Object? country = null,Object? position = null,Object? lat = freezed,Object? lon = freezed,}) {
  return _then(_TripStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
