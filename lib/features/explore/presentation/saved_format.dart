import '../domain/destination.dart';
import '../domain/saved_place.dart';

/// Builds a [SavedPlace] snapshot from a [Destination] in the active [lang], so
/// the Saved tab stays readable offline and independent of the live catalogue.
SavedPlace savedPlaceFrom(Destination d, String lang) => SavedPlace(
  destinationId: d.id,
  name: d.nameFor(lang),
  country: d.countryFor(lang),
  imageUrl: d.imageUrl,
  createdAt: DateTime.now(),
);
