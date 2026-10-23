import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/refresh.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../places/application/place_search_providers.dart';
import '../../../places/domain/place_suggestion.dart';
import '../../../trips/application/create_trip_controller.dart';
import '../../../trips/presentation/widgets/trip_photo.dart';
import '../../application/destinations_providers.dart';
import '../../application/saved_controller.dart';
import '../../application/saved_providers.dart';
import '../../domain/destination.dart';
import '../saved_format.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Explore / Discover full screen (prototype `Explore.jsx`, adapted to our
/// city-level `destinations`): a searchable grid of places to save and open.
/// The heart saves to Saved, and the header heart opens that list.
///
/// Search runs in two tiers. Typing filters the curated Ventus destinations
/// instantly and offline; past [kPlaceSearchMinChars] it *also* queries the
/// OpenStreetMap geocoder already used by Create Trip, so a city we don't
/// curate is still findable — it just starts a trip instead of opening a
/// (non-existent) destination page. Before this the screen had a search-shaped
/// bar that only opened the AI planner, so Home's "Where to?" led somewhere the
/// user could not actually search.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key, this.autofocusSearch = false});

  /// Open with the keyboard up — set when arriving from a search field.
  final bool autofocusSearch;

  /// Curated destinations whose name or country contains the query, in the
  /// active language.
  static List<Destination> _filter(
    List<Destination> all,
    String query,
    String lang,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return [
      for (final d in all)
        if (d.nameFor(lang).toLowerCase().contains(q) ||
            d.countryFor(lang).toLowerCase().contains(q))
          d,
    ];
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    String query, {
    required bool showAsk,
  }) {
    final colors = context.colors;
    final l10n = context.l10n;
    final lang = context.languageCode;
    final destinations = ref.watch(destinationsProvider);
    return destinations.when(
      loading: () => const _GridSkeleton(),
      error: (_, _) => Center(
        child: Text(l10n.toolsOffline, style: TextStyle(color: colors.muted)),
      ),
      data: (all) => RefreshIndicator(
        onRefresh: () =>
            refreshQuietly(() => ref.refresh(destinationsProvider.future)),
        child: _Results(
          query: query.trim(),
          matches: _filter(all, query, lang),
          hasAnyCurated: all.isNotEmpty,
          showAsk: showAsk,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    ref.watch(savedSyncProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(onOpenSaved: () => context.push(AppRoutes.saved)),
            const SizedBox(height: 8),
            Expanded(
              child: VentusSearchLayout(
                autofocus: autofocusSearch,
                hintText: context.l10n.exploreSearchHint,
                // Searching: the same grid/results, filtered, without the AI
                // shortcut (it is an alternative to searching).
                resultsBuilder: (context, query, close) =>
                    _content(context, ref, query, showAsk: false),
                child: _content(context, ref, '', showAsk: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Back button, title, and the shortcut into Saved.
class _Header extends ConsumerWidget {
  const _Header({required this.onOpenSaved});

  final VoidCallback onOpenSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    // Hearting a place here used to have no visible destination — the saved
    // list lived only behind Profile. This is the way back to it.
    final savedCount = ref.watch(savedIdsProvider).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        6,
        AppSpacing.screen,
        4,
      ),
      child: Row(
        children: [
          VentusTap(
            onTap: () => Navigator.of(context).maybePop(),
            semanticLabel: l10n.back,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                boxShadow: context.shadows.card,
              ),
              child: VentusIcon(
                VentusIcons.arrowLeft,
                size: 20,
                color: colors.ink,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.exploreTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.h2,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: colors.ink,
                  ),
                ),
                Text(
                  l10n.exploreSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          VentusTap(
            onTap: onOpenSaved,
            semanticLabel: l10n.savedTitleShort,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                boxShadow: context.shadows.card,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  VentusIcon(
                    savedCount > 0 ? VentusIcons.heartFill : VentusIcons.heart,
                    size: 20,
                    color: savedCount > 0 ? colors.primary : colors.ink,
                  ),
                  if (savedCount > 0)
                    Positioned(
                      top: -1,
                      right: -3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        constraints: const BoxConstraints(minWidth: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: AppRadius.brFull,
                          border: Border.all(color: colors.surface, width: 1.5),
                        ),
                        child: Text(
                          '$savedCount',
                          style: TextStyle(
                            fontSize: AppFontSize.eyebrow,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The grid of curated matches, plus the geocoder results when the query goes
/// beyond what Ventus curates.
class _Results extends ConsumerWidget {
  const _Results({
    required this.query,
    required this.matches,
    required this.hasAnyCurated,
    required this.showAsk,
  });

  final String query;
  final List<Destination> matches;
  final bool hasAnyCurated;

  /// Whether the AI shortcut leads the list (idle state only).
  final bool showAsk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final searching = query.isNotEmpty;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    if (!searching && !hasAnyCurated) {
      return _ScrollableMessage(text: l10n.exploreEmpty);
    }

    // Only ask the network once the query is long enough to be meaningful —
    // the provider itself debounces and returns [] below the threshold.
    final remote = searching && query.length >= kPlaceSearchMinChars
        ? ref.watch(placeSuggestionsProvider(query))
        : const AsyncValue<List<PlaceSuggestion>>.data([]);
    // Don't offer a geocoder row for a city already shown in the grid above.
    final curatedNames = {
      for (final d in matches) d.nameFor(context.languageCode).toLowerCase(),
    };
    final suggestions = [
      for (final s in remote.asData?.value ?? const <PlaceSuggestion>[])
        if (!curatedNames.contains(s.name.toLowerCase())) s,
    ];

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (showAsk && !searching)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                6,
                AppSpacing.screen,
                4,
              ),
              child: VentusAiPill(
                label: context.l10n.exploreAsk,
                onTap: () => context.push(
                  AppRoutes.createTrip,
                  extra: CreateTripEntry.ai,
                ),
              ),
            ),
          ),
        if (matches.isNotEmpty) ...[
          if (searching) _SliverSectionLabel(label: l10n.exploreCuratedSection),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              14,
              AppSpacing.screen,
              6,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              delegate: SliverChildBuilderDelegate((context, i) {
                final card = _DestinationCard(destination: matches[i]);
                return i < 6
                    ? VentusReveal(
                        key: ValueKey('dest-${matches[i].id}'),
                        index: i,
                        child: card,
                      )
                    : card;
              }, childCount: matches.length),
            ),
          ),
        ],
        if (searching) ...[
          if (suggestions.isNotEmpty) ...[
            _SliverSectionLabel(label: l10n.exploreOtherPlacesSection),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                8,
                AppSpacing.screen,
                6,
              ),
              sliver: SliverList.separated(
                itemCount: suggestions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) =>
                    _SuggestionRow(suggestion: suggestions[i]),
              ),
            ),
          ],
          if (matches.isEmpty && suggestions.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  40,
                  AppSpacing.screen,
                  20,
                ),
                child: Center(
                  child: Text(
                    remote.isLoading
                        ? l10n.exploreSearching
                        : l10n.exploreNoMatches(query),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.muted,
                      fontSize: AppFontSize.sm,
                    ),
                  ),
                ),
              ),
            ),
        ],
        SliverToBoxAdapter(child: SizedBox(height: 20 + bottomInset)),
      ],
    );
  }
}

/// A geocoder hit: not a curated destination, so the only thing to do with it
/// is start planning a trip there.
class _SuggestionRow extends ConsumerWidget {
  const _SuggestionRow({required this.suggestion});

  final PlaceSuggestion suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return VentusTap(
      onTap: () {
        final controller = ref.read(createTripControllerProvider.notifier);
        controller.start(CreateTripEntry.manual);
        controller.addStop(
          DraftStop(
            name: suggestion.name,
            country: suggestion.country,
            lat: suggestion.lat,
            lon: suggestion.lon,
          ),
        );
        context.push(AppRoutes.createTrip, extra: const CreateTripSeeded());
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            const VentusLeadIcon(VentusIcons.mapPin),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                      letterSpacing: -0.16,
                    ),
                  ),
                  if (suggestion.country.isNotEmpty)
                    Text(
                      suggestion.country,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        color: colors.muted,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              context.l10n.exploreStartTripHere,
              style: context.typography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: context.primaryFill,
              ),
            ),
            const SizedBox(width: 4),
            VentusIcon(VentusIcons.chevronRight, size: 16, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

class _SliverSectionLabel extends StatelessWidget {
  const _SliverSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: VentusSectionLabel(
        label,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          16,
          AppSpacing.screen,
          0,
        ),
      ),
    );
  }
}

/// A centred message that still scrolls, so pull-to-refresh keeps working.
class _ScrollableMessage extends StatelessWidget {
  const _ScrollableMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.muted),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Placeholder cards shown while the destination list loads, instead of a bare
/// spinner — the layout arrives first and the content fills in.
class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        14,
        AppSpacing.screen,
        20,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (context, _) =>
          const VentusSkeleton(borderRadius: AppRadius.brLg),
    );
  }
}

class _DestinationCard extends ConsumerWidget {
  const _DestinationCard({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = context.languageCode;
    final saved = ref.watch(savedIdsProvider).contains(destination.id);

    return VentusTap(
      onTap: () => context.push(AppRoutes.explorePlace(destination.id)),
      feedback: VentusTapFeedback.scaleFade,
      semanticLabel:
          '${destination.nameFor(lang)}, ${destination.countryFor(lang)}',
      child: DestinationPhotoHero(
        id: destination.id,
        imageUrl: destination.imageUrl,
        child: TripPhoto(
          imageUrl: destination.imageUrl,
          borderRadius: AppRadius.brLg,
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xE01F1B18), Color(0x001F1B18)],
                      stops: [0.0, 0.7],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: _HeartButton(
                  saved: saved,
                  onTap: () => ref
                      .read(savedControllerProvider.notifier)
                      .toggle(savedPlaceFrom(destination, lang)),
                ),
              ),
              Positioned(
                left: 13,
                right: 13,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.nameFor(lang),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: AppFontSize.body,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      destination.countryFor(lang),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Save toggle. The glyph is 34px for looks but sits in a 44px tap target, and
/// it pops on save rather than swapping icons instantly.
class _HeartButton extends StatelessWidget {
  const _HeartButton({required this.saved, required this.onTap});

  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VentusTap(
      onTap: onTap,
      // The heart animates its own state below, so no scale on the wrapper.
      feedback: VentusTapFeedback.none,
      semanticLabel: saved ? l10n.savedRemove : l10n.savedAdd,
      padding: const EdgeInsets.all(5),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: Tween<double>(begin: 0.6, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
          child: VentusIcon(
            saved ? VentusIcons.heartFill : VentusIcons.heart,
            key: ValueKey(saved),
            size: 17,
            color: saved ? context.colors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
