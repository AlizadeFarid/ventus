/// Fixed buckets a checklist item falls into (prototype `Documents.jsx` →
/// Checklist categories). Persisted as the enum name (e.g. `pack`) in the
/// `checklist_items.category` column and JSON; localized for display.
enum ChecklistCategory { beforeYouGo, pack, onArrival }
