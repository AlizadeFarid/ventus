import 'itinerary_item.dart';
import 'trip.dart';

/// Number of days a trip's plan spans: the trip's length (nights + 1), but
/// never fewer than the highest day any activity is already on, and at least 1.
int itineraryDayCount(Trip? trip, List<ItineraryItem> items) {
  final fromDates = trip == null ? 1 : trip.nights + 1;
  final fromItems = items.isEmpty
      ? 1
      : items.map((i) => i.day).reduce((a, b) => a > b ? a : b);
  return [fromDates, fromItems, 1].reduce((a, b) => a > b ? a : b);
}

/// How many activities a day needs before it counts as fully planned.
///
/// Three is what a realistic day looks like in practice (morning, lunch,
/// afternoon) and it's what the AI planner aims for, so a day that reaches it
/// shouldn't keep nagging the user for more.
const kActivitiesForAPlannedDay = 3;

/// The "% planned" figure shown on the trip card and the Trip Hub cover.
///
/// Grades each day rather than counting it planned or not: a day with one
/// activity is a third of the way there, a day with three or more is done. The
/// trip's figure is the average across all its days, so it moves steadily as
/// the user fills the plan in instead of jumping 20% for a single entry.
///
/// Deliberately about the day plan alone — it sits next to the label "planned",
/// so folding the checklist or the budget into it would make the number mean
/// something the label doesn't say.
int plannedPercentFor({
  required int dayCount,
  required List<ItineraryItem> items,
}) {
  if (dayCount <= 0) return 0;

  final countByDay = <int, int>{};
  for (final item in items) {
    if (item.day < 1 || item.day > dayCount) continue;
    countByDay.update(item.day, (n) => n + 1, ifAbsent: () => 1);
  }
  if (countByDay.isEmpty) return 0;

  var score = 0.0;
  for (final count in countByDay.values) {
    score += (count / kActivitiesForAPlannedDay).clamp(0.0, 1.0);
  }
  return (score / dayCount * 100).round().clamp(0, 100);
}
