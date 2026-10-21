import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/budget_repository.dart';
import '../domain/expense.dart';
import '../domain/expense_category.dart';
import '../domain/trip_budget.dart';
import 'supabase_budget_remote.dart';

/// Local-first [BudgetRepository]: Drift is the source of truth the UI reads
/// from, so the budget works offline. Writes hit Drift first (instant,
/// reactive) then the remote; [syncTrip] pulls remote changes back into Drift.
class DriftBudgetRepository implements BudgetRepository {
  DriftBudgetRepository(this._db, {SupabaseBudgetRemote? remote})
    : _remote = remote;

  final AppDatabase _db;
  final SupabaseBudgetRemote? _remote;

  /// Keys used in [AppDatabase.markPendingSync] et al. — budgets and expenses
  /// are tracked separately since they're independent tables.
  static const _budgetTable = 'trip_budgets';
  static const _expenseTable = 'expenses';

  @override
  Stream<TripBudget?> watchBudget(String tripId) {
    final query = _db.select(_db.tripBudgets)
      ..where((b) => b.tripId.equals(tripId));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _budgetToDomain(row),
    );
  }

  @override
  Future<void> saveBudget(TripBudget budget) async {
    await _db.transaction(() async {
      await _db
          .into(_db.tripBudgets)
          .insertOnConflictUpdate(_budgetToCompanion(budget));
      await _db.markPendingSync(_budgetTable, budget.tripId);
    });
    if (_remote == null) return;
    await _remote.upsertBudget(budget);
    await _db.clearPendingSync(_budgetTable, budget.tripId);
  }

  @override
  Stream<List<Expense>> watchExpenses(String tripId) {
    final query = _db.select(_db.expenses)
      ..where((e) => e.tripId.equals(tripId))
      ..orderBy([(e) => OrderingTerm.desc(e.createdAt)]);
    return query.watch().map((rows) => rows.map(_expenseToDomain).toList());
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    await _db.transaction(() async {
      await _db
          .into(_db.expenses)
          .insertOnConflictUpdate(_expenseToCompanion(expense));
      await _db.markPendingSync(_expenseTable, expense.id);
    });
    if (_remote == null) return;
    await _remote.upsertExpense(expense);
    await _db.clearPendingSync(_expenseTable, expense.id);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();
    await _remote?.deleteExpense(id);
    await _db.clearPendingSync(_expenseTable, id);
  }

  @override
  Future<void> syncTrip(String tripId) async {
    final remote = _remote;
    if (remote == null) return;
    // Fetch first; if the network fails this throws before we touch local data,
    // so an offline open keeps the existing local copy intact.
    final budget = await remote.fetchBudget(tripId);
    final expenses = await remote.fetchExpenses(tripId);
    // Rows with unpushed local changes are never wiped/overwritten here.
    final pendingBudgetIds = await _db.pendingSyncIds(_budgetTable);
    final pendingExpenseIds = await _db.pendingSyncIds(_expenseTable);
    final budgetIsPending = pendingBudgetIds.contains(tripId);
    final serverExpenses = expenses
        .where((e) => !pendingExpenseIds.contains(e.id))
        .toList();

    await _db.transaction(() async {
      if (!budgetIsPending) {
        await (_db.delete(
          _db.tripBudgets,
        )..where((b) => b.tripId.equals(tripId))).go();
        if (budget != null) {
          await _db.into(_db.tripBudgets).insert(_budgetToCompanion(budget));
        }
      }
      if (pendingExpenseIds.isEmpty) {
        await (_db.delete(
          _db.expenses,
        )..where((e) => e.tripId.equals(tripId))).go();
      } else {
        await (_db.delete(_db.expenses)..where(
              (e) => e.tripId.equals(tripId) & e.id.isNotIn(pendingExpenseIds),
            ))
            .go();
      }
      await _db.batch((batch) {
        batch.insertAll(
          _db.expenses,
          serverExpenses.map(_expenseToCompanion).toList(),
        );
      });
    });
  }
}

TripBudget _budgetToDomain(TripBudgetRow row) => TripBudget(
  tripId: row.tripId,
  currency: row.currency,
  total: row.total,
  allocations: _decodeAllocations(row.allocations),
);

TripBudgetsCompanion _budgetToCompanion(TripBudget budget) =>
    TripBudgetsCompanion.insert(
      tripId: budget.tripId,
      currency: Value(budget.currency),
      total: Value(budget.total),
      allocations: Value(jsonEncode(budget.allocations)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

Expense _expenseToDomain(ExpenseRow row) => Expense(
  id: row.id,
  tripId: row.tripId,
  category: _categoryFromName(row.category),
  amount: row.amount,
  note: row.note,
  day: row.day,
  createdAt: row.createdAt,
);

ExpensesCompanion _expenseToCompanion(Expense e) => ExpensesCompanion.insert(
  id: e.id,
  tripId: e.tripId,
  category: Value(e.category.name),
  amount: Value(e.amount),
  note: Value(e.note),
  day: Value(e.day),
  createdAt: e.createdAt,
);

Map<String, double> _decodeAllocations(String raw) {
  try {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
  } catch (_) {
    return const {};
  }
}

ExpenseCategory _categoryFromName(String? name) {
  for (final category in ExpenseCategory.values) {
    if (category.name == name) return category;
  }
  return ExpenseCategory.other;
}
