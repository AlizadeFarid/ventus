import 'dart:typed_data';

import 'document.dart';

/// Contract for a trip's documents, independent of any backend.
///
/// Local-first like the other trip modules: metadata is read from on-device
/// Drift (so the list works offline) and mirrored to Supabase when configured.
/// The file *binaries*, however, live only in the private `trip-docs` Storage
/// bucket — so [upload], [fileBytes] and [signedUrl] require a configured
/// backend and otherwise no-op / return null.
abstract interface class DocumentsRepository {
  /// Streams a trip's documents (newest first), re-emitting on any local change.
  Stream<List<TripDocument>> watch(String tripId);

  /// Uploads [bytes] to Storage at [doc.storagePath], then saves [doc]'s
  /// metadata locally and to the remote.
  Future<void> upload(TripDocument doc, Uint8List bytes, {String? contentType});

  /// Updates a document's metadata only (rename / retype / relink day).
  Future<void> update(TripDocument doc);

  /// Deletes the Storage object then the metadata, locally and on the remote.
  Future<void> delete(TripDocument doc);

  /// Pulls a trip's remote documents into local storage. No-op without a
  /// configured backend.
  Future<void> syncTrip(String tripId);

  /// Downloads the file's bytes (for sharing / saving / opening), or null when
  /// there is no backend.
  Future<Uint8List?> fileBytes(TripDocument doc);

  /// A short-lived signed URL to the file (for inline image preview), or null.
  Future<String?> signedUrl(TripDocument doc);
}
