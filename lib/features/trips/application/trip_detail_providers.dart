import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/trip.dart';
import 'trips_providers.dart';

/// Loads a single trip with its route stops hydrated, for the Trip Hub screen.
///
/// Unlike [tripsProvider] (the dashboard stream, which leaves `stops` empty to
/// stay light), this goes through [TripsRepository.getTrip], which reads the
/// trip's stops from their own table. `autoDispose` so the trip isn't held in
/// memory after the user leaves the screen; `family` keys it by trip id.
final tripDetailProvider = FutureProvider.autoDispose.family<Trip?, String>(
  (ref, id) => ref.watch(tripsRepositoryProvider).getTrip(id),
);
