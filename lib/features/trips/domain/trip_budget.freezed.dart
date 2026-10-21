// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripBudget {

@JsonKey(name: 'trip_id') String get tripId;@JsonKey(name: 'user_id') String? get userId; String get currency; double get total; Map<String, double> get allocations;
/// Create a copy of TripBudget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripBudgetCopyWith<TripBudget> get copyWith => _$TripBudgetCopyWithImpl<TripBudget>(this as TripBudget, _$identity);

  /// Serializes this TripBudget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripBudget&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.allocations, allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tripId,userId,currency,total,const DeepCollectionEquality().hash(allocations));

@override
String toString() {
  return 'TripBudget(tripId: $tripId, userId: $userId, currency: $currency, total: $total, allocations: $allocations)';
}


}

/// @nodoc
abstract mixin class $TripBudgetCopyWith<$Res>  {
  factory $TripBudgetCopyWith(TripBudget value, $Res Function(TripBudget) _then) = _$TripBudgetCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, String currency, double total, Map<String, double> allocations
});




}
/// @nodoc
class _$TripBudgetCopyWithImpl<$Res>
    implements $TripBudgetCopyWith<$Res> {
  _$TripBudgetCopyWithImpl(this._self, this._then);

  final TripBudget _self;
  final $Res Function(TripBudget) _then;

/// Create a copy of TripBudget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tripId = null,Object? userId = freezed,Object? currency = null,Object? total = null,Object? allocations = null,}) {
  return _then(_self.copyWith(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,allocations: null == allocations ? _self.allocations : allocations // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [TripBudget].
extension TripBudgetPatterns on TripBudget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripBudget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripBudget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripBudget value)  $default,){
final _that = this;
switch (_that) {
case _TripBudget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripBudget value)?  $default,){
final _that = this;
switch (_that) {
case _TripBudget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String currency,  double total,  Map<String, double> allocations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripBudget() when $default != null:
return $default(_that.tripId,_that.userId,_that.currency,_that.total,_that.allocations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String currency,  double total,  Map<String, double> allocations)  $default,) {final _that = this;
switch (_that) {
case _TripBudget():
return $default(_that.tripId,_that.userId,_that.currency,_that.total,_that.allocations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String currency,  double total,  Map<String, double> allocations)?  $default,) {final _that = this;
switch (_that) {
case _TripBudget() when $default != null:
return $default(_that.tripId,_that.userId,_that.currency,_that.total,_that.allocations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripBudget extends TripBudget {
  const _TripBudget({@JsonKey(name: 'trip_id') required this.tripId, @JsonKey(name: 'user_id') this.userId, this.currency = 'USD', this.total = 0, final  Map<String, double> allocations = const <String, double>{}}): _allocations = allocations,super._();
  factory _TripBudget.fromJson(Map<String, dynamic> json) => _$TripBudgetFromJson(json);

@override@JsonKey(name: 'trip_id') final  String tripId;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey() final  String currency;
@override@JsonKey() final  double total;
 final  Map<String, double> _allocations;
@override@JsonKey() Map<String, double> get allocations {
  if (_allocations is EqualUnmodifiableMapView) return _allocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_allocations);
}


/// Create a copy of TripBudget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripBudgetCopyWith<_TripBudget> get copyWith => __$TripBudgetCopyWithImpl<_TripBudget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripBudgetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripBudget&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._allocations, _allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tripId,userId,currency,total,const DeepCollectionEquality().hash(_allocations));

@override
String toString() {
  return 'TripBudget(tripId: $tripId, userId: $userId, currency: $currency, total: $total, allocations: $allocations)';
}


}

/// @nodoc
abstract mixin class _$TripBudgetCopyWith<$Res> implements $TripBudgetCopyWith<$Res> {
  factory _$TripBudgetCopyWith(_TripBudget value, $Res Function(_TripBudget) _then) = __$TripBudgetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, String currency, double total, Map<String, double> allocations
});




}
/// @nodoc
class __$TripBudgetCopyWithImpl<$Res>
    implements _$TripBudgetCopyWith<$Res> {
  __$TripBudgetCopyWithImpl(this._self, this._then);

  final _TripBudget _self;
  final $Res Function(_TripBudget) _then;

/// Create a copy of TripBudget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tripId = null,Object? userId = freezed,Object? currency = null,Object? total = null,Object? allocations = null,}) {
  return _then(_TripBudget(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,allocations: null == allocations ? _self._allocations : allocations // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
