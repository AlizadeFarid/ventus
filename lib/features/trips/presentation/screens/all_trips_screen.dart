import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/country_names.dart';
import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/storage/app_storage.dart';
import '../../../../core/utils/country_flag.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/trips_controller.dart';
import '../../application/trips_providers.dart';
import '../../data/supabase_trips_remote.dart'
    show TripDeleteForbiddenException;
import '../../domain/trip.dart';
import '../widgets/trip_cards.dart';
import '../widgets/trip_photo.dart';
import '../../../../core/utils/refresh.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Full list of the user's trips, reached from Home's "Your trips → See all".
/// Trips are grouped into Upcoming (soonest first) and Past (most recent first).
class AllTripsScreen extends ConsumerWidget {
  const AllTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tripsAsync = ref.watch(tripsProvider);
    final upcoming = ref.watch(upcomingTripsProvider);
    final past = ref.watch(pastTripsProvider);

    return TabScaffold(
      active: VentusTab.trips,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VentusTabTitle(l10n.allTrips),
          Expanded(
            child: tripsAsync.when(
              loading: () => const VentusListSkeleton(itemHeight: 96),
              error: (e, _) => _Empty(message: l10n.couldNotLoadTrips),
              data: (trips) => trips.isEmpty
                  ? _Empty(message: l10n.allTripsEmptyBody, illustrated: true)
                  : RefreshIndicator(
                      onRefresh: () => refreshQuietly(() async {
                        ref.invalidate(tripsBootstrapProvider);
                        await ref.read(tripsProvider.future);
                      }),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screen,
                          0,
                          AppSpacing.screen,
                          28,
                        ),
                        children: [
                          if (upcoming.isNotEmpty) ...[
                            VentusSectionLabel(
                              '${l10n.tripsUpcoming} · ${upcoming.length}',
                            ),
                            for (final t in upcoming) _TripRowCard(trip: t),
                          ],
                          if (past.isNotEmpty) ...[
                            SizedBox(height: upcoming.isEmpty ? 0 : 8),
                            VentusSectionLabel(
                              '${l10n.tripsPast} · ${past.length}',
                            ),
                            for (final t in past)
                              _TripRowCard(trip: t, faded: true),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width trip row: cover thumbnail, country, title, dates. Past trips are
/// dimmed to read as history.
class _TripRowCard extends ConsumerWidget {
  const _TripRowCard({required this.trip, this.faded = false});

  final Trip trip;
  final bool faded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final coverUrl = AppStorage.publicUrl(
      StorageBuckets.tripCovers,
      trip.coverImagePath,
    );
    final hasCover = coverUrl != null && coverUrl.isNotEmpty;
    final flag = countryFlag(trip.country);

    // Swipe left to delete, long-press for the same confirm dialog. The
    // dialog runs from confirmDismiss so a cancelled swipe snaps back.
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(trip.id),
        direction: DismissDirection.endToStart,
        background: const VentusSwipeDeleteBackground(
          borderRadius: AppRadius.brLg,
        ),
        confirmDismiss: (_) async {
          await _deleteTrip(context, ref, trip);
          // The list rebuilds from the trips stream; never let Dismissible
          // remove the row itself.
          return false;
        },
        child: VentusTap(
          onTap: () => context.push(AppRoutes.tripDetail(trip.id)),
          onLongPress: () => _deleteTrip(context, ref, trip),
          child: Opacity(
            opacity: faded ? 0.7 : 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.brLg,
                boxShadow: context.shadows.card,
              ),
              child: Row(
                children: [
                  // No photo: just the country's flag, no background tile.
                  if (hasCover)
                    TripPhoto(
                      imageUrl: coverUrl,
                      seed: trip.id,
                      width: 84,
                      height: 84,
                      borderRadius: AppRadius.brMd,
                    )
                  else
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: Center(
                        child: flag != null
                            ? Text(
                                flag,
                                style: const TextStyle(
                                  fontSize: AppFontSize.hero,
                                ),
                              )
                            : VentusIcon(
                                VentusIcons.globe,
                                size: 36,
                                color: colors.muted,
                              ),
                      ),
                    ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizedCountryName(
                            trip.country,
                            context.languageCode,
                          ).toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSize.eyebrow,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: colors.muted,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          trip.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSize.body,
                            fontWeight: FontWeight.w600,
                            color: colors.ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TripDateRow(trip: trip, size: 12.5),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  VentusIcon(
                    VentusIcons.arrowRight,
                    size: 18,
                    color: colors.muted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Confirm, then delete [trip] for real (same flow as the trip hub's "…").
Future<void> _deleteTrip(BuildContext context, WidgetRef ref, Trip trip) async {
  final l10n = context.l10n;
  final confirmed = await confirmVentusAction(
    context,
    title: l10n.deleteTripTitle,
    body: l10n.deleteTripBody,
    confirmLabel: l10n.deleteConfirm,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return;

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
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message, this.illustrated = false});

  final String message;

  /// Shows the passport illustration (a friendly "nothing here yet") instead of
  /// the plain icon, which is kept for the error state.
  final bool illustrated;

  @override
  Widget build(BuildContext context) {
    return VentusEmptyState(
      icon: illustrated ? null : VentusIcons.compass,
      leading: illustrated ? const VentusPassportIllustration() : null,
      body: message,
    );
  }
}
