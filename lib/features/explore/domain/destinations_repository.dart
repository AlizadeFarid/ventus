import 'destination.dart';

/// Contract for fetching curated Discover destinations.
///
/// Explore content is online (see the local-first decision): it is read from
/// the backend, not stored in Drift. A fake implementation backs offline/dev.
abstract interface class DestinationsRepository {
  /// Returns the active destinations, in display order.
  Future<List<Destination>> fetchAll();
}
