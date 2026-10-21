import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/preferences/unit_system_provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/tools_providers.dart';
import '../../domain/weather.dart';
import '../tools_format.dart';
import '../widgets/city_search_results.dart';
import '../widgets/tools_header.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Weather tool (prototype `Tools.jsx` → WeatherFull): a current-conditions hero
/// with an hourly strip and a 5-day outlook, for a searchable city. Real data
/// from the free, key-less Open-Meteo forecast API.
class WeatherToolScreen extends ConsumerWidget {
  const WeatherToolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final city = ref.watch(weatherCityProvider).asData?.value ?? kDefaultCity;
    final cityName =
        ref
            .watch(
              cityDisplayNameProvider((
                name: city.name,
                lat: city.lat,
                lon: city.lon,
              )),
            )
            .asData
            ?.value ??
        city.name;
    final weather = ref.watch(weatherProvider((lat: city.lat, lon: city.lon)));
    final imperial = ref.watch(unitSystemProvider) == UnitSystem.imperial;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolsHeader(title: l10n.toolWeather, subtitle: cityName),
            Expanded(
              child: VentusSearchLayout(
                hintText: l10n.searchCity,
                resultsBuilder: (context, query, close) => CitySearchResults(
                  query: query,
                  onPick: (picked) {
                    ref.read(weatherCityProvider.notifier).set(picked);
                    close();
                  },
                ),
                child: weather.when(
                  loading: () => const VentusListSkeleton(
                    itemCount: 3,
                    itemHeight: 132,
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      4,
                      AppSpacing.screen,
                      24,
                    ),
                  ),
                  error: (_, _) => Center(
                    child: _Retry(
                      onRetry: () => ref.invalidate(
                        weatherProvider((lat: city.lat, lon: city.lon)),
                      ),
                    ),
                  ),
                  data: (w) => _Body(weather: w, imperial: imperial),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.weather, required this.imperial});

  final Weather weather;
  final bool imperial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = context.languageCode;
    final w = weather;
    final unit = imperial ? 'F' : 'C';
    final timeFmt = DateFormat.Hm(lang);
    final wind = '${w.windSpeed.round()}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        4,
        AppSpacing.screen,
        24,
      ),
      children: [
        _Hero(weather: w, unit: unit, lang: lang),
        const SizedBox(height: 12),
        _DetailGrid(
          tiles: [
            (l10n.weatherFeelsLike, '${w.feelsLike.round()}°'),
            (
              l10n.weatherWind,
              imperial ? l10n.weatherWindMph(wind) : l10n.weatherWindKmh(wind),
            ),
            (l10n.weatherHumidity, '${w.humidity}%'),
            (
              l10n.weatherRainChance,
              w.today.rainChance == null ? '–' : '${w.today.rainChance}%',
            ),
            (
              l10n.weatherSunrise,
              w.today.sunrise == null ? '–' : timeFmt.format(w.today.sunrise!),
            ),
            (
              l10n.weatherSunset,
              w.today.sunset == null ? '–' : timeFmt.format(w.today.sunset!),
            ),
          ],
        ),
        const SizedBox(height: 20),
        VentusSectionLabel(l10n.weatherNextDays),
        VentusCard(
          children: [
            for (var i = 0; i < w.daily.length; i++)
              _DayRow(day: w.daily[i], isTomorrow: i == 0, lang: lang),
          ],
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.weather, required this.unit, required this.lang});

  final Weather weather;
  final String unit;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final w = weather;
    final onSoft = colors.onPrimary.withValues(alpha: 0.92);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        // Solid deep brand tone: white text stays AA-readable on it (the
        // brighter gradient is not, at the small hour labels).
        color: context.primaryFill,
        borderRadius: AppRadius.brXl,
        boxShadow: [
          BoxShadow(
            color: context.primaryFill.withValues(alpha: 0.3),
            offset: const Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.weatherToday} · ${DateFormat.MMMd(lang).format(w.localNow)}',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        color: onSoft,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${w.currentTemp.round()}°$unit',
                      style: TextStyle(
                        fontSize: AppFontSize.hero,
                        fontWeight: FontWeight.w800,
                        height: 0.9,
                        letterSpacing: -2,
                        color: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weatherLabel(l10n, w.currentCode),
                      style: TextStyle(
                        fontSize: AppFontSize.body,
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${w.today.high.round()}° / ${w.today.low.round()}°',
                      style: TextStyle(fontSize: AppFontSize.sm, color: onSoft),
                    ),
                  ],
                ),
              ),
              VentusIcon(
                weatherIcon(w.currentCode),
                size: 56,
                color: colors.onPrimary,
              ),
            ],
          ),
          if (w.hourly.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.only(top: 14),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colors.onPrimary.withValues(alpha: 0.4),
                  ),
                ),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < w.hourly.length; i++)
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            i == 0
                                ? l10n.weatherNow
                                : DateFormat('HH:00').format(w.hourly[i].time),
                            style: TextStyle(
                              fontSize: AppFontSize.caption,
                              fontWeight: FontWeight.w700,
                              color: onSoft,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: VentusIcon(
                              weatherIcon(w.hourly[i].code),
                              size: 20,
                              color: colors.onPrimary,
                            ),
                          ),
                          Text(
                            '${w.hourly[i].temp.round()}°',
                            style: TextStyle(
                              fontSize: AppFontSize.sm,
                              fontWeight: FontWeight.w700,
                              color: colors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Two-column grid of small label/value cards (feels like, wind, …).
class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.tiles});

  final List<(String, String)> tiles;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    Widget tile((String, String) t) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.$1, style: type.sm.copyWith(color: colors.muted)),
          const SizedBox(height: 4),
          Text(
            t.$2,
            style: type.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        for (var i = 0; i < tiles.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: tile(tiles[i])),
              const SizedBox(width: 12),
              Expanded(
                child: i + 1 < tiles.length
                    ? tile(tiles[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.isTomorrow,
    required this.lang,
  });

  final DayForecast day;
  final bool isTomorrow;
  final String lang;

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final name = isTomorrow
        ? l10n.weatherTomorrow
        : _capitalize(DateFormat.EEEE(lang).format(day.date));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
                color: colors.ink,
              ),
            ),
          ),
          VentusIcon(
            weatherIcon(day.code),
            size: 22,
            color: weatherKindFor(day.code) == WeatherKind.clear
                ? colors.amber
                : colors.primary,
          ),
          const SizedBox(width: 16),
          // Fixed-width columns so highs and lows line up row to row.
          SizedBox(
            width: 38,
            child: Text(
              '${day.high.round()}°',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
          ),
          SizedBox(
            width: 38,
            child: Text(
              '${day.low.round()}°',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: AppFontSize.body, color: colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.toolsOffline, style: TextStyle(color: context.colors.muted)),
        const SizedBox(height: 12),
        VentusButton(label: l10n.tryAgain, onPressed: onRetry),
      ],
    );
  }
}
