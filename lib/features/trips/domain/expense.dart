import 'package:freezed_annotation/freezed_annotation.dart';

import 'expense_category.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// A single logged spend on a trip (prototype `Budget.jsx` → ExpenseRow), in the
/// trip's single currency.
///
/// Belongs to a trip via [tripId], optionally to a 1-based itinerary [day].
/// Stored local-first in Drift and mirrored to the Supabase `expenses` table;
/// JSON keys are snake_case to match the Postgres columns.
@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'user_id') String? userId,
    @Default(ExpenseCategory.other) ExpenseCategory category,

    /// Amount in the trip's currency (see [TripBudget.currency]).
    @Default(0) double amount,
    String? note,

    /// Optional link to a 1-based itinerary day; null = unassigned.
    int? day,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
