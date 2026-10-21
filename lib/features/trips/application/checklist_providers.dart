import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/drift_checklist_repository.dart';
import '../data/supabase_checklist_remote.dart';
import '../domain/checklist_item.dart';
import '../domain/checklist_repository.dart';
import 'trips_providers.dart';

/// Binds [ChecklistRepository] to the local-first Drift implementation, sharing
/// the app database with the other trip repositories and attaching a Supabase
/// remote only when the backend is configured.
final checklistRepositoryProvider = Provider<ChecklistRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseChecklistRemote() : null;
  return DriftChecklistRepository(db, remote: remote);
});

/// Pulls a trip's remote checklist into Drift once, when it's first shown.
final checklistSyncProvider = FutureProvider.autoDispose.family<void, String>((
  ref,
  tripId,
) {
  return ref.watch(checklistRepositoryProvider).syncTrip(tripId);
});

/// Live list of a trip's checklist items (ordered), backed by Drift.
final checklistProvider = StreamProvider.autoDispose
    .family<List<ChecklistItem>, String>((ref, tripId) {
      return ref.watch(checklistRepositoryProvider).watch(tripId);
    });
