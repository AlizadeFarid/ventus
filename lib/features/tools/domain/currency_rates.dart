/// A snapshot of exchange rates relative to a [base] currency, from the
/// Azerbaijan Central Bank's (CBAR) official daily bulletin. [convert] turns
/// an amount between any two listed codes.
class CurrencyRates {
  const CurrencyRates({
    required this.base,
    required this.rates,
    required this.date,
    this.official = true,
  });

  /// Base currency the [rates] are expressed against (e.g. `USD`).
  final String base;

  /// Currency code → units per 1 [base].
  final Map<String, double> rates;

  /// When the rates were last refreshed by the provider.
  final DateTime date;

  /// True for the CBAR bulletin, false when the market-rate fallback was used.
  final bool official;

  /// Converts [amount] from currency [from] to [to]. Returns 0 if either code
  /// is unknown. Works by routing through the base: amount / rate(from) * rate(to).
  double convert(double amount, String from, String to) {
    final rf = rates[from];
    final rt = rates[to];
    if (rf == null || rt == null || rf == 0) return 0;
    return amount / rf * rt;
  }

  /// The rate of 1 [from] expressed in [to] (for "rate ₺32.40 / \$1" labels).
  double rate(String from, String to) => convert(1, from, to);
}
