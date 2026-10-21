/// A collaborator's permission level on a trip (prototype `Profile.jsx`).
///
/// The trip owner is implicit (derived from the trip, never stored as a
/// collaborator), so only the two grantable roles live here.
enum CollaboratorRole {
  /// Can add & edit itinerary, budget, documents.
  editor,

  /// Can view the trip but not make changes.
  viewer,
}

/// Whether an invite has been accepted. Phase 1 has no acceptance flow, so new
/// invites stay [pending]; [active] is reserved for when real sharing lands.
enum CollaboratorStatus { pending, active }

/// Parses a stored role name, defaulting to the least-privileged [viewer].
CollaboratorRole collaboratorRoleFromName(String? name) {
  for (final role in CollaboratorRole.values) {
    if (role.name == name) return role;
  }
  return CollaboratorRole.viewer;
}

/// Parses a stored status name, defaulting to [CollaboratorStatus.pending].
CollaboratorStatus collaboratorStatusFromName(String? name) {
  for (final status in CollaboratorStatus.values) {
    if (status.name == name) return status;
  }
  return CollaboratorStatus.pending;
}
