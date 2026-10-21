import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/expense.dart';
import '../domain/trip_budget.dart';

/// Thin Supabase wrapper for a trip's budget setup (`trip_budgets`) and its
/// `expenses`. All reads/writes are scoped to the signed-in user; row-level
/// security enforces the same boundary. Errors propagate to the caller, so the
/// local-first Drift copy stays authoritative even if a push fails.
class SupabaseBudgetRemote {
  static const _budgets = 'trip_budgets';
  static const _expenses = 'expenses';

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  Future<TripBudget?> fetchBudget(String tripId) async {
    final uid = _userId;
    if (uid == null) return null;
    final row = await _client
        .from(_budgets)
        .select()
        .eq('trip_id', tripId)
        .maybeSingle();
    return row == null ? null : TripBudget.fromJson(row);
  }

  Future<void> upsertBudget(TripBudget budget) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_budgets).upsert({
      ...budget.toJson(),
      if (budget.userId == null) 'user_id': uid,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Expense>> fetchExpenses(String tripId) async {
    final uid = _userId;
    if (uid == null) return const [];
    final rows = await _client.from(_expenses).select().eq('trip_id', tripId);
    return rows.map(Expense.fromJson).toList();
  }

  Future<void> upsertExpense(Expense expense) async {
    final uid = _userId;
    if (uid == null) return;
    await _client.from(_expenses).upsert({
      ...expense.toJson(),
      if (expense.userId == null) 'user_id': uid,
    });
  }

  Future<void> deleteExpense(String id) async {
    if (_userId == null) return;
    await _client.from(_expenses).delete().eq('id', id);
  }
}
