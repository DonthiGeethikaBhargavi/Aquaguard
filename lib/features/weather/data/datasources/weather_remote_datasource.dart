import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env.dart';

class WeatherRemoteDataSource {
  Future<Map<String, dynamic>> fetchWeather({
    required double lat,
    required double lng,
  }) async {
    final apiKey = Env.weatherApiKey;

    final url =
        "https://api.openweathermap.org/data/2.5/weather"
        "?lat=$lat&lon=$lng&appid=$apiKey&units=metric";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception("Weather API failed: ${res.body}");
    }

    return jsonDecode(res.body);
  }
}
