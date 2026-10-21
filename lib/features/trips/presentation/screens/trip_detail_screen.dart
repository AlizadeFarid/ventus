import 'package:flutter/foundation.dart';
import '../../../../core/theme/app_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/config/feature_flags.dart';
import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/storage/app_storage.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/budget_providers.dart';
import '../../application/checklist_providers.dart';
import '../../application/documents_providers.dart';
import '../../application/itinerary_providers.dart';
import '../../application/trip_detail_providers.dart';
import '../../application/trips_controller.dart';
import '../../data/cover_picker.dart';
import '../../data/supabase_trips_remote.dart'
    show TripDeleteForbiddenException;
import '../../domain/checklist_item.dart';
import '../../domain/document.dart';
import '../../domain/trip_stop.dart';
import '../../domain/expense.dart';
import '../../domain/itinerary_item.dart';
import '../../domain/trip_progress.dart';
import '../../domain/traveler_type.dart';
import '../../domain/trip.dart';
import '../widgets/budget_format.dart';
import '../widgets/cover_source_sheet.dart';
import '../../../../core/utils/country_flag.dart' show foldCountryName;
import '../../../../core/utils/country_names.dart';
import '../widgets/ai_plan_flow.dart';
import '../widgets/hub_tab_bar.dart';
import '../widgets/itinerary_format.dart';
import '../widgets/open_in_maps.dart';
import '../widgets/timeline_item.dart';
import '../widgets/trip_cards.dart' show TripProgressBar, tripCoverHeroTag;
import '../widgets/trip_photo.dart';
import 'budget_screen.dart' show BudgetBody;
import 'checklist_screen.dart' show ChecklistBody;
import 'documents_screen.dart' show DocumentsBody;
import 'itinerary_screen.dart' show ItineraryBody;
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Action chosen in the cover hero's "more" (…) sheet.
enum _MoreAction { changeCover, delete }

/// The Trip Hub's tabs, in on-screen order. İcmal (overview) is the cover +
/// recap + AI hero / live module previews; the rest embed that module's full
/// content in place of what used to be a separate pushed route.
enum HubTab { overview, itinerary, budget, documents, checklist }

/// Trip Hub — the screen reached by tapping a trip (prototype `TripHub.jsx`).
///
/// Built as the "empty / new trip" hub for now: cover hero + module tabs + a
/// real route & travelers recap + the AI plan hero + manual start rows. The
/// itinerary / budget / checklist / documents modules each get their own
/// UI+backend pass later, so they stub to "coming soon" here.
class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({
    super.key,
    required this.tripId,
    this.initialTab = HubTab.overview,
  });

  final String tripId;
  final HubTab initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripDetailProvider(tripId));
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: tripAsync.when(
        loading: () => const _HubSkeleton(),
        error: (_, _) => _NotFound(),
        data: (trip) => trip == null
            ? _NotFound()
            : _Hub(trip: trip, initialTab: initialTab),
      ),
    );
  }
}

/// Loading placeholder shaped like the hub: cover, tab strip, then content.
class _HubSkeleton extends StatelessWidget {
  const _HubSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VentusSkeleton(
          height: _kCoverExpandedHeight,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Row(
            children: const [
              VentusSkeleton(
                width: 64,
                height: 14,
                borderRadius: AppRadius.brFull,
              ),
              SizedBox(width: 18),
              VentusSkeleton(
                width: 78,
                height: 14,
                borderRadius: AppRadius.brFull,
              ),
              SizedBox(width: 18),
              VentusSkeleton(
                width: 58,
                height: 14,
                borderRadius: AppRadius.brFull,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Expanded(
          child: VentusListSkeleton(itemCount: 3, itemHeight: 110),
        ),
      ],
    );
  }
}

/// Shown when the trip id no longer resolves (e.g. just deleted) or failed to
/// load. A bare back affordance so the user is never stranded.
class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 6,
            left: 16,
            child: VentusIconButton(
              icon: VentusIcons.arrowLeft,
              semanticLabel: l10n.back,
              onTap: () => _leave(context),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VentusIcon(
                    VentusIcons.compass,
                    size: 40,
                    color: colors.muted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.tripNotFound,
                    style: context.typography.body.copyWith(
                      color: colors.muted,
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

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }
}

/// Expanded height of the collapsing cover hero (SliverAppBar).
const double _kCoverExpandedHeight = 276;

/// Expanded header height when the trip has no cover photo.
const double _kCoverNoPhotoHeight = 244;

/// Once the header has been dragged past this many pixels, releasing the
/// scroll snaps it the rest of the way to fully collapsed instead of
/// settling mid-transition (where the glass buttons sit in a low-contrast
/// state, neither on the photo nor on the solid surface).
const double _kCoverSnapThreshold = 28;

class _Hub extends ConsumerStatefulWidget {
  const _Hub({required this.trip, required this.initialTab});

  final Trip trip;
  final HubTab initialTab;

  @override
  ConsumerState<_Hub> createState() => _HubState();
}

class _HubState extends ConsumerState<_Hub>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late int _tabIndex;

  /// Tracks the shared header's own scroll offset (not the active tab's
  /// content), so the cover collapses identically no matter which module tab
  /// is being scrolled.
  final ScrollController _outerScroll = ScrollController();

  /// 0 = cover fully expanded, 1 = collapsed to the toolbar. Drives the cover
  /// wipe-to-surface and the pinned title fade without rebuilding the hub.
  final ValueNotifier<double> _collapse = ValueNotifier<double>(0);

  Trip get trip => widget.trip;

  /// A trip without a cover photo is just a gradient, so its header is kept
  /// short rather than leaving a tall empty block above the content.
  double get _coverHeight => trip.coverImagePath == null
      ? _kCoverNoPhotoHeight
      : _kCoverExpandedHeight;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTab.index;
    _tabController = TabController(
      length: HubTab.values.length,
      initialIndex: _tabIndex,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.index != _tabIndex) {
        setState(() => _tabIndex = _tabController.index);
      }
    });
    _outerScroll.addListener(_onOuterScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_outerScroll.hasClients) return;
      _outerScroll.position.isScrollingNotifier.addListener(_onOuterScrollIdle);
    });
  }

  void _onOuterScroll() {
    final distance = _coverHeight - kToolbarHeight;
    _collapse.value = (_outerScroll.offset / distance).clamp(0.0, 1.0);
  }

  /// Fires whenever the outer header scroll starts or stops moving. Once it
  /// settles mid-collapse, snaps it the rest of the way open or shut instead
  /// of leaving the cover/buttons paused in a half-transitioned state.
  void _onOuterScrollIdle() {
    if (!_outerScroll.hasClients ||
        _outerScroll.position.isScrollingNotifier.value) {
      return;
    }
    final offset = _outerScroll.offset;
    final distance = _coverHeight - kToolbarHeight;
    if (offset <= 0 || offset >= distance) return;
    final target = offset > _kCoverSnapThreshold ? distance : 0.0;
    _outerScroll.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _outerScroll.removeListener(_onOuterScroll);
    if (_outerScroll.hasClients) {
      _outerScroll.position.isScrollingNotifier.removeListener(
        _onOuterScrollIdle,
      );
    }
    _outerScroll.dispose();
    _collapse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final tabLabels = [
      l10n.tripOverviewTab,
      l10n.moduleItinerary,
      l10n.moduleBudget,
      l10n.moduleDocuments,
      l10n.moduleChecklistShort,
    ];

    // Live planning progress for the cover's percent pill — kept here so it's
    // available regardless of which module tab is currently showing below.
    ref.watch(itinerarySyncProvider(trip.id));
    final itineraryItems =
        ref.watch(itineraryProvider(trip.id)).asData?.value ??
        const <ItineraryItem>[];
    final plannedPercent = plannedPercentFor(
      dayCount: itineraryDayCount(trip, itineraryItems),
      items: itineraryItems,
    );

    return Scaffold(
      backgroundColor: colors.bg,
      body: NestedScrollView(
        controller: _outerScroll,
        // Clamping (not bouncing) on the outer header: with bouncing physics
        // an overscroll at the end of a tab's list also feeds negative slack
        // back into the pinned cover/tab-bar coordination, which visibly
        // yanks that fixed chrome further up and off-screen. Each tab's own
        // list keeps its native bounce — this only tames the shared header.
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _coverAppBar(context, plannedPercent),
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedTabBarDelegate(
              tabBar: HubTabBar(controller: _tabController, labels: tabLabels),
              background: colors.surface,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewBody(
              trip: trip,
              onSwitchTab: (tab) => _tabController.animateTo(tab.index),
            ),
            ItineraryBody(tripId: trip.id),
            BudgetBody(tripId: trip.id),
            DocumentsBody(tripId: trip.id),
            ChecklistBody(tripId: trip.id),
          ],
        ),
      ),
    );
  }

  /// Collapsing cover hero: the photo + trip recap scroll away while the back /
  /// share / more controls stay pinned and the trip title fades into the bar.
  /// Shared by every module tab via [NestedScrollView.headerSliverBuilder].
  Widget _coverAppBar(BuildContext context, int plannedPercent) {
    final colors = context.colors;
    return SliverAppBar(
      pinned: true,
      expandedHeight: _coverHeight,
      automaticallyImplyLeading: false,
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Align(
          alignment: Alignment.centerLeft,
          child: VentusHeroIconButton(
            icon: VentusIcons.arrowLeft,
            collapse: _collapse,
            onTap: () => _leaveTripHub(context),
          ),
        ),
      ),
      title: ValueListenableBuilder<double>(
        valueListenable: _collapse,
        builder: (context, t, _) => Opacity(
          // Fade the title in only over the second half of the collapse.
          opacity: ((t - 0.5) * 2).clamp(0.0, 1.0),
          child: Text(
            localizedPlaceTitle(trip.title, trip.country, context.languageCode),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typography.h3.copyWith(
              fontSize: AppFontSize.h3,
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
          ),
        ),
      ),
      actions: [
        VentusHeroIconButton(
          icon: VentusIcons.share,
          collapse: _collapse,
          onTap: () => _shareTrip(context, trip),
        ),
        const SizedBox(width: 10),
        VentusHeroIconButton(
          icon: VentusIcons.more,
          collapse: _collapse,
          onTap: () => _showMore(context, ref, trip),
        ),
        const SizedBox(width: 18),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _CoverBackground(
          trip: trip,
          plannedPercent: plannedPercent,
          collapse: _collapse,
          onStartPlanning: () =>
              _tabController.animateTo(HubTab.itinerary.index),
        ),
      ),
    );
  }
}

/// The İcmal (overview) tab's content: the trip recap, and either the AI hero
/// / manual-start rows or live module previews, depending on whether the trip
/// has any plan yet. The collapsing cover + pinned tab strip are hub-level
/// chrome shared by every tab (see [_HubState._coverAppBar]) — this only
/// scrolls the content underneath them.
class _OverviewBody extends ConsumerWidget {
  const _OverviewBody({required this.trip, required this.onSwitchTab});

  final Trip trip;
  final ValueChanged<HubTab> onSwitchTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pull the trip's remote modules into Drift once, then read them live.
    ref.watch(itinerarySyncProvider(trip.id));
    ref.watch(checklistSyncProvider(trip.id));
    ref.watch(documentsSyncProvider(trip.id));
    ref.watch(budgetSyncProvider(trip.id));
    final items =
        ref.watch(itineraryProvider(trip.id)).asData?.value ??
        const <ItineraryItem>[];
    final checklist =
        ref.watch(checklistProvider(trip.id)).asData?.value ??
        const <ChecklistItem>[];
    final documents =
        ref.watch(documentsProvider(trip.id)).asData?.value ??
        const <TripDocument>[];
    final budget = ref.watch(tripBudgetProvider(trip.id)).asData?.value;
    final expenses =
        ref.watch(expensesProvider(trip.id)).asData?.value ?? const <Expense>[];
    final hasItinerary = items.isNotEmpty;
    final hasChecklist = checklist.isNotEmpty;
    final hasDocuments = documents.isNotEmpty;
    final hasBudget = (budget?.total ?? 0) > 0 || expenses.isNotEmpty;
    final hasAnyPlan =
        hasItinerary || hasChecklist || hasDocuments || hasBudget;

    final dayCount = itineraryDayCount(trip, items);
    final plannedDays = items.map((i) => i.day).toSet().length;

    // Earliest activity that is still ahead: from today's day on while the
    // trip is running, otherwise the very first one.
    final todayDay = trip.daysToGo < 0 ? 1 - trip.daysToGo : 1;
    ItineraryItem? found;
    for (final item in items) {
      if (item.day >= todayDay) {
        found = item;
        break;
      }
    }
    found ??= items.isEmpty ? null : items.first;
    final nextUp = found;
    final nextUpDayLabel = nextUp == null
        ? ''
        : '${context.l10n.dayLabel} ${nextUp.day} · ${DateFormat.MMMMd(context.languageCode).format(trip.startDate.add(Duration(days: nextUp.day - 1)))}';

    final total = budget?.total ?? 0;
    final spent = expenses.fold<double>(0, (s, e) => s + e.amount);
    final currency = budget?.currency ?? 'USD';
    String budgetSub(BuildContext context) => total > 0
        ? '${formatMoney(total - spent, currency)} '
              '${context.l10n.budgetRemaining.toLowerCase()}'
        : spent > 0
        ? formatMoney(spent, currency)
        : context.l10n.readinessBudgetNotSet;
    final budgetFraction = total > 0 ? (spent / total).clamp(0.0, 1.0) : 0.0;
    final budgetOver = total > 0 && spent > total;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (trip.stops.isNotEmpty || trip.travelerType != null) ...[
          const SizedBox(height: 18),
          VentusSectionHeader(title: context.l10n.tripDetailsTitle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: _DetailsCard(trip: trip),
          ),
        ],
        if (AppFeatures.collaborators) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: _StartRow(
              icon: VentusIcons.userPlus,
              title: context.l10n.collaboratorsTitle,
              sub: context.l10n.collaboratorsManageSub,
              onTap: () => _openCollaborators(context, trip.id),
            ),
          ),
        ],
        const SizedBox(height: 22),
        if (hasAnyPlan) ...[
          VentusSectionHeader(title: context.l10n.overviewReadiness),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: _ReadinessGrid(
              itinerarySub: dayCount == 0
                  ? context.l10n.readinessActivities(0)
                  : context.l10n.readinessDaysPlanned(plannedDays, dayCount),
              itineraryFraction: dayCount == 0 ? 0 : plannedDays / dayCount,
              budgetSub: budgetSub(context),
              budgetFraction: budgetFraction,
              budgetOver: budgetOver,
              documentsSub: hasDocuments
                  ? context.l10n.documentsCount(documents.length)
                  : context.l10n.readinessNoDocs,
              checklistSub: hasChecklist
                  ? context.l10n.checklistProgress(
                      checklist.where((i) => i.done).length,
                      checklist.length,
                    )
                  : context.l10n.readinessEmpty,
              checklistFraction: hasChecklist
                  ? checklist.where((i) => i.done).length / checklist.length
                  : 0,
              onOpen: onSwitchTab,
            ),
          ),
          if (nextUp != null) ...[
            const SizedBox(height: 26),
            VentusSectionHeader(
              title: context.l10n.overviewNextUp,
              actionLabel: context.l10n.seeAll,
              onAction: () => onSwitchTab(HubTab.itinerary),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 8),
                    child: Text(
                      nextUpDayLabel,
                      style: context.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colors.muted,
                      ),
                    ),
                  ),
                  TimelineItem(
                    time: formatStartMinutes(nextUp.startMinutes),
                    icon: activityKindIcon(nextUp.kind),
                    title: nextUp.title,
                    place: nextUp.place,
                    last: true,
                    onTap: () => onSwitchTab(HubTab.itinerary),
                    onOpenMap: (nextUp.place?.trim().isNotEmpty ?? false)
                        ? () => showOpenInMapsSheet(
                            context,
                            place: nextUp.place!.trim(),
                            lat: nextUp.lat,
                            lon: nextUp.lon,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
          if (hasItinerary && plannedDays < dayCount)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                14,
                AppSpacing.screen,
                0,
              ),
              child: _AiAssist(
                onPlan: () => generateTripPlan(context, ref, trip),
              ),
            ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: _AiHero(
              city: trip.title,
              onGenerate: () => generateTripPlan(context, ref, trip),
            ),
          ),
          const SizedBox(height: 26),
          VentusSectionHeader(title: context.l10n.orStartManually),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Column(
              children: [
                _StartRow(
                  icon: VentusIcons.route,
                  title: context.l10n.startBuildItinerary,
                  sub: context.l10n.startBuildItinerarySub,
                  onTap: () => onSwitchTab(HubTab.itinerary),
                ),
                const SizedBox(height: 12),
                _StartRow(
                  icon: VentusIcons.document,
                  title: context.l10n.startUploadDocs,
                  sub: context.l10n.startUploadDocsSub,
                  onTap: () => onSwitchTab(HubTab.documents),
                ),
                const SizedBox(height: 12),
                _StartRow(
                  icon: VentusIcons.listCheck,
                  title: context.l10n.startChecklist,
                  sub: context.l10n.startChecklistSub,
                  onTap: () => onSwitchTab(HubTab.checklist),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 28),
      ],
    );
  }
}

/// Pins [HubTabBar] just below the cover photo as the İcmal tab scrolls, with
/// an opaque background so content doesn't show through underneath it.
class _PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedTabBarDelegate({required this.tabBar, required this.background});

  final HubTabBar tabBar;
  final Color background;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: background, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _PinnedTabBarDelegate oldDelegate) =>
      oldDelegate.tabBar.controller != tabBar.controller ||
      oldDelegate.background != background;
}

void _leaveTripHub(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}

/// Shares a human-readable summary of the trip via the OS share sheet.
Future<void> _shareTrip(BuildContext context, Trip trip) async {
  final l10n = context.l10n;
  final lang = context.languageCode;
  final fmt = DateFormat.MMMd(lang);
  final endFmt = trip.startDate.month == trip.endDate.month
      ? DateFormat.d(lang).format(trip.endDate)
      : fmt.format(trip.endDate);
  final dates =
      '${fmt.format(trip.startDate)} – $endFmt · ${l10n.nightsCount(trip.nights)}';

  final buffer = StringBuffer()
    ..writeln('${trip.title} · ${trip.country}')
    ..writeln(dates);
  if (trip.stops.length > 1) {
    buffer.writeln(trip.stops.map((s) => s.name).join(' → '));
  }
  buffer.write(l10n.sharedViaVentus);

  await SharePlus.instance.share(ShareParams(text: buffer.toString()));
}

/// "More" sheet → change cover photo, or confirm + real delete.
Future<void> _showMore(BuildContext context, WidgetRef ref, Trip trip) async {
  final l10n = context.l10n;

  final action = await showVentusOptionSheet<_MoreAction>(
    context,
    options: [
      VentusSheetOption(
        value: _MoreAction.changeCover,
        label: l10n.changeCoverPhoto,
        icon: VentusIcons.image,
      ),
      VentusSheetOption(
        value: _MoreAction.delete,
        label: l10n.deleteTripAction,
        icon: VentusIcons.trash,
        destructive: true,
      ),
    ],
  );

  if (action == null || !context.mounted) return;
  switch (action) {
    case _MoreAction.changeCover:
      await _changeCover(context, ref, trip);
    case _MoreAction.delete:
      await _confirmDelete(context, ref, trip);
  }
}

/// Pick / replace / remove the trip's cover photo, then refresh the hub.
Future<void> _changeCover(
  BuildContext context,
  WidgetRef ref,
  Trip trip,
) async {
  final action = await showCoverSourceSheet(
    context,
    canRemove: trip.coverImagePath != null,
  );
  if (action == null || !context.mounted) return;

  PickedCover? picked;
  var remove = false;
  switch (action) {
    case CoverSourceAction.camera:
      picked = await CoverPicker.fromCamera();
    case CoverSourceAction.gallery:
      picked = await CoverPicker.fromGallery();
    case CoverSourceAction.remove:
      remove = true;
  }
  if (!remove && picked == null) return; // picker cancelled
  if (!context.mounted) return;

  final l10n = context.l10n;
  final ok = await ref
      .read(tripsControllerProvider.notifier)
      .changeCover(trip: trip, picked: picked, remove: remove);
  ref.invalidate(tripDetailProvider(trip.id));
  if (!context.mounted) return;
  if (ok) {
    showVentusSuccess(context, l10n.coverUpdated);
  } else {
    showVentusError(context, l10n.somethingWentWrong);
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  Trip trip,
) async {
  final l10n = context.l10n;

  final confirmed = await confirmVentusAction(
    context,
    title: l10n.deleteTripTitle,
    body: l10n.deleteTripBody,
    confirmLabel: l10n.deleteConfirm,
    destructive: true,
  );

  if (!confirmed || !context.mounted) return;

  final router = GoRouter.of(context);
  final deletedText = l10n.tripDeleted;
  final failedText = l10n.somethingWentWrong;
  final ownerOnlyText = l10n.tripDeleteOwnerOnly;

  final ok = await ref.read(tripsControllerProvider.notifier).delete(trip.id);

  if (!context.mounted) return;
  if (ok) {
    showVentusSuccess(context, deletedText);
  } else {
    final forbidden =
        ref.read(tripsControllerProvider).error is TripDeleteForbiddenException;
    showVentusError(context, forbidden ? ownerOnlyText : failedText);
  }
  if (ok) router.go(AppRoutes.home);
}

void _openCollaborators(BuildContext context, String tripId) {
  context.push(AppRoutes.collaborators(tripId));
}

/// Full-bleed cover background for the collapsing hero: gradient over the photo,
/// countdown pill, title, country · stops, dates · nights and the progress bar.
/// The back / share / more controls and the collapsed title live in the
/// [SliverAppBar] toolbar — this only renders the scrollable cover content and
/// wipes to the surface colour as it collapses so the pinned bar reads cleanly.
class _CoverBackground extends StatelessWidget {
  const _CoverBackground({
    required this.trip,
    required this.plannedPercent,
    required this.collapse,
    required this.onStartPlanning,
  });

  final Trip trip;

  /// Switches the hub to the itinerary tab (the 0%-planned call to action).
  final VoidCallback onStartPlanning;

  /// Live planning progress computed from the itinerary (days with activities).
  final int plannedPercent;

  /// 0 = expanded, 1 = collapsed; drives the wipe-to-surface overlay.
  final ValueListenable<double> collapse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = context.languageCode;
    final colors = context.colors;
    final days = trip.daysToGo;
    final countdown = days > 0
        ? l10n.tripDaysToGo(days)
        : days == 0
        ? l10n.tripToday
        : l10n.tripInProgress;

    final coverUrl = AppStorage.publicUrl(
      StorageBuckets.tripCovers,
      trip.coverImagePath,
    );
    final fmt = DateFormat.MMMd(lang);
    final endFmt = trip.startDate.month == trip.endDate.month
        ? DateFormat.d(lang).format(trip.endDate)
        : fmt.format(trip.endDate);
    final dateLine =
        '${fmt.format(trip.startDate)} – $endFmt · ${l10n.nightsCount(trip.nights)}';
    final country = localizedCountryName(trip.country, lang);
    final title = localizedPlaceTitle(trip.title, trip.country, lang);
    // The country line is dropped when it would only repeat the title
    // ("FRANCE" above "France").
    final eyebrow = trip.stops.length > 1
        ? '${country.toUpperCase()} · ${l10n.stopsCount(trip.stops.length).toUpperCase()}'
        : (foldCountryName(country) == foldCountryName(title)
              ? null
              : country.toUpperCase());

    // Paired with [tripCoverHeroTag] on the trip cards, so tapping a trip
    // grows its cover into this header rather than cutting to a new screen.
    return Hero(
      tag: tripCoverHeroTag(trip.id),
      child: TripPhoto(
        imageUrl: coverUrl,
        seed: trip.id,
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x801F1B18),
                      Color(0x1F1F1B18),
                      Color(0xD11F1B18),
                    ],
                    stops: [0, 0.32, 1],
                  ),
                ),
              ),
            ),
            // Bottom info.
            Positioned(
              left: AppSpacing.screen,
              right: AppSpacing.screen,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VentusGlassPill(icon: VentusIcons.clock, label: countdown),
                  const SizedBox(height: 10),
                  if (eyebrow != null) ...[
                    Text(
                      eyebrow,
                      style: const TextStyle(
                        fontSize: AppFontSize.caption,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.96,
                        color: AppOverlay.onPhotoMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppFontSize.h1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.9,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const VentusIcon(
                              VentusIcons.calendar,
                              size: 16,
                              color: AppOverlay.onPhotoStrong,
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                dateLine,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: AppFontSize.sm,
                                  fontWeight: FontWeight.w600,
                                  color: AppOverlay.onPhotoStrong,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Nothing planned yet: the percentage says nothing, so
                      // offer the next step instead.
                      if (plannedPercent == 0)
                        VentusTap(
                          onTap: onStartPlanning,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.tripStartPlanning,
                                style: const TextStyle(
                                  fontSize: AppFontSize.sm,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const VentusIcon(
                                VentusIcons.chevronRight,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          l10n.percentPlanned(plannedPercent),
                          style: const TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w700,
                            color: AppOverlay.onPhotoStrong,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TripProgressBar(percent: plannedPercent),
                ],
              ),
            ),
            // Wipe the cover to the surface colour as it collapses, so the pinned
            // toolbar (with the fading title) reads on a clean background.
            Positioned.fill(
              child: ValueListenableBuilder<double>(
                valueListenable: collapse,
                builder: (context, t, _) {
                  final a = ((t - 0.35) / 0.65).clamp(0.0, 1.0);
                  return IgnorePointer(
                    child: ColoredBox(
                      color: colors.surface.withValues(alpha: a),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AI nudge card shown when some itinerary days are still open.
class _AiAssist extends StatelessWidget {
  const _AiAssist({required this.onPlan});

  final VoidCallback onPlan;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: colors.primarySoft,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: AppRadius.brSm,
            ),
            child: VentusIcon(
              VentusIcons.sparkle,
              size: 19,
              color: colors.onPrimary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiAssistTitle,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  l10n.aiAssistBody,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: colors.ink2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          VentusButton(
            label: l10n.planAction,
            size: VentusButtonSize.sm,
            onPressed: onPlan,
          ),
        ],
      ),
    );
  }
}

/// Real recap of the data we already have: the route (stops) and travelers.
class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final lang = context.languageCode;

    // A stop's name is often just its country ("France" / "France"): show the
    // country once, in the app language, and route values as "A → B → C".
    String stopLabel(TripStop stop) =>
        localizedPlaceTitle(stop.name, stop.country, lang);
    final route = trip.stops.map(stopLabel).join(' → ');

    final rows = <Widget>[
      if (trip.stops.isNotEmpty)
        _InfoRow(
          icon: VentusIcons.route,
          label: l10n.routeLabel,
          value: route,
          maxLines: 2,
        ),
      if (trip.travelerType != null)
        _InfoRow(
          icon: VentusIcons.users,
          label: l10n.travelersLabel,
          value: _travelers(l10n, trip),
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Container(height: 1, color: colors.line),
              ),
            rows[i],
          ],
        ],
      ),
    );
  }

  String _travelers(AppLocalizations l10n, Trip trip) {
    final parts = <String>[
      if (trip.travelerType != null) _typeLabel(l10n, trip.travelerType!),
      l10n.adultsCount(trip.adults),
      if (trip.children > 0) l10n.childrenCount(trip.children),
    ];
    return parts.join(' · ');
  }

  String _typeLabel(AppLocalizations l10n, TravelerType type) => switch (type) {
    TravelerType.solo => l10n.travelerSolo,
    TravelerType.couple => l10n.travelerCouple,
    TravelerType.family => l10n.travelerFamily,
    TravelerType.friends => l10n.travelerFriends,
  };
}

/// One labelled fact in the details card: sand icon tile, small caps label,
/// bold value.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final String icon;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          VentusLeadIcon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BlockLabel(label: label),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.body,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                    letterSpacing: -0.16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockLabel extends StatelessWidget {
  const _BlockLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: AppFontSize.caption,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.48,
        color: context.colors.muted,
      ),
    );
  }
}

/// Primary-colored hero inviting the user to let Ventus draft the plan.
class _AiHero extends StatelessWidget {
  const _AiHero({required this.city, required this.onGenerate});

  final String city;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return ClipRRect(
      borderRadius: AppRadius.brXl,
      child: Container(
        color: colors.primary,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          24,
          AppSpacing.screen,
          24,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  color: Color(0x14FFFFFF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppOverlay.glassFill,
                    borderRadius: AppRadius.brMd,
                  ),
                  child: VentusIcon(
                    VentusIcons.sparkle,
                    size: 26,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.aiHubTitle(city),
                  style: TextStyle(
                    fontSize: AppFontSize.h2,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.46,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 290),
                  child: Text(
                    l10n.aiHubBody,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      height: 1.45,
                      color: colors.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _OnPrimaryButton(
                  label: l10n.aiHubGenerate,
                  icon: VentusIcons.sparkle,
                  onTap: onGenerate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// White pill button used on the primary AI hero (inverse of VentusButton).
class _OnPrimaryButton extends StatelessWidget {
  const _OnPrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VentusIcon(icon, size: 18, color: colors.primary),
            const SizedBox(width: 9),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
                color: context.primaryFill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2×2 "how ready is this trip" tiles: one per module, each with a one-line
/// status and a thin progress bar, tapping through to that module's tab.
class _ReadinessGrid extends StatelessWidget {
  const _ReadinessGrid({
    required this.itinerarySub,
    required this.itineraryFraction,
    required this.budgetSub,
    required this.budgetFraction,
    required this.budgetOver,
    required this.documentsSub,
    required this.checklistSub,
    required this.checklistFraction,
    required this.onOpen,
  });

  final String itinerarySub;
  final double itineraryFraction;
  final String budgetSub;
  final double budgetFraction;
  final bool budgetOver;
  final String documentsSub;
  final String checklistSub;
  final double checklistFraction;
  final ValueChanged<HubTab> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _ReadinessTile(
                  icon: VentusIcons.route,
                  title: l10n.moduleItinerary,
                  sub: itinerarySub,
                  fraction: itineraryFraction,
                  onTap: () => onOpen(HubTab.itinerary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReadinessTile(
                  icon: VentusIcons.wallet,
                  title: l10n.moduleBudget,
                  sub: budgetSub,
                  fraction: budgetFraction,
                  color: budgetOver ? colors.danger : null,
                  onTap: () => onOpen(HubTab.budget),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _ReadinessTile(
                  icon: VentusIcons.document,
                  title: l10n.moduleDocuments,
                  sub: documentsSub,
                  onTap: () => onOpen(HubTab.documents),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReadinessTile(
                  icon: VentusIcons.listCheck,
                  title: l10n.moduleChecklistShort,
                  sub: checklistSub,
                  fraction: checklistFraction,
                  color: checklistFraction >= 1 ? colors.success : null,
                  onTap: () => onOpen(HubTab.checklist),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadinessTile extends StatelessWidget {
  const _ReadinessTile({
    required this.icon,
    required this.title,
    required this.sub,
    required this.onTap,
    this.fraction,
    this.color,
  });

  final String icon;
  final String title;
  final String sub;
  final VoidCallback onTap;

  /// 0..1 progress shown as a thin bar; null hides the bar (documents).
  final double? fraction;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                VentusLeadIcon(icon, slot: 24),
                const Spacer(),
                VentusIcon(
                  VentusIcons.chevronRight,
                  size: 16,
                  color: colors.muted,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
                color: colors.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
            ),
            const SizedBox(height: 10),
            // Reserve the bar's height even when hidden so tiles in a row
            // keep the same rhythm.
            SizedBox(
              height: 5,
              child: fraction == null
                  ? null
                  : ClipRRect(
                      borderRadius: AppRadius.brFull,
                      child: ColoredBox(
                        color: colors.surfaceSand,
                        child: AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.centerLeft,
                          widthFactor: fraction!.clamp(0.0, 1.0),
                          child: ColoredBox(color: color ?? colors.primary),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Manual "start" row — icon, title, subtitle, chevron.
class _StartRow extends StatelessWidget {
  const _StartRow({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            VentusLeadIcon(icon, slot: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            VentusIcon(VentusIcons.chevronRight, size: 20, color: colors.muted),
          ],
        ),
      ),
    );
  }
}
