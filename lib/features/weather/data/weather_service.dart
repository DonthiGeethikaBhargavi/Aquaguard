import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather() async {
    final apiKey = dotenv.env['WEATHER_API_KEY'];

    // Using Nellore for now (later: dynamic location)
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=Nellore&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Failed to load weather");
    }

    return json.decode(response.body);
  }
}
