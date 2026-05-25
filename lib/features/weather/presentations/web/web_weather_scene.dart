import 'package:flutter/material.dart';
import '../../domain/models/weather_model.dart';

class WebWeatherScene extends StatelessWidget {
  final WeatherModel weather;

  const WebWeatherScene({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
        ),
      ),
    );
  }
}
