import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/fake_destinations_repository.dart';
import '../data/supabase_destinations_repository.dart';
import '../domain/destination.dart';
import '../domain/destinations_repository.dart';

/// Binds [DestinationsRepository] to Supabase when configured, else the fake.
final destinationsRepositoryProvider = Provider<DestinationsRepository>((ref) {
  return Env.isConfigured
      ? SupabaseDestinationsRepository()
      : FakeDestinationsRepository();
});

/// Curated Discover destinations. On failure (e.g. offline) it resolves to an
/// empty list so the dashboard degrades gracefully instead of erroring.
final destinationsProvider = FutureProvider<List<Destination>>((ref) async {
  try {
    return await ref.watch(destinationsRepositoryProvider).fetchAll();
  } catch (_) {
    return const [];
  }
});
