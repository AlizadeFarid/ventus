// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripDocument {

 String get id;@JsonKey(name: 'trip_id') String get tripId;@JsonKey(name: 'user_id') String? get userId;/// Display name (defaults to the picked file name, editable).
 String get name; DocumentType get type;/// Object path inside the `trip-docs` bucket, e.g. `{userId}/{tripId}/{id}.pdf`.
@JsonKey(name: 'storage_path') String get storagePath;/// Uppercase extension label for the thumbnail (e.g. `PDF`, `JPG`).
 String? get ext;@JsonKey(name: 'mime_type') String? get mimeType;/// File size in bytes, for the "0.4 MB" meta line.
@JsonKey(name: 'size_bytes') int? get sizeBytes;/// Optional link to a 1-based itinerary day; null = trip-wide.
 int? get day;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of TripDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripDocumentCopyWith<TripDocument> get copyWith => _$TripDocumentCopyWithImpl<TripDocument>(this as TripDocument, _$identity);

  /// Serializes this TripDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.day, day) || other.day == day)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,userId,name,type,storagePath,ext,mimeType,sizeBytes,day,createdAt);

@override
String toString() {
  return 'TripDocument(id: $id, tripId: $tripId, userId: $userId, name: $name, type: $type, storagePath: $storagePath, ext: $ext, mimeType: $mimeType, sizeBytes: $sizeBytes, day: $day, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TripDocumentCopyWith<$Res>  {
  factory $TripDocumentCopyWith(TripDocument value, $Res Function(TripDocument) _then) = _$TripDocumentCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, String name, DocumentType type,@JsonKey(name: 'storage_path') String storagePath, String? ext,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'size_bytes') int? sizeBytes, int? day,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$TripDocumentCopyWithImpl<$Res>
    implements $TripDocumentCopyWith<$Res> {
  _$TripDocumentCopyWithImpl(this._self, this._then);

  final TripDocument _self;
  final $Res Function(TripDocument) _then;

/// Create a copy of TripDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = null,Object? userId = freezed,Object? name = null,Object? type = null,Object? storagePath = null,Object? ext = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? day = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TripDocument].
extension TripDocumentPatterns on TripDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripDocument value)  $default,){
final _that = this;
switch (_that) {
case _TripDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripDocument value)?  $default,){
final _that = this;
switch (_that) {
case _TripDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String name,  DocumentType type, @JsonKey(name: 'storage_path')  String storagePath,  String? ext, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes,  int? day, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripDocument() when $default != null:
return $default(_that.id,_that.tripId,_that.userId,_that.name,_that.type,_that.storagePath,_that.ext,_that.mimeType,_that.sizeBytes,_that.day,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String name,  DocumentType type, @JsonKey(name: 'storage_path')  String storagePath,  String? ext, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes,  int? day, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TripDocument():
return $default(_that.id,_that.tripId,_that.userId,_that.name,_that.type,_that.storagePath,_that.ext,_that.mimeType,_that.sizeBytes,_that.day,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'trip_id')  String tripId, @JsonKey(name: 'user_id')  String? userId,  String name,  DocumentType type, @JsonKey(name: 'storage_path')  String storagePath,  String? ext, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes,  int? day, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TripDocument() when $default != null:
return $default(_that.id,_that.tripId,_that.userId,_that.name,_that.type,_that.storagePath,_that.ext,_that.mimeType,_that.sizeBytes,_that.day,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripDocument extends TripDocument {
  const _TripDocument({required this.id, @JsonKey(name: 'trip_id') required this.tripId, @JsonKey(name: 'user_id') this.userId, required this.name, this.type = DocumentType.other, @JsonKey(name: 'storage_path') required this.storagePath, this.ext, @JsonKey(name: 'mime_type') this.mimeType, @JsonKey(name: 'size_bytes') this.sizeBytes, this.day, @JsonKey(name: 'created_at') required this.createdAt}): super._();
  factory _TripDocument.fromJson(Map<String, dynamic> json) => _$TripDocumentFromJson(json);

@override final  String id;
@override@JsonKey(name: 'trip_id') final  String tripId;
@override@JsonKey(name: 'user_id') final  String? userId;
/// Display name (defaults to the picked file name, editable).
@override final  String name;
@override@JsonKey() final  DocumentType type;
/// Object path inside the `trip-docs` bucket, e.g. `{userId}/{tripId}/{id}.pdf`.
@override@JsonKey(name: 'storage_path') final  String storagePath;
/// Uppercase extension label for the thumbnail (e.g. `PDF`, `JPG`).
@override final  String? ext;
@override@JsonKey(name: 'mime_type') final  String? mimeType;
/// File size in bytes, for the "0.4 MB" meta line.
@override@JsonKey(name: 'size_bytes') final  int? sizeBytes;
/// Optional link to a 1-based itinerary day; null = trip-wide.
@override final  int? day;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of TripDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripDocumentCopyWith<_TripDocument> get copyWith => __$TripDocumentCopyWithImpl<_TripDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.day, day) || other.day == day)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,userId,name,type,storagePath,ext,mimeType,sizeBytes,day,createdAt);

@override
String toString() {
  return 'TripDocument(id: $id, tripId: $tripId, userId: $userId, name: $name, type: $type, storagePath: $storagePath, ext: $ext, mimeType: $mimeType, sizeBytes: $sizeBytes, day: $day, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TripDocumentCopyWith<$Res> implements $TripDocumentCopyWith<$Res> {
  factory _$TripDocumentCopyWith(_TripDocument value, $Res Function(_TripDocument) _then) = __$TripDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'trip_id') String tripId,@JsonKey(name: 'user_id') String? userId, String name, DocumentType type,@JsonKey(name: 'storage_path') String storagePath, String? ext,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'size_bytes') int? sizeBytes, int? day,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$TripDocumentCopyWithImpl<$Res>
    implements _$TripDocumentCopyWith<$Res> {
  __$TripDocumentCopyWithImpl(this._self, this._then);

  final _TripDocument _self;
  final $Res Function(_TripDocument) _then;

/// Create a copy of TripDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = null,Object? userId = freezed,Object? name = null,Object? type = null,Object? storagePath = null,Object? ext = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? day = freezed,Object? createdAt = null,}) {
  return _then(_TripDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
