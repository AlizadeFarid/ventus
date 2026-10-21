import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_type.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// A single activity-feed entry (prototype `Profile.jsx` → NotificationsFeed).
///
/// Owned by the signed-in user ([userId]); stored local-first in Drift and
/// mirrored to the Supabase `notifications` table. The display [tripTitle] /
/// [subject] are denormalised so the feed renders offline without joins. JSON
/// keys are snake_case to match the Postgres columns; the enum serialises by
/// name. The localized title/body are derived from [kind] + these fields at
/// render time, so they follow the active language.
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    @Default(NotificationType.generic) NotificationType kind,
    @JsonKey(name: 'trip_id') String? tripId,
    @JsonKey(name: 'trip_title') String? tripTitle,

    /// Free-form subject of the event (e.g. the invited email).
    String? subject,
    @Default(false) bool read,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
