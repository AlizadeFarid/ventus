// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Trip {

 String get id;@JsonKey(name: 'user_id') String? get userId; String get title; String get country;/// Object path inside the `trip-covers` bucket (e.g. `{userId}/{id}.jpg`).
/// The public URL is derived at read time via `AppStorage.publicUrl`.
@JsonKey(name: 'cover_image_path') String? get coverImagePath;@JsonKey(name: 'start_date') DateTime get startDate;@JsonKey(name: 'end_date') DateTime get endDate;@JsonKey(name: 'planned_percent') int get plannedPercent; int get adults; int get children;@JsonKey(name: 'traveler_type') TravelerType? get travelerType;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;/// Route stops, ordered by position. Stored in a separate `trip_stops`
/// table, so this is hydrated by the data layer — never serialized onto the
/// `trips` row itself.
@JsonKey(includeFromJson: false, includeToJson: false) List<TripStop> get stops;
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripCopyWith<Trip> get copyWith => _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.country, country) || other.country == country)&&(identical(other.coverImagePath, coverImagePath) || other.coverImagePath == coverImagePath)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.plannedPercent, plannedPercent) || other.plannedPercent == plannedPercent)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.travelerType, travelerType) || other.travelerType == travelerType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.stops, stops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,country,coverImagePath,startDate,endDate,plannedPercent,adults,children,travelerType,createdAt,updatedAt,const DeepCollectionEquality().hash(stops));

@override
String toString() {
  return 'Trip(id: $id, userId: $userId, title: $title, country: $country, coverImagePath: $coverImagePath, startDate: $startDate, endDate: $endDate, plannedPercent: $plannedPercent, adults: $adults, children: $children, travelerType: $travelerType, createdAt: $createdAt, updatedAt: $updatedAt, stops: $stops)';
}


}

/// @nodoc
abstract mixin class $TripCopyWith<$Res>  {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) = _$TripCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String title, String country,@JsonKey(name: 'cover_image_path') String? coverImagePath,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate,@JsonKey(name: 'planned_percent') int plannedPercent, int adults, int children,@JsonKey(name: 'traveler_type') TravelerType? travelerType,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(includeFromJson: false, includeToJson: false) List<TripStop> stops
});




}
/// @nodoc
class _$TripCopyWithImpl<$Res>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? title = null,Object? country = null,Object? coverImagePath = freezed,Object? startDate = null,Object? endDate = null,Object? plannedPercent = null,Object? adults = null,Object? children = null,Object? travelerType = freezed,Object? createdAt = null,Object? updatedAt = null,Object? stops = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,coverImagePath: freezed == coverImagePath ? _self.coverImagePath : coverImagePath // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,plannedPercent: null == plannedPercent ? _self.plannedPercent : plannedPercent // ignore: cast_nullable_to_non_nullable
as int,adults: null == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int,travelerType: freezed == travelerType ? _self.travelerType : travelerType // ignore: cast_nullable_to_non_nullable
as TravelerType?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<TripStop>,
  ));
}

}


/// Adds pattern-matching-related methods to [Trip].
extension TripPatterns on Trip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trip value)  $default,){
final _that = this;
switch (_that) {
case _Trip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trip value)?  $default,){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String title,  String country, @JsonKey(name: 'cover_image_path')  String? coverImagePath, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(name: 'planned_percent')  int plannedPercent,  int adults,  int children, @JsonKey(name: 'traveler_type')  TravelerType? travelerType, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  List<TripStop> stops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.country,_that.coverImagePath,_that.startDate,_that.endDate,_that.plannedPercent,_that.adults,_that.children,_that.travelerType,_that.createdAt,_that.updatedAt,_that.stops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String title,  String country, @JsonKey(name: 'cover_image_path')  String? coverImagePath, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(name: 'planned_percent')  int plannedPercent,  int adults,  int children, @JsonKey(name: 'traveler_type')  TravelerType? travelerType, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  List<TripStop> stops)  $default,) {final _that = this;
switch (_that) {
case _Trip():
return $default(_that.id,_that.userId,_that.title,_that.country,_that.coverImagePath,_that.startDate,_that.endDate,_that.plannedPercent,_that.adults,_that.children,_that.travelerType,_that.createdAt,_that.updatedAt,_that.stops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String? userId,  String title,  String country, @JsonKey(name: 'cover_image_path')  String? coverImagePath, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(name: 'planned_percent')  int plannedPercent,  int adults,  int children, @JsonKey(name: 'traveler_type')  TravelerType? travelerType, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeFromJson: false, includeToJson: false)  List<TripStop> stops)?  $default,) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.country,_that.coverImagePath,_that.startDate,_that.endDate,_that.plannedPercent,_that.adults,_that.children,_that.travelerType,_that.createdAt,_that.updatedAt,_that.stops);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trip extends Trip {
  const _Trip({required this.id, @JsonKey(name: 'user_id') this.userId, required this.title, required this.country, @JsonKey(name: 'cover_image_path') this.coverImagePath, @JsonKey(name: 'start_date') required this.startDate, @JsonKey(name: 'end_date') required this.endDate, @JsonKey(name: 'planned_percent') this.plannedPercent = 0, this.adults = 2, this.children = 0, @JsonKey(name: 'traveler_type') this.travelerType, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(includeFromJson: false, includeToJson: false) final  List<TripStop> stops = const <TripStop>[]}): _stops = stops,super._();
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override final  String title;
@override final  String country;
/// Object path inside the `trip-covers` bucket (e.g. `{userId}/{id}.jpg`).
/// The public URL is derived at read time via `AppStorage.publicUrl`.
@override@JsonKey(name: 'cover_image_path') final  String? coverImagePath;
@override@JsonKey(name: 'start_date') final  DateTime startDate;
@override@JsonKey(name: 'end_date') final  DateTime endDate;
@override@JsonKey(name: 'planned_percent') final  int plannedPercent;
@override@JsonKey() final  int adults;
@override@JsonKey() final  int children;
@override@JsonKey(name: 'traveler_type') final  TravelerType? travelerType;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
/// Route stops, ordered by position. Stored in a separate `trip_stops`
/// table, so this is hydrated by the data layer — never serialized onto the
/// `trips` row itself.
 final  List<TripStop> _stops;
/// Route stops, ordered by position. Stored in a separate `trip_stops`
/// table, so this is hydrated by the data layer — never serialized onto the
/// `trips` row itself.
@override@JsonKey(includeFromJson: false, includeToJson: false) List<TripStop> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}


/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripCopyWith<_Trip> get copyWith => __$TripCopyWithImpl<_Trip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.country, country) || other.country == country)&&(identical(other.coverImagePath, coverImagePath) || other.coverImagePath == coverImagePath)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.plannedPercent, plannedPercent) || other.plannedPercent == plannedPercent)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.travelerType, travelerType) || other.travelerType == travelerType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._stops, _stops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,country,coverImagePath,startDate,endDate,plannedPercent,adults,children,travelerType,createdAt,updatedAt,const DeepCollectionEquality().hash(_stops));

@override
String toString() {
  return 'Trip(id: $id, userId: $userId, title: $title, country: $country, coverImagePath: $coverImagePath, startDate: $startDate, endDate: $endDate, plannedPercent: $plannedPercent, adults: $adults, children: $children, travelerType: $travelerType, createdAt: $createdAt, updatedAt: $updatedAt, stops: $stops)';
}


}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) = __$TripCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String title, String country,@JsonKey(name: 'cover_image_path') String? coverImagePath,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate,@JsonKey(name: 'planned_percent') int plannedPercent, int adults, int children,@JsonKey(name: 'traveler_type') TravelerType? travelerType,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(includeFromJson: false, includeToJson: false) List<TripStop> stops
});




}
/// @nodoc
class __$TripCopyWithImpl<$Res>
    implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? title = null,Object? country = null,Object? coverImagePath = freezed,Object? startDate = null,Object? endDate = null,Object? plannedPercent = null,Object? adults = null,Object? children = null,Object? travelerType = freezed,Object? createdAt = null,Object? updatedAt = null,Object? stops = null,}) {
  return _then(_Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,coverImagePath: freezed == coverImagePath ? _self.coverImagePath : coverImagePath // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,plannedPercent: null == plannedPercent ? _self.plannedPercent : plannedPercent // ignore: cast_nullable_to_non_nullable
as int,adults: null == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int,travelerType: freezed == travelerType ? _self.travelerType : travelerType // ignore: cast_nullable_to_non_nullable
as TravelerType?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<TripStop>,
  ));
}


}

// dart format on
