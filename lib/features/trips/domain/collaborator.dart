import 'package:freezed_annotation/freezed_annotation.dart';

import 'collaborator_role.dart';

part 'collaborator.freezed.dart';
part 'collaborator.g.dart';

/// A person invited to co-plan a trip (prototype `Profile.jsx` → Collaborators).
///
/// Belongs to a trip via [tripId]; [userId] is the trip **owner** (who created
/// the invite), used for owner-scoped storage/RLS. Stored local-first in Drift
/// and mirrored to the Supabase `trip_collaborators` table; JSON keys are
/// snake_case to match the Postgres columns. Enums serialize by name.
@freezed
abstract class Collaborator with _$Collaborator {
  const factory Collaborator({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'user_id') String? userId,
    required String email,
    String? name,
    @Default(CollaboratorRole.viewer) CollaboratorRole role,
    @Default(CollaboratorStatus.pending) CollaboratorStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Collaborator;

  factory Collaborator.fromJson(Map<String, dynamic> json) =>
      _$CollaboratorFromJson(json);
}
