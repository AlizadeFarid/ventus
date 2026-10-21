import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/drift_documents_repository.dart';
import '../data/supabase_documents_remote.dart';
import '../domain/document.dart';
import '../domain/documents_repository.dart';
import 'trips_providers.dart';

/// Binds [DocumentsRepository] to the local-first Drift implementation, sharing
/// the app database with the other trip repositories and attaching a Supabase
/// remote (table + private Storage bucket) only when the backend is configured.
final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseDocumentsRemote() : null;
  return DriftDocumentsRepository(db, remote: remote);
});

/// Pulls a trip's remote document metadata into Drift once, when first shown.
final documentsSyncProvider = FutureProvider.autoDispose.family<void, String>((
  ref,
  tripId,
) {
  return ref.watch(documentsRepositoryProvider).syncTrip(tripId);
});

/// Live list of a trip's documents (newest first), backed by Drift.
final documentsProvider = StreamProvider.autoDispose
    .family<List<TripDocument>, String>((ref, tripId) {
      return ref.watch(documentsRepositoryProvider).watch(tripId);
    });

/// A short-lived signed URL to a document's file, for inline image preview.
/// Null offline / when there's no configured backend.
final documentSignedUrlProvider = FutureProvider.autoDispose
    .family<String?, TripDocument>((ref, doc) {
      return ref.watch(documentsRepositoryProvider).signedUrl(doc);
    });
