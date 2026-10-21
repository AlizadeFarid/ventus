import '../../../core/storage/app_storage.dart';
import '../../../core/utils/id.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/checklist_category.dart';
import '../domain/checklist_item.dart';

/// The starter checklist seeded into every new trip so it's useful out of the
/// box instead of empty. These are plain [ChecklistItem]s — once created the
/// user can tick, rename, delete or add to them like any other item.
///
/// Kept client-side and localized (rather than fetched from the backend): trip
/// creation must work offline, and a starter template rarely changes — see the
/// note in the Checklist feature for when a remote template would be worth it.
List<ChecklistItem> defaultChecklistItems({
  required String tripId,
  required AppLocalizations l10n,
}) {
  final groups = <ChecklistCategory, List<String>>{
    ChecklistCategory.beforeYouGo: [
      l10n.defChkVisa,
      l10n.defChkInsurance,
      l10n.defChkCheckin,
      l10n.defChkCash,
    ],
    ChecklistCategory.pack: [
      l10n.defChkPassport,
      l10n.defChkTickets,
      l10n.defChkId,
      l10n.defChkCharger,
    ],
    ChecklistCategory.onArrival: [
      l10n.defChkSim,
      l10n.defChkHotel,
      l10n.defChkTransport,
    ],
  };

  final now = DateTime.now();
  final userId = AppStorage.currentUserId;
  final items = <ChecklistItem>[];
  var position = 0;
  groups.forEach((category, titles) {
    for (final title in titles) {
      items.add(
        ChecklistItem(
          id: newId(),
          tripId: tripId,
          userId: userId,
          title: title,
          category: category,
          position: position,
          // Nudge createdAt per item so the insertion order is stable.
          createdAt: now.add(Duration(milliseconds: position)),
        ),
      );
      position++;
    }
  });
  return items;
}
