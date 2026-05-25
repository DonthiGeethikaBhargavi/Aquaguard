import '../../data/datasources/weather_remote_datasource.dart';
import '../mappers/weather_mapper.dart';
import '../../domain/models/weather_model.dart';

class WeatherRepository {
  final _ds = WeatherRemoteDataSource();

  /// 🧠 cache: key = "lat,lng"
  final Map<String, WeatherModel> _cache = {};

  /// 🕒 store timestamps
  final Map<String, DateTime> _timestamps = {};

  /// ⏱ cache validity (10 minutes)
  final Duration ttl = const Duration(minutes: 10);

  ////////////////////////////////////////////////////////////
  /// GET WEATHER (WITH CACHE)
  ////////////////////////////////////////////////////////////
  Future<WeatherModel> getWeather({
    required double lat,
    required double lng,
  }) async {
    final key = "${lat.toStringAsFixed(3)},${lng.toStringAsFixed(3)}";

    /// ✅ check cache
    if (_cache.containsKey(key)) {
      final time = _timestamps[key]!;

      if (DateTime.now().difference(time) < ttl) {
        return _cache[key]!; // 🚀 reuse cached data
      }
    }

    /// 🌐 fetch fresh
    final raw = await _ds.fetchWeather(lat: lat, lng: lng);
    final model = mapWeather(raw);

    /// 💾 store cache
    _cache[key] = model;
    _timestamps[key] = DateTime.now();

    return model;
  }
}
