import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ventus/core/theme/app_theme.dart';
import 'package:ventus/features/trips/application/budget_providers.dart';
import 'package:ventus/features/trips/application/checklist_providers.dart';
import 'package:ventus/features/trips/application/documents_providers.dart';
import 'package:ventus/features/trips/application/itinerary_providers.dart';
import 'package:ventus/features/trips/application/trip_detail_providers.dart';
import 'package:ventus/features/trips/domain/itinerary_item.dart';
import 'package:ventus/features/trips/domain/trip.dart';
import 'package:ventus/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:ventus/l10n/app_localizations.dart';

void main() {
  testWidgets('trip hub overview renders with a planned trip', (tester) async {
    final now = DateTime(2026, 11, 1);
    final trip = Trip(
      id: 't1',
      title: 'France',
      country: 'France',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 34)),
      createdAt: now,
      updatedAt: now,
    );
    final item = ItineraryItem(
      id: 'i1',
      tripId: 't1',
      day: 1,
      startMinutes: 540,
      title: 'Rome walk',
      place: 'Rome',
      createdAt: now,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripDetailProvider('t1').overrideWith((ref) async => trip),
          itinerarySyncProvider('t1').overrideWith((ref) async {}),
          checklistSyncProvider('t1').overrideWith((ref) async {}),
          documentsSyncProvider('t1').overrideWith((ref) async {}),
          budgetSyncProvider('t1').overrideWith((ref) async {}),
          itineraryProvider('t1').overrideWith((ref) => Stream.value([item])),
          checklistProvider('t1').overrideWith((ref) => Stream.value([])),
          documentsProvider('t1').overrideWith((ref) => Stream.value([])),
          tripBudgetProvider('t1').overrideWith((ref) => Stream.value(null)),
          expensesProvider('t1').overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('az'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const TripDetailScreen(tripId: 't1'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    expect(find.text('Hazırlıq'), findsOneWidget);
  });
}
