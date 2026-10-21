import 'package:freezed_annotation/freezed_annotation.dart';

import 'expense_category.dart';

part 'trip_budget.freezed.dart';
part 'trip_budget.g.dart';

/// A trip's budget setup (prototype `Budget.jsx` → TRIP_TOTAL + CATS allocations):
/// the single [currency], the [total] budget, and how much is allocated to each
/// category. Spending is computed from [Expense]s, not stored here.
///
/// One row per trip (keyed by [tripId]). Stored local-first in Drift and
/// mirrored to the Supabase `trip_budgets` table; [allocations] is a JSONB map of
/// category name -> amount.
@freezed
abstract class TripBudget with _$TripBudget {
  const factory TripBudget({
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'user_id') String? userId,
    @Default('USD') String currency,
    @Default(0) double total,
    @Default(<String, double>{}) Map<String, double> allocations,
  }) = _TripBudget;

  const TripBudget._();

  factory TripBudget.fromJson(Map<String, dynamic> json) =>
      _$TripBudgetFromJson(json);

  /// The amount allocated to [category] (0 when none set).
  double allocationFor(ExpenseCategory category) =>
      allocations[category.name] ?? 0;

  /// The sum of all category allocations.
  double get allocatedTotal =>
      allocations.values.fold(0, (sum, value) => sum + value);
}
