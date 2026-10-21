import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/storage/app_storage.dart';
import '../domain/destination.dart';
import '../domain/destinations_repository.dart';

/// Reads curated destinations from the public `destinations` Supabase table and
/// resolves each row's storage `image_path` into a public image URL.
class SupabaseDestinationsRepository implements DestinationsRepository {
  static const _table = 'destinations';

  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<Destination>> fetchAll() async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('is_active', true)
        .order('sort_order');
    return rows.map((json) {
      final url = AppStorage.publicUrl(
        StorageBuckets.destinations,
        json['image_path'] as String?,
      );
      return Destination.fromJson(json).copyWith(imageUrl: url);
    }).toList();
  }
}
