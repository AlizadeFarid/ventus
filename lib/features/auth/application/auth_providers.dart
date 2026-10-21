import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/fake_auth_repository.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/auth_repository.dart';

/// Binds the [AuthRepository] interface to its implementation.
///
/// Uses the real [SupabaseAuthRepository] when the backend is configured, and
/// falls back to [FakeAuthRepository] otherwise (e.g. tests, or running without
/// `env.json`). This single line is the only place the backend is chosen.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return Env.isConfigured ? SupabaseAuthRepository() : FakeAuthRepository();
});
