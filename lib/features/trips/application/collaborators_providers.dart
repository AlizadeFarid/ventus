import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/drift_collaborators_repository.dart';
import '../data/supabase_collaborators_remote.dart';
import '../domain/collaborator.dart';
import '../domain/collaborators_repository.dart';
import 'trips_providers.dart';

/// Binds [CollaboratorsRepository] to the local-first Drift implementation,
/// sharing the app database with the other trip repositories and attaching a
/// Supabase remote only when the backend is configured.
final collaboratorsRepositoryProvider = Provider<CollaboratorsRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseCollaboratorsRemote() : null;
  return DriftCollaboratorsRepository(db, remote: remote);
});

/// Pulls a trip's remote collaborators into Drift once, when first shown.
final collaboratorsSyncProvider = FutureProvider.autoDispose
    .family<void, String>((ref, tripId) {
      return ref.watch(collaboratorsRepositoryProvider).syncTrip(tripId);
    });

/// Live list of a trip's collaborators, backed by Drift.
final collaboratorsProvider = StreamProvider.autoDispose
    .family<List<Collaborator>, String>((ref, tripId) {
      return ref.watch(collaboratorsRepositoryProvider).watch(tripId);
    });
