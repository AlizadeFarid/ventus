import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/supabase_ai_planner_repository.dart';
import '../domain/ai_planner_repository.dart';

/// Binds [AiPlannerRepository] to the Supabase Edge Function implementation when
/// the backend is configured, falling back to an "unavailable" stub otherwise
/// (AI planning has no offline mode — it needs the server-side Gemini call).
final aiPlannerRepositoryProvider = Provider<AiPlannerRepository>((ref) {
  return Env.isConfigured
      ? SupabaseAiPlannerRepository()
      : UnavailableAiPlannerRepository();
});
