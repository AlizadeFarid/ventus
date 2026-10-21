import 'package:flutter/widgets.dart';

/// The languages Ventus ships with: English, Azerbaijani, Turkish.
///
/// Kept as a small constant so the locale provider and any language picker
/// share one source of truth, independent of the generated localizations.
abstract final class AppLocales {
  static const en = Locale('en');
  static const az = Locale('az');
  static const tr = Locale('tr');

  static const all = [en, az, tr];

  static bool isSupported(String languageCode) =>
      all.any((l) => l.languageCode == languageCode);
}
