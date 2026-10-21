import 'collaborator.dart';

/// Contract for a trip's collaborators storage, independent of any backend.
///
/// Local-first like the other trip sub-features: rows are read from on-device
/// Drift (so the list works offline) and mirrored to Supabase when configured.
abstract interface class CollaboratorsRepository {
  /// Streams a trip's collaborators (newest first), re-emitting on any change.
  Stream<List<Collaborator>> watch(String tripId);

  /// Inserts or updates [collaborator] locally, then pushes to the remote.
  /// Also used to change a collaborator's role.
  Future<void> save(Collaborator collaborator);

  /// Removes a collaborator locally, then on the remote (if any).
  Future<void> remove(String id);

  Future<void> syncTrip(String tripId);

  /// Accepts an invitation for the given trip.
  Future<void> acceptInvite(String tripId);
}
