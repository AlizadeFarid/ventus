import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_provider.dart';

import '../data/photon_places_repository.dart';
import '../domain/place_suggestion.dart';
import '../domain/places_repository.dart';

/// Minimum characters before a network search fires (Google-Maps-like).
const kPlaceSearchMinChars = 3;

/// The active place-search provider. Single binding to swap geocoders.
final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  final repo = PhotonPlacesRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

/// Debounced autocomplete suggestions for [query].
///
/// Returns an empty list below [kPlaceSearchMinChars] and waits ~300ms before
/// hitting the network: while the user keeps typing, this provider is disposed
/// and re-created per keystroke, so the delay of a superseded query never
/// resolves and only the settled query reaches the network.
final placeSuggestionsProvider = FutureProvider.autoDispose
    .family<List<PlaceSuggestion>, String>((ref, query) async {
      final q = query.trim();
      if (q.length < kPlaceSearchMinChars) return const [];

      final completer = Completer<void>();
      final timer = Timer(
        const Duration(milliseconds: 300),
        completer.complete,
      );
      ref.onDispose(timer.cancel);
      await completer.future;

      final locale = ref.watch(localeProvider);
      final langCode =
          locale?.languageCode ??
          ui.PlatformDispatcher.instance.locale.languageCode;

      return ref
          .watch(placesRepositoryProvider)
          .search(q, languageCode: langCode);
    });
