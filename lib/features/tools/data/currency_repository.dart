import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../domain/currency_rates.dart';
import 'open_meteo_repository.dart' show ToolsException;

/// Fetches the official exchange-rate bulletin from the Azerbaijan Central
/// Bank (CBAR) — one XML file per calendar date, `cbar.az/currencies/DD.MM.YYYY.xml`,
/// quoting each currency as "N units = X AZN". CBAR only publishes on business
/// days, so we walk backwards from today until a bulletin is found. We invert
/// each quote into "units of currency per 1 AZN" so the result fits the shared
/// [CurrencyRates] shape (base currency = AZN here, since that's what CBAR
/// quotes against).
class CurrencyRepository {
  CurrencyRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _base = 'https://cbar.az/currencies';
  static const _maxLookback = 7;

  static const _fallbackUrl = 'https://open.er-api.com/v6/latest/AZN';

  /// Official CBAR rates first; cbar.az is slow or unreachable from many
  /// networks (it timed out outside Azerbaijan), so fall back to a keyless
  /// market-rate feed rather than leaving the converter dead.
  Future<CurrencyRates> fetchRates() async {
    try {
      return await _fetchCbar();
    } catch (_) {
      return _fetchFallback();
    }
  }

  Future<CurrencyRates> _fetchFallback() async {
    final res = await _client
        .get(Uri.parse(_fallbackUrl))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw ToolsException('Rates request timed out'),
        );
    if (res.statusCode != 200) throw ToolsException('Rates unavailable');
    final body = jsonDecode(res.body);
    final raw = body is Map ? body['rates'] : null;
    if (raw is! Map) throw ToolsException('Rates response was malformed');
    final rates = <String, double>{
      for (final e in raw.entries)
        if (e.value is num && (e.value as num) > 0)
          e.key as String: (e.value as num).toDouble(),
    };
    rates['AZN'] = 1.0;
    if (rates.length <= 1) throw ToolsException('Rates unavailable');
    final updated = body['time_last_update_unix'];
    final date = updated is int
        ? DateTime.fromMillisecondsSinceEpoch(updated * 1000)
        : DateTime.now();
    return CurrencyRates(
      base: 'AZN',
      rates: rates,
      date: date,
      official: false,
    );
  }

  Future<CurrencyRates> _fetchCbar() async {
    var date = DateTime.now();
    for (var i = 0; i < _maxLookback; i++) {
      final uri = Uri.parse('$_base/${_formatDate(date)}.xml');
      final res = await _client
          .get(uri)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw ToolsException('Rates request timed out'),
          );
      if (res.statusCode == 200 && res.body.trim().isNotEmpty) {
        return _parse(res.body, fallbackDate: date);
      }
      date = date.subtract(const Duration(days: 1));
    }
    throw ToolsException('Rates unavailable');
  }

  CurrencyRates _parse(String xmlBody, {required DateTime fallbackDate}) {
    final XmlDocument doc;
    try {
      doc = XmlDocument.parse(xmlBody);
    } on XmlException {
      throw ToolsException('Rates response was malformed');
    }

    final dateAttr = doc.rootElement.getAttribute('Date');
    final date =
        (dateAttr != null ? _parseCbarDate(dateAttr) : null) ?? fallbackDate;

    final rates = <String, double>{'AZN': 1.0};
    for (final valute in doc.findAllElements('Valute')) {
      final code = valute.getAttribute('Code');
      if (code == null) continue;
      final value = double.tryParse(
        valute.getElement('Value')?.innerText.trim() ?? '',
      );
      if (value == null || value == 0) continue;
      final nominal =
          double.tryParse(
            valute.getElement('Nominal')?.innerText.trim() ?? '',
          ) ??
          1;
      rates[code] = nominal / value; // units of `code` per 1 AZN
    }

    if (rates.length <= 1) throw ToolsException('Rates unavailable');
    return CurrencyRates(base: 'AZN', rates: rates, date: date);
  }

  static String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}';
  }

  static DateTime? _parseCbarDate(String s) {
    final parts = s.split('.');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  void dispose() => _client.close();
}
