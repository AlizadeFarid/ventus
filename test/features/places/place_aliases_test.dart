import 'package:flutter_test/flutter_test.dart';
import 'package:ventus/features/places/domain/place_aliases.dart';

void main() {
  group('resolvePlaceAlias', () {
    test('translates Azerbaijani names the geocoder has never heard of', () {
      // Each of these previously returned nothing, or the wrong country.
      expect(resolvePlaceAlias('Vyetnam'), 'Vietnam');
      expect(resolvePlaceAlias('Fransa'), 'France');
      expect(resolvePlaceAlias('Almaniya'), 'Germany');
      expect(resolvePlaceAlias('Yunanıstan'), 'Greece');
      expect(resolvePlaceAlias('Vyana'), 'Vienna');
      expect(resolvePlaceAlias('Dubay'), 'Dubai');
    });

    test('accepts the Turkish spelling of the same place', () {
      expect(resolvePlaceAlias('Almanya'), 'Germany');
      expect(resolvePlaceAlias('Viyana'), 'Vienna');
      expect(resolvePlaceAlias('Yunanistan'), 'Greece');
    });

    test('ignores case and the local letters', () {
      expect(resolvePlaceAlias('İTALİYA'), 'Italy');
      expect(resolvePlaceAlias('  italiya  '), 'Italy');
      expect(resolvePlaceAlias('Azərbaycan'), 'Azerbaijan');
    });

    test('completes a half-typed name when it can only mean one place', () {
      expect(resolvePlaceAlias('vyetn'), 'Vietnam');
      // Two spellings, one country — still unambiguous.
      expect(resolvePlaceAlias('italy'), 'Italy');
    });

    test('leaves an ambiguous prefix alone', () {
      // "isve" starts both İsveç (Sweden) and İsveçrə (Switzerland).
      expect(resolvePlaceAlias('isve'), isNull);
      // Too short to guess from.
      expect(resolvePlaceAlias('fra'), isNull);
    });

    test('passes through names that are already international', () {
      expect(resolvePlaceAlias('Paris'), isNull);
      expect(resolvePlaceAlias('Malta'), isNull);
      expect(resolvePlaceAlias(''), isNull);
    });
  });
}
