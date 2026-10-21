import 'package:flutter_test/flutter_test.dart';
import 'package:ventus/features/trips/data/drift_itinerary_repository.dart';
import 'package:ventus/features/trips/domain/itinerary_item.dart';

ItineraryItem item({
  required String id,
  int day = 1,
  int? startMinutes,
  int position = 0,
}) {
  return ItineraryItem(
    id: id,
    tripId: 't1',
    day: day,
    startMinutes: startMinutes,
    title: id,
    position: position,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('byDayThenPosition', () {
    test('orders by day first', () {
      final items = [
        item(id: 'b', day: 2, position: 0),
        item(id: 'a', day: 1, position: 5),
      ]..sort(byDayThenPosition);
      expect(items.map((i) => i.id), ['a', 'b']);
    });

    test('position wins over start time, so a drag sticks', () {
      // The user dragged the 14:00 activity above the 09:00 one. Before
      // position led the comparator, the list snapped straight back.
      final items = [
        item(id: 'morning', startMinutes: 9 * 60, position: 1),
        item(id: 'afternoon', startMinutes: 14 * 60, position: 0),
      ]..sort(byDayThenPosition);
      expect(items.map((i) => i.id), ['afternoon', 'morning']);
    });

    test('falls back to start time when positions tie', () {
      final items = [
        item(id: 'late', startMinutes: 18 * 60),
        item(id: 'early', startMinutes: 8 * 60),
      ]..sort(byDayThenPosition);
      expect(items.map((i) => i.id), ['early', 'late']);
    });

    test('untimed activities sort after timed ones at the same position', () {
      final items = [
        item(id: 'untimed'),
        item(id: 'timed', startMinutes: 20 * 60),
      ]..sort(byDayThenPosition);
      expect(items.map((i) => i.id), ['timed', 'untimed']);
    });
  });

  group('positionForNewItem', () {
    final day = [
      item(id: 'a', startMinutes: 9 * 60, position: 0),
      item(id: 'b', startMinutes: 15 * 60, position: 1),
      item(id: 'c', position: 2),
    ];

    test('a timed activity slots in ahead of the first later one', () {
      expect(positionForNewItem(day, 12 * 60), 1);
    });

    test('an earlier activity goes first', () {
      expect(positionForNewItem(day, 7 * 60), 0);
    });

    test('a later activity goes ahead of the untimed tail', () {
      expect(positionForNewItem(day, 18 * 60), 2);
    });

    test('an untimed activity appends', () {
      expect(positionForNewItem(day, null), 3);
    });

    test('the first activity of a day is position 0', () {
      expect(positionForNewItem(const [], 9 * 60), 0);
      expect(positionForNewItem(const [], null), 0);
    });
  });
}
