import 'expense.dart';
import 'trip_budget.dart';

/// Contract for a trip's budget setup and expenses, independent of any backend.
///
/// Local-first like the other trip modules: everything is read from on-device
/// Drift (so the budget works offline) and mirrored to Supabase when configured.
abstract interface class BudgetRepository {
  /// Streams a trip's budget setup, or null when none has been saved yet.
  Stream<TripBudget?> watchBudget(String tripId);

  /// Inserts or updates a trip's budget setup (currency / total / allocations).
  Future<void> saveBudget(TripBudget budget);

  /// Streams a trip's expenses (newest first), re-emitting on any local change.
  Stream<List<Expense>> watchExpenses(String tripId);

  /// Inserts or updates an expense locally, then on the remote (if any).
  Future<void> saveExpense(Expense expense);

  /// Deletes an expense locally, then on the remote (if any).
  Future<void> deleteExpense(String id);

  /// Pulls a trip's remote budget + expenses into local storage. No-op without
  /// a configured backend.
  Future<void> syncTrip(String tripId);
}
