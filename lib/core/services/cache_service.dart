import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static Future<void> saveWeather(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weather_cache', data);
  }

  static Future<String?> getWeather() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('weather_cache');
  }
}
