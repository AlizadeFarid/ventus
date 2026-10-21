import 'dart:async';
import '../../../../core/theme/app_overlay.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../ads/application/ads_providers.dart';
import '../../../ads/domain/ad.dart';
import '../../../explore/application/destinations_providers.dart';
import '../../../notifications/application/notifications_providers.dart';
import '../../../profile/application/profile_providers.dart';
import '../../../auth/application/auth_controller.dart';
import '../../application/budget_providers.dart';
import '../../application/itinerary_providers.dart';
import '../../application/checklist_providers.dart';
import '../../application/collaborators_providers.dart';
import '../../application/create_trip_controller.dart';
import '../../application/documents_providers.dart';
import '../../application/trips_providers.dart';
import '../../domain/trip.dart';
import '../../domain/itinerary_item.dart';
import '../../domain/trip_progress.dart';
import '../widgets/budget_format.dart';
import '../widgets/trip_cards.dart';
import '../widgets/trip_next_step_card.dart';
import '../widgets/trip_photo.dart';
import 'trip_detail_screen.dart' show HubTab;
import '../../../../core/theme/app_typography.dart';

/// Home / My Trips dashboard (prototype `Home.jsx` → HomeA + HomeEmpty).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kick off the one-time pull + demo seed; the trip stream updates the UI.
    ref.watch(tripsBootstrapProvider);
    final tripsAsync = ref.watch(tripsProvider);
    final colors = context.colors;

    // Scaffold + SafeArea + bottom nav all come from [VentusShell] now.
    return ColoredBox(
      color: colors.bg,
      child: tripsAsync.when(
        loading: () => const VentusHomeSkeleton(),
        error: (e, _) =>
            _ErrorState(onRetry: () => ref.invalidate(tripsBootstrapProvider)),
        // Show the empty card whenever nothing is upcoming — not just when the
        // user has no trips at all. Someone whose trips have all passed would
        // otherwise land on a header and search bar with nothing below them.
        data: (_) => ref.watch(featuredTripProvider) == null
            ? const _EmptyHome()
            : const _PopulatedHome(),
      ),
    );
  }
}

/// Opens the Create Trip flow with the given entry style.
void _openCreate(BuildContext context, CreateTripEntry entry) {
  context.push(AppRoutes.createTrip, extra: entry);
}

/// Pull-to-refresh handler shared by the populated and empty dashboards:
/// re-checks the session, then re-runs the remote pull and waits for the trip
/// stream to settle.
///
/// The wait must never rethrow — a [RefreshIndicator] whose future completes
/// with an error leaves the spinner stuck and surfaces an unhandled async
/// error. `onError` is typed explicitly (rather than a bare `catchError`,
/// which infers `List<dynamic>` and throws a `TypeError` on the very error
/// path it was meant to swallow); the stream itself keeps the error so the
/// screen still renders its error state.
Future<void> _refreshTrips(WidgetRef ref) async {
  final authOk = await ref
      .read(authControllerProvider.notifier)
      .verifySession();
  if (!authOk) return;
  ref.invalidate(tripsBootstrapProvider);
  await ref
      .read(tripsProvider.future)
      .then<List<Trip>>((trips) => trips, onError: (_, _) => const <Trip>[]);
}

/// Opens the Trip Hub for a given trip.
void _openTrip(BuildContext context, String id) {
  context.push(AppRoutes.tripDetail(id));
}

/// One or two uppercase initials for a collaborator avatar: from the display
/// name when set (first letter of up to two words), else from the email.
String _initialsFor(String? name, String email) {
  final source = (name != null && name.trim().isNotEmpty) ? name.trim() : email;
  final words = source.trim().split(RegExp(r'\s+'));
  if (words.length > 1) {
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }
  final single = words.first.replaceAll('@', '').trim();
  return single
      .substring(0, single.length < 2 ? single.length : 2)
      .toUpperCase();
}

/// Time-of-day greeting. Late night falls back to the neutral "Hi" rather than
/// wishing someone a good morning at 2 a.m.
String _greetingFor(AppLocalizations l10n, String name) {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) return l10n.greetingMorning(name);
  if (hour >= 12 && hour < 18) return l10n.greetingAfternoon(name);
  if (hour >= 18 && hour < 23) return l10n.greetingEvening(name);
  return l10n.greeting(name);
}

/// The big line above the featured trip.
///
/// It reports where that trip stands rather than labelling the section: a
/// static "next stop" said nothing the card below didn't already show, and
/// called the whole trip a *stop*, which everywhere else in Ventus means one
/// city on a route.
String _headlineFor(AppLocalizations l10n, Trip? trip) {
  if (trip == null) return l10n.homeTripSoon;
  final days = trip.daysToGo;
  if (days > 0) return l10n.homeTripSoon;
  return days == 0 ? l10n.homeTripToday : l10n.homeTripOngoing;
}

/// Populated dashboard: header, featured hero, your trips, plan-with-AI,
/// discover.
class _PopulatedHome extends ConsumerWidget {
  const _PopulatedHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final featured = ref.watch(featuredTripProvider);
    final others = ref.watch(otherTripsProvider);
    final trips = ref.watch(tripsProvider).asData?.value ?? const [];

    return RefreshIndicator(
      onRefresh: () => _refreshTrips(ref),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VentusReveal(
              key: const ValueKey('home-header'),
              child: _HomeHeader(
                headline: _headlineFor(l10n, featured),
                showActions: true,
                onSwitch: trips.length > 1
                    ? () => _openTripSwitcher(context, ref, trips, featured)
                    : null,
              ),
            ),
            const VentusReveal(
              key: ValueKey('home-search'),
              index: 1,
              child: _HomeSearchBar(),
            ),
            if (featured != null)
              VentusReveal(
                key: const ValueKey('home-featured'),
                index: 2,
                child: _FeaturedTripSection(trip: featured),
              ),
            if (others.isNotEmpty) ...[
              VentusSectionHeader(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  24,
                  AppSpacing.screen,
                  12,
                ),
                title: l10n.yourTrips,
                actionLabel: l10n.seeAll,
                onAction: () => context.push(AppRoutes.allTrips),
              ),
              SizedBox(
                height: 198,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  itemCount: others.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, i) => i < others.length
                      ? TripCard(
                          trip: others[i],
                          onTap: () => _openTrip(context, others[i].id),
                        )
                      : _AddTripCard(onTap: () => openCreateTripFlow(context)),
                ),
              ),
            ],
            const _AdBanner(),
            VentusSectionHeader(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                24,
                AppSpacing.screen,
                12,
              ),
              title: l10n.discover,
              actionLabel: l10n.seeAll,
              onAction: () => context.push(AppRoutes.explore),
            ),
            const _DiscoverRow(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Featured trip's hero card + the 2x2 module shortcut grid (Checklist /
/// Budget / Documents / Map), fed by the same repositories the Trip Hub uses.
class _FeaturedTripSection extends ConsumerWidget {
  const _FeaturedTripSection({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pull each module's remote data into Drift once, then read it live —
    // same pattern as the Trip Hub, just scoped to the featured trip.
    ref.watch(checklistSyncProvider(trip.id));
    ref.watch(budgetSyncProvider(trip.id));
    ref.watch(documentsSyncProvider(trip.id));
    ref.watch(collaboratorsSyncProvider(trip.id));
    ref.watch(itinerarySyncProvider(trip.id));
    final itinerary =
        ref.watch(itineraryProvider(trip.id)).asData?.value ??
        const <ItineraryItem>[];
    final checklist =
        ref.watch(checklistProvider(trip.id)).asData?.value ?? const [];
    final budget = ref.watch(tripBudgetProvider(trip.id)).asData?.value;
    final expenses =
        ref.watch(expensesProvider(trip.id)).asData?.value ?? const [];
    final documents =
        ref.watch(documentsProvider(trip.id)).asData?.value ?? const [];
    final collaborators =
        ref.watch(collaboratorsProvider(trip.id)).asData?.value ?? const [];

    final spent = expenses.fold<double>(0, (s, e) => s + e.amount);
    final plannedPercent = plannedPercentFor(
      dayCount: itineraryDayCount(trip, itinerary),
      items: itinerary,
    );
    final initials = [
      for (final c in collaborators) _initialsFor(c.name, c.email),
    ];
    // Hold the nudge back until every module has reported in; otherwise a
    // trip that is really half-planned flashes "build your plan" while its
    // data is still loading.
    final loaded =
        ref.watch(itineraryProvider(trip.id)).hasValue &&
        ref.watch(checklistProvider(trip.id)).hasValue &&
        ref.watch(documentsProvider(trip.id)).hasValue;
    final nextStep = loaded
        ? nextStepFor(
            plannedPercent: plannedPercent,
            checklistCount: checklist.length,
            hasBudget: budget != null && budget.total > 0,
            documentsCount: documents.length,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: TripHeroCard(
            trip: trip,
            plannedPercent: plannedPercent,
            onTap: () => _openTrip(context, trip.id),
            collaboratorInitials: initials,
            budgetTotal: budget?.total,
            budgetSpent: spent,
            budgetCurrency: budget?.currency,
          ),
        ),
        const SizedBox(height: 14),
        if (nextStep != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: TripNextStepCard(
              step: nextStep,
              onOpen: (tab) =>
                  context.push(AppRoutes.tripDetail(trip.id), extra: tab),
            ),
          ),
          const SizedBox(height: 10),
        ],
        _TripHubModuleGrid(
          tripId: trip.id,
          checklistDone: checklist.where((c) => c.done).length,
          checklistTotal: checklist.length,
          budgetRemaining: budget != null && budget.total > 0
              ? budget.total - spent
              : null,
          budgetCurrency: budget?.currency ?? 'USD',
          documentsCount: documents.length,
          plannedPercent: plannedPercent,
        ),
      ],
    );
  }
}

/// Shortcut grid to a trip's Checklist / Budget / Documents modules
/// (prototype state B1), each showing a live one-line summary.
class _TripHubModuleGrid extends StatelessWidget {
  const _TripHubModuleGrid({
    required this.tripId,
    required this.checklistDone,
    required this.checklistTotal,
    required this.budgetRemaining,
    required this.budgetCurrency,
    required this.documentsCount,
    required this.plannedPercent,
  });

  final String tripId;
  final int checklistDone;
  final int checklistTotal;
  final double? budgetRemaining;
  final String budgetCurrency;
  final int documentsCount;
  final int plannedPercent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tiles = <(String, String, String, VoidCallback)>[
      (
        VentusIcons.listCheck,
        // The compact tile has room for one short word; the full label
        // ("Yoxlama siyahısı") ellipsised here.
        l10n.moduleChecklistShort,
        l10n.checklistProgress(checklistDone, checklistTotal),
        () =>
            context.push(AppRoutes.tripDetail(tripId), extra: HubTab.checklist),
      ),
      (
        VentusIcons.wallet,
        l10n.moduleBudget,
        // Without a budget the subtitle used to repeat the title verbatim
        // ("Budget / Budget"); prompt the next step instead.
        budgetRemaining == null
            ? l10n.setBudget
            : '${formatMoney(budgetRemaining!, budgetCurrency)} '
                  '${l10n.budgetRemaining.toLowerCase()}',
        () => context.push(AppRoutes.tripDetail(tripId), extra: HubTab.budget),
      ),
      (
        VentusIcons.document,
        l10n.moduleDocuments,
        l10n.documentsCount(documentsCount),
        () =>
            context.push(AppRoutes.tripDetail(tripId), extra: HubTab.documents),
      ),
      (
        VentusIcons.route,
        l10n.moduleItinerary,
        l10n.percentPlanned(plannedPercent),
        () =>
            context.push(AppRoutes.tripDetail(tripId), extra: HubTab.itinerary),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
        children: [
          for (final (icon, title, sub, onTap) in tiles)
            _ModuleCard(icon: icon, title: title, sub: sub, onTap: onTap),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.sub,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brMd,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            VentusLeadIcon(icon, slot: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                  ),
                  Text(
                    sub,
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
          ],
        ),
      ),
    );
  }
}

/// Trailing dashed card at the end of "Your trips" — a shortcut into the
/// create-trip sheet (prototype state B1 → "Yeni").
class _AddTripCard extends StatelessWidget {
  const _AddTripCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return VentusTap(
      onTap: onTap,
      child: Container(
        width: 84,
        decoration: BoxDecoration(
          color: colors.primarySoft,
          borderRadius: AppRadius.brLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VentusIcon(VentusIcons.plus, size: 22, color: colors.primary),
            const SizedBox(height: 6),
            Text(
              l10n.addNewTripShort,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSize.caption,
                fontWeight: FontWeight.w700,
                color: context.primaryFill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens the trip-switcher bottom sheet (prototype state F): lists every
/// upcoming trip, lets the user pick which one is featured on Home.
Future<void> _openTripSwitcher(
  BuildContext context,
  WidgetRef ref,
  List<Trip> trips,
  Trip? featured,
) async {
  final upcoming = trips.where((t) => t.isUpcoming).toList()
    ..sort((a, b) => a.startDate.compareTo(b.startDate));
  final picked = await showVentusSheet<String>(
    context,
    backgroundColor: context.colors.bg,
    builder: (_) =>
        _TripSwitcherSheet(trips: upcoming, featuredId: featured?.id),
  );
  if (picked == null) return;
  ref.read(selectedTripIdProvider.notifier).select(picked);
}

class _TripSwitcherSheet extends StatelessWidget {
  const _TripSwitcherSheet({required this.trips, required this.featuredId});

  final List<Trip> trips;
  final String? featuredId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    // The bottom safe-area inset is padding *inside* the sheet so its fill
    // reaches the screen edge instead of leaving a transparent strip.
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        22 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: colors.lineStrong,
                borderRadius: AppRadius.brFull,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.tripPickerTitle,
            style: context.typography.h1.copyWith(
              fontSize: AppFontSize.h3,
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.42,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: trips.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = trips[i];
                final active = t.id == featuredId;
                final inProgress = t.daysToGo <= 0;
                return VentusTap(
                  onTap: () => Navigator.of(context).pop(t.id),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: AppRadius.brMd,
                      border: Border.all(
                        color: active ? colors.primary : colors.line,
                        width: active ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFF8A4C), Color(0xFFE2365B)],
                            ),
                            borderRadius: AppRadius.brSm,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppFontSize.body,
                                  fontWeight: FontWeight.w600,
                                  color: colors.ink,
                                ),
                              ),
                              Text(
                                active && inProgress
                                    ? context.l10n.tripInProgress
                                    : '${DateFormat.MMMd(context.languageCode).format(t.startDate)} – '
                                          '${DateFormat.MMMd(context.languageCode).format(t.endDate)}',
                                style: TextStyle(
                                  fontSize: AppFontSize.sm,
                                  fontWeight: active
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: active ? colors.primary : colors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (active)
                          VentusIcon(
                            VentusIcons.check,
                            size: 20,
                            color: colors.primary,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: VentusButton(
                  label: l10n.seeAll,
                  variant: VentusButtonVariant.secondary,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (!context.mounted) return;
                    context.push(AppRoutes.allTrips);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: VentusButton(
                  label: l10n.createSheetTitle,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (!context.mounted) return;
                    await openCreateTripFlow(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Persistent search pill below the header (prototype states A/B1/B2/D):
/// shortcut into full-text place search on the Explore tab.
class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        16,
      ),
      child: VentusSearchButton(
        label: context.l10n.homeSearchHint,
        onTap: () => context.push(AppRoutes.explore),
      ),
    );
  }
}

/// First-open empty state (prototype `Home.jsx` → HomeEmpty).
class _EmptyHome extends ConsumerWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh: () => _refreshTrips(ref),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeHeader(
              headline: l10n.homeWhereTo,
              showActions: true,
              onSwitch: null,
            ),
            const _HomeSearchBar(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 32, 26, 32),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.brLg,
                  boxShadow: context.shadows.card,
                ),
                child: Column(
                  children: [
                    const VentusTravelIllustration(),
                    const SizedBox(height: 24),
                    Text(
                      l10n.emptyHomeTitle,
                      style: type.h2.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.emptyHomeBody,
                      textAlign: TextAlign.center,
                      style: type.body.copyWith(
                        fontSize: AppFontSize.body,
                        color: colors.muted,
                      ),
                    ),
                    const SizedBox(height: 28),
                    VentusButton(
                      label: l10n.planNewTrip,
                      full: true,
                      onPressed: () =>
                          _openCreate(context, CreateTripEntry.manual),
                    ),
                    const SizedBox(height: 14),
                    VentusButton(
                      label: l10n.planWithAi,
                      variant: VentusButtonVariant.tonal,
                      full: true,
                      iconLeft: VentusIcons.sparkle,
                      onPressed: () => _openCreate(context, CreateTripEntry.ai),
                    ),
                  ],
                ),
              ),
            ),
            // Sponsors are shown even before the first trip exists — the empty
            // home is the screen these users see most.
            const _AdBanner(topGap: 24),
            VentusSectionHeader(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                24,
                AppSpacing.screen,
                12,
              ),
              title: l10n.discover,
              actionLabel: l10n.seeAll,
              onAction: () => context.push(AppRoutes.explore),
            ),
            const _DiscoverRow(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader({
    required this.headline,
    required this.showActions,
    this.onSwitch,
  });

  /// Contextual big title: "Next stop" when there's a featured trip, "Where
  /// to?" on the empty state.
  final String headline;
  final bool showActions;

  /// Opens the trip-switcher sheet when tapping the headline; null hides the
  /// chevron affordance (empty state, or a single trip).
  final VoidCallback? onSwitch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final hasUnread = ref.watch(unreadNotificationsCountProvider) > 0;
    final profile = ref.watch(profileProvider);
    final firstName = profile.name.trim().split(RegExp(r'\s+'))[0];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        6,
        AppSpacing.screen,
        14,
      ),
      child: Row(
        children: [
          Expanded(
            child: VentusTap(
              onTap: onSwitch,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greetingFor(context.l10n, firstName),
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color: colors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        // Scales down rather than clipping: the headline is a
                        // sentence in three languages, and the longest ones sit
                        // a hair short of the bell + avatar on a narrow phone.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            headline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: VentusTabTitle.style(context),
                          ),
                        ),
                      ),
                      if (onSwitch != null) ...[
                        const SizedBox(width: 6),
                        VentusIcon(
                          VentusIcons.chevronDown,
                          size: 18,
                          color: colors.muted,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (showActions) ...[
            VentusIconButton(
              icon: VentusIcons.bell,
              semanticLabel: context.l10n.notificationsTitleShort,
              badge: hasUnread,
              onTap: () => context.push(AppRoutes.notifications),
            ),
            const SizedBox(width: 10),
          ],
          VentusAvatar(
            initials: profile.initials,
            imageUrl: profile.avatarUrl,
            onTap: () => context.go(AppRoutes.profile),
          ),
        ],
      ),
    );
  }
}

/// Dismiss state for the home ad banner. Lives for the session so the banner
/// stays hidden after the user closes it, until the app restarts.
class _AdBannerDismissed extends Notifier<bool> {
  @override
  bool build() => false;
  void dismiss() => state = true;
}

final _adBannerDismissedProvider = NotifierProvider<_AdBannerDismissed, bool>(
  _AdBannerDismissed.new,
);

/// Sponsored banner below the AI-plan card: a carousel that slides through the
/// active ads from Supabase (the `ads` table → [adsProvider]). Hidden when
/// there are no ads or once dismissed, so the rest of the home order stays
/// intact.
class _AdBanner extends ConsumerStatefulWidget {
  const _AdBanner({this.topGap = 0});

  /// Space above the banner, applied only when the banner actually shows — so
  /// a hidden banner leaves no gap behind it.
  final double topGap;

  @override
  ConsumerState<_AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends ConsumerState<_AdBanner> {
  static const _height = 108.0;
  static const _autoAdvance = Duration(seconds: 5);

  final PageController _controller = PageController();
  Timer? _timer;
  int _page = 0;
  int _count = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// (Re)starts auto-advance for [count] ads; no timer for a single ad.
  ///
  /// Safe to call straight from `build`: it never calls `setState`, and the
  /// `count == _count` guard makes repeat calls free. (It used to run from a
  /// post-frame callback, which could fire after `dispose` and leave an
  /// un-cancellable timer behind.)
  void _syncTimer(int count) {
    if (count == _count) return;
    // A shorter list can leave the controller parked past the last page.
    if (count <= _page) _page = 0;
    _count = count;
    _timer?.cancel();
    if (count > 1) {
      _timer = Timer.periodic(_autoAdvance, (_) {
        if (!mounted || !_controller.hasClients) return;
        final next = (_page + 1) % count;
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(_adBannerDismissedProvider)) return const SizedBox.shrink();

    final ads = ref.watch(adsProvider).asData?.value ?? const <Ad>[];
    if (ads.isEmpty) return const SizedBox.shrink();

    // Keep the auto-advance timer in step with the current ad count.
    _syncTimer(ads.length);

    final colors = context.colors;
    final l10n = context.l10n;
    final page = _page.clamp(0, ads.length - 1);

    return Padding(
      padding: EdgeInsets.only(top: widget.topGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            // The label keeps the 22px page gutter; the × gets 8, because its
            // own 14px tap padding makes up the rest — that lands the glyph
            // itself on the gutter, flush with the card's right edge below,
            // instead of floating 14px inside it.
            padding: const EdgeInsets.only(left: AppSpacing.screen, right: 8),
            child: Row(
              children: [
                Text(
                  l10n.sponsored.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSize.eyebrow,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: colors.muted,
                  ),
                ),
                const Spacer(),
                VentusTap(
                  onTap: () =>
                      ref.read(_adBannerDismissedProvider.notifier).dismiss(),
                  semanticLabel: l10n.dismiss,
                  // Wide enough for a comfortable target, shallow enough that
                  // the row doesn't push the label away from the card.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  child: VentusIcon(
                    VentusIcons.close,
                    size: 16,
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          // 22 matches the page gutter used by the trip card and module grid
          // above, so the ad card's edges line up with theirs instead of
          // reading as its own narrower, off-center element.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: SizedBox(
              height: _height,
              // Full-bleed pages (no viewport peek): with a single ad — the
              // common case — this reads as one plain card flush with the
              // gutter, not a carousel with a sliver of a neighbor showing.
              child: PageView.builder(
                controller: _controller,
                itemCount: ads.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _AdCard(ad: ads[i]),
              ),
            ),
          ),
          if (ads.length > 1) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < ads.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == page ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == page ? colors.primary : colors.lineStrong,
                      borderRadius: AppRadius.brFull,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A single ad page: image, advertiser chip, title and subtitle.
class _AdCard extends StatelessWidget {
  const _AdCard({required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return TripPhoto(
      imageUrl: ad.imageUrl,
      borderRadius: AppRadius.brLg,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x331F1B18), Color(0xCC1F1B18)],
                  stops: [0.25, 1],
                ),
              ),
            ),
          ),
          if (ad.advertiser != null && ad.advertiser!.isNotEmpty)
            Positioned(
              top: 10,
              left: 12,
              child: _AdChip(icon: VentusIcons.tag, label: ad.advertiser!),
            ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppFontSize.h3,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: Colors.white,
                  ),
                ),
                if (ad.subtitle != null && ad.subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 1),
                  Text(
                    ad.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSize.caption,
                      fontWeight: FontWeight.w500,
                      color: AppOverlay.onPhotoMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Glass pill on the ad image (advertiser name).
class _AdChip extends StatelessWidget {
  const _AdChip({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: AppOverlay.glassFill,
        borderRadius: AppRadius.brFull,
        border: Border.all(color: AppOverlay.glassStroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VentusIcon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSize.caption,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal Discover row, fed by the online destinations provider.
class _DiscoverRow extends ConsumerWidget {
  const _DiscoverRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(destinationsProvider).asData?.value ?? const [];
    final lang = context.languageCode;

    return SizedBox(
      height: 168,
      child: items.isEmpty
          ? const SizedBox.shrink()
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final d = items[i];
                return DiscoverCard(
                  title: d.nameFor(lang),
                  country: d.countryFor(lang),
                  imageUrl: d.imageUrl ?? '',
                  onTap: () => context.push(AppRoutes.explorePlace(d.id)),
                );
              },
            ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VentusIcon(VentusIcons.compass, size: 40, color: colors.muted),
            const SizedBox(height: AppSpacing.s4),
            Text(
              l10n.couldNotLoadTrips,
              style: context.typography.body.copyWith(color: colors.muted),
            ),
            const SizedBox(height: AppSpacing.s4),
            VentusButton(
              label: l10n.tryAgain,
              variant: VentusButtonVariant.secondary,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
