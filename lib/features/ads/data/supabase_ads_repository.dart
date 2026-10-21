import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/ad.dart';
import '../domain/ads_repository.dart';

/// Reads active sponsored ads from the public `ads` Supabase table, ordered by
/// `sort_order`. Each row carries a full `image_url`.
class SupabaseAdsRepository implements AdsRepository {
  static const _table = 'ads';

  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<Ad>> fetchAll() async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('is_active', true)
        .order('sort_order');
    return rows.map(Ad.fromJson).toList();
  }
}
