import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/utils/id.dart';
import '../domain/ai_planner_repository.dart';
import '../domain/traveler_type.dart';
import '../domain/trip.dart';
import '../domain/trip_stop.dart';

/// How the user entered the Create Trip flow — search-led (manual) vs the
/// AI-led description screen. Only changes the first step's presentation.
enum CreateTripEntry { manual, ai }

/// Route `extra` for opening Create Trip with a destination already added (from
/// Explore or a place page). The flow keeps that draft instead of resetting it
/// and opens on the travelers step, since "Where?" is already answered.
class CreateTripSeeded {
  const CreateTripSeeded();
}

/// A place added to the in-progress route. [imageUrl] is kept only for the
/// review cover preview; persistence uses [TripStop] (name/country/position).
class DraftStop {
  const DraftStop({
    required this.name,
    required this.country,
    this.imageUrl,
    this.lat,
    this.lon,
  });

  final String name;
  final String country;
  final String? imageUrl;

  /// Coordinates from the place search, carried through to the saved [TripStop]
  /// so the route can be drawn on the map. Null for places without a point.
  final double? lat;
  final double? lon;
}

/// Immutable state of the multi-step Create Trip flow. Built up step by step and
/// turned into a [Trip] on submit.
class CreateTripState {
  const CreateTripState({
    this.entry = CreateTripEntry.manual,
    this.stops = const [],
    this.travelerType = TravelerType.solo,
    this.adults = 1,
    this.children = 0,
    this.startDate,
    this.endDate,
    this.title,
    this.invites = const [],
    this.aiNights,
    this.budgetAmount,
    this.budgetCurrency,
  });

  final CreateTripEntry entry;
  final List<DraftStop> stops;
  final TravelerType travelerType;
  final int adults;
  final int children;
  final DateTime? startDate;
  final DateTime? endDate;

  /// User-edited trip name on the review step; null means "derive from stops".
  final String? title;

  /// Emails to invite as collaborators once the trip is saved (see
  /// [CreateTripController.addInvite]). They become pending collaborators.
  final List<String> invites;

  /// Trip length the AI read from the description. When set, picking a start
  /// date on the Dates step fills the end date by itself.
  final int? aiNights;

  /// Budget the AI read from the description; written to the trip's budget once
  /// it is saved.
  final double? budgetAmount;
  final String? budgetCurrency;

  bool get hasStops => stops.isNotEmpty;
  bool get hasDates => startDate != null && endDate != null;

  /// Composed name from stops, e.g. "Istanbul & Cappadocia".
  String get derivedTitle => stops.map((s) => s.name).join(' & ');

  /// The name actually saved: the user's edit when set, else the derived one.
  String get effectiveTitle {
    final t = title?.trim();
    return (t != null && t.isNotEmpty) ? t : derivedTitle;
  }

  /// The first stop leads the trip (matches hero/card country display).
  String get primaryCountry => stops.isEmpty ? '' : stops.first.country;

  String? get coverPreviewUrl => stops.isEmpty ? null : stops.first.imageUrl;

  int get nights => hasDates ? endDate!.difference(startDate!).inDays : 0;

  CreateTripState copyWith({
    CreateTripEntry? entry,
    List<DraftStop>? stops,
    TravelerType? travelerType,
    int? adults,
    int? children,
    DateTime? startDate,
    DateTime? endDate,
    String? title,
    List<String>? invites,
    int? aiNights,
    double? budgetAmount,
    String? budgetCurrency,
  }) {
    return CreateTripState(
      entry: entry ?? this.entry,
      stops: stops ?? this.stops,
      travelerType: travelerType ?? this.travelerType,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      title: title ?? this.title,
      invites: invites ?? this.invites,
      aiNights: aiNights ?? this.aiNights,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      budgetCurrency: budgetCurrency ?? this.budgetCurrency,
    );
  }
}

/// Owns the in-progress Create Trip state. [start] resets it for a fresh flow;
/// [buildTrip] turns the collected answers into a savable [Trip].
class CreateTripController extends Notifier<CreateTripState> {
  @override
  CreateTripState build() => const CreateTripState();

  /// Begins a new flow from the given [entry] point, clearing any prior input.
  void start(CreateTripEntry entry) => state = CreateTripState(entry: entry);

  /// Switches the destination entry style without discarding collected input
  /// (e.g. "or add places manually" from the AI screen).
  void setEntry(CreateTripEntry entry) => state = state.copyWith(entry: entry);

  void addStop(DraftStop stop) {
    final exists = state.stops.any(
      (s) => s.name.toLowerCase() == stop.name.toLowerCase(),
    );
    if (exists) return;
    state = state.copyWith(stops: [...state.stops, stop]);
  }

  void removeStopAt(int index) {
    if (index < 0 || index >= state.stops.length) return;
    final next = [...state.stops]..removeAt(index);
    state = state.copyWith(stops: next);
  }

  void setTravelerType(TravelerType type) =>
      state = state.copyWith(travelerType: type);

  void setAdults(int value) =>
      state = state.copyWith(adults: value.clamp(1, 20));

  void setChildren(int value) =>
      state = state.copyWith(children: value.clamp(0, 20));

  /// Queues [email] to be invited as a collaborator after the trip is saved.
  /// Ignores blanks and case-insensitive duplicates.
  void addInvite(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return;
    final exists = state.invites.any(
      (e) => e.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return;
    state = state.copyWith(invites: [...state.invites, trimmed]);
  }

  void removeInvite(String email) => state = state.copyWith(
    invites: state.invites.where((e) => e != email).toList(),
  );

  void setDates(DateTime start, DateTime end) =>
      state = state.copyWith(startDate: start, endDate: end);

  /// Clears the chosen dates (e.g. a half-finished range selection), since
  /// [copyWith] can't reset them back to null.
  void clearDates() => state = CreateTripState(
    entry: state.entry,
    stops: state.stops,
    travelerType: state.travelerType,
    adults: state.adults,
    children: state.children,
    title: state.title,
    invites: state.invites,
    aiNights: state.aiNights,
    budgetAmount: state.budgetAmount,
    budgetCurrency: state.budgetCurrency,
  );

  void setTitle(String title) => state = state.copyWith(title: title);

  /// Fills the draft from an AI-parsed [ParsedTrip] (stops + optional dates and
  /// travellers), so the rest of the flow opens pre-populated for the user to
  /// confirm. Stops carry no coordinates here — the AI returns names, not
  /// points — and are geocoded later by [TripGeocodeController] the first time
  /// the trip's map is needed; dates only apply when both ends are present.
  void applyParsed(ParsedTrip parsed) {
    // A start date plus a stated length is as good as a full range.
    DateTime? start = parsed.startDate == null
        ? null
        : _dateOnly(parsed.startDate!);
    DateTime? end = parsed.endDate == null ? null : _dateOnly(parsed.endDate!);
    if (start != null && end == null && parsed.nights != null) {
      end = start.add(Duration(days: parsed.nights!));
    }
    if (start == null || end == null || end.isBefore(start)) {
      start = null;
      end = null;
    }

    state = CreateTripState(
      entry: state.entry,
      stops: [
        for (final s in parsed.stops)
          DraftStop(name: s.name, country: s.country),
      ],
      travelerType: parsed.travelerType ?? state.travelerType,
      // Not mentioned in the text: keep the flow's defaults, don't ask.
      adults: (parsed.adults ?? state.adults).clamp(1, 20),
      children: (parsed.children ?? state.children).clamp(0, 20),
      startDate: start,
      endDate: end,
      title: parsed.title,
      aiNights: parsed.nights,
      budgetAmount: parsed.budgetAmount,
      budgetCurrency: parsed.budgetCurrency,
    );
  }

  /// Builds the [Trip] to persist from the current answers. Caller must ensure
  /// [CreateTripState.hasStops] and [CreateTripState.hasDates] first.
  Trip buildTrip() {
    final s = state;
    final now = DateTime.now();
    final id = newId();
    final userId = Env.isConfigured
        ? Supabase.instance.client.auth.currentUser?.id
        : null;

    final stops = [
      for (var i = 0; i < s.stops.length; i++)
        TripStop(
          id: '$id-$i',
          tripId: id,
          name: s.stops[i].name,
          country: s.stops[i].country,
          position: i,
          lat: s.stops[i].lat,
          lon: s.stops[i].lon,
        ),
    ];

    return Trip(
      id: id,
      userId: userId,
      title: s.effectiveTitle,
      country: s.primaryCountry,
      startDate: _dateOnly(s.startDate!),
      endDate: _dateOnly(s.endDate!),
      adults: s.adults,
      children: s.children,
      travelerType: s.travelerType,
      createdAt: now,
      updatedAt: now,
      stops: stops,
      // Carry the Discover card's photo through as the trip's cover. It was
      // previously shown on the review step and then dropped, so a trip started
      // from a Discover card fell back to the placeholder gradient the moment
      // it was saved. Uploading a cover later overwrites this with a real
      // `trip-covers` object path — [AppStorage.publicUrl] handles both.
      coverImagePath: s.coverPreviewUrl,
    );
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

final createTripControllerProvider =
    NotifierProvider<CreateTripController, CreateTripState>(
      CreateTripController.new,
    );
