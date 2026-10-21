import 'activity_kind.dart';
import 'traveler_type.dart';
import 'trip.dart';

/// One activity returned by the AI planner, before it becomes a persisted
/// [ItineraryItem]. Intentionally light — no id/tripId/position yet; the
/// controller assigns those when saving.
class GeneratedActivity {
  const GeneratedActivity({
    required this.day,
    required this.title,
    this.startMinutes,
    this.place,
    this.kind = ActivityKind.activity,
  });

  /// 1-based index into the trip's date range.
  final int day;
  final String title;

  /// Minutes from midnight (0..1439), or null for an untimed activity.
  final int? startMinutes;
  final String? place;
  final ActivityKind kind;

  factory GeneratedActivity.fromJson(Map<String, dynamic> json) {
    return GeneratedActivity(
      day: (json['day'] as num?)?.toInt() ?? 1,
      title: (json['title'] as String?)?.trim() ?? '',
      startMinutes: (json['startMinutes'] as num?)?.toInt(),
      place: (json['place'] as String?)?.trim().isNotEmpty == true
          ? (json['place'] as String).trim()
          : null,
      kind: _kindFromName(json['kind'] as String?),
    );
  }
}

ActivityKind _kindFromName(String? name) {
  for (final kind in ActivityKind.values) {
    if (kind.name == name) return kind;
  }
  return ActivityKind.activity;
}

/// A single place parsed from a free-text trip description.
class ParsedStop {
  const ParsedStop({required this.name, this.country = ''});

  final String name;
  final String country;

  factory ParsedStop.fromJson(Map<String, dynamic> json) => ParsedStop(
    name: (json['name'] as String?)?.trim() ?? '',
    country: (json['country'] as String?)?.trim() ?? '',
  );
}

/// A structured draft extracted from a free-text trip description, used to
/// pre-fill the Create Trip flow. Every field beyond [stops] is best-effort.
class ParsedTrip {
  const ParsedTrip({
    required this.stops,
    this.title,
    this.startDate,
    this.endDate,
    this.travelerType,
    this.adults,
    this.children,
    this.nights,
    this.budgetAmount,
    this.budgetCurrency,
  });

  final List<ParsedStop> stops;
  final String? title;
  final DateTime? startDate;
  final DateTime? endDate;
  final TravelerType? travelerType;

  /// Null when the description didn't say — the flow then keeps its defaults
  /// instead of asking.
  final int? adults;
  final int? children;

  /// Trip length stated in the text; lets the flow ask only for a start date.
  final int? nights;

  /// Total budget stated in the text, applied to the trip once it's saved.
  final double? budgetAmount;
  final String? budgetCurrency;

  factory ParsedTrip.fromJson(Map<String, dynamic> json) {
    final rawStops = (json['stops'] as List?) ?? const [];
    return ParsedTrip(
      stops: [
        for (final s in rawStops)
          if (s is Map<String, dynamic>) ParsedStop.fromJson(s),
      ].where((s) => s.name.isNotEmpty).toList(),
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : null,
      startDate: _date(json['startDate']),
      endDate: _date(json['endDate']),
      travelerType: _travelerType(json['travelerType'] as String?),
      adults: (json['adults'] as num?)?.toInt(),
      children: (json['children'] as num?)?.toInt(),
      nights: (json['nights'] as num?)?.toInt(),
      budgetAmount: (json['budgetAmount'] as num?)?.toDouble(),
      budgetCurrency: json['budgetCurrency'] as String?,
    );
  }
}

DateTime? _date(dynamic v) {
  if (v is! String || v.isEmpty) return null;
  return DateTime.tryParse(v);
}

TravelerType? _travelerType(String? name) {
  if (name == null) return null;
  for (final t in TravelerType.values) {
    if (t.name == name) return t;
  }
  return null;
}

/// Contract for AI-assisted trip planning, independent of the provider behind
/// it (today a Supabase Edge Function calling Gemini). Kept behind an interface
/// so the model/transport can be swapped without touching the UI.
abstract interface class AiPlannerRepository {
  /// Generates a day-by-day plan for [trip]. [language] is a locale code (e.g.
  /// `az`) so the activities come back in the user's language. Throws
  /// [AiPlannerException] when generation can't complete.
  Future<List<GeneratedActivity>> generateItinerary(
    Trip trip, {
    required String language,
  });

  /// Parses a free-text [description] into a draft trip (stops + optional dates
  /// and travellers). [language] localises the suggested title. Throws
  /// [AiPlannerException] when parsing can't complete.
  Future<ParsedTrip> parseTrip(String description, {required String language});
}

/// Raised when the AI planner can't produce a plan (network, backend, or an
/// unconfigured/offline environment). Carries an optional [code] so the UI can
/// localise the message.
class AiPlannerException implements Exception {
  AiPlannerException(this.message, {this.code});

  final String message;
  final AiPlannerErrorCode? code;

  @override
  String toString() => 'AiPlannerException($code): $message';
}

/// Coarse failure categories the UI maps to a localised message.
enum AiPlannerErrorCode { notConfigured, network, empty, unknown }
