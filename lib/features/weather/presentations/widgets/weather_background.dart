import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/weather_model.dart';

class WeatherBackground extends StatelessWidget {
  final WeatherType type;

  const WeatherBackground({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeatherPainter(type),
      size: Size.infinite, // 🔥 critical
    );
  }
}

class _WeatherPainter extends CustomPainter {
  final WeatherType type;
  final Random rnd = Random();

  _WeatherPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);

    if (type == WeatherType.rainy) {
      for (int i = 0; i < 60; i++) {
        final x = rnd.nextDouble() * size.width;
        final y = rnd.nextDouble() * size.height;
        canvas.drawLine(Offset(x, y), Offset(x + 2, y + 10), paint);
      }
    } else if (type == WeatherType.cloudy) {
      for (int i = 0; i < 6; i++) {
        final x = rnd.nextDouble() * size.width;
        final y = rnd.nextDouble() * size.height / 2;
        canvas.drawCircle(Offset(x, y), 30, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
