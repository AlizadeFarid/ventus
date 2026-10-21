/// A simplified weather snapshot for a city, from the free Open-Meteo forecast
/// API: current conditions, the next few hours, and a multi-day outlook.
class Weather {
  const Weather({
    required this.localNow,
    required this.currentTemp,
    required this.currentCode,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.today,
    required this.hourly,
    required this.daily,
  });

  /// Current wall-clock time **at the forecast location** (not the device).
  final DateTime localNow;
  final double currentTemp;
  final int currentCode;
  final double feelsLike;

  /// Relative humidity, percent.
  final int humidity;

  /// km/h, or mph when the forecast was requested in imperial units.
  final double windSpeed;

  /// Today's outlook (high / low / sun times / rain chance).
  final DayForecast today;
  final List<HourForecast> hourly;

  /// The days after today.
  final List<DayForecast> daily;
}

class HourForecast {
  const HourForecast({
    required this.time,
    required this.temp,
    required this.code,
  });

  final DateTime time;
  final double temp;
  final int code;
}

class DayForecast {
  const DayForecast({
    required this.date,
    required this.code,
    required this.high,
    required this.low,
    this.sunrise,
    this.sunset,
    this.rainChance,
  });

  final DateTime date;
  final int code;
  final double high;
  final double low;
  final DateTime? sunrise;
  final DateTime? sunset;

  /// Peak precipitation probability for the day, percent.
  final int? rainChance;
}

/// Coarse weather "kind" the UI maps to an icon, derived from a WMO weather code
/// (https://open-meteo.com/en/docs — clear / cloud / rain / snow / storm).
enum WeatherKind { clear, cloudy, rain, snow, storm }

WeatherKind weatherKindFor(int code) {
  if (code == 0 || code == 1) return WeatherKind.clear;
  if (code == 2 || code == 3 || code == 45 || code == 48) {
    return WeatherKind.cloudy;
  }
  if (code >= 71 && code <= 77) return WeatherKind.snow;
  if (code >= 95) return WeatherKind.storm;
  return WeatherKind.rain; // drizzle / rain / showers (51–67, 80–86)
}
