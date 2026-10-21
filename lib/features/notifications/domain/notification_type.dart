/// The kind of activity a notification represents, which drives its icon,
/// colour and localized copy in the feed.
///
/// Only kinds that have a real producer wired today are listed. Future
/// producers (weather changes, document-expiry checks, checklist reminders…)
/// add their own value here when the event actually starts being emitted —
/// we deliberately don't ship dead kinds with no source.
enum NotificationType {
  /// A friendly first-run greeting, emitted once when an account is created.
  welcome,

  /// Someone was invited to co-plan a trip.
  collaboratorInvited,

  /// Ventus AI finished drafting a trip's day-by-day plan.
  aiPlanReady,

  /// Fallback for an unknown / future kind read from storage.
  generic,
}

/// Parses a stored enum name back to a [NotificationType], tolerating unknown
/// values (e.g. a newer producer synced from another device) as [generic].
NotificationType notificationTypeFromName(String name) => NotificationType
    .values
    .firstWhere((t) => t.name == name, orElse: () => NotificationType.generic);
