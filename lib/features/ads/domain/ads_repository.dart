import 'ad.dart';

/// Contract for fetching sponsored Home ads.
///
/// Ad content is online (see the local-first decision): read from the backend,
/// not stored in Drift. A fake implementation backs offline/dev.
abstract interface class AdsRepository {
  /// Returns the active ads, in display order.
  Future<List<Ad>> fetchAll();
}
