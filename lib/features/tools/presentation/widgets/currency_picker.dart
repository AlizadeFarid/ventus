import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/widgets.dart';
import '../tools_format.dart';
import '../../../../core/theme/app_typography.dart';

/// Bottom sheet that lists [toolCurrencies] with flags + full names, used by
/// the Currency converter's send/receive chips (prototype state B2).
///
/// [homeCurrency] and [tripCurrency] (when provided) get a contextual
/// subtitle tag ("Home currency" / "Active trip currency"); [selected] gets a
/// trailing checkmark. Returns the tapped code, or null if dismissed.
Future<String?> showCurrencyPicker(
  BuildContext context, {
  required String selected,
  String? homeCurrency,
  String? tripCurrency,
}) {
  return showVentusSheet<String>(
    context,
    builder: (_) => _CurrencyPickerSheet(
      selected: selected,
      homeCurrency: homeCurrency,
      tripCurrency: tripCurrency,
    ),
  );
}

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({
    required this.selected,
    this.homeCurrency,
    this.tripCurrency,
  });

  final String selected;
  final String? homeCurrency;
  final String? tripCurrency;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = _query.trim().toLowerCase();
    final results = toolCurrencies.where((code) {
      if (query.isEmpty) return true;
      return code.toLowerCase().contains(query) ||
          currencyName(l10n, code).toLowerCase().contains(query);
    }).toList();

    return VentusSearchSheet(
      title: l10n.currencyPickerTitle,
      controller: _controller,
      hintText: l10n.currencySearchHint,
      onChanged: (v) => setState(() => _query = v),
      child: results.isEmpty
          ? VentusSearchSheet.message(context, l10n.noCitiesFound)
          : ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, i) {
                final code = results[i];
                String? tag;
                if (code == widget.tripCurrency) {
                  tag = l10n.currencyTripCurrency;
                } else if (code == widget.homeCurrency) {
                  tag = l10n.currencyHomeCurrency;
                }
                return VentusListRow(
                  leading: Text(
                    currencyFlag(code),
                    style: const TextStyle(fontSize: AppFontSize.h3),
                  ),
                  title: '$code — ${currencyName(l10n, code)}',
                  subtitle: tag,
                  selected: code == widget.selected,
                  onTap: () => Navigator.of(context).pop(code),
                );
              },
            ),
    );
  }
}
