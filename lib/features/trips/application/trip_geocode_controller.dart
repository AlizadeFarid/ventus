import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_provider.dart';
import '../../../core/utils/geo.dart';
import '../../places/application/place_search_providers.dart';
import '../../places/domain/place_suggestion.dart';
import '../../places/domain/places_repository.dart';
import '../domain/itinerary_item.dart';
import '../domain/trip_stop.dart';
import 'itinerary_providers.dart';
import 'trip_detail_providers.dart';
import 'trips_providers.dart';

/// How many places one run may look up, so a very long plan can't turn into a
/// runaway sequence of geocoder calls.
const _kMaxLookupsPerRun = 60;

/// Pause between geocoder calls — Photon is free and key-less, so we stay a
/// polite client rather than firing a whole plan at it at once.
const _kLookupGap = Duration(milliseconds: 250);

/// What a geocoding run managed to locate, so the UI can report it.
class GeocodeOutcome {
  const GeocodeOutcome({required this.located, required this.stillMissing});

  /// Places that gained coordinates in this run.
  final int located;

  /// Places that still have no point (unknown venue, offline, bad text).
  final int stillMissing;

  bool get isEmpty => located == 0 && stillMissing == 0;
}

/// Fills in the map coordinates a trip is missing: first its route stops (so
/// the map has an anchor), then each day-plan activity, biased towards those
/// stops.
///
/// Activities arrive from the AI planner (and from manual entry) as free text —
/// "Wat Pho", "Chatuchak market" — with no location attached, which is why the
/// Map tab used to stay empty on a freshly generated trip. This resolves that
/// text through the same free Photon/OSM geocoder the Create Trip search uses,
/// then persists the points so the work happens once per place.
class TripGeocodeController extends AsyncNotifier<void> {
  /// Runs in flight, keyed by trip. The Map tab auto-starts a run and the AI
  /// planner starts one right after generating, so the same trip can be asked
  /// twice within seconds — both callers then share the one set of lookups.
  final _inFlight = <String, Future<GeocodeOutcome>>{};

  @override
  FutureOr<void> build() {}

  /// Resolves every stop and activity of [tripId] that has no coordinates yet.
  /// Returns what it managed to locate; throws only when the trip is missing.
  Future<GeocodeOutcome> resolveMissing(String tripId) {
    final running = _inFlight[tripId];
    if (running != null) return running;

    final run = _run(tripId);
    _inFlight[tripId] = run;
    return run.whenComplete(() => _inFlight.remove(tripId));
  }

  Future<GeocodeOutcome> _run(String tripId) async {
    state = const AsyncLoading();
    try {
      final outcome = await _resolve(tripId);
      state = const AsyncData(null);
      return outcome;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<GeocodeOutcome> _resolve(String tripId) async {
    final tripsRepo = ref.read(tripsRepositoryProvider);
    final trip = await tripsRepo.getTrip(tripId);
    if (trip == null) return const GeocodeOutcome(located: 0, stillMissing: 0);

    final places = ref.read(placesRepositoryProvider);
    final lang = _languageCode();
    var budget = _kMaxLookupsPerRun;
    var located = 0;
    var missing = 0;

    // 1. Route stops. These double as the bias point for every activity, so
    //    they go first even when the user only cares about the day plan.
    final stops = <TripStop>[...trip.stops];
    var stopsChanged = false;
    for (var i = 0; i < stops.length; i++) {
      final stop = stops[i];
      if (stop.hasCoords || stop.name.trim().isEmpty) continue;
      if (budget <= 0) break;
      budget--;
      final hit = await _lookupCity(places, stop, lang);
      if (hit?.lat != null && hit?.lon != null) {
        stops[i] = stop.copyWith(lat: hit!.lat, lon: hit.lon);
        stopsChanged = true;
        located++;
      } else {
        missing++;
      }
    }
    if (stopsChanged) {
      await tripsRepo.saveTrip(trip.copyWith(stops: stops));
      // Stops aren't streamed (the hub loads them once per visit), so the
      // screen only sees the new points if we invalidate that read.
      ref.invalidate(tripDetailProvider(tripId));
    }

    // 2. Day-plan activities, biased towards the stops we now know.
    final anchors = [
      for (final s in stops)
        if (s.hasCoords) s,
    ];
    final items = await ref
        .read(itineraryRepositoryProvider)
        .watch(tripId)
        .first;
    final updated = <ItineraryItem>[];
    for (final item in items) {
      if (item.hasCoords) continue;
      if (item.geocodeQuery.isEmpty) continue;
      if (budget <= 0) break;
      budget--;
      final hit = await _lookupActivity(places, item, anchors, lang);
      if (hit?.lat != null && hit?.lon != null) {
        updated.add(item.copyWith(lat: hit!.lat, lon: hit.lon));
        located++;
      } else {
        missing++;
      }
    }
    if (updated.isNotEmpty) {
      await ref.read(itineraryRepositoryProvider).saveAll(updated);
    }

    return GeocodeOutcome(located: located, stillMissing: missing);
  }

  /// Looks a city-level stop up. Uses the place-filtered search (cities only),
  /// falling back to the bare name when "name, country" finds nothing.
  Future<PlaceSuggestion?> _lookupCity(
    PlacesRepository places,
    TripStop stop,
    String lang,
  ) async {
    final name = stop.name.trim();
    final country = stop.country.trim();
    try {
      await Future<void>.delayed(_kLookupGap);
      final query = country.isEmpty ? name : '$name, $country';
      final hits = await places.search(query, languageCode: lang);
      final hit = _firstLocated(hits);
      if (hit != null) return hit;
      if (country.isEmpty) return null;
      await Future<void>.delayed(_kLookupGap);
      return _firstLocated(await places.search(name, languageCode: lang));
    } catch (e) {
      developer.log('stop lookup failed for "$name": $e', name: 'TripGeocode');
      return null;
    }
  }

  /// Looks a single activity up, biased towards the [anchors] (the trip's
  /// located stops) so a venue name resolves inside the right city. Anchors are
  /// tried in route order: a multi-city trip finds its Rome stop from Rome.
  Future<PlaceSuggestion?> _lookupActivity(
    PlacesRepository places,
    ItineraryItem item,
    List<TripStop> anchors,
    String lang,
  ) async {
    final query = item.geocodeQuery;
    try {
      if (anchors.isEmpty) {
        await Future<void>.delayed(_kLookupGap);
        return await places.resolve(query, languageCode: lang);
      }
      for (final anchor in anchors) {
        await Future<void>.delayed(_kLookupGap);
        final hit = await places.resolve(
          query,
          languageCode: lang,
          nearLat: anchor.lat,
          nearLon: anchor.lon,
          context: anchor.name,
        );
        if (hit != null) return hit;
      }
      return null;
    } catch (e) {
      developer.log(
        'activity lookup failed for "$query": $e',
        name: 'TripGeocode',
      );
      return null;
    }
  }

  PlaceSuggestion? _firstLocated(List<PlaceSuggestion> hits) {
    for (final hit in hits) {
      if (hit.lat != null && hit.lon != null) return hit;
    }
    return null;
  }

  String _languageCode() =>
      ref.read(localeProvider)?.languageCode ??
      ui.PlatformDispatcher.instance.locale.languageCode;
}

final tripGeocodeControllerProvider =
    AsyncNotifierProvider<TripGeocodeController, void>(
      TripGeocodeController.new,
    );

/// Fills in a trip's missing coordinates once when its Map tab is opened, so a
/// freshly AI-generated plan draws itself without the user asking. Skips the
/// network entirely when everything is already located.
final tripAutoGeocodeProvider = FutureProvider.autoDispose
    .family<GeocodeOutcome, String>((ref, tripId) async {
      final trip = await ref.read(tripsRepositoryProvider).getTrip(tripId);
      if (trip == null)
        return const GeocodeOutcome(located: 0, stillMissing: 0);

      final items = await ref
          .read(itineraryRepositoryProvider)
          .watch(tripId)
          .first;
      final pendingStops = trip.stops.any(
        (s) => !s.hasCoords && s.name.trim().isNotEmpty,
      );
      final pendingItems = items.any(
        (i) => !i.hasCoords && i.geocodeQuery.isNotEmpty,
      );
      if (!pendingStops && !pendingItems) {
        return const GeocodeOutcome(located: 0, stillMissing: 0);
      }

      return ref
          .read(tripGeocodeControllerProvider.notifier)
          .resolveMissing(tripId);
    });

/// Straight-line distance in km along [points], in the order given. Used for a
/// day's "~4.2 km" summary; 0 for fewer than two points.
double routeLengthKm(List<({double lat, double lon})> points) {
  var total = 0.0;
  for (var i = 1; i < points.length; i++) {
    total += distanceKm(
      points[i - 1].lat,
      points[i - 1].lon,
      points[i].lat,
      points[i].lon,
    );
  }
  return total;
}
