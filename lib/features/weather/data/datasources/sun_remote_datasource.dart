import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SunRemoteDataSource {
  final _key = dotenv.env['OPENWEATHER_API_KEY'];

  Future<Map<String, dynamic>> fetch(double lat, double lng) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=$_key";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception("Sun API failed");
    }

    return jsonDecode(res.body);
  }
}
