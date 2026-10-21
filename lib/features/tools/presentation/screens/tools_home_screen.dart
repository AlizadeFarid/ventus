import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/preferences/preferred_currency_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../trips/application/budget_providers.dart';
import '../../../trips/application/trips_providers.dart';
import '../../application/tools_providers.dart';
import '../tools_format.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Tools tab hub (prototype `Tools.jsx` → ToolsHome, state A): a short list of
/// on-the-road utilities — Currency, Tip, Timezone — plus a contextual banner
/// naming the active trip when one exists.
class ToolsHomeScreen extends ConsumerWidget {
  const ToolsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final trip = ref.watch(featuredTripProvider);

    return TabScaffold(
      active: VentusTab.tools,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VentusTabTitle(l10n.navTools),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                16,
              ),
              children: [
                if (trip != null) ...[
                  _ActiveTripBanner(tripTitle: trip.title),
                  const SizedBox(height: 18),
                ],
                _ToolRow(
                  icon: VentusIcons.wallet,
                  title: l10n.toolCurrency,
                  subtitle: const _CurrencySubtitle(),
                  onTap: () => context.push(AppRoutes.toolsCurrency),
                ),
                const SizedBox(height: 12),
                _ToolRow(
                  icon: VentusIcons.listCheck,
                  title: l10n.toolTip,
                  subtitle: Text(
                    l10n.tipSubtitle,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color: colors.muted,
                    ),
                  ),
                  onTap: () => context.push(AppRoutes.toolsTip),
                ),
                const SizedBox(height: 12),
                _ToolRow(
                  icon: VentusIcons.sun,
                  title: l10n.toolWeather,
                  subtitle: const _WeatherSubtitle(),
                  onTap: () => context.push(AppRoutes.toolsWeather),
                ),
                const SizedBox(height: 12),
                _ToolRow(
                  icon: VentusIcons.clock,
                  title: l10n.toolWorldClock,
                  subtitle: const _TimezoneSubtitle(),
                  onTap: () => context.push(AppRoutes.toolsClock),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveTripBanner extends StatelessWidget {
  const _ActiveTripBanner({required this.tripTitle});

  final String tripTitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceSand,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        children: [
          VentusIcon(VentusIcons.plane, size: 17, color: colors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: l10n.toolsActiveTripBanner(tripTitle),
                style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final Widget subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            VentusLeadIcon(icon, size: 26, slot: 32),
            const SizedBox(width: 14),
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
                  const SizedBox(height: 2),
                  subtitle,
                ],
              ),
            ),
            const SizedBox(width: 8),
            VentusIcon(VentusIcons.chevronRight, size: 20, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

class _CurrencySubtitle extends ConsumerWidget {
  const _CurrencySubtitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final rates = ref.watch(currencyRatesProvider);
    final home = ref.watch(preferredCurrencyProvider);
    final trip = ref.watch(featuredTripProvider);
    final tripBudget = trip == null
        ? null
        : ref.watch(tripBudgetProvider(trip.id)).asData?.value;
    final foreign = (tripBudget != null && tripBudget.currency != home)
        ? tripBudget.currency
        : (home == 'EUR' ? 'USD' : 'EUR');

    return rates.when(
      loading: () => Text(
        '—',
        style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
      ),
      error: (_, _) => Text(
        l10n.toolsOffline,
        style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
      ),
      data: (r) {
        final rate = r.rate(foreign, home);
        // The bank publishes on business days, so the newest rate is often
        // yesterday's — say which day it is instead of always "today".
        final now = DateTime.now();
        final isToday =
            r.date.year == now.year &&
            r.date.month == now.month &&
            r.date.day == now.day;
        final when = isToday
            ? l10n.toolsRateToday
            : DateFormat.MMMd(context.languageCode).format(r.date);
        return Text(
          l10n.toolsCurrencyHint(
            currencyGlyph(foreign),
            rate.toStringAsFixed(2),
            currencyGlyph(home),
            when,
          ),
          style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
        );
      },
    );
  }
}

/// Live "22° · Baku" line under the Weather row, from the same providers the
/// Weather tool itself uses — so the hub shows real data, not a static blurb.
class _WeatherSubtitle extends ConsumerWidget {
  const _WeatherSubtitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final style = TextStyle(fontSize: AppFontSize.sm, color: colors.muted);
    final city = ref.watch(weatherCityProvider).asData?.value ?? kDefaultCity;
    final weather = ref.watch(weatherProvider((lat: city.lat, lon: city.lon)));

    return weather.when(
      loading: () => Text('—', style: style),
      error: (_, _) => Text(l10n.toolsOffline, style: style),
      data: (w) => Text(
        l10n.toolsWeatherHint('${w.currentTemp.round()}', city.name),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

class _TimezoneSubtitle extends ConsumerWidget {
  const _TimezoneSubtitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final cities = ref.watch(clockCitiesProvider);
    if (cities.isEmpty) {
      return Text(
        l10n.toolsTimezoneEmptyHint,
        style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
      );
    }
    final city = cities.first;
    final diff = (city.localTime.difference(DateTime.now()).inMinutes / 60)
        .round()
        .abs();
    return Text(
      l10n.toolsTimezoneHint(diff, city.name),
      style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
    );
  }
}
