/// The kind of file a trip document is (prototype `Documents.jsx` → doc types).
/// Drives the grouped list, the colored thumbnail and the type badge. Persisted
/// as the enum name (e.g. `ticket`) in the `documents.type` column and JSON;
/// localized for display.
enum DocumentType { ticket, stay, id, other }
