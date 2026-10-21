import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/extensions/theme_context_extension.dart';
import '../../../../../../core/l10n/l10n_extension.dart';
import '../../../../../../shared/widgets/widgets.dart';
import '../../../../application/create_trip_controller.dart';
import '../create_chrome.dart';
import '../../../../../../core/theme/app_typography.dart';

/// Step 3 — choose the trip dates via quick presets or an inline range calendar.
class DatesStep extends ConsumerStatefulWidget {
  const DatesStep({super.key, required this.onReview, required this.onBack});

  final VoidCallback onReview;
  final VoidCallback onBack;

  @override
  ConsumerState<DatesStep> createState() => _DatesStepState();
}

class _DatesStepState extends ConsumerState<DatesStep> {
  DateTime? _start;
  DateTime? _end;
  late DateTime _visible;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createTripControllerProvider);
    _start = state.startDate;
    _end = state.endDate;
    final base = state.startDate ?? DateTime.now();
    _visible = DateTime(base.year, base.month);
  }

  void _sync() {
    final controller = ref.read(createTripControllerProvider.notifier);
    if (_start != null && _end != null) {
      controller.setDates(_start!, _end!);
    } else {
      controller.clearDates();
    }
  }

  void _onTapDay(DateTime day) {
    setState(() {
      final nights = ref.read(createTripControllerProvider).aiNights;
      if (nights != null) {
        // The description gave a length: one tap (the departure day) is enough.
        _start = day;
        _end = day.add(Duration(days: nights));
        _visible = DateTime(day.year, day.month);
      } else if (_start == null || _end != null) {
        _start = day;
        _end = null;
      } else if (day.isBefore(_start!)) {
        _start = day;
      } else {
        _end = day;
      }
    });
    _sync();
  }

  void _applyPreset(DateTime start, DateTime end) {
    setState(() {
      _start = start;
      _end = end;
      _visible = DateTime(start.year, start.month);
    });
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasRange = _start != null && _end != null;
    final aiNights = ref.watch(createTripControllerProvider).aiNights;

    return CreateStepScaffold(
      header: CreateStepHeader(step: 3, onLead: widget.onBack),
      footer: _Footer(
        start: _start,
        end: _end,
        onReview: hasRange ? widget.onReview : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateStepTitle(
              title: l10n.when,
              subtitle: aiNights == null
                  ? l10n.datesSubtitle
                  : l10n.datesPickStartOnly(aiNights),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                VentusChip(
                  label: l10n.presetThisWeekend,
                  onTap: () {
                    final (s, e) = _thisWeekend();
                    _applyPreset(s, e);
                  },
                ),
                VentusChip(
                  label: l10n.presetNextWeek,
                  onTap: () {
                    final (s, e) = _nextWeek();
                    _applyPreset(s, e);
                  },
                ),
                VentusChip(
                  label: l10n.presetInAMonth,
                  onTap: () {
                    final s = _dateOnly(
                      DateTime.now().add(const Duration(days: 30)),
                    );
                    _applyPreset(s, s.add(const Duration(days: 3)));
                  },
                ),
                VentusChip(
                  label: l10n.presetFlexible,
                  onTap: () {
                    final s = _dateOnly(
                      DateTime.now().add(const Duration(days: 14)),
                    );
                    _applyPreset(s, s.add(const Duration(days: 4)));
                  },
                ),
              ],
            ),
            const SizedBox(height: 22),
            _MonthCalendar(
              visible: _visible,
              start: _start,
              end: _end,
              onPrev: () => setState(
                () => _visible = DateTime(_visible.year, _visible.month - 1),
              ),
              onNext: () => setState(
                () => _visible = DateTime(_visible.year, _visible.month + 1),
              ),
              onTapDay: _onTapDay,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  (DateTime, DateTime) _thisWeekend() {
    final today = _dateOnly(DateTime.now());
    // Saturday = 6; jump to the coming Saturday (today if already Saturday).
    final delta = (DateTime.saturday - today.weekday) % 7;
    final sat = today.add(Duration(days: delta));
    return (sat, sat.add(const Duration(days: 1)));
  }

  (DateTime, DateTime) _nextWeek() {
    final today = _dateOnly(DateTime.now());
    final delta = ((DateTime.monday - today.weekday) % 7);
    final mon = today.add(Duration(days: delta == 0 ? 7 : delta));
    return (mon, mon.add(const Duration(days: 6)));
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

/// Footer summary + "Review trip" CTA.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.start,
    required this.end,
    required this.onReview,
  });

  final DateTime? start;
  final DateTime? end;
  final VoidCallback? onReview;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final lang = context.languageCode;

    final label = (start != null && end != null)
        ? _formatRange(start!, end!, lang)
        : l10n.selectDates;
    final nights = (start != null && end != null)
        ? end!.difference(start!).inDays
        : 0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                  letterSpacing: -0.16,
                ),
              ),
              if (start != null && end != null) ...[
                const SizedBox(height: 1),
                Text(
                  l10n.nightsCount(nights),
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: colors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 14),
        VentusButton(
          label: l10n.reviewTrip,
          iconRight: VentusIcons.arrowRight,
          onPressed: onReview,
        ),
      ],
    );
  }

  static String _formatRange(DateTime s, DateTime e, String lang) {
    final startFmt = DateFormat.MMMd(lang).format(s);
    final endFmt = s.month == e.month
        ? DateFormat.d(lang).format(e)
        : DateFormat.MMMd(lang).format(e);
    return '$startFmt – $endFmt';
  }
}

/// Inline month grid with two-tap range selection.
class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.visible,
    required this.start,
    required this.end,
    required this.onPrev,
    required this.onNext,
    required this.onTapDay,
  });

  final DateTime visible;
  final DateTime? start;
  final DateTime? end;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onTapDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lang = context.languageCode;
    final weekdays = _weekdayLabels(lang);

    final first = DateTime(visible.year, visible.month);
    final daysInMonth = DateUtils.getDaysInMonth(visible.year, visible.month);
    final leading = first.weekday - DateTime.monday; // Monday-first offset

    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= daysInMonth; d++)
        DateTime(visible.year, visible.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.yMMMM(lang).format(visible),
              style: TextStyle(
                fontSize: AppFontSize.h3,
                fontWeight: FontWeight.w700,
                color: colors.ink,
                letterSpacing: -0.34,
              ),
            ),
            Row(
              children: [
                _NavButton(
                  icon: VentusIcons.chevronRight,
                  flip: true,
                  onTap: onPrev,
                ),
                const SizedBox(width: 8),
                _NavButton(icon: VentusIcons.chevronRight, onTap: onNext),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            for (final w in weekdays)
              Expanded(
                child: Text(
                  w,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w700,
                    color: colors.muted,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var w = 0; w * 7 < cells.length; w++)
          Row(
            children: [
              for (final date in cells.sublist(w * 7, w * 7 + 7))
                Expanded(
                  child: _DayCell(
                    date: date,
                    start: start,
                    end: end,
                    onTap: onTapDay,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  static List<String> _weekdayLabels(String lang) {
    // Monday-first short labels, localized via intl (first letters trimmed).
    final fmt = DateFormat.E(lang);
    // 2024-01-01 is a Monday — walk a known week.
    return [
      for (var i = 0; i < 7; i++)
        _short(fmt.format(DateTime(2024, 1, 1).add(Duration(days: i)))),
    ];
  }

  static String _short(String s) => s.length <= 2 ? s : s.substring(0, 2);
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.start,
    required this.end,
    required this.onTap,
  });

  final DateTime? date;
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onTap;

  bool _same(DateTime? a, DateTime? b) =>
      a != null &&
      b != null &&
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final d = date;
    if (d == null) return const SizedBox(height: 44);

    final isStart = _same(d, start);
    final isEnd = _same(d, end);
    final selectedSingle = start != null && end == null && _same(d, start);
    final inRange =
        start != null && end != null && !d.isBefore(start!) && !d.isAfter(end!);
    final isCap = isStart || isEnd || selectedSingle;

    final radius = BorderRadius.horizontal(
      left: Radius.circular(isStart ? 999 : 0),
      right: Radius.circular(isEnd ? 999 : 0),
    );

    return VentusTap(
      onTap: () => onTap(d),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: inRange ? colors.primarySoft : Colors.transparent,
          borderRadius: radius,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isCap ? colors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${d.day}',
            style: TextStyle(
              fontSize: AppFontSize.body,
              fontWeight: isCap
                  ? FontWeight.w700
                  : (inRange ? FontWeight.w600 : FontWeight.w500),
              color: isCap
                  ? colors.onPrimary
                  : (inRange ? colors.primary : colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    this.flip = false,
    required this.onTap,
  });

  final String icon;
  final bool flip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          boxShadow: context.shadows.card,
        ),
        child: Transform.flip(
          flipX: flip,
          child: VentusIcon(icon, size: 18, color: colors.ink),
        ),
      ),
    );
  }
}
