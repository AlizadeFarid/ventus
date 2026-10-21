import 'package:flutter_test/flutter_test.dart';
import 'package:ventus/features/trips/domain/itinerary_item.dart';
import 'package:ventus/features/trips/domain/trip_progress.dart';

ItineraryItem _item(int day) => ItineraryItem(
  id: 'a$day-${DateTime.now().microsecondsSinceEpoch}',
  tripId: 't1',
  day: day,
  title: 'Activity',
  createdAt: DateTime(2026, 1, 1),
);

List<ItineraryItem> _plan(Map<int, int> activitiesByDay) => [
  for (final entry in activitiesByDay.entries)
    for (var i = 0; i < entry.value; i++) _item(entry.key),
];

void main() {
  group('plannedPercentFor', () {
    test('an empty plan is 0%', () {
      expect(plannedPercentFor(dayCount: 5, items: const []), 0);
    });

    test('a day counts fully once it has three activities', () {
      // 1 of 2 days planned to the full three.
      expect(plannedPercentFor(dayCount: 2, items: _plan({1: 3})), 50);
      // More than three doesn't push it past that day's share.
      expect(plannedPercentFor(dayCount: 2, items: _plan({1: 8})), 50);
    });

    test('a partly filled day counts partly', () {
      // One activity on one of two days: a third of half the trip.
      expect(plannedPercentFor(dayCount: 2, items: _plan({1: 1})), 17);
      expect(plannedPercentFor(dayCount: 2, items: _plan({1: 2})), 33);
    });

    test('a full plan is 100%', () {
      expect(
        plannedPercentFor(dayCount: 3, items: _plan({1: 3, 2: 4, 3: 3})),
        100,
      );
    });

    test('activities outside the trip length are ignored', () {
      expect(plannedPercentFor(dayCount: 2, items: _plan({7: 3})), 0);
    });

    test('a trip with no days never divides by zero', () {
      expect(plannedPercentFor(dayCount: 0, items: _plan({1: 3})), 0);
    });
  });
}
