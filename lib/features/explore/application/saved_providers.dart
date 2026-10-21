import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../trips/application/trips_providers.dart' show appDatabaseProvider;
import '../data/drift_saved_places_repository.dart';
import '../data/supabase_saved_places_remote.dart';
import '../domain/saved_place.dart';
import '../domain/saved_places_repository.dart';

/// Local-first saved-places repository, sharing the app database and attaching a
/// Supabase remote only when the backend is configured.
final savedPlacesRepositoryProvider = Provider<SavedPlacesRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseSavedPlacesRemote() : null;
  return DriftSavedPlacesRepository(db, remote: remote);
});

/// Pulls remote saves into Drift once.
final savedSyncProvider = FutureProvider<void>((ref) {
  return ref.watch(savedPlacesRepositoryProvider).sync();
});

/// Live list of saved places (newest first).
final savedPlacesProvider = StreamProvider<List<SavedPlace>>((ref) {
  return ref.watch(savedPlacesRepositoryProvider).watch();
});

/// The set of saved destination ids, for quick "is this saved?" checks.
final savedIdsProvider = Provider<Set<String>>((ref) {
  final saved = ref.watch(savedPlacesProvider).asData?.value ?? const [];
  return {for (final p in saved) p.destinationId};
});
