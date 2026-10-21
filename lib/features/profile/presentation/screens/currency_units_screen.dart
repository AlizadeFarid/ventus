import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/preferences/preferred_currency_provider.dart';
import '../../../../core/preferences/unit_system_provider.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Currency & units preferences, opened from the Profile menu.
///
/// Both controls are persisted preferences that drive real behaviour: the
/// chosen currency is the default for new trip budgets ([preferredCurrencyProvider]),
/// and the measurement system sets the Weather tool's temperature unit
/// ([unitSystemProvider]).
class CurrencyUnitsScreen extends ConsumerWidget {
  const CurrencyUnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final currency = ref.watch(preferredCurrencyProvider);
    final units = ref.watch(unitSystemProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(title: l10n.menuCurrencyUnits),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            8,
            AppSpacing.screen,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VentusSectionLabel(l10n.budgetCurrency),
              VentusCard(
                children: [
                  for (var i = 0; i < kSupportedCurrencies.length; i++)
                    _SelectRow(
                      label: kSupportedCurrencies[i],
                      trailing: _currencyGlyph(kSupportedCurrencies[i]),
                      selected: currency == kSupportedCurrencies[i],
                      last: i == kSupportedCurrencies.length - 1,
                      onTap: () => ref
                          .read(preferredCurrencyProvider.notifier)
                          .set(kSupportedCurrencies[i]),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              VentusSectionLabel(l10n.measurementSystem),
              VentusCard(
                children: [
                  _SelectRow(
                    label: l10n.unitMetric,
                    subtitle: l10n.unitMetricDesc,
                    selected: units == UnitSystem.metric,
                    onTap: () => ref
                        .read(unitSystemProvider.notifier)
                        .set(UnitSystem.metric),
                  ),
                  _SelectRow(
                    label: l10n.unitImperial,
                    subtitle: l10n.unitImperialDesc,
                    selected: units == UnitSystem.imperial,
                    last: true,
                    onTap: () => ref
                        .read(unitSystemProvider.notifier)
                        .set(UnitSystem.imperial),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _currencyGlyph(String code) => switch (code) {
    'USD' => '\$',
    'EUR' => '€',
    'GBP' => '£',
    'TRY' => '₺',
    'AZN' => '₼',
    'AED' => 'د.إ',
    _ => code,
  };
}

class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.last = false,
  });

  final String label;
  final String? subtitle;

  /// Small muted text shown before the selected check (e.g. a currency glyph).
  final String? trailing;
  final bool selected;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        color: colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  trailing!,
                  style: TextStyle(
                    fontSize: AppFontSize.body,
                    fontWeight: FontWeight.w600,
                    color: colors.muted,
                  ),
                ),
              ),
            if (selected)
              VentusIcon(VentusIcons.check, size: 20, color: colors.primary)
            else
              const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
