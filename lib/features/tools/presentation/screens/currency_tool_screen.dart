import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/preferences/preferred_currency_provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../trips/application/budget_providers.dart';
import '../../../trips/application/trips_providers.dart';
import '../../application/tools_providers.dart';
import '../../domain/currency_rates.dart';
import '../tools_format.dart';
import '../widgets/currency_picker.dart';
import '../widgets/tools_header.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Currency converter (prototype `Tools.jsx` → CurrencyFull, state B): a
/// send/receive pair of cards with a swap button, official rates from the
/// Azerbaijan Central Bank (cbar.az), quick preset amounts, and it starts from the
/// active trip's budget currency when there is one.
class CurrencyToolScreen extends ConsumerStatefulWidget {
  const CurrencyToolScreen({super.key});

  @override
  ConsumerState<CurrencyToolScreen> createState() => _CurrencyToolScreenState();
}

class _CurrencyToolScreenState extends ConsumerState<CurrencyToolScreen> {
  late String _sendCode;
  late String _receiveCode;
  // 1 unit is the convention every converter opens on (Google, XE, Wise): it
  // reads as the rate itself before the user types anything.
  String _amount = '1';

  // The pre-filled "1" (or a tapped preset) is replaced by the next key, not
  // appended to, so typing 50 gives 50 rather than 150.
  bool _fresh = true;

  static const _quickAmounts = [1, 10, 20, 50, 100];

  @override
  void initState() {
    super.initState();
    final home = ref.read(preferredCurrencyProvider);
    final trip = ref.read(featuredTripProvider);
    final tripCurrency = trip == null
        ? null
        : ref.read(tripBudgetProvider(trip.id)).asData?.value?.currency;
    _receiveCode = home;
    _sendCode = (tripCurrency != null && tripCurrency != home)
        ? tripCurrency
        : (home == 'EUR' ? 'USD' : 'EUR');
    if (_sendCode == _receiveCode) _sendCode = home == 'EUR' ? 'USD' : 'EUR';
  }

  double get _sendAmount => double.tryParse(_amount) ?? 0;

  void _onKey(String k) {
    setState(() {
      if (_fresh) {
        _fresh = false;
        _amount = k == '.' ? '0.' : k;
        return;
      }
      if (k == '.') {
        if (_amount.contains('.')) return;
        _amount = _amount.isEmpty ? '0.' : '$_amount.';
        return;
      }
      if (_amount.contains('.') && _amount.split('.')[1].length >= 2) return;
      if (_amount.replaceAll('.', '').length >= 10) return;
      _amount = _amount == '0' ? k : '$_amount$k';
    });
  }

  void _onBackspace() {
    if (_amount.isEmpty) return;
    setState(() {
      _fresh = false;
      _amount = _amount.substring(0, _amount.length - 1);
    });
  }

  void _swap() {
    setState(() {
      final tmp = _sendCode;
      _sendCode = _receiveCode;
      _receiveCode = tmp;
    });
  }

  Future<void> _pickSend() async {
    final home = ref.read(preferredCurrencyProvider);
    final trip = ref.read(featuredTripProvider);
    final tripCurrency = trip == null
        ? null
        : ref.read(tripBudgetProvider(trip.id)).asData?.value?.currency;
    final picked = await showCurrencyPicker(
      context,
      selected: _sendCode,
      homeCurrency: home,
      tripCurrency: tripCurrency,
    );
    if (picked == null) return;
    setState(() {
      if (picked == _receiveCode) _receiveCode = _sendCode;
      _sendCode = picked;
    });
  }

  Future<void> _pickReceive() async {
    final home = ref.read(preferredCurrencyProvider);
    final trip = ref.read(featuredTripProvider);
    final tripCurrency = trip == null
        ? null
        : ref.read(tripBudgetProvider(trip.id)).asData?.value?.currency;
    final picked = await showCurrencyPicker(
      context,
      selected: _receiveCode,
      homeCurrency: home,
      tripCurrency: tripCurrency,
    );
    if (picked == null) return;
    setState(() {
      if (picked == _sendCode) _sendCode = _receiveCode;
      _receiveCode = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final ratesAsync = ref.watch(currencyRatesProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: ratesAsync.when(
          loading: () => Column(
            children: [
              ToolsHeader(title: l10n.toolCurrency),
              const Expanded(
                child: VentusListSkeleton(itemCount: 3, itemHeight: 110),
              ),
            ],
          ),
          error: (_, _) => Column(
            children: [
              ToolsHeader(title: l10n.toolCurrency),
              Expanded(
                child: Center(
                  child: _Error(
                    onRetry: () => ref.invalidate(currencyRatesProvider),
                  ),
                ),
              ),
            ],
          ),
          data: (rates) => _body(context, rates),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, CurrencyRates rates) {
    final colors = context.colors;
    final l10n = context.l10n;
    final receiveAmount = rates.convert(_sendAmount, _sendCode, _receiveCode);
    final rate = rates.rate(_sendCode, _receiveCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToolsHeader(title: l10n.toolCurrency),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              4,
              AppSpacing.screen,
              24,
            ),
            children: [
              _CurrencyCard(
                semanticsLabel: l10n.currencyAmountLabel,
                code: _sendCode,
                onPickCurrency: _pickSend,
                dark: false,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _amount.isEmpty ? '0' : _amount,
                    maxLines: 1,
                    style: context.typography.h1.copyWith(
                      fontSize: AppFontSize.display,
                      fontWeight: FontWeight.w600,
                      color: _amount.isEmpty ? colors.muted : colors.ink,
                    ),
                  ),
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -8),
                  child: VentusTap(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _swap();
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.primaryPress,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.bg, width: 3),
                      ),
                      child: VentusIcon(
                        VentusIcons.swap,
                        size: 18,
                        color: colors.bg,
                      ),
                    ),
                  ),
                ),
              ),
              _CurrencyCard(
                semanticsLabel: l10n.currencyConvertedLabel,
                code: _receiveCode,
                onPickCurrency: _pickReceive,
                dark: true,
                // A long result (millions of a weak currency) shrinks to fit
                // rather than being cut off mid-number.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _fmt(receiveAmount),
                    maxLines: 1,
                    style: context.typography.h1.copyWith(
                      fontSize: AppFontSize.display,
                      fontWeight: FontWeight.w600,
                      color: colors.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceSand,
                  borderRadius: AppRadius.brLg,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: VentusIcon(
                        VentusIcons.globe,
                        size: 18,
                        color: colors.ink2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      // The rate leads; where it came from and how fresh it is
                      // sit under it, so the number is readable at a glance.
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currencyRateLine(
                              _sendCode,
                              _fmtRate(rate),
                              _receiveCode,
                            ),
                            style: TextStyle(
                              fontSize: AppFontSize.sm,
                              fontWeight: FontWeight.w700,
                              color: colors.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            (rates.official
                                ? l10n.currencyRateSource
                                : l10n.currencyRateSourceMarket)(
                              DateFormat.yMMMd(
                                context.languageCode,
                              ).format(rates.date),
                            ),
                            style: TextStyle(
                              fontSize: AppFontSize.caption,
                              height: 1.3,
                              color: colors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.quickAmountsLabel.toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSize.caption,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: colors.muted,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final v in _quickAmounts)
                    _QuickAmountChip(
                      label: '${currencyGlyph(_sendCode)}$v',
                      active: _amount == '$v',
                      onTap: () => setState(() {
                        _amount = '$v';
                        _fresh = true;
                      }),
                    ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            4,
            AppSpacing.screen,
            12 + MediaQuery.paddingOf(context).bottom,
          ),
          child: VentusNumberPad(onKey: _onKey, onBackspace: _onBackspace),
        ),
      ],
    );
  }

  String _fmt(double v) => NumberFormat('#,##0.##', 'en').format(v);

  /// Rates get more decimals than amounts — at two, 1 EUR = 1.96 AZN wouldn't
  /// explain the 196.15 the card above it shows.
  String _fmtRate(double v) => NumberFormat('#,##0.####', 'en').format(v);
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.semanticsLabel,
    required this.code,
    required this.onPickCurrency,
    required this.dark,
    required this.child,
  });

  /// Spoken by screen readers only. The cards carry no visible caption: the
  /// input/result roles are already clear from the layout (plain card on top,
  /// filled card below) — the way Google's and Apple's converters do it.
  final String semanticsLabel;
  final String code;
  final VoidCallback onPickCurrency;
  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: dark ? colors.primaryPress : colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.raised,
      ),
      child: Semantics(
        label: semanticsLabel,
        container: true,
        // Amount and currency on one line: the currency chip already names the
        // unit, so the card needs neither a caption row above nor a repeated
        // glyph beside the number.
        child: Row(
          children: [
            Expanded(child: child),
            const SizedBox(width: 12),
            VentusTap(
              onTap: onPickCurrency,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: dark
                      ? colors.onPrimary.withValues(alpha: 0.12)
                      : colors.surfaceSand,
                  borderRadius: AppRadius.brFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currencyFlag(code),
                      style: const TextStyle(fontSize: AppFontSize.sm),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        color: dark ? colors.onPrimary : colors.ink,
                      ),
                    ),
                    const SizedBox(width: 5),
                    VentusIcon(
                      VentusIcons.chevronDown,
                      size: 13,
                      color: dark
                          ? colors.onPrimary.withValues(alpha: 0.7)
                          : colors.muted,
                    ),
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

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: active ? colors.primary : colors.surfaceSand,
          borderRadius: AppRadius.brFull,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.sm,
            fontWeight: FontWeight.w600,
            color: active ? colors.onPrimary : colors.ink,
          ),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.toolsOffline,
          style: TextStyle(
            fontSize: AppFontSize.sm,
            color: context.colors.muted,
          ),
        ),
        const SizedBox(height: 12),
        VentusButton(label: l10n.tryAgain, onPressed: onRetry),
      ],
    );
  }
}
