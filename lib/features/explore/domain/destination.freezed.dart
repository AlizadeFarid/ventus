// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Destination {

 String get id; Map<String, String> get name; Map<String, String> get country; Map<String, String> get description;@JsonKey(name: 'image_url') String? get imageUrl; Map<String, String> get currency; Map<String, String> get language;@JsonKey(name: 'best_time') Map<String, String> get bestTime; String? get timezone; List<DestinationTip> get tips;
/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DestinationCopyWith<Destination> get copyWith => _$DestinationCopyWithImpl<Destination>(this as Destination, _$identity);

  /// Serializes this Destination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Destination&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, name)&&const DeepCollectionEquality().equals(other.country, country)&&const DeepCollectionEquality().equals(other.description, description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.currency, currency)&&const DeepCollectionEquality().equals(other.language, language)&&const DeepCollectionEquality().equals(other.bestTime, bestTime)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other.tips, tips));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(name),const DeepCollectionEquality().hash(country),const DeepCollectionEquality().hash(description),imageUrl,const DeepCollectionEquality().hash(currency),const DeepCollectionEquality().hash(language),const DeepCollectionEquality().hash(bestTime),timezone,const DeepCollectionEquality().hash(tips));

@override
String toString() {
  return 'Destination(id: $id, name: $name, country: $country, description: $description, imageUrl: $imageUrl, currency: $currency, language: $language, bestTime: $bestTime, timezone: $timezone, tips: $tips)';
}


}

/// @nodoc
abstract mixin class $DestinationCopyWith<$Res>  {
  factory $DestinationCopyWith(Destination value, $Res Function(Destination) _then) = _$DestinationCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> name, Map<String, String> country, Map<String, String> description,@JsonKey(name: 'image_url') String? imageUrl, Map<String, String> currency, Map<String, String> language,@JsonKey(name: 'best_time') Map<String, String> bestTime, String? timezone, List<DestinationTip> tips
});




}
/// @nodoc
class _$DestinationCopyWithImpl<$Res>
    implements $DestinationCopyWith<$Res> {
  _$DestinationCopyWithImpl(this._self, this._then);

  final Destination _self;
  final $Res Function(Destination) _then;

/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? country = null,Object? description = null,Object? imageUrl = freezed,Object? currency = null,Object? language = null,Object? bestTime = null,Object? timezone = freezed,Object? tips = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as Map<String, String>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as Map<String, String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Map<String, String>,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as Map<String, String>,bestTime: null == bestTime ? _self.bestTime : bestTime // ignore: cast_nullable_to_non_nullable
as Map<String, String>,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,tips: null == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as List<DestinationTip>,
  ));
}

}


/// Adds pattern-matching-related methods to [Destination].
extension DestinationPatterns on Destination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Destination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Destination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Destination value)  $default,){
final _that = this;
switch (_that) {
case _Destination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Destination value)?  $default,){
final _that = this;
switch (_that) {
case _Destination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> name,  Map<String, String> country,  Map<String, String> description, @JsonKey(name: 'image_url')  String? imageUrl,  Map<String, String> currency,  Map<String, String> language, @JsonKey(name: 'best_time')  Map<String, String> bestTime,  String? timezone,  List<DestinationTip> tips)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Destination() when $default != null:
return $default(_that.id,_that.name,_that.country,_that.description,_that.imageUrl,_that.currency,_that.language,_that.bestTime,_that.timezone,_that.tips);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> name,  Map<String, String> country,  Map<String, String> description, @JsonKey(name: 'image_url')  String? imageUrl,  Map<String, String> currency,  Map<String, String> language, @JsonKey(name: 'best_time')  Map<String, String> bestTime,  String? timezone,  List<DestinationTip> tips)  $default,) {final _that = this;
switch (_that) {
case _Destination():
return $default(_that.id,_that.name,_that.country,_that.description,_that.imageUrl,_that.currency,_that.language,_that.bestTime,_that.timezone,_that.tips);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> name,  Map<String, String> country,  Map<String, String> description, @JsonKey(name: 'image_url')  String? imageUrl,  Map<String, String> currency,  Map<String, String> language, @JsonKey(name: 'best_time')  Map<String, String> bestTime,  String? timezone,  List<DestinationTip> tips)?  $default,) {final _that = this;
switch (_that) {
case _Destination() when $default != null:
return $default(_that.id,_that.name,_that.country,_that.description,_that.imageUrl,_that.currency,_that.language,_that.bestTime,_that.timezone,_that.tips);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Destination extends Destination {
  const _Destination({required this.id, required final  Map<String, String> name, required final  Map<String, String> country, final  Map<String, String> description = const <String, String>{}, @JsonKey(name: 'image_url') this.imageUrl, final  Map<String, String> currency = const <String, String>{}, final  Map<String, String> language = const <String, String>{}, @JsonKey(name: 'best_time') final  Map<String, String> bestTime = const <String, String>{}, this.timezone, final  List<DestinationTip> tips = const <DestinationTip>[]}): _name = name,_country = country,_description = description,_currency = currency,_language = language,_bestTime = bestTime,_tips = tips,super._();
  factory _Destination.fromJson(Map<String, dynamic> json) => _$DestinationFromJson(json);

@override final  String id;
 final  Map<String, String> _name;
@override Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

 final  Map<String, String> _country;
@override Map<String, String> get country {
  if (_country is EqualUnmodifiableMapView) return _country;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_country);
}

 final  Map<String, String> _description;
@override@JsonKey() Map<String, String> get description {
  if (_description is EqualUnmodifiableMapView) return _description;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_description);
}

@override@JsonKey(name: 'image_url') final  String? imageUrl;
 final  Map<String, String> _currency;
@override@JsonKey() Map<String, String> get currency {
  if (_currency is EqualUnmodifiableMapView) return _currency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_currency);
}

 final  Map<String, String> _language;
@override@JsonKey() Map<String, String> get language {
  if (_language is EqualUnmodifiableMapView) return _language;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_language);
}

 final  Map<String, String> _bestTime;
@override@JsonKey(name: 'best_time') Map<String, String> get bestTime {
  if (_bestTime is EqualUnmodifiableMapView) return _bestTime;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bestTime);
}

@override final  String? timezone;
 final  List<DestinationTip> _tips;
@override@JsonKey() List<DestinationTip> get tips {
  if (_tips is EqualUnmodifiableListView) return _tips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tips);
}


/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DestinationCopyWith<_Destination> get copyWith => __$DestinationCopyWithImpl<_Destination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DestinationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Destination&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._name, _name)&&const DeepCollectionEquality().equals(other._country, _country)&&const DeepCollectionEquality().equals(other._description, _description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._currency, _currency)&&const DeepCollectionEquality().equals(other._language, _language)&&const DeepCollectionEquality().equals(other._bestTime, _bestTime)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other._tips, _tips));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),const DeepCollectionEquality().hash(_country),const DeepCollectionEquality().hash(_description),imageUrl,const DeepCollectionEquality().hash(_currency),const DeepCollectionEquality().hash(_language),const DeepCollectionEquality().hash(_bestTime),timezone,const DeepCollectionEquality().hash(_tips));

@override
String toString() {
  return 'Destination(id: $id, name: $name, country: $country, description: $description, imageUrl: $imageUrl, currency: $currency, language: $language, bestTime: $bestTime, timezone: $timezone, tips: $tips)';
}


}

/// @nodoc
abstract mixin class _$DestinationCopyWith<$Res> implements $DestinationCopyWith<$Res> {
  factory _$DestinationCopyWith(_Destination value, $Res Function(_Destination) _then) = __$DestinationCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> name, Map<String, String> country, Map<String, String> description,@JsonKey(name: 'image_url') String? imageUrl, Map<String, String> currency, Map<String, String> language,@JsonKey(name: 'best_time') Map<String, String> bestTime, String? timezone, List<DestinationTip> tips
});




}
/// @nodoc
class __$DestinationCopyWithImpl<$Res>
    implements _$DestinationCopyWith<$Res> {
  __$DestinationCopyWithImpl(this._self, this._then);

  final _Destination _self;
  final $Res Function(_Destination) _then;

/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? country = null,Object? description = null,Object? imageUrl = freezed,Object? currency = null,Object? language = null,Object? bestTime = null,Object? timezone = freezed,Object? tips = null,}) {
  return _then(_Destination(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,country: null == country ? _self._country : country // ignore: cast_nullable_to_non_nullable
as Map<String, String>,description: null == description ? _self._description : description // ignore: cast_nullable_to_non_nullable
as Map<String, String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self._currency : currency // ignore: cast_nullable_to_non_nullable
as Map<String, String>,language: null == language ? _self._language : language // ignore: cast_nullable_to_non_nullable
as Map<String, String>,bestTime: null == bestTime ? _self._bestTime : bestTime // ignore: cast_nullable_to_non_nullable
as Map<String, String>,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,tips: null == tips ? _self._tips : tips // ignore: cast_nullable_to_non_nullable
as List<DestinationTip>,
  ));
}


}


/// @nodoc
mixin _$DestinationTip {

 String get icon; Map<String, String> get title; Map<String, String> get body;
/// Create a copy of DestinationTip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DestinationTipCopyWith<DestinationTip> get copyWith => _$DestinationTipCopyWithImpl<DestinationTip>(this as DestinationTip, _$identity);

  /// Serializes this DestinationTip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DestinationTip&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.title, title)&&const DeepCollectionEquality().equals(other.body, body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,const DeepCollectionEquality().hash(title),const DeepCollectionEquality().hash(body));

@override
String toString() {
  return 'DestinationTip(icon: $icon, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class $DestinationTipCopyWith<$Res>  {
  factory $DestinationTipCopyWith(DestinationTip value, $Res Function(DestinationTip) _then) = _$DestinationTipCopyWithImpl;
@useResult
$Res call({
 String icon, Map<String, String> title, Map<String, String> body
});




}
/// @nodoc
class _$DestinationTipCopyWithImpl<$Res>
    implements $DestinationTipCopyWith<$Res> {
  _$DestinationTipCopyWithImpl(this._self, this._then);

  final DestinationTip _self;
  final $Res Function(DestinationTip) _then;

/// Create a copy of DestinationTip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? title = null,Object? body = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Map<String, String>,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DestinationTip].
extension DestinationTipPatterns on DestinationTip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DestinationTip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DestinationTip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DestinationTip value)  $default,){
final _that = this;
switch (_that) {
case _DestinationTip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DestinationTip value)?  $default,){
final _that = this;
switch (_that) {
case _DestinationTip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String icon,  Map<String, String> title,  Map<String, String> body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DestinationTip() when $default != null:
return $default(_that.icon,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String icon,  Map<String, String> title,  Map<String, String> body)  $default,) {final _that = this;
switch (_that) {
case _DestinationTip():
return $default(_that.icon,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String icon,  Map<String, String> title,  Map<String, String> body)?  $default,) {final _that = this;
switch (_that) {
case _DestinationTip() when $default != null:
return $default(_that.icon,_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DestinationTip extends DestinationTip {
  const _DestinationTip({this.icon = 'note', final  Map<String, String> title = const <String, String>{}, final  Map<String, String> body = const <String, String>{}}): _title = title,_body = body,super._();
  factory _DestinationTip.fromJson(Map<String, dynamic> json) => _$DestinationTipFromJson(json);

@override@JsonKey() final  String icon;
 final  Map<String, String> _title;
@override@JsonKey() Map<String, String> get title {
  if (_title is EqualUnmodifiableMapView) return _title;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_title);
}

 final  Map<String, String> _body;
@override@JsonKey() Map<String, String> get body {
  if (_body is EqualUnmodifiableMapView) return _body;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_body);
}


/// Create a copy of DestinationTip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DestinationTipCopyWith<_DestinationTip> get copyWith => __$DestinationTipCopyWithImpl<_DestinationTip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DestinationTipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DestinationTip&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._title, _title)&&const DeepCollectionEquality().equals(other._body, _body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,const DeepCollectionEquality().hash(_title),const DeepCollectionEquality().hash(_body));

@override
String toString() {
  return 'DestinationTip(icon: $icon, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$DestinationTipCopyWith<$Res> implements $DestinationTipCopyWith<$Res> {
  factory _$DestinationTipCopyWith(_DestinationTip value, $Res Function(_DestinationTip) _then) = __$DestinationTipCopyWithImpl;
@override @useResult
$Res call({
 String icon, Map<String, String> title, Map<String, String> body
});




}
/// @nodoc
class __$DestinationTipCopyWithImpl<$Res>
    implements _$DestinationTipCopyWith<$Res> {
  __$DestinationTipCopyWithImpl(this._self, this._then);

  final _DestinationTip _self;
  final $Res Function(_DestinationTip) _then;

/// Create a copy of DestinationTip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? title = null,Object? body = null,}) {
  return _then(_DestinationTip(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self._title : title // ignore: cast_nullable_to_non_nullable
as Map<String, String>,body: null == body ? _self._body : body // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
