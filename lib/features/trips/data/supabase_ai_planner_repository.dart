import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/ai_planner_repository.dart';
import '../domain/trip.dart';

/// [AiPlannerRepository] backed by the `generate-itinerary` Supabase Edge
/// Function, which proxies Google Gemini server-side (the API key never reaches
/// the client). Returns plain [GeneratedActivity] drafts; persistence is the
/// caller's job, keeping this stateless and aligned with local-first storage.
class SupabaseAiPlannerRepository implements AiPlannerRepository {
  static const _function = 'generate-itinerary';

  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<GeneratedActivity>> generateItinerary(
    Trip trip, {
    required String language,
  }) async {
    try {
      final res = await _client.functions.invoke(
        _function,
        body: {
          'language': language,
          'trip': {
            'title': trip.title,
            'country': trip.country,
            'stops': [
              for (final s in trip.stops)
                {'name': s.name, 'country': s.country},
            ],
            'startDate': trip.startDate.toIso8601String().split('T').first,
            'endDate': trip.endDate.toIso8601String().split('T').first,
            'nights': trip.nights,
            'dayCount': trip.nights + 1,
            'travelerType': trip.travelerType?.name,
            'adults': trip.adults,
            'children': trip.children,
          },
        },
      );

      final data = res.data;
      if (data is! Map || data['activities'] is! List) {
        throw AiPlannerException(
          'Unexpected response from planner',
          code: AiPlannerErrorCode.empty,
        );
      }

      final activities = [
        for (final raw in data['activities'] as List)
          if (raw is Map<String, dynamic>) GeneratedActivity.fromJson(raw),
      ].where((a) => a.title.isNotEmpty).toList();

      if (activities.isEmpty) {
        throw AiPlannerException(
          'The planner returned an empty plan',
          code: AiPlannerErrorCode.empty,
        );
      }
      return activities;
    } on FunctionException catch (e) {
      developer.log(
        'generate-itinerary failed: status=${e.status} details=${e.details}',
        name: 'AiPlanner',
      );
      throw AiPlannerException(
        'Planner function failed (${e.status}): ${e.details}',
        code: AiPlannerErrorCode.network,
      );
    } on AiPlannerException {
      rethrow;
    } catch (e) {
      throw AiPlannerException('$e', code: AiPlannerErrorCode.unknown);
    }
  }

  @override
  Future<ParsedTrip> parseTrip(
    String description, {
    required String language,
  }) async {
    try {
      final res = await _client.functions.invoke(
        'parse-trip',
        body: {
          'description': description,
          'language': language,
          'today': DateTime.now().toIso8601String().split('T').first,
        },
      );

      final data = res.data;
      if (data is! Map || data['stops'] is! List) {
        throw AiPlannerException(
          'Unexpected response from planner',
          code: AiPlannerErrorCode.empty,
        );
      }

      final parsed = ParsedTrip.fromJson(Map<String, dynamic>.from(data));
      if (parsed.stops.isEmpty) {
        throw AiPlannerException(
          'Could not find any places in the description',
          code: AiPlannerErrorCode.empty,
        );
      }
      return parsed;
    } on FunctionException catch (e) {
      developer.log(
        'parse-trip failed: status=${e.status} details=${e.details}',
        name: 'AiPlanner',
      );
      throw AiPlannerException(
        'Parser function failed (${e.status}): ${e.details}',
        code: AiPlannerErrorCode.network,
      );
    } on AiPlannerException {
      rethrow;
    } catch (e) {
      throw AiPlannerException('$e', code: AiPlannerErrorCode.unknown);
    }
  }
}

/// Fallback used when the backend isn't configured (offline dev / plain tests):
/// AI planning needs the server, so it always reports "not configured".
class UnavailableAiPlannerRepository implements AiPlannerRepository {
  @override
  Future<List<GeneratedActivity>> generateItinerary(
    Trip trip, {
    required String language,
  }) async {
    throw AiPlannerException(
      'AI planner needs a configured backend',
      code: AiPlannerErrorCode.notConfigured,
    );
  }

  @override
  Future<ParsedTrip> parseTrip(
    String description, {
    required String language,
  }) async {
    throw AiPlannerException(
      'AI planner needs a configured backend',
      code: AiPlannerErrorCode.notConfigured,
    );
  }
}
