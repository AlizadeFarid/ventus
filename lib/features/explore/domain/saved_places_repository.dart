import 'saved_place.dart';

/// Contract for the user's saved (hearted) destinations. Local-first like the
/// trip features: read from Drift (works offline), mirrored to Supabase.
abstract interface class SavedPlacesRepository {
  /// Streams the saved places, newest first.
  Stream<List<SavedPlace>> watch();

  /// Saves [place] locally then remotely.
  Future<void> save(SavedPlace place);

  /// Removes a saved destination by its id, locally then remotely.
  Future<void> remove(String destinationId);

  /// Pulls remote saves into local storage once. No-op without a backend.
  Future<void> sync();
}
