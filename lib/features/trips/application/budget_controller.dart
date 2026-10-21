import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/expense.dart';
import '../domain/trip_budget.dart';
import 'budget_providers.dart';

/// Drives budget write actions (save budget / add-edit-delete expense) and
/// exposes their loading + error state. Reads stay reactive through
/// [tripBudgetProvider] / [expensesProvider]; this only owns the mutations.
class BudgetController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> saveBudget(TripBudget budget) =>
      _run(() => ref.read(budgetRepositoryProvider).saveBudget(budget));

  Future<bool> saveExpense(Expense expense) =>
      _run(() => ref.read(budgetRepositoryProvider).saveExpense(expense));

  Future<bool> deleteExpense(String id) =>
      _run(() => ref.read(budgetRepositoryProvider).deleteExpense(id));

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final budgetControllerProvider = AsyncNotifierProvider<BudgetController, void>(
  BudgetController.new,
);
