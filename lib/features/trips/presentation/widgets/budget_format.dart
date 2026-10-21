import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/ventus_icon.dart';
import '../../domain/expense_category.dart';

/// The icon for an expense category (prototype `Budget.jsx` → CATS icons).
String expenseCategoryIcon(ExpenseCategory category) => switch (category) {
  ExpenseCategory.stay => VentusIcons.bed,
  ExpenseCategory.food => VentusIcons.cup,
  ExpenseCategory.sight => VentusIcons.ticket,
  ExpenseCategory.transport => VentusIcons.car,
  ExpenseCategory.other => VentusIcons.cart,
};

/// The accent color for an expense category (matches the design's tokens).
Color expenseCategoryColor(ExpenseCategory category, AppColors colors) =>
    switch (category) {
      ExpenseCategory.stay => colors.primary,
      ExpenseCategory.food => colors.sea,
      ExpenseCategory.sight => colors.amber,
      ExpenseCategory.transport => colors.success,
      ExpenseCategory.other => colors.muted,
    };

/// Localized category name.
String expenseCategoryLabel(AppLocalizations l10n, ExpenseCategory category) =>
    switch (category) {
      ExpenseCategory.stay => l10n.expCatStay,
      ExpenseCategory.food => l10n.expCatFood,
      ExpenseCategory.sight => l10n.expCatSight,
      ExpenseCategory.transport => l10n.expCatTransport,
      ExpenseCategory.other => l10n.expCatOther,
    };

/// Symbol for a currency code, falling back to the code itself.
String currencySymbol(String currency) => switch (currency.toUpperCase()) {
  'USD' => '\$',
  'EUR' => '€',
  'GBP' => '£',
  'TRY' => '₺',
  'AZN' => '₼',
  'AED' => 'AED ',
  'RUB' => '₽',
  'JPY' => '¥',
  _ => '$currency ',
};

/// The currencies offered in the budget editor.
const budgetCurrencies = ['USD', 'EUR', 'GBP', 'TRY', 'AZN', 'AED'];

/// Formats [amount] in [currency] with thousands grouping and no trailing
/// zeros (e.g. `$1,200`, `₼780.5`).
String formatMoney(double amount, String currency) {
  final number = NumberFormat('#,##0.##').format(amount);
  return '${currencySymbol(currency)}$number';
}
