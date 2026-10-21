import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../trips/application/trips_providers.dart';
import '../../application/tools_providers.dart';
import '../../data/open_meteo_repository.dart' show ToolsException;
import '../../domain/geo_city.dart';
import '../widgets/city_search_results.dart';
import '../widgets/tools_header.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Timezone tool (prototype `Tools.jsx` → ClockFull, state D): the device's
/// home time against the featured pinned city (matched to the active trip
/// when its name/country lines up), with a diff pill and any extra pinned
/// cities listed below.
class ClockToolScreen extends ConsumerStatefulWidget {
  const ClockToolScreen({super.key});

  @override
  ConsumerState<ClockToolScreen> createState() => _ClockToolScreenState();
}

class _ClockToolScreenState extends ConsumerState<ClockToolScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _addCity(GeoCity picked) async {
    // The geocoding search behind the picker doesn't return a UTC offset, so
    // look the real (DST-aware) one up before pinning the city — otherwise it
    // defaults to 0 and reads as UTC.
    var city = picked;
    try {
      final offset = await ref
          .read(openMeteoRepositoryProvider)
          .fetchUtcOffsetSeconds(picked.lat, picked.lon);
      city = GeoCity(
        name: picked.name,
        country: picked.country,
        lat: picked.lat,
        lon: picked.lon,
        timezone: picked.timezone,
        utcOffsetSeconds: offset,
      );
    } on ToolsException {
      // Fall back to the offset-less city rather than losing the pick.
    }
    if (!mounted) return;
    ref.read(clockCitiesProvider.notifier).add(city);
  }

  void _remove(int index, GeoCity city) {
    final notifier = ref.read(clockCitiesProvider.notifier);
    notifier.removeAt(index);
    final l10n = context.l10n;
    showVentusSnack(
      context,
      l10n.clockCityRemoved,
      kind: VentusSnackKind.success,
      actionLabel: l10n.undo,
      onAction: () => notifier.insertAt(index, city),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final lang = context.languageCode;
    final cities = ref.watch(clockCitiesProvider);
    final trip = ref.watch(featuredTripProvider);
    final home = DateTime.now();

    final featured = cities.isNotEmpty ? cities.first : null;
    final isTripCity =
        featured != null &&
        trip != null &&
        (trip.country.toLowerCase().contains(featured.country.toLowerCase()) ||
            featured.country.toLowerCase().contains(
              trip.country.toLowerCase(),
            ));

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolsHeader(title: l10n.toolWorldClock),
            Expanded(
              child: VentusSearchLayout(
                hintText: l10n.searchCity,
                resultsBuilder: (context, query, close) => CitySearchResults(
                  query: query,
                  onPick: (picked) {
                    _addCity(picked);
                    close();
                  },
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    4,
                    AppSpacing.screen,
                    24,
                  ),
                  children: [
                    _TimeCard(
                      label: l10n.clockHome,
                      time: home,
                      dayLabel: _dayLabel(l10n, home, home),
                      daytime: _isDaytime(home),
                      dark: true,
                      highlighted: false,
                    ),
                    if (featured != null) ...[
                      const SizedBox(height: 12),
                      Dismissible(
                        key: ValueKey(
                          'clock-${featured.name}-${featured.timezone}',
                        ),
                        direction: DismissDirection.endToStart,
                        background: const VentusSwipeDeleteBackground(
                          borderRadius: AppRadius.brLg,
                        ),
                        onDismissed: (_) => _remove(0, featured),
                        child: _TimeCard(
                          label: isTripCity
                              ? '${featured.name} · ${l10n.timezoneTripTag}'
                              : featured.name,
                          time: featured.localTime,
                          dayLabel: _dayLabel(l10n, featured.localTime, home),
                          daytime: _isDaytime(featured.localTime),
                          footer: _relation(l10n, featured, home),
                          dark: false,
                          highlighted: isTripCity,
                        ),
                      ),
                    ],
                    if (cities.length > 1) ...[
                      const SizedBox(height: 12),
                      for (var i = 1; i < cities.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Dismissible(
                            key: ValueKey(
                              'clock-${cities[i].name}-${cities[i].timezone}',
                            ),
                            direction: DismissDirection.endToStart,
                            background: const VentusSwipeDeleteBackground(
                              borderRadius: AppRadius.brMd,
                            ),
                            onDismissed: (_) => _remove(i, cities[i]),
                            child: _CityTile(
                              city: cities[i],
                              home: home,
                              lang: lang,
                              onTap: () => ref
                                  .read(clockCitiesProvider.notifier)
                                  .featureAt(i),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool _isDaytime(DateTime t) => t.hour >= 6 && t.hour < 19;

int _diffSeconds(GeoCity city, DateTime home) =>
    city.utcOffsetSeconds - home.timeZoneOffset.inSeconds;

/// "2" or "5:30" — whole hours stay clean, half-hour zones keep the minutes.
String _hoursText(int seconds) {
  final minutes = (seconds.abs() / 60).round();
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '$h' : '$h:${m.toString().padLeft(2, '0')}';
}

String _relation(AppLocalizations l10n, GeoCity city, DateTime home) {
  final diff = _diffSeconds(city, home);
  if (diff.abs() < 60) return l10n.clockSameAsHome;
  final hours = _hoursText(diff);
  return diff < 0 ? l10n.clockBehindHome(hours) : l10n.clockAheadOfHome(hours);
}

/// Today / Tomorrow / Yesterday for [time] (a wall-clock value at some place)
/// against the device's date — the weekday name alone doesn't tell you
/// whether that city is already a day ahead.
String _dayLabel(AppLocalizations l10n, DateTime time, DateTime home) {
  final a = DateTime.utc(time.year, time.month, time.day);
  final b = DateTime.utc(home.year, home.month, home.day);
  final days = a.difference(b).inDays;
  if (days == 0) return l10n.weatherToday;
  if (days == 1) return l10n.weatherTomorrow;
  if (days == -1) return l10n.clockYesterday;
  return DateFormat.MMMd().format(time);
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.label,
    required this.time,
    required this.dayLabel,
    required this.daytime,
    required this.dark,
    required this.highlighted,
    this.footer,
  });

  final String label;
  final DateTime time;
  final String dayLabel;
  final bool daytime;
  final String? footer;
  final bool dark;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final soft = dark ? colors.onPrimary.withValues(alpha: 0.92) : colors.muted;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? colors.primaryPress : colors.surface,
        borderRadius: AppRadius.brLg,
        border: highlighted
            ? Border.all(color: colors.primary, width: 1.5)
            : null,
        boxShadow: highlighted || dark ? null : context.shadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: dark
                        ? colors.onPrimary.withValues(alpha: 0.92)
                        : (highlighted ? colors.primaryPress : colors.muted),
                  ),
                ),
              ),
              VentusIcon(
                daytime ? VentusIcons.sun : VentusIcons.moon,
                size: 18,
                color: dark
                    ? colors.onPrimary
                    : (daytime ? colors.amber : colors.muted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('HH:mm').format(time),
                style: context.typography.h1.copyWith(
                  fontSize: AppFontSize.display,
                  fontWeight: FontWeight.w600,
                  color: dark ? colors.onPrimary : colors.ink,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  dayLabel,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: soft,
                  ),
                ),
              ),
            ],
          ),
          if (footer != null) ...[
            const SizedBox(height: 6),
            Text(
              footer!,
              style: TextStyle(fontSize: AppFontSize.sm, color: soft),
            ),
          ],
        ],
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({
    required this.city,
    required this.home,
    required this.lang,
    required this.onTap,
  });

  final GeoCity city;
  final DateTime home;
  final String lang;

  /// Promotes this city to the large featured card next to Home.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final local = city.localTime;
    final daytime = _isDaytime(local);
    final diff = _diffSeconds(city, home);
    final offset = diff.abs() < 60
        ? l10n.clockSameShort
        : '${diff < 0 ? '−' : '+'}${_hoursText(diff)}${l10n.clockHourShort}';
    final day = _dayLabel(l10n, local, home);

    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brMd,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surfaceSand,
                shape: BoxShape.circle,
              ),
              child: VentusIcon(
                daytime ? VentusIcons.sun : VentusIcons.moon,
                size: 19,
                color: daytime ? colors.amber : colors.muted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  if (city.country.isNotEmpty)
                    Text(
                      city.country,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('HH:mm').format(local),
                  style: TextStyle(
                    fontSize: AppFontSize.h3,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                Text(
                  '$offset · $day',
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w600,
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
