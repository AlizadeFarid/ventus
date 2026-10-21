import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/preferences/preferred_currency_provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../tools_format.dart';
import '../widgets/tools_header.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Tip calculator (prototype `Tools.jsx` → TipFull, state C): a bill amount,
/// a tip %, an optional split, and a dark summary card — all offline.
class TipToolScreen extends ConsumerStatefulWidget {
  const TipToolScreen({super.key});

  @override
  ConsumerState<TipToolScreen> createState() => _TipToolScreenState();
}

class _TipToolScreenState extends ConsumerState<TipToolScreen> {
  final _customController = TextEditingController();
  String _billText = '';
  double _tipPercent = 15;
  bool _customActive = false;
  int _split = 1;

  static const _presets = [10.0, 15.0, 20.0];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  double get _bill => double.tryParse(_billText) ?? 0;
  double get _tip => _bill * _tipPercent / 100;
  double get _total => _bill + _tip;

  String _money(double v) => v.toStringAsFixed(2);

  void _onKey(String k) {
    setState(() {
      if (k == '.') {
        if (_billText.contains('.')) return;
        _billText = _billText.isEmpty ? '0.' : '$_billText.';
        return;
      }
      if (_billText.contains('.') && _billText.split('.')[1].length >= 2) {
        return;
      }
      if (_billText.replaceAll('.', '').length >= 9) return;
      _billText = _billText == '0' ? k : '$_billText$k';
    });
  }

  void _onBackspace() {
    if (_billText.isEmpty) return;
    setState(() => _billText = _billText.substring(0, _billText.length - 1));
  }

  void _selectPreset(double p) {
    setState(() {
      _customActive = false;
      _tipPercent = p;
    });
  }

  void _selectCustom() {
    setState(() => _customActive = true);
  }

  void _applyCustom(String v) {
    final parsed = double.tryParse(v.replaceAll(',', '.'));
    if (parsed != null) setState(() => _tipPercent = parsed);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final prefCurrency = ref.watch(preferredCurrencyProvider);
    final glyph = currencyGlyph(prefCurrency);
    final onPrimarySoft = colors.onPrimary.withValues(alpha: 0.92);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolsHeader(title: l10n.toolTip),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  4,
                  AppSpacing.screen,
                  16,
                ),
                children: [
                  VentusSectionLabel(l10n.tipBillLabel),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: AppRadius.brLg,
                      boxShadow: context.shadows.card,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$glyph${_billText.isEmpty ? '0' : _billText}',
                        maxLines: 1,
                        style: context.typography.h1.copyWith(
                          fontSize: AppFontSize.display,
                          fontWeight: FontWeight.w600,
                          color: _billText.isEmpty ? colors.muted : colors.ink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  VentusSectionLabel(l10n.tipPercentLabel),
                  Row(
                    children: [
                      for (final p in _presets) ...[
                        Expanded(child: _percentChip(context, p)),
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: _otherChip(context)),
                    ],
                  ),
                  if (_customActive) ...[
                    const SizedBox(height: 10),
                    VentusTextField(
                      controller: _customController,
                      hintText: l10n.tipCustomPercentHint,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: _applyCustom,
                    ),
                  ],
                  const SizedBox(height: 20),
                  VentusSectionLabel(l10n.tipSplitLabel),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceSand,
                      borderRadius: AppRadius.brMd,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _stepper(context, VentusIcons.minus, () {
                          if (_split > 1) setState(() => _split--);
                        }),
                        Text(
                          l10n.tipPeopleCount(_split),
                          style: TextStyle(
                            fontSize: AppFontSize.h3,
                            fontWeight: FontWeight.w600,
                            color: colors.ink,
                          ),
                        ),
                        _stepper(
                          context,
                          VentusIcons.plus,
                          () => setState(() => _split++),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                12,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primaryPress,
                  borderRadius: AppRadius.brLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryRow(
                      context,
                      l10n.tipAmount,
                      '$glyph${_money(_tip)}',
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.tipTotal,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        color: onPrimarySoft,
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$glyph${_money(_total)}',
                        maxLines: 1,
                        style: context.typography.h1.copyWith(
                          fontSize: AppFontSize.display,
                          fontWeight: FontWeight.w600,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                    if (_split > 1) ...[
                      const SizedBox(height: 14),
                      Container(
                        height: 1,
                        color: colors.onPrimary.withValues(alpha: 0.14),
                      ),
                      const SizedBox(height: 14),
                      _summaryRow(
                        context,
                        l10n.tipPerPerson,
                        '$glyph${_money(_total / _split)}',
                        emphasized: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                12 + MediaQuery.paddingOf(context).bottom,
              ),
              child: VentusNumberPad(onKey: _onKey, onBackspace: _onBackspace),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String label,
    String value, {
    bool emphasized = false,
  }) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasized ? AppFontSize.body : AppFontSize.sm,
            color: colors.onPrimary.withValues(alpha: 0.92),
          ),
        ),
        Text(
          value,
          style: emphasized
              ? context.typography.h1.copyWith(
                  fontSize: AppFontSize.h2,
                  fontWeight: FontWeight.w600,
                  color: colors.onPrimary,
                )
              : TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w600,
                  color: colors.onPrimary,
                ),
        ),
      ],
    );
  }

  Widget _percentChip(BuildContext context, double p) {
    final colors = context.colors;
    final active = !_customActive && _tipPercent == p;
    return VentusTap(
      onTap: () => _selectPreset(p),
      child: Container(
        height: AppSizes.controlMd,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? colors.primary : colors.surfaceSand,
          borderRadius: AppRadius.brMd,
        ),
        child: Text(
          '${p.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: AppFontSize.body,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? colors.onPrimary : colors.muted,
          ),
        ),
      ),
    );
  }

  Widget _otherChip(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return VentusTap(
      onTap: _selectCustom,
      child: Container(
        height: AppSizes.controlMd,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _customActive ? colors.primary : colors.surfaceSand,
          borderRadius: AppRadius.brMd,
        ),
        child: Text(
          l10n.tipOtherPercent,
          style: TextStyle(
            fontSize: AppFontSize.body,
            fontWeight: _customActive ? FontWeight.w600 : FontWeight.w500,
            color: _customActive ? colors.onPrimary : colors.muted,
          ),
        ),
      ),
    );
  }

  Widget _stepper(BuildContext context, String icon, VoidCallback onTap) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brSm,
        ),
        child: VentusIcon(icon, size: 18, color: colors.ink),
      ),
    );
  }
}
