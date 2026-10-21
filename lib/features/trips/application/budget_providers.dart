import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/drift_budget_repository.dart';
import '../data/supabase_budget_remote.dart';
import '../domain/budget_repository.dart';
import '../domain/expense.dart';
import '../domain/trip_budget.dart';
import 'trips_providers.dart';

/// Binds [BudgetRepository] to the local-first Drift implementation, sharing the
/// app database with the other trip repositories and attaching a Supabase remote
/// only when the backend is configured.
final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final remote = Env.isConfigured ? SupabaseBudgetRemote() : null;
  return DriftBudgetRepository(db, remote: remote);
});

/// Pulls a trip's remote budget + expenses into Drift once, when first shown.
final budgetSyncProvider = FutureProvider.autoDispose.family<void, String>((
  ref,
  tripId,
) {
  return ref.watch(budgetRepositoryProvider).syncTrip(tripId);
});

/// Live budget setup for a trip (null until one is saved), backed by Drift.
final tripBudgetProvider = StreamProvider.autoDispose
    .family<TripBudget?, String>((ref, tripId) {
      return ref.watch(budgetRepositoryProvider).watchBudget(tripId);
    });

/// Live list of a trip's expenses (newest first), backed by Drift.
final expensesProvider = StreamProvider.autoDispose
    .family<List<Expense>, String>((ref, tripId) {
      return ref.watch(budgetRepositoryProvider).watchExpenses(tripId);
    });
