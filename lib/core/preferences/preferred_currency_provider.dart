import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Default trip currency when the user hasn't chosen one.
const kDefaultCurrency = 'USD';

/// Currencies the app supports (mirrors the budget editor's chip list).
const kSupportedCurrencies = ['USD', 'EUR', 'GBP', 'TRY', 'AZN', 'AED'];

/// The user's preferred currency code, used as the default for new trip
/// budgets. Persisted on-device (like [localeProvider]) so it survives
/// restarts; hydrated asynchronously so startup never blocks on disk.
class PreferredCurrencyController extends Notifier<String> {
  static const _key = 'pref_currency';
  final _storage = const FlutterSecureStorage();

  @override
  String build() {
    _hydrate();
    return kDefaultCurrency;
  }

  Future<void> _hydrate() async {
    final code = await _storage.read(key: _key);
    if (code != null && kSupportedCurrencies.contains(code)) {
      state = code;
    }
  }

  Future<void> set(String code) async {
    if (!kSupportedCurrencies.contains(code)) return;
    state = code;
    await _storage.write(key: _key, value: code);
  }
}

final preferredCurrencyProvider =
    NotifierProvider<PreferredCurrencyController, String>(
      PreferredCurrencyController.new,
    );
