import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/id.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../places/application/place_search_providers.dart';
import '../../../places/domain/place_suggestion.dart';
import '../../data/drift_itinerary_repository.dart' show positionForNewItem;
import '../../application/itinerary_controller.dart';
import '../../application/itinerary_providers.dart';
import '../../application/trip_detail_providers.dart';
import '../../domain/activity_kind.dart';
import '../../domain/itinerary_item.dart';
import '../../domain/trip_progress.dart';
import '../../domain/trip.dart';
import '../widgets/ai_plan_flow.dart';
import '../widgets/itinerary_day_chip.dart';
import '../widgets/itinerary_format.dart';
import '../widgets/open_in_maps.dart';
import '../widgets/timeline_item.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Day-by-day itinerary tab content — add / edit / delete activities per day.
/// Embedded as the Trip Hub's "Marşrut" tab.
class ItineraryBody extends ConsumerStatefulWidget {
  const ItineraryBody({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<ItineraryBody> createState() => _ItineraryBodyState();
}

class _ItineraryBodyState extends ConsumerState<ItineraryBody> {
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    // Pull remote activities into Drift once for this trip.
    ref.watch(itinerarySyncProvider(widget.tripId));
    final trip = ref.watch(tripDetailProvider(widget.tripId)).asData?.value;
    final items =
        ref.watch(itineraryProvider(widget.tripId)).asData?.value ??
        const <ItineraryItem>[];
    final l10n = context.l10n;

    final dayCount = itineraryDayCount(trip, items);
    final selectedDay = _selectedDay.clamp(1, dayCount);
    final dayItems = items.where((i) => i.day == selectedDay).toList();

    final date = dayDate(trip, selectedDay);
    final lang = context.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        _DaySelector(
          trip: trip,
          dayCount: dayCount,
          selected: selectedDay,
          plannedDays: items.map((i) => i.day).toSet(),
          onSelect: (d) => setState(() => _selectedDay = d),
        ),
        // The selected day, with the one add button: this row replaces the
        // old "Day plan" title (the tab already says that) and the separate
        // add row under the list.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            4,
            AppSpacing.screen,
            8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.dayLabel} $selectedDay',
                      style: context.typography.h2.copyWith(
                        fontSize: AppFontSize.h3,
                        fontWeight: FontWeight.w700,
                        color: context.colors.ink,
                      ),
                    ),
                    if (date != null)
                      Text(
                        _daySubtitle(l10n, lang, date, dayItems),
                        style: context.typography.sm.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              // An empty day already shows the add action below, so the
              // header button appears only once there is something listed.
              if (dayItems.isNotEmpty)
                VentusAddButton(
                  semanticLabel: l10n.addActivity,
                  onTap: () => _openSheet(context, trip, dayCount, selectedDay),
                ),
            ],
          ),
        ),
        Expanded(
          child: dayItems.isEmpty
              ? _EmptyDay(
                  onAdd: () => _openSheet(context, trip, dayCount, selectedDay),
                  onPlanWithAi: trip == null
                      ? null
                      : () => generateTripPlan(context, ref, trip),
                )
              : Column(
                  children: [
                    Expanded(
                      // Long-press a row to drag it: a day plan is rarely
                      // right on the first pass, and re-typing times to
                      // reshuffle it was the only way to change the order.
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screen,
                          8,
                          AppSpacing.screen,
                          8,
                        ),
                        itemCount: dayItems.length,
                        onReorderItem: (from, to) =>
                            _reorder(dayItems, from, to),
                        proxyDecorator: _dragProxy,
                        itemBuilder: (context, i) => VentusReveal(
                          key: ValueKey(dayItems[i].id),
                          index: i,
                          child: TimelineItem(
                            time: formatStartMinutes(dayItems[i].startMinutes),
                            icon: activityKindIcon(dayItems[i].kind),
                            title: dayItems[i].title,
                            last: i == dayItems.length - 1,
                            onOpenMap: _mapCallback(context, dayItems[i]),
                            onTap: () => _openSheet(
                              context,
                              trip,
                              dayCount,
                              selectedDay,
                              existing: dayItems[i],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  /// Opens the activity's place in a maps app; null (no button) when the
  /// activity has no place to show.
  VoidCallback? _mapCallback(BuildContext context, ItineraryItem item) {
    final place = item.place?.trim();
    if (place == null || place.isEmpty) return null;
    return () => showOpenInMapsSheet(
      context,
      place: place,
      lat: item.lat,
      lon: item.lon,
    );
  }

  /// Applies a drag: moves the row locally, then persists the day's new order.
  ///
  /// Uses `onReorderItem` rather than the deprecated `onReorder`, so [to] is
  /// already the destination index *after* the dragged row is lifted out — no
  /// off-by-one adjustment needed here.
  void _reorder(List<ItineraryItem> dayItems, int from, int to) {
    final next = [...dayItems];
    next.insert(to, next.removeAt(from));
    ref.read(itineraryControllerProvider.notifier).reorder(next);
  }

  /// Lifts the dragged row instead of letting Material paint its default
  /// elevated Material sheet behind the (borderless) timeline card.
  Widget _dragProxy(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = Curves.easeOut.transform(animation.value);
        return Transform.scale(
          scale: 1 + 0.03 * t,
          child: Material(color: Colors.transparent, child: child),
        );
      },
      child: child,
    );
  }

  Future<void> _openSheet(
    BuildContext context,
    Trip? trip,
    int dayCount,
    int day, {
    ItineraryItem? existing,
  }) {
    return showVentusSheet<void>(
      context,
      builder: (_) => _ActivitySheet(
        tripId: widget.tripId,
        dayCount: dayCount,
        initialDay: existing?.day ?? day,
        existing: existing,
      ),
    );
  }
}

/// "26 noyabr, cümə axşamı · 3 fəaliyyət" — the date plus how full the day is.
String _daySubtitle(
  AppLocalizations l10n,
  String lang,
  DateTime date,
  List<ItineraryItem> dayItems,
) {
  final dateText = DateFormat.MMMMEEEEd(lang).format(date);
  if (dayItems.isEmpty) return dateText;
  return '$dateText · ${l10n.readinessActivities(dayItems.length)}';
}

/// The calendar date of a 1-based [day], or null when the trip has no dates.
DateTime? dayDate(Trip? trip, int day) =>
    trip?.startDate.add(Duration(days: day - 1));

class _DaySelector extends StatelessWidget {
  const _DaySelector({
    required this.trip,
    required this.dayCount,
    required this.selected,
    required this.plannedDays,
    required this.onSelect,
  });

  final Trip? trip;
  final int dayCount;
  final int selected;
  final Set<int> plannedDays;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 8,
        ),
        itemCount: dayCount,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final day = i + 1;
          return ItineraryDayChip(
            day: day,
            date: dayDate(trip, day),
            active: day == selected,
            planned: plannedDays.contains(day),
            onTap: () => onSelect(day),
          );
        },
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.onAdd, this.onPlanWithAi});

  final VoidCallback onAdd;

  /// Hands the trip to the AI planner; hidden when no trip is loaded.
  final VoidCallback? onPlanWithAi;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VentusEmptyState(
      icon: VentusIcons.route,
      title: l10n.emptyDayTitle,
      body: l10n.emptyDayBody,
      // Two equal-width buttons: add by hand (primary) or let Ventus plan it
      // (tonal), instead of a button and a differently sized pill.
      action: SizedBox(
        width: 264,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VentusButton(
              label: l10n.addActivity,
              iconLeft: VentusIcons.plus,
              full: true,
              onPressed: onAdd,
            ),
            if (onPlanWithAi != null) ...[
              const SizedBox(height: 10),
              VentusButton(
                label: l10n.destAskPlan,
                iconLeft: VentusIcons.sparkle,
                variant: VentusButtonVariant.tonal,
                full: true,
                onPressed: onPlanWithAi,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Add / edit an activity. Manages its own form state and writes through
/// [ItineraryController]; the timeline updates reactively via [itineraryProvider].
class _ActivitySheet extends ConsumerStatefulWidget {
  const _ActivitySheet({
    required this.tripId,
    required this.dayCount,
    required this.initialDay,
    this.existing,
  });

  final String tripId;
  final int dayCount;
  final int initialDay;
  final ItineraryItem? existing;

  @override
  ConsumerState<_ActivitySheet> createState() => _ActivitySheetState();
}

class _ActivitySheetState extends ConsumerState<_ActivitySheet> {
  late final TextEditingController _title;
  late final TextEditingController _place;
  late int _day;
  late ActivityKind _kind;
  int? _startMinutes;
  bool _showTitleError = false;
  String _placeQuery = '';

  // Floating autocomplete anchored to the place field, so suggestions overlay
  // the form below instead of pushing it down.
  final LayerLink _placeLink = LayerLink();
  final OverlayPortalController _placeOverlay = OverlayPortalController();
  final GlobalKey _placeAnchorKey = GlobalKey();
  final FocusNode _placeFocus = FocusNode();

  /// Space from under the place field down to just above the Save button, so the
  /// dropdown grows with its results but never runs off the bottom of the sheet.
  double _placeDropdownMaxHeight() {
    final media = MediaQuery.of(context);
    final box =
        _placeAnchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return 320;
    final fieldBottom = box.localToGlobal(Offset.zero).dy + box.size.height;
    final reserve = media.viewInsets.bottom > 0
        ? media.viewInsets.bottom + 12
        : 96;
    return (media.size.height - fieldBottom - 8 - reserve).clamp(120, 420);
  }

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _place = TextEditingController(text: e?.place ?? '');
    _day = e?.day ?? widget.initialDay;
    _kind = e?.kind ?? ActivityKind.activity;
    _startMinutes = e?.startMinutes;
    // Close the suggestions whenever the place field loses focus (tap-outside).
    _placeFocus.addListener(() {
      if (!_placeFocus.hasFocus) _placeOverlay.hide();
    });
  }

  @override
  void dispose() {
    _placeFocus.dispose();
    _title.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final saving = ref.watch(itineraryControllerProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: GestureDetector(
        // Tapping any empty area drops focus, which closes the suggestions.
        // Stays a bare GestureDetector: this is a dismiss backdrop, not a
        // control, so it must not scale, tick, or announce itself as a button.
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
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
                  _isEdit ? l10n.editActivity : l10n.newActivity,
                  style: context.typography.h2.copyWith(
                    fontSize: AppFontSize.h3,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 18),
                VentusTextField(
                  label: l10n.activityTitleLabel,
                  controller: _title,
                  hintText: l10n.activityTitleHint,
                  icon: VentusIcons.note,
                  errorText: _showTitleError
                      ? l10n.activityTitleRequired
                      : null,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    if (_showTitleError) {
                      setState(() => _showTitleError = false);
                    }
                  },
                ),
                const SizedBox(height: 14),
                CompositedTransformTarget(
                  key: _placeAnchorKey,
                  link: _placeLink,
                  child: OverlayPortal(
                    controller: _placeOverlay,
                    overlayChildBuilder: (_) => CompositedTransformFollower(
                      link: _placeLink,
                      targetAnchor: Alignment.bottomLeft,
                      followerAnchor: Alignment.topLeft,
                      showWhenUnlinked: false,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: _PlaceSuggestions(
                            query: _placeQuery,
                            maxHeight: _placeDropdownMaxHeight(),
                            onPick: (name) {
                              _place.text = name;
                              setState(() => _placeQuery = '');
                              _placeOverlay.hide();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                    ),
                    child: VentusTextField(
                      label: l10n.activityPlaceLabel,
                      controller: _place,
                      focusNode: _placeFocus,
                      hintText: l10n.activityPlaceHint,
                      icon: VentusIcons.mapPin,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) {
                        setState(() => _placeQuery = v);
                        if (v.trim().length >= kPlaceSearchMinChars) {
                          _placeOverlay.show();
                        } else {
                          _placeOverlay.hide();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _FieldLabel(l10n.activityTimeLabel),
                const SizedBox(height: 8),
                _TimeField(
                  minutes: _startMinutes,
                  onPick: _pickTime,
                  onClear: () => setState(() => _startMinutes = null),
                ),
                const SizedBox(height: 18),
                _FieldLabel(l10n.activityKindLabel),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final kind in ActivityKind.values)
                      VentusChip(
                        label: _kindLabel(l10n, kind),
                        icon: activityKindIcon(kind),
                        active: kind == _kind,
                        onTap: () => setState(() => _kind = kind),
                      ),
                  ],
                ),
                if (widget.dayCount > 1) ...[
                  const SizedBox(height: 18),
                  _FieldLabel(l10n.activityDayLabel),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var d = 1; d <= widget.dayCount; d++)
                        VentusChip(
                          label: '${l10n.dayLabel} $d',
                          active: d == _day,
                          onTap: () => setState(() => _day = d),
                        ),
                    ],
                  ),
                ],
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
                        l10n.deleteActivity,
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
      ),
    );
  }

  Future<void> _pickTime() async {
    // The wheel opens on a plausible start of day (09:00), not on the current
    // time of day, which is meaningless for a plan made weeks ahead.
    final initial = _startMinutes ?? 9 * 60;
    final picked = await showVentusSheet<int>(
      context,
      isScrollControlled: false,
      builder: (_) => _TimeWheelSheet(initialMinutes: initial),
    );
    if (picked != null) setState(() => _startMinutes = picked);
  }

  Future<void> _save(BuildContext context) async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _showTitleError = true);
      return;
    }
    // Capture context-dependent objects before the await.
    final navigator = Navigator.of(context);
    final failed = context.l10n.somethingWentWrong;
    final e = widget.existing;
    final item = ItineraryItem(
      id: e?.id ?? newId(),
      tripId: widget.tripId,
      day: _day,
      startMinutes: _startMinutes,
      title: title,
      place: _place.text.trim().isEmpty ? null : _place.text.trim(),
      kind: _kind,
      // A brand-new activity slots in by time (see [positionForNewItem]); an
      // existing one keeps wherever the user dragged it to.
      position:
          e?.position ??
          positionForNewItem(
            (ref.read(itineraryProvider(widget.tripId)).asData?.value ??
                    const <ItineraryItem>[])
                .where((i) => i.day == _day)
                .toList(),
            _startMinutes,
          ),
      createdAt: e?.createdAt ?? DateTime.now(),
    );
    final ok = await ref.read(itineraryControllerProvider.notifier).save(item);
    if (!context.mounted) return;
    if (ok) {
      navigator.pop();
    } else {
      showVentusError(context, failed);
    }
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await confirmVentusAction(
      context,
      title: l10n.deleteActivityTitle,
      confirmLabel: l10n.deleteConfirm,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final navigator = Navigator.of(context);
    final failed = l10n.somethingWentWrong;
    final ok = await ref
        .read(itineraryControllerProvider.notifier)
        .delete(widget.existing!.id);
    if (!context.mounted) return;
    if (ok) {
      navigator.pop();
    } else {
      showVentusError(context, failed);
    }
  }

  String _kindLabel(AppLocalizations l10n, ActivityKind kind) => switch (kind) {
    ActivityKind.flight => l10n.kindFlight,
    ActivityKind.stay => l10n.kindStay,
    ActivityKind.food => l10n.kindFood,
    ActivityKind.sight => l10n.kindSight,
    ActivityKind.transport => l10n.kindTransport,
    ActivityKind.activity => l10n.kindActivity,
  };
}

/// Inline place autocomplete shown under the activity's "Place" field, reusing
/// the shared free-OSM (Photon) search. Hidden below [kPlaceSearchMinChars]; a
/// tap fills the field via [onPick].
class _PlaceSuggestions extends ConsumerWidget {
  const _PlaceSuggestions({
    required this.query,
    required this.maxHeight,
    required this.onPick,
  });

  final String query;
  final double maxHeight;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = query.trim();
    if (q.length < kPlaceSearchMinChars) return const SizedBox.shrink();

    final colors = context.colors;
    final async = ref.watch(placeSuggestionsProvider(q));
    final results = async.asData?.value ?? const <PlaceSuggestion>[];
    final loading = async.isLoading;

    if (results.isEmpty && !loading) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brMd,
        boxShadow: context.shadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: results.isEmpty && loading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  VentusSpinner(size: 14, color: colors.muted),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.searchingPlaces,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, i) => _PlaceRow(
                suggestion: results[i],
                query: q,
                last: i == results.length - 1,
                onTap: () => onPick(results[i].name),
              ),
            ),
    );
  }
}

/// A place result row, matching the destination-search row style: a sand circle
/// icon, the matched substring highlighted, and the country beneath.
class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.suggestion,
    required this.query,
    required this.last,
    required this.onTap,
  });

  final PlaceSuggestion suggestion;
  final String query;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = suggestion.name;
    final idx = name.toLowerCase().indexOf(query.toLowerCase());
    final base = TextStyle(
      fontSize: AppFontSize.body,
      fontWeight: FontWeight.w600,
      color: colors.ink,
      letterSpacing: -0.16,
    );
    final highlight = base.copyWith(
      color: context.primaryFill,
      fontWeight: FontWeight.w800,
    );

    return VentusTap(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const VentusLeadIcon(VentusIcons.mapPin),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      idx < 0 || query.isEmpty
                          ? Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: base,
                            )
                          : Text.rich(
                              TextSpan(
                                style: base,
                                children: [
                                  TextSpan(text: name.substring(0, idx)),
                                  TextSpan(
                                    text: name.substring(
                                      idx,
                                      idx + query.length,
                                    ),
                                    style: highlight,
                                  ),
                                  TextSpan(
                                    text: name.substring(idx + query.length),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      if (suggestion.country.isNotEmpty)
                        Text(
                          suggestion.country,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            color: colors.muted,
                          ),
                        ),
                    ],
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

/// Bottom-sheet time picker: two scroll wheels (hour 0–23, minute in 5-minute
/// steps). No free-text entry — the user only ever selects from the lists.
/// Returns the chosen time as minutes-since-midnight, or null on cancel.
class _TimeWheelSheet extends StatefulWidget {
  const _TimeWheelSheet({required this.initialMinutes});

  final int initialMinutes;

  @override
  State<_TimeWheelSheet> createState() => _TimeWheelSheetState();
}

class _TimeWheelSheetState extends State<_TimeWheelSheet> {
  static const _itemExtent = 44.0;
  static const _minuteStep = 5;

  late int _hour;
  late int _minuteIndex; // index into the 5-minute list (0..11)
  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minuteCtrl;

  @override
  void initState() {
    super.initState();
    _hour = (widget.initialMinutes ~/ 60).clamp(0, 23);
    final minute = widget.initialMinutes % 60;
    _minuteIndex = (minute / _minuteStep).round() % (60 ~/ _minuteStep);
    _hourCtrl = FixedExtentScrollController(initialItem: _hour);
    _minuteCtrl = FixedExtentScrollController(initialItem: _minuteIndex);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.lineStrong,
                  borderRadius: AppRadius.brFull,
                ),
              ),
              Text(
                l10n.selectTime,
                style: context.typography.h2.copyWith(
                  fontSize: AppFontSize.h3,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: _itemExtent * 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Selection band behind the centre row.
                    Container(
                      height: _itemExtent,
                      decoration: BoxDecoration(
                        color: colors.surfaceSand,
                        borderRadius: AppRadius.brMd,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _wheel(
                          controller: _hourCtrl,
                          count: 24,
                          label: (i) => i.toString().padLeft(2, '0'),
                          onChanged: (i) => _hour = i,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            ':',
                            style: TextStyle(
                              fontSize: AppFontSize.h2,
                              fontWeight: FontWeight.w700,
                              color: colors.ink,
                            ),
                          ),
                        ),
                        _wheel(
                          controller: _minuteCtrl,
                          count: 60 ~/ _minuteStep,
                          label: (i) =>
                              (i * _minuteStep).toString().padLeft(2, '0'),
                          onChanged: (i) => _minuteIndex = i,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: VentusButton(
                      label: l10n.cancel,
                      full: true,
                      variant: VentusButtonVariant.ghost,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VentusButton(
                      label: l10n.setTime,
                      full: true,
                      onPressed: () => Navigator.of(
                        context,
                      ).pop(_hour * 60 + _minuteIndex * _minuteStep),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required String Function(int) label,
    required ValueChanged<int> onChanged,
  }) {
    final colors = context.colors;
    return SizedBox(
      width: 64,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemExtent,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.004,
        diameterRatio: 1.5,
        overAndUnderCenterOpacity: 0.4,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, i) => Center(
            child: Text(
              label(i),
              style: TextStyle(
                fontSize: AppFontSize.h3,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
          ),
        ),
      ),
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

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.minutes,
    required this.onPick,
    required this.onClear,
  });

  final int? minutes;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final label = formatStartMinutes(minutes) ?? l10n.activityAddTime;
    return VentusTap(
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
            VentusIcon(VentusIcons.clock, size: 20, color: colors.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w500,
                  color: minutes == null ? colors.muted : colors.ink,
                ),
              ),
            ),
            if (minutes != null)
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
    );
  }
}
