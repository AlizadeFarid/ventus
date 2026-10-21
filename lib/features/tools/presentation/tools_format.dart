import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ventus_icon.dart';
import '../domain/weather.dart';

/// Human-readable condition for a WMO weather code, in the app language.
String weatherLabel(AppLocalizations l10n, int code) {
  if (code == 0) return l10n.wxClear;
  if (code == 1 || code == 2) return l10n.wxPartly;
  if (code == 3) return l10n.wxCloudy;
  if (code == 45 || code == 48) return l10n.wxFog;
  if (code >= 51 && code <= 57) return l10n.wxDrizzle;
  if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
    return l10n.wxSnow;
  }
  if (code >= 95) return l10n.wxStorm;
  return l10n.wxRain;
}

/// Maps a weather code to one of the app's weather icons.
String weatherIcon(int code) {
  switch (weatherKindFor(code)) {
    case WeatherKind.clear:
      return VentusIcons.sun;
    case WeatherKind.cloudy:
      return VentusIcons.cloud;
    case WeatherKind.rain:
      return VentusIcons.cloudRain;
    case WeatherKind.snow:
      return VentusIcons.cloudSnow;
    case WeatherKind.storm:
      return VentusIcons.cloudLightning;
  }
}

/// Currencies offered in the converter (code → symbol + display name key).
/// Names are localised via the matching `cur<Code>` ARB key.
const toolCurrencies = ['USD', 'EUR', 'GBP', 'TRY', 'AZN', 'GEL', 'AED'];

String currencyGlyph(String code) {
  switch (code) {
    case 'USD':
      return r'$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'TRY':
      return '₺';
    case 'AZN':
      return '₼';
    case 'GEL':
      return '₾';
    case 'AED':
      return 'د.إ';
    default:
      return code;
  }
}

/// Flag emoji for a currency code, used by the currency picker sheet.
String currencyFlag(String code) {
  switch (code) {
    case 'USD':
      return '🇺🇸';
    case 'EUR':
      return '🇪🇺';
    case 'GBP':
      return '🇬🇧';
    case 'TRY':
      return '🇹🇷';
    case 'AZN':
      return '🇦🇿';
    case 'GEL':
      return '🇬🇪';
    case 'AED':
      return '🇦🇪';
    default:
      return '🏳️';
  }
}

/// Localised display name for a currency code (matching `cur<Code>` ARB keys).
String currencyName(AppLocalizations l10n, String code) {
  switch (code) {
    case 'USD':
      return l10n.curUSD;
    case 'EUR':
      return l10n.curEUR;
    case 'GBP':
      return l10n.curGBP;
    case 'TRY':
      return l10n.curTRY;
    case 'AZN':
      return l10n.curAZN;
    case 'GEL':
      return l10n.curGEL;
    case 'AED':
      return l10n.curAED;
    default:
      return code;
  }
}
