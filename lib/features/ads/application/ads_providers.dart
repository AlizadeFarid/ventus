import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/fake_ads_repository.dart';
import '../data/supabase_ads_repository.dart';
import '../domain/ad.dart';
import '../domain/ads_repository.dart';

/// Binds [AdsRepository] to Supabase when configured, else the fake.
final adsRepositoryProvider = Provider<AdsRepository>((ref) {
  return Env.isConfigured ? SupabaseAdsRepository() : FakeAdsRepository();
});

/// Active sponsored ads for the Home banner. On failure (e.g. offline) it
/// resolves to an empty list so the dashboard degrades gracefully.
final adsProvider = FutureProvider<List<Ad>>((ref) async {
  try {
    return await ref.watch(adsRepositoryProvider).fetchAll();
  } catch (_) {
    return const [];
  }
});
