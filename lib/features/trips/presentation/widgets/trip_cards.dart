import '../../../../core/theme/app_colors.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_overlay.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/country_names.dart';
import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/storage/app_storage.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/trip.dart';
import 'budget_format.dart';
import 'trip_photo.dart';
import '../../../../core/theme/app_typography.dart';

/// Public URL of a trip's cover, resolved from its `trip-covers` object path
/// (null when unset/offline — [TripPhoto] then shows the gradient fallback).
String? _coverUrl(Trip trip) =>
    AppStorage.publicUrl(StorageBuckets.tripCovers, trip.coverImagePath);

/// "Jun 17 – Jun 20" date range with a leading calendar icon.
class TripDateRow extends StatelessWidget {
  const TripDateRow({
    super.key,
    required this.trip,
    this.color,
    this.size = 14,
    this.trailing,
  });

  final Trip trip;
  final Color? color;
  final double size;

  /// Appended after the dates as `dates · trailing` (the hero card puts the
  /// country here instead of giving it a line of its own).
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.muted;
    // Locale-aware month/day, e.g. "Jun 17" / "17 iyn" depending on language.
    final fmt = DateFormat.MMMd(context.languageCode);
    final dates = '${fmt.format(trip.startDate)} – ${fmt.format(trip.endDate)}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VentusIcon(VentusIcons.calendar, size: size + 2, color: c),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            trailing == null ? dates : '$dates · $trailing',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w600,
              color: c,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

/// Hero tag for a trip's cover photo, shared by every card that shows it and
/// by the Trip Hub's cover — so opening a trip grows the photo in place
/// instead of cutting to a new screen.
///
/// Only one of these may be live in a subtree at a time. The bottom-nav shell
/// disables [Hero]s in its inactive branches for exactly that reason; see the
/// `navigatorContainerBuilder` in `app_router.dart`.
String tripCoverHeroTag(String tripId) => 'trip-cover-$tripId';

/// Large featured trip on Home: cover, countdown pill, dates, collaborators
/// and progress.
class TripHeroCard extends StatelessWidget {
  const TripHeroCard({
    super.key,
    required this.trip,
    required this.plannedPercent,
    this.onTap,
    this.collaboratorInitials = const [],
    this.budgetTotal,
    this.budgetSpent,
    this.budgetCurrency,
  });

  final Trip trip;

  /// Share of the trip's days that are planned, computed live from the
  /// itinerary by [plannedPercentFor] — the `trips.planned_percent` column is
  /// only ever written by the demo seed, so reading it here showed "0%" on
  /// every real trip no matter how full its plan was.
  final int plannedPercent;

  final VoidCallback? onTap;

  /// Up to a handful of collaborator initials shown as a stacked avatar row
  /// (an overflow "+N" pill is added automatically beyond the 2 shown).
  final List<String> collaboratorInitials;

  /// When a budget is configured ([budgetTotal] > 0), a spend bar replaces
  /// nothing — it's shown in addition to the itinerary progress bar.
  final double? budgetTotal;
  final double? budgetSpent;
  final String? budgetCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = trip.daysToGo;
    final countdown = days > 0
        ? l10n.tripDaysToGo(days)
        : days == 0
        ? l10n.tripToday
        : l10n.tripInProgress;
    final hasCover = _coverUrl(trip) != null;
    final hasBudget = (budgetTotal ?? 0) > 0;
    final spent = budgetSpent ?? 0;
    final total = budgetTotal ?? 0;
    final remaining = total - spent;
    final budgetPct = hasBudget
        ? (spent / total * 100).round().clamp(0, 100)
        : 0;

    return VentusTap(
      onTap: onTap,
      // Credit-card proportions (ISO/IEC 7810 ID-1) rather than a fixed height,
      // so the card keeps the same silhouette on every screen width and stays
      // short enough for the module grid below it to sit above the fold.
      child: AspectRatio(
        aspectRatio: 1.586,
        child: Hero(
          tag: tripCoverHeroTag(trip.id),
          child: TripPhoto(
            imageUrl: _coverUrl(trip),
            seed: trip.id,
            borderRadius: AppRadius.brLg,
            child: Stack(
              children: [
                if (!hasCover) ...[
                  Positioned(
                    right: -50,
                    top: -60,
                    child: _SoftCircle(size: 220, alpha: 0.14),
                  ),
                  Positioned(
                    right: 40,
                    top: 70,
                    child: _SoftCircle(size: 110, alpha: 0.10),
                  ),
                ],
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: hasCover ? 0.75 : 0.5),
                        ],
                        stops: const [0.4, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: VentusGlassPill(
                    icon: VentusIcons.calendar,
                    label: countdown,
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              trip.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.typography.h1.copyWith(
                                fontSize: AppFontSize.h1,
                                height: 1.1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (collaboratorInitials.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            _AvatarStack(initials: collaboratorInitials),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Country moved off its own eyebrow line and onto the meta
                      // row — one line saved, which is most of what buys the
                      // shorter card.
                      Row(
                        children: [
                          Flexible(
                            child: TripDateRow(
                              trip: trip,
                              color: AppOverlay.onPhotoStrong,
                              size: 13,
                              trailing: localizedCountryName(
                                trip.country,
                                context.languageCode,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.percentPlanned(plannedPercent),
                            style: TextStyle(
                              fontSize: AppFontSize.caption,
                              fontWeight: FontWeight.w700,
                              color: AppOverlay.onPhotoStrong,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Only ever one bar: the budget is the more useful of the
                      // two, so it wins when there is one.
                      if (hasBudget) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.moduleBudget,
                              style: TextStyle(
                                fontSize: AppFontSize.caption,
                                color: AppOverlay.onPhotoMuted,
                              ),
                            ),
                            Text(
                              '${formatMoney(spent, budgetCurrency ?? 'USD')} / '
                              '${formatMoney(total, budgetCurrency ?? 'USD')}',
                              style: TextStyle(
                                fontSize: AppFontSize.caption,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TripProgressBar(
                          percent: budgetPct.toInt(),
                          color: remaining < 0 ? const Color(0xFFFF8A65) : null,
                        ),
                      ] else
                        TripProgressBar(percent: plannedPercent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Stacked collaborator initials (prototype `Home.jsx` hero avatars), capped
/// at 2 visible with a "+N" overflow pill for the rest.
class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.initials});

  final List<String> initials;

  @override
  Widget build(BuildContext context) {
    final shown = initials.take(2).toList();
    final overflow = initials.length - shown.length;
    final circles = shown.length + (overflow > 0 ? 1 : 0);
    return SizedBox(
      // A Stack made entirely of Positioned children (as this one is) sizes
      // itself to its constraints rather than its content, and needs those
      // constraints to be bounded — which they aren't when this sits as a
      // non-flex child of a Row (Flex measures such children with an
      // unbounded main axis). Giving the SizedBox an explicit width, not just
      // height, keeps this widget correct regardless of where it's placed.
      width: circles == 0 ? 0 : (circles - 1) * 20.0 + 30,
      height: 30,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * 20.0,
              child: _AvatarCircle(label: shown[i]),
            ),
          if (overflow > 0)
            Positioned(
              left: shown.length * 20.0,
              child: _AvatarCircle(label: '+$overflow', glass: true),
            ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.label, this.glass = false});

  final String label;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: glass ? const Color(0xE6FBF7F1) : null,
        gradient: glass ? null : AppColors.heroGradient,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSize.eyebrow,
          fontWeight: FontWeight.w700,
          color: glass ? const Color(0xFF0B2A2E) : Colors.white,
        ),
      ),
    );
  }
}

/// Small trip card used in the horizontal "Your trips" row.
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, this.onTap});

  final Trip trip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        width: 158,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_coverUrl(trip) != null)
              TripPhoto(
                imageUrl: _coverUrl(trip),
                seed: trip.id,
                height: 104,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              )
            else
              Container(
                height: 104,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceSand,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg),
                  ),
                ),
                child: VentusIcon(
                  VentusIcons.mapPin,
                  size: 28,
                  color: colors.muted,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedCountryName(
                      trip.country,
                      context.languageCode,
                    ).toUpperCase(),
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
                  const SizedBox(height: 6),
                  TripDateRow(trip: trip, size: 12.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tall inspiration card for the "Discover" row.
class DiscoverCard extends StatelessWidget {
  const DiscoverCard({
    super.key,
    required this.title,
    required this.country,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String country;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VentusTap(
      onTap: onTap,
      child: TripPhoto(
        imageUrl: imageUrl,
        seed: '$country-$title',
        width: 132,
        height: 168,
        borderRadius: AppRadius.brLg,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    stops: const [0.45, 1],
                  ),
                ),
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
                    country.toUpperCase(),
                    style: const TextStyle(
                      fontSize: AppFontSize.eyebrow,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppOverlay.onPhotoMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppFontSize.h3,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

/// The thin progress bar drawn over a trip's cover photo — planning progress
/// on the Trip Hub, budget spend on the home card.
class TripProgressBar extends StatelessWidget {
  const TripProgressBar({super.key, required this.percent, this.color});

  final int percent;
  final Color? color;

  /// Track height, and the diameter of the fill's rounded ends.
  static const _height = 6.0;

  /// Shortest fill that still reads as a bar. A ₼10 spend against a ₼1,000
  /// budget is 1%, which as a plain fraction of the width came out as a 3px
  /// speck floating on the card — it looked like a rendering glitch rather
  /// than "barely started".
  static const _minFill = 14.0;

  @override
  Widget build(BuildContext context) {
    final fraction = percent.clamp(0, 100) / 100;

    return LayoutBuilder(
      builder: (context, constraints) {
        final full = constraints.maxWidth;
        final width = fraction == 0
            ? 0.0
            : math.max(_minFill, full * fraction).clamp(0.0, full);

        return SizedBox(
          height: _height,
          child: Stack(
            children: [
              // A stronger track than the fill needs, because it has to stay
              // visible over a bright cover photo.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0x5CFFFFFF),
                    borderRadius: AppRadius.brFull,
                  ),
                ),
              ),
              if (width > 0)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  width: width,
                  height: _height,
                  decoration: BoxDecoration(
                    color: color ?? Colors.white,
                    borderRadius: AppRadius.brFull,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Decorative translucent disc used on the cover-less hero card.
class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}
