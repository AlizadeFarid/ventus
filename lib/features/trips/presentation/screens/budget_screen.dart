import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/preferences/preferred_currency_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/id.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/budget_controller.dart';
import '../../application/budget_providers.dart';
import '../../application/trip_detail_providers.dart';
import '../../domain/expense.dart';
import '../../domain/expense_category.dart';
import '../../domain/trip.dart';
import '../../domain/trip_budget.dart';
import '../widgets/budget_format.dart';
import '../widgets/module_header_row.dart';
import 'itinerary_screen.dart' show dayDate;
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Opens the add/edit-expense sheet. Exposed so the Trip Hub's Büdcə-tab FAB
/// can trigger it directly, the same way [BudgetBody] does internally.
Future<void> openAddExpenseSheet(
  BuildContext context, {
  required String tripId,
  required Trip? trip,
  required String currency,
  Expense? existing,
}) {
  return showVentusSheet<void>(
    context,
    builder: (_) => _AddExpenseSheet(
      tripId: tripId,
      trip: trip,
      currency: currency,
      existing: existing,
    ),
  );
}

/// Budget tab content — a "remaining" hero with a stacked spend bar, the
/// per-category breakdown, and expenses grouped by day, plus add-expense and
/// edit-budget sheets. Embedded as the Trip Hub's "Büdcə" tab. Prototype
/// `Budget.jsx` → BudgetOverview (bar variant).
class BudgetBody extends ConsumerWidget {
  const BudgetBody({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(budgetSyncProvider(tripId));
    final trip = ref.watch(tripDetailProvider(tripId)).asData?.value;
    final budget = ref.watch(tripBudgetProvider(tripId)).asData?.value;
    final expenses =
        ref.watch(expensesProvider(tripId)).asData?.value ?? const <Expense>[];
    final colors = context.colors;
    final l10n = context.l10n;

    final String currency =
        budget?.currency ?? ref.watch(preferredCurrencyProvider);
    final spentByCategory = _spentByCategory(expenses);
    final totalSpent = spentByCategory.values.fold<double>(0, (s, v) => s + v);
    final hasBudget = (budget?.total ?? 0) > 0;
    final hasExpenses = expenses.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModuleHeaderRow(
          title: l10n.moduleBudget,
          action: VentusAddButton(
            onTap: () => openAddExpenseSheet(
              context,
              tripId: tripId,
              trip: trip,
              currency: currency,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 4, bottom: 96),
            children: [
              if (hasBudget)
                _RemainHero(
                  budget: budget!,
                  spentByCategory: spentByCategory,
                  totalSpent: totalSpent,
                  onEdit: () => _openEdit(context, trip, budget),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    4,
                    AppSpacing.screen,
                    8,
                  ),
                  child: _SetBudgetCard(
                    onTap: () => _openEdit(context, trip, budget),
                  ),
                ),
              if (hasBudget || hasExpenses) ...[
                VentusSectionHeader(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    4,
                    AppSpacing.screen,
                    12,
                  ),
                  title: l10n.budgetByCategory,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  child: _CategoryBlock(
                    budget: budget,
                    spentByCategory: spentByCategory,
                    currency: currency,
                  ),
                ),
                const SizedBox(height: 22),
              ],
              if (!hasBudget && !hasExpenses)
                // Nothing at all yet: one quiet add row under the "set a
                // budget" card instead of a header over an empty list.
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    4,
                    AppSpacing.screen,
                    0,
                  ),
                  child: VentusAddRow(
                    label: l10n.addExpense,
                    onTap: () => openAddExpenseSheet(
                      context,
                      tripId: tripId,
                      trip: trip,
                      currency: currency,
                    ),
                  ),
                )
              else ...[
                VentusSectionHeader(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    4,
                    AppSpacing.screen,
                    12,
                  ),
                  title: l10n.budgetExpenses,
                ),
                if (hasExpenses)
                  ..._expensesByDay(context, trip, expenses, currency)
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      12,
                    ),
                    child: Text(
                      l10n.emptyExpensesBody,
                      style: context.typography.body.copyWith(
                        fontSize: AppFontSize.body,
                        color: colors.muted,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Map<ExpenseCategory, double> _spentByCategory(List<Expense> expenses) {
    final map = <ExpenseCategory, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  List<Widget> _expensesByDay(
    BuildContext context,
    Trip? trip,
    List<Expense> expenses,
    String currency,
  ) {
    final l10n = context.l10n;
    final lang = context.languageCode;
    // Days present, newest (highest day) first; null-day expenses go last.
    final days = expenses.map((e) => e.day).whereType<int>().toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    final unassigned = expenses.where((e) => e.day == null).toList();

    String dayTitle(int day) {
      final date = dayDate(trip, day);
      return date == null
          ? l10n.docDayShort(day)
          : l10n.docDayWithDate(day, DateFormat.MMMEd(lang).format(date));
    }

    return [
      for (final day in days)
        _DayGroup(
          title: dayTitle(day),
          items: expenses.where((e) => e.day == day).toList(),
          currency: currency,
          onTap: (e) => openAddExpenseSheet(
            context,
            tripId: tripId,
            trip: trip,
            currency: currency,
            existing: e,
          ),
        ),
      if (unassigned.isNotEmpty)
        _DayGroup(
          title: l10n.budgetUnassigned,
          items: unassigned,
          currency: currency,
          onTap: (e) => openAddExpenseSheet(
            context,
            tripId: tripId,
            trip: trip,
            currency: currency,
            existing: e,
          ),
        ),
    ];
  }

  Future<void> _openEdit(BuildContext context, Trip? trip, TripBudget? budget) {
    return showVentusSheet<void>(
      context,
      builder: (_) => _EditBudgetSheet(tripId: tripId, existing: budget),
    );
  }
}

/// Remaining-budget hero with a stacked spend bar (prototype RemainHero).
class _RemainHero extends StatelessWidget {
  const _RemainHero({
    required this.budget,
    required this.spentByCategory,
    required this.totalSpent,
    required this.onEdit,
  });

  final VoidCallback onEdit;
  final TripBudget budget;
  final Map<ExpenseCategory, double> spentByCategory;
  final double totalSpent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final total = budget.total;
    final remaining = total - totalSpent;
    final usedPct = total <= 0
        ? 0
        : (totalSpent / total * 100).round().clamp(0, 100);
    final leftPct = (100 - usedPct).clamp(0, 100);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        8,
        AppSpacing.screen,
        18,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.raised,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.budgetRemaining.toUpperCase(),
                    style: _eyebrow(colors),
                  ),
                ),
                VentusTap(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.10),
                      borderRadius: AppRadius.brFull,
                    ),
                    child: Text(
                      l10n.edit,
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        fontWeight: FontWeight.w700,
                        color: context.primaryFill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              formatMoney(remaining, budget.currency),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSize.display,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
                color: remaining < 0 ? colors.danger : colors.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.budgetOfTotal(formatMoney(total, budget.currency)),
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: colors.muted,
              ),
            ),
            const SizedBox(height: 18),
            _StackedBar(total: total, spentByCategory: spentByCategory),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    l10n.budgetSpentUsed(
                      formatMoney(totalSpent, budget.currency),
                      usedPct,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: colors.ink2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                VentusBadge(
                  label: l10n.budgetLeftPct(leftPct),
                  tone: VentusBadgeTone.success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StackedBar extends StatelessWidget {
  const _StackedBar({required this.total, required this.spentByCategory});

  final double total;
  final Map<ExpenseCategory, double> spentByCategory;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final segments = [
      for (final category in ExpenseCategory.values)
        if ((spentByCategory[category] ?? 0) > 0 && total > 0)
          (
            flex: ((spentByCategory[category]! / total) * 1000).round(),
            color: expenseCategoryColor(category, colors),
          ),
    ];
    final spent = spentByCategory.values.fold<double>(0, (s, v) => s + v);
    final remainderFlex = total <= 0
        ? 1000
        : (((total - spent).clamp(0, total) / total) * 1000).round();

    return ClipRRect(
      borderRadius: AppRadius.brFull,
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            for (final seg in segments)
              Expanded(
                flex: seg.flex,
                child: ColoredBox(color: seg.color),
              ),
            if (remainderFlex > 0)
              Expanded(
                flex: remainderFlex,
                child: ColoredBox(color: colors.surfaceSand),
              ),
          ],
        ),
      ),
    );
  }
}

/// Prompt shown when no budget total is set yet.
class _SetBudgetCard extends StatelessWidget {
  const _SetBudgetCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.primarySoft,
          borderRadius: AppRadius.brLg,
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: AppRadius.brSm,
              ),
              child: VentusIcon(
                VentusIcons.wallet,
                size: 22,
                color: colors.onPrimary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.setBudgetTitle,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.setBudgetBody,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color: colors.ink2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            VentusIcon(
              VentusIcons.chevronRight,
              size: 20,
              color: colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Per-category breakdown card (prototype CategoryBlock).
class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.budget,
    required this.spentByCategory,
    required this.currency,
  });

  final TripBudget? budget;
  final Map<ExpenseCategory, double> spentByCategory;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            for (var i = 0; i < ExpenseCategory.values.length; i++)
              _CatRow(
                category: ExpenseCategory.values[i],
                spent: spentByCategory[ExpenseCategory.values[i]] ?? 0,
                alloc: budget?.allocationFor(ExpenseCategory.values[i]) ?? 0,
                currency: currency,
                last: i == ExpenseCategory.values.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _CatRow extends StatelessWidget {
  const _CatRow({
    required this.category,
    required this.spent,
    required this.alloc,
    required this.currency,
    required this.last,
  });

  final ExpenseCategory category;
  final double spent;
  final double alloc;
  final String currency;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final color = expenseCategoryColor(category, colors);
    final over = alloc > 0 && spent > alloc;
    final fraction = alloc <= 0
        ? (spent > 0 ? 1.0 : 0.0)
        : (spent / alloc).clamp(0.0, 1.0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: VentusLeadIcon(
                  expenseCategoryIcon(category),
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            expenseCategoryLabel(l10n, category),
                            style: TextStyle(
                              fontSize: AppFontSize.sm,
                              fontWeight: FontWeight.w600,
                              color: colors.ink,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: formatMoney(spent, currency),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: over ? colors.danger : colors.ink,
                                ),
                              ),
                              if (alloc > 0)
                                TextSpan(
                                  text: ' / ${formatMoney(alloc, currency)}',
                                  style: TextStyle(color: colors.muted),
                                ),
                            ],
                          ),
                          style: const TextStyle(fontSize: AppFontSize.sm),
                        ),
                      ],
                    ),
                    if (alloc > 0 || spent > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: AppRadius.brFull,
                        child: Container(
                          height: 6,
                          color: colors.surfaceSand,
                          child: AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 420),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.centerLeft,
                            widthFactor: fraction,
                            child: ColoredBox(
                              color: over ? colors.danger : color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last) Container(height: 1, color: colors.line),
      ],
    );
  }
}

/// A day's expenses as a card with a header + subtotal (prototype DayGroup).
class _DayGroup extends StatelessWidget {
  const _DayGroup({
    required this.title,
    required this.items,
    required this.currency,
    required this.onTap,
  });

  final String title;
  final List<Expense> items;
  final String currency;
  final ValueChanged<Expense> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtotal = items.fold<double>(0, (s, e) => s + e.amount);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: context.primaryFill,
                  ),
                ),
                Text(
                  formatMoney(subtotal, currency),
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w700,
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.brLg,
              boxShadow: context.shadows.card,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (var i = 0; i < items.length; i++)
                    _ExpenseRow(
                      expense: items[i],
                      currency: currency,
                      last: i == items.length - 1,
                      onTap: () => onTap(items[i]),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({
    required this.expense,
    required this.currency,
    required this.last,
    required this.onTap,
  });

  final Expense expense;
  final String currency;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final color = expenseCategoryColor(expense.category, colors);
    final label = (expense.note == null || expense.note!.trim().isEmpty)
        ? expenseCategoryLabel(l10n, expense.category)
        : expense.note!;

    return VentusTap(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              children: [
                VentusLeadIcon(
                  expenseCategoryIcon(expense.category),
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
                      if (expense.note != null &&
                          expense.note!.trim().isNotEmpty)
                        Text(
                          expenseCategoryLabel(l10n, expense.category),
                          style: TextStyle(
                            fontSize: AppFontSize.caption,
                            color: colors.muted,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  formatMoney(expense.amount, currency),
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
              ],
            ),
          ),
          if (!last) Container(height: 1, color: colors.line),
        ],
      ),
    );
  }
}

TextStyle _eyebrow(AppColors colors) => TextStyle(
  fontSize: AppFontSize.eyebrow,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.66,
  color: colors.muted,
);

/// Add / edit an expense — amount via a number pad, category, note and day.
class _AddExpenseSheet extends ConsumerStatefulWidget {
  const _AddExpenseSheet({
    required this.tripId,
    required this.trip,
    required this.currency,
    this.existing,
  });

  final String tripId;
  final Trip? trip;
  final String currency;
  final Expense? existing;

  @override
  ConsumerState<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<_AddExpenseSheet> {
  late String _amount;
  late ExpenseCategory _category;
  late final TextEditingController _note;
  int? _day;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _amount = e == null ? '' : _trimZeros(e.amount);
    _category = e?.category ?? ExpenseCategory.food;
    _note = TextEditingController(text: e?.note ?? '');
    _day = e?.day;
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  double get _value => double.tryParse(_amount) ?? 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final saving = ref.watch(budgetControllerProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            10,
            AppSpacing.screen,
            22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: colors.lineStrong,
                    borderRadius: AppRadius.brFull,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEdit ? l10n.editExpense : l10n.addExpense,
                    style: context.typography.h2.copyWith(
                      fontSize: AppFontSize.h3,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                  ),
                  if (_isEdit)
                    VentusTap(
                      onTap: saving ? null : () => _delete(context),
                      child: VentusIcon(
                        VentusIcons.trash,
                        size: 20,
                        color: colors.danger,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Amount display: small muted symbol, large figure.
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      currencySymbol(widget.currency),
                      style: TextStyle(
                        fontSize: AppFontSize.h1,
                        fontWeight: FontWeight.w700,
                        color: colors.muted,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _amount.isEmpty ? '0' : _amount,
                      style: TextStyle(
                        fontSize: AppFontSize.hero,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.2,
                        color: _amount.isEmpty ? colors.muted : colors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Category chips.
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ExpenseCategory.values.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = ExpenseCategory.values[i];
                    return VentusChip(
                      label: expenseCategoryLabel(l10n, cat),
                      icon: expenseCategoryIcon(cat),
                      active: cat == _category,
                      onTap: () => setState(() => _category = cat),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Note + day row.
              Row(
                children: [
                  Expanded(
                    child: VentusTextField(
                      controller: _note,
                      hintText: l10n.expenseNoteHint,
                      icon: VentusIcons.note,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _DayPickerButton(label: _dayLabel(l10n), onTap: _pickDay),
                ],
              ),
              const SizedBox(height: 14),
              VentusNumberPad(onKey: _onKey, onBackspace: _onBackspace),
              const SizedBox(height: 12),
              VentusButton(
                label: _value > 0
                    ? l10n.addAmountTo(
                        formatMoney(_value, widget.currency),
                        expenseCategoryLabel(l10n, _category),
                      )
                    : l10n.addExpense,
                iconLeft: VentusIcons.check,
                full: true,
                loading: saving,
                onPressed: () => _save(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dayLabel(AppLocalizations l10n) {
    if (_day == null) return l10n.budgetUnassigned;
    final date = dayDate(widget.trip, _day!);
    return date == null
        ? l10n.docDayShort(_day!)
        : l10n.docDayWithDate(
            _day!,
            DateFormat.MMMd(context.languageCode).format(date),
          );
  }

  void _onKey(String k) {
    setState(() {
      if (k == '.') {
        if (_amount.contains('.')) return;
        _amount = _amount.isEmpty ? '0.' : '$_amount.';
        return;
      }
      // Limit to a sensible length and 2 decimal places.
      if (_amount.contains('.') && _amount.split('.')[1].length >= 2) return;
      if (_amount.replaceAll('.', '').length >= 9) return;
      _amount = _amount == '0' ? k : '$_amount$k';
    });
  }

  void _onBackspace() {
    if (_amount.isEmpty) return;
    setState(() => _amount = _amount.substring(0, _amount.length - 1));
  }

  Future<void> _pickDay() async {
    final l10n = context.l10n;
    final lang = context.languageCode;
    final dayCount = ((widget.trip?.nights ?? 0) + 1).clamp(1, 1 << 30);
    final picked = await showVentusOptionSheet<int>(
      context,
      options: [
        VentusSheetOption(
          value: -1,
          label: l10n.budgetUnassigned,
          selected: _day == null,
        ),
        for (var d = 1; d <= dayCount; d++)
          VentusSheetOption(
            value: d,
            label: () {
              final date = dayDate(widget.trip, d);
              return date == null
                  ? l10n.docDayShort(d)
                  : l10n.docDayWithDate(d, DateFormat.MMMd(lang).format(date));
            }(),
            selected: _day == d,
          ),
      ],
    );
    if (picked == null) return;
    setState(() => _day = picked == -1 ? null : picked);
  }

  Future<void> _save(BuildContext context) async {
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    if (_value <= 0) {
      showVentusError(context, l10n.amountRequired);
      return;
    }
    final e = widget.existing;
    final note = _note.text.trim();
    final expense = Expense(
      id: e?.id ?? newId(),
      tripId: widget.tripId,
      category: _category,
      amount: _value,
      note: note.isEmpty ? null : note,
      day: _day,
      createdAt: e?.createdAt ?? DateTime.now(),
    );
    final ok = await ref
        .read(budgetControllerProvider.notifier)
        .saveExpense(expense);
    if (!context.mounted) return;
    if (ok) {
      navigator.pop();
    } else {
      showVentusError(
        context,
        l10n.somethingWentWrong,
        onRetry: () => _save(context),
      );
    }
  }

  Future<void> _delete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    // Deleting an expense had no confirmation and no undo — one mis-tap in the
    // edit sheet and the entry was gone.
    final confirmed = await confirmVentusAction(
      context,
      title: l10n.deleteExpenseTitle,
      confirmLabel: l10n.deleteConfirm,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final ok = await ref
        .read(budgetControllerProvider.notifier)
        .deleteExpense(widget.existing!.id);
    if (!context.mounted) return;
    if (ok) {
      showVentusSuccess(context, l10n.expenseDeleted);
      navigator.pop();
    } else {
      showVentusError(context, l10n.somethingWentWrong);
    }
  }
}

class _DayPickerButton extends StatelessWidget {
  const _DayPickerButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        height: AppSizes.controlLg,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.surfaceSand,
          borderRadius: AppRadius.brMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VentusIcon(VentusIcons.calendar, size: 17, color: colors.ink2),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: colors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Edit a trip's budget — currency, total, and per-category allocations.
class _EditBudgetSheet extends ConsumerStatefulWidget {
  const _EditBudgetSheet({required this.tripId, this.existing});

  final String tripId;
  final TripBudget? existing;

  @override
  ConsumerState<_EditBudgetSheet> createState() => _EditBudgetSheetState();
}

class _EditBudgetSheetState extends ConsumerState<_EditBudgetSheet> {
  late String _currency;
  late final TextEditingController _total;
  late final Map<ExpenseCategory, TextEditingController> _allocs;

  @override
  void initState() {
    super.initState();
    final b = widget.existing;
    _currency = b?.currency ?? ref.read(preferredCurrencyProvider);
    _total = TextEditingController(text: b == null ? '' : _trimZeros(b.total));
    _allocs = {
      for (final c in ExpenseCategory.values)
        c: TextEditingController(
          text: (b?.allocationFor(c) ?? 0) == 0
              ? ''
              : _trimZeros(b!.allocationFor(c)),
        ),
    };
  }

  @override
  void dispose() {
    _total.dispose();
    for (final c in _allocs.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final saving = ref.watch(budgetControllerProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final total = double.tryParse(_total.text) ?? 0;
    final allocated = _allocs.values.fold<double>(
      0,
      (s, c) => s + (double.tryParse(c.text) ?? 0),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            10,
            AppSpacing.screen,
            22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: colors.lineStrong,
                    borderRadius: AppRadius.brFull,
                  ),
                ),
              ),
              Text(
                l10n.editBudget,
                style: context.typography.h2.copyWith(
                  fontSize: AppFontSize.h3,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 16),
              _FieldLabel(l10n.budgetCurrency),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: budgetCurrencies.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final code = budgetCurrencies[i];
                    return VentusChip(
                      label: '${currencySymbol(code).trim()} $code',
                      active: code == _currency,
                      onTap: () => setState(() => _currency = code),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _FieldLabel(l10n.budgetTotalLabel),
              const SizedBox(height: 8),
              VentusTextField(
                controller: _total,
                hintText: '0',
                icon: VentusIcons.wallet,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 18),
              _FieldLabel(l10n.budgetAllocateByCategory),
              const SizedBox(height: 8),
              for (final c in ExpenseCategory.values) ...[
                _AllocRow(
                  category: c,
                  controller: _allocs[c]!,
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.budgetAllocated,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: colors.muted,
                    ),
                  ),
                  Text(
                    '${formatMoney(allocated, _currency)} / ${formatMoney(total, _currency)}',
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      color: allocated == total && total > 0
                          ? colors.success
                          : colors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              VentusButton(
                label: l10n.budgetSave,
                full: true,
                loading: saving,
                onPressed: () => _save(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final navigator = Navigator.of(context);
    final failed = context.l10n.somethingWentWrong;
    final allocations = <String, double>{};
    for (final entry in _allocs.entries) {
      final value = double.tryParse(entry.value.text) ?? 0;
      if (value > 0) allocations[entry.key.name] = value;
    }
    final budget = TripBudget(
      tripId: widget.tripId,
      userId: widget.existing?.userId,
      currency: _currency,
      total: double.tryParse(_total.text) ?? 0,
      allocations: allocations,
    );
    final ok = await ref
        .read(budgetControllerProvider.notifier)
        .saveBudget(budget);
    if (!context.mounted) return;
    if (ok) {
      navigator.pop();
    } else {
      showVentusError(context, failed, onRetry: () => _save(context));
    }
  }
}

class _AllocRow extends StatelessWidget {
  const _AllocRow({
    required this.category,
    required this.controller,
    required this.onChanged,
  });

  final ExpenseCategory category;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final color = expenseCategoryColor(category, colors);
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceSand,
            borderRadius: AppRadius.brSm,
          ),
          child: VentusIcon(
            expenseCategoryIcon(category),
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            expenseCategoryLabel(l10n, category),
            style: TextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
          ),
        ),
        SizedBox(
          width: 110,
          child: TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: AppFontSize.body,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: '0',
              filled: true,
              fillColor: colors.surfaceSand,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.brMd,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.brMd,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.brMd,
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.typography.sm.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.ink2,
      ),
    );
  }
}

/// Formats a double without trailing zeros, for editing (e.g. 500.0 -> "500").
String _trimZeros(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toString();
}
