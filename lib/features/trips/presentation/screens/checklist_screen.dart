import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/id.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/checklist_controller.dart';
import '../../application/checklist_providers.dart';
import '../../domain/checklist_category.dart';
import '../../domain/checklist_item.dart';
import '../widgets/check_row.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Checklist tab content — categorized to-dos with progress, optional reminder
/// dates, and add / edit / delete. Embedded as the Trip Hub's "Yoxlama
/// siyahısı" tab. Prototype `Documents.jsx` → Checklist.
class ChecklistBody extends ConsumerWidget {
  const ChecklistBody({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pull the trip's remote checklist into Drift once, then read it live.
    ref.watch(checklistSyncProvider(tripId));
    final items =
        ref.watch(checklistProvider(tripId)).asData?.value ??
        const <ChecklistItem>[];
    final done = items.where((i) => i.done).length;

    if (items.isEmpty) {
      return _EmptyChecklist(onAdd: () => _openSheet(context, ref));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 28),
      children: [
        // The tab already says "Checklist", so the header is the progress
        // itself (count + bar) with the one add button beside it.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            10,
            AppSpacing.screen,
            18,
          ),
          child: _ProgressHeader(
            done: done,
            total: items.length,
            onAdd: () => _openSheet(context, ref),
          ),
        ),
        for (final category in ChecklistCategory.values)
          _CategoryBlock(
            category: category,
            items: items.where((i) => i.category == category).toList(),
            onAdd: () => _openSheet(context, ref, category: category),
            onToggle: (item) {
              ref.read(checklistControllerProvider.notifier).toggle(item);
              // Ticking the last open item is the "ready to go" moment.
              final completes =
                  !item.done && items.where((i) => !i.done).length == 1;
              if (completes) {
                HapticFeedback.mediumImpact();
                showVentusSuccess(context, context.l10n.checklistAllDone);
              }
            },
            onEdit: (item) => _openSheet(context, ref, existing: item),
            onDelete: (item) => _deleteWithUndo(context, ref, item),
          ),
      ],
    );
  }

  Future<void> _openSheet(
    BuildContext context,
    WidgetRef ref, {
    ChecklistCategory? category,
    ChecklistItem? existing,
  }) {
    return showVentusSheet<void>(
      context,
      builder: (_) => _ChecklistItemSheet(
        tripId: tripId,
        initialCategory:
            existing?.category ?? category ?? ChecklistCategory.beforeYouGo,
        existing: existing,
      ),
    );
  }
}

/// Deletes [item] and offers an Undo, from anywhere in the checklist (the swipe
/// gesture and the edit sheet's Delete button both land here).
Future<void> _deleteWithUndo(
  BuildContext context,
  WidgetRef ref,
  ChecklistItem item,
) async {
  final l10n = context.l10n;
  final ok = await ref
      .read(checklistControllerProvider.notifier)
      .delete(item.id);
  if (!context.mounted) return;
  if (ok) {
    showChecklistUndoSnack(context, ref, item);
  } else {
    showVentusError(context, l10n.somethingWentWrong);
  }
}

/// "Deleted · Undo" toast. Re-saving the original item restores it exactly,
/// including its id, so nothing else in the trip loses its reference to it.
void showChecklistUndoSnack(
  BuildContext context,
  WidgetRef ref,
  ChecklistItem item,
) {
  final l10n = context.l10n;
  showVentusSnack(
    context,
    l10n.itemDeleted,
    kind: VentusSnackKind.success,
    actionLabel: l10n.undo,
    onAction: () => ref.read(checklistControllerProvider.notifier).save(item),
  );
}

/// Localized category name.
String checklistCategoryLabel(AppLocalizations l10n, ChecklistCategory c) =>
    switch (c) {
      ChecklistCategory.beforeYouGo => l10n.checklistCatBeforeYouGo,
      ChecklistCategory.pack => l10n.checklistCatPack,
      ChecklistCategory.onArrival => l10n.checklistCatOnArrival,
    };

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.done,
    required this.total,
    required this.onAdd,
  });

  final int done;
  final int total;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final fraction = total == 0 ? 0.0 : done / total;
    // Coral while in progress; green only once everything is ticked, so an
    // untouched list doesn't read as a success.
    final fill = done == total && total > 0 ? colors.success : colors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.checklistProgress(done, total),
                style: context.typography.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
              ),
            ),
            VentusAddButton(semanticLabel: l10n.addItem, onTap: onAdd),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: AppRadius.brFull,
          child: Container(
            height: 6,
            // A track that stays visible on the page background at 0%.
            color: colors.lineStrong,
            child: AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(color: fill),
            ),
          ),
        ),
      ],
    );
  }
}

/// One category section: an eyebrow label and a card of its items plus an
/// "Add item" footer (prototype `Documents.jsx` → ChecklistCat).
class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.category,
    required this.items,
    required this.onAdd,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final ChecklistCategory category;
  final List<ChecklistItem> items;
  final VoidCallback onAdd;
  final ValueChanged<ChecklistItem> onToggle;
  final ValueChanged<ChecklistItem> onEdit;
  final ValueChanged<ChecklistItem> onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final lang = context.languageCode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VentusSectionLabel(
            checklistCategoryLabel(l10n, category),
            padding: const EdgeInsets.only(left: 2, bottom: 8),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.brLg,
              boxShadow: context.shadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        // Swipe-to-delete: the only other way to remove an
                        // item is to open its edit sheet and scroll to the
                        // bottom, which nobody discovers.
                        Dismissible(
                          key: ValueKey(items[i].id),
                          direction: DismissDirection.endToStart,
                          background: const VentusSwipeDeleteBackground(),
                          onDismissed: (_) => onDelete(items[i]),
                          child: CheckRow(
                            label: items[i].title,
                            done: items[i].done,
                            dueLabel: items[i].dueDate == null
                                ? null
                                : l10n.dueBy(
                                    DateFormat.MMMd(
                                      lang,
                                    ).format(items[i].dueDate!),
                                  ),
                            onTap: () => onToggle(items[i]),
                            onEdit: () => onEdit(items[i]),
                          ),
                        ),
                    ],
                  ),
                ),
                // A text link, not a filled pill: it repeats under every
                // category, so it must stay quieter than the items above.
                VentusTap(
                  onTap: onAdd,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                    child: Row(
                      children: [
                        VentusIcon(
                          VentusIcons.plus,
                          size: 16,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.addItem,
                          style: context.typography.sm.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.primaryFill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChecklist extends StatelessWidget {
  const _EmptyChecklist({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VentusEmptyState(
      icon: VentusIcons.listCheck,
      title: l10n.emptyChecklistTitle,
      body: l10n.emptyChecklistBody,
      action: VentusButton(
        label: l10n.addItem,
        iconLeft: VentusIcons.plus,
        onPressed: onAdd,
      ),
    );
  }
}

/// Add / edit a checklist item — title, category and an optional reminder date.
class _ChecklistItemSheet extends ConsumerStatefulWidget {
  const _ChecklistItemSheet({
    required this.tripId,
    required this.initialCategory,
    this.existing,
  });

  final String tripId;
  final ChecklistCategory initialCategory;
  final ChecklistItem? existing;

  @override
  ConsumerState<_ChecklistItemSheet> createState() =>
      _ChecklistItemSheetState();
}

class _ChecklistItemSheetState extends ConsumerState<_ChecklistItemSheet> {
  late final TextEditingController _title;
  late ChecklistCategory _category;
  DateTime? _dueDate;
  bool _showTitleError = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _category = e?.category ?? widget.initialCategory;
    _dueDate = e?.dueDate;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final lang = context.languageCode;
    final saving = ref.watch(checklistControllerProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colors.lineStrong,
                    borderRadius: AppRadius.brFull,
                  ),
                ),
              ),
              Text(
                _isEdit ? l10n.editChecklistItem : l10n.addToChecklist,
                style: context.typography.h2.copyWith(
                  fontSize: AppFontSize.h3,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 18),
              VentusTextField(
                controller: _title,
                hintText: l10n.checklistItemHint,
                icon: VentusIcons.listCheck,
                errorText: _showTitleError ? l10n.activityTitleRequired : null,
                textInputAction: TextInputAction.done,
                onChanged: (_) {
                  if (_showTitleError) setState(() => _showTitleError = false);
                },
                onSubmitted: (_) => _save(context),
              ),
              const SizedBox(height: 18),
              _FieldLabel(l10n.checklistCategoryLabel),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in ChecklistCategory.values)
                    VentusChip(
                      label: checklistCategoryLabel(l10n, c),
                      active: c == _category,
                      onTap: () => setState(() => _category = c),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              _ReminderField(
                date: _dueDate,
                dateLabel: _dueDate == null
                    ? null
                    : DateFormat.MMMMEEEEd(lang).format(_dueDate!),
                onToggle: _toggleReminder,
                onPick: _pickDate,
                onClear: () => setState(() => _dueDate = null),
              ),
              const SizedBox(height: 24),
              VentusButton(
                label: l10n.save,
                full: true,
                loading: saving,
                onPressed: () => _save(context),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: saving ? null : () => _delete(context),
                    child: Text(
                      l10n.deleteChecklistItem,
                      style: TextStyle(
                        color: colors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _toggleReminder(bool on) {
    if (on) {
      _pickDate();
    } else {
      setState(() => _dueDate = null);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 2),
    );
    if (picked != null) {
      setState(
        () => _dueDate = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _save(BuildContext context) async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _showTitleError = true);
      return;
    }
    final navigator = Navigator.of(context);
    final failed = context.l10n.somethingWentWrong;
    final e = widget.existing;
    final items =
        ref.read(checklistProvider(widget.tripId)).asData?.value ?? const [];
    final item = ChecklistItem(
      id: e?.id ?? newId(),
      tripId: widget.tripId,
      title: title,
      done: e?.done ?? false,
      category: _category,
      dueDate: _dueDate,
      position: e?.position ?? items.length,
      createdAt: e?.createdAt ?? DateTime.now(),
    );
    final ok = await ref.read(checklistControllerProvider.notifier).save(item);
    if (!context.mounted) return;
    if (ok) {
      navigator.pop();
    } else {
      showVentusError(context, failed, onRetry: () => _save(context));
    }
  }

  Future<void> _delete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final item = widget.existing!;
    final ok = await ref
        .read(checklistControllerProvider.notifier)
        .delete(item.id);
    if (!context.mounted) return;
    if (ok) {
      showChecklistUndoSnack(context, ref, item);
      navigator.pop();
    } else {
      showVentusError(context, l10n.somethingWentWrong);
    }
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

/// "Set a reminder" toggle row that reveals the chosen date once enabled.
class _ReminderField extends StatelessWidget {
  const _ReminderField({
    required this.date,
    required this.dateLabel,
    required this.onToggle,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? date;
  final String? dateLabel;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surfaceSand,
            borderRadius: AppRadius.brMd,
          ),
          child: Row(
            children: [
              VentusIcon(VentusIcons.bell, size: 18, color: colors.ink2),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  l10n.setReminder,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
              ),
              VentusToggle(value: date != null, onChanged: onToggle),
            ],
          ),
        ),
        if (date != null) ...[
          const SizedBox(height: 8),
          VentusTap(
            onTap: onPick,
            child: Container(
              height: AppSizes.controlLg,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.brMd,
                boxShadow: context.shadows.card,
              ),
              child: Row(
                children: [
                  VentusIcon(
                    VentusIcons.calendar,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dateLabel ?? '',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                      ),
                    ),
                  ),
                  VentusTap(
                    onTap: onClear,
                    child: VentusIcon(
                      VentusIcons.close,
                      size: 18,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
