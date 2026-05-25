enum WeatherType { sunny, cloudy, rainy, night, snow }

class WeatherModel {
  /// 🌡️ Temperature
  final double temp;
  final double feelsLike;

  /// 💧 Environment
  final int humidity;

  /// 🌬️ Wind
  final double windSpeed;
  final double windDeg;

  /// ☁️ Clouds
  final int cloudCoverage;

  /// 🌤️ Condition
  final String condition;
  final WeatherType type;

  /// 🌅 Time
  final DateTime sunrise;
  final DateTime sunset;

  WeatherModel({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.cloudCoverage,
    required this.condition,
    required this.type,
    required this.sunrise,
    required this.sunset,
  });
}
