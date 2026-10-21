import 'package:freezed_annotation/freezed_annotation.dart';

import 'checklist_category.dart';

part 'checklist_item.freezed.dart';
part 'checklist_item.g.dart';

/// A single to-do on a trip's checklist (prototype `TripHub.jsx` → CheckRow):
/// pack/prepare items the traveler ticks off.
///
/// Belongs to a trip via [tripId], ordered by [position]. Stored local-first in
/// Drift and mirrored to the Supabase `checklist_items` table; JSON keys are
/// snake_case to match the Postgres columns.
@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'user_id') String? userId,
    required String title,
    @Default(false) bool done,
    @Default(ChecklistCategory.beforeYouGo) ChecklistCategory category,

    /// Optional reminder date (date-only). Shown as an amber "Do by …" badge;
    /// no OS notification yet.
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @Default(0) int position,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);
}
