import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination.freezed.dart';
part 'destination.g.dart';

/// A curated Discover/Explore destination.
///
/// This is online content managed in Supabase (not local-first user data).
/// Localized fields are stored as `{ 'en': ..., 'az': ..., 'tr': ... }` maps
/// (Postgres `jsonb`), resolved to the active language in the UI.
@freezed
abstract class Destination with _$Destination {
  const Destination._();

  const factory Destination({
    required String id,
    required Map<String, String> name,
    required Map<String, String> country,
    @Default(<String, String>{}) Map<String, String> description,
    @JsonKey(name: 'image_url') String? imageUrl,
    // Quick facts (localized; timezone is a plain label like "GMT+3").
    @Default(<String, String>{}) Map<String, String> currency,
    @Default(<String, String>{}) Map<String, String> language,
    @JsonKey(name: 'best_time')
    @Default(<String, String>{})
    Map<String, String> bestTime,
    String? timezone,
    // "Good to know" tips.
    @Default(<DestinationTip>[]) List<DestinationTip> tips,
  }) = _Destination;

  factory Destination.fromJson(Map<String, dynamic> json) =>
      _$DestinationFromJson(json);

  String nameFor(String languageCode) => _pick(name, languageCode);
  String countryFor(String languageCode) => _pick(country, languageCode);
  String descriptionFor(String languageCode) =>
      _pick(description, languageCode);
  String currencyFor(String languageCode) => _pick(currency, languageCode);
  String languageFor(String languageCode) => _pick(language, languageCode);
  String bestTimeFor(String languageCode) => _pick(bestTime, languageCode);

  /// True when there's at least one quick fact to show.
  bool get hasFacts =>
      currency.isNotEmpty ||
      language.isNotEmpty ||
      bestTime.isNotEmpty ||
      (timezone != null && timezone!.isNotEmpty);

  /// Resolves a localized value, falling back to English then any available
  /// translation so a missing language never renders blank.
  static String _pick(Map<String, String> values, String languageCode) {
    return values[languageCode] ??
        values['en'] ??
        (values.isEmpty ? '' : values.values.first);
  }
}

/// A single "Good to know" tip: an icon plus a localized title and body.
@freezed
abstract class DestinationTip with _$DestinationTip {
  const DestinationTip._();

  const factory DestinationTip({
    @Default('note') String icon,
    @Default(<String, String>{}) Map<String, String> title,
    @Default(<String, String>{}) Map<String, String> body,
  }) = _DestinationTip;

  factory DestinationTip.fromJson(Map<String, dynamic> json) =>
      _$DestinationTipFromJson(json);

  String titleFor(String languageCode) =>
      Destination._pick(title, languageCode);
  String bodyFor(String languageCode) => Destination._pick(body, languageCode);
}
