/// The bucket a trip expense falls into (prototype `Budget.jsx` → CATS).
/// Drives the colored icon, the category breakdown and allocations. Persisted as
/// the enum name (e.g. `food`) in the `expenses.category` column and as the keys
/// of the budget's allocations map; localized for display.
enum ExpenseCategory { stay, food, sight, transport, other }
