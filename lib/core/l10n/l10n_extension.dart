import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Ergonomic access to the generated localizations: `context.l10n.yourTrips`
/// instead of `AppLocalizations.of(context).yourTrips`.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// The active language code (e.g. 'en', 'az', 'tr') — handy for resolving
  /// localized data fetched from the backend.
  String get languageCode => Localizations.localeOf(this).languageCode;
}
