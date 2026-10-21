import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_type.dart';

part 'document.freezed.dart';
part 'document.g.dart';

/// A user-uploaded file attached to a trip (prototype `Documents.jsx` → DOCS):
/// tickets, vouchers, IDs, policies. The binary lives in the private `trip-docs`
/// Storage bucket at [storagePath]; this is the metadata.
///
/// Belongs to a trip via [tripId]. Stored local-first in Drift (so the list
/// works offline) and mirrored to the Supabase `documents` table; JSON keys are
/// snake_case to match the Postgres columns. The class is named `TripDocument`
/// to avoid clashing with Flutter's own `Document` types.
@freezed
abstract class TripDocument with _$TripDocument {
  const factory TripDocument({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'user_id') String? userId,

    /// Display name (defaults to the picked file name, editable).
    required String name,
    @Default(DocumentType.other) DocumentType type,

    /// Object path inside the `trip-docs` bucket, e.g. `{userId}/{tripId}/{id}.pdf`.
    @JsonKey(name: 'storage_path') required String storagePath,

    /// Uppercase extension label for the thumbnail (e.g. `PDF`, `JPG`).
    String? ext,
    @JsonKey(name: 'mime_type') String? mimeType,

    /// File size in bytes, for the "0.4 MB" meta line.
    @JsonKey(name: 'size_bytes') int? sizeBytes,

    /// Optional link to a 1-based itinerary day; null = trip-wide.
    int? day,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TripDocument;

  const TripDocument._();

  factory TripDocument.fromJson(Map<String, dynamic> json) =>
      _$TripDocumentFromJson(json);

  /// True for image files we can preview inline (vs. open externally).
  bool get isImage =>
      (mimeType?.startsWith('image/') ?? false) ||
      const {
        'JPG',
        'JPEG',
        'PNG',
        'GIF',
        'WEBP',
        'HEIC',
      }.contains((ext ?? '').toUpperCase());
}
