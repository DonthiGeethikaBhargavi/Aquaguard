import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/weather_model.dart';

enum Season { spring, summer, autumn, winter }

////////////////////////////////////////////////////////////
/// MODEL (you can adapt to your weather model)
////////////////////////////////////////////////////////////

class WeatherData {
  final bool isNight;
  final double cloudiness; // 0 → 1
  final double sunIntensity; // 0 → 1
  final String condition;
  final Season season;

  WeatherData({
    required this.isNight,
    required this.cloudiness,
    required this.sunIntensity,
    required this.condition,
    required this.season,
  });
}

////////////////////////////////////////////////////////////
/// MAIN ENGINE
////////////////////////////////////////////////////////////

class AdaptiveWeatherBackground extends StatefulWidget {
  final WeatherModel weather;

  const AdaptiveWeatherBackground({super.key, required this.weather});

  @override
  State<AdaptiveWeatherBackground> createState() =>
      _AdaptiveWeatherBackgroundState();
}

class _AdaptiveWeatherBackgroundState extends State<AdaptiveWeatherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat(); // continuous sky movement
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// WEATHER PARSER (adapt to your API)
  ////////////////////////////////////////////////////////////

  LinearGradient _daySkyGradient(Season season, String condition) {
    switch (season) {
      case Season.spring:
        return const LinearGradient(
          colors: [Color(0xFF5BA3D0), Color(0xFF87CEEB), Color(0xFFE8F4F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        );
      case Season.summer:
        return const LinearGradient(
          colors: [Color(0xFF2E8BC0), Color(0xFF4FACFE), Color(0xFFC6E9F9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        );
      case Season.autumn:
        return const LinearGradient(
          colors: [Color(0xFFD97706), Color(0xFFFF9E42), Color(0xFFFDC17B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        );
      case Season.winter:
        return const LinearGradient(
          colors: [Color(0xFF8AB4D8), Color(0xFFB0E0E6), Color(0xFFF0F8FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        );
    }
  }

  LinearGradient _nightSkyGradient(Season season) {
    return const LinearGradient(
      colors: [Color(0xFF051B3D), Color(0xFF0B1D3A), Color(0xFF0A0E27)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 1.0],
    );
  }

  WeatherData _mapWeather(WeatherModel w) {
    final now = DateTime.now();
    final isNight = now.isBefore(w.sunrise) || now.isAfter(w.sunset);

    return WeatherData(
      isNight: isNight,
      cloudiness: w.cloudCoverage / 100,
      sunIntensity: w.temp / 50,
      condition: w.condition,
      season: _getSeason(),
    );
  }

  Season _getSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  @override
  Widget build(BuildContext context) {
    final weather = _mapWeather(widget.weather);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [
            ////////////////////////////////////////////////////////////
            /// 🌌 SKY GRADIENT
            ////////////////////////////////////////////////////////////
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: weather.isNight
                      ? _nightSkyGradient(weather.season)
                      : _daySkyGradient(weather.season, weather.condition),
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////
            /// ☀️ SUN / 🌙 MOON
            ////////////////////////////////////////////////////////////
            Positioned(
              top: weather.isNight ? 80 : 120,
              left:
                  MediaQuery.of(context).size.width *
                  (0.2 + 0.6 * _controller.value),
              child: weather.isNight
                  ? _Moon()
                  : _Sun(intensity: weather.sunIntensity),
            ),

            ////////////////////////////////////////////////////////////
            /// ☁️ CLOUD LAYER (BACK)
            ////////////////////////////////////////////////////////////
            _CloudLayer(
              controller: _controller,
              speed: 0.2,
              opacity: 0.3 + weather.cloudiness * 0.4,
              scale: 1.2,
            ),

            ////////////////////////////////////////////////////////////
            /// ☁️ CLOUD LAYER (FRONT)
            ////////////////////////////////////////////////////////////
            _CloudLayer(
              controller: _controller,
              speed: 0.5,
              opacity: 0.5 + weather.cloudiness * 0.5,
              scale: 1.6,
            ),

            ////////////////////////////////////////////////////////////
            /// � DARKNESS OVERLAY (NIGHT ONLY)
            ////////////////////////////////////////////////////////////
            if (weather.isNight)
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),

            ////////////////////////////////////////////////////////////
            /// ⭐ STARS (NIGHT ONLY)
            ////////////////////////////////////////////////////////////
            if (weather.isNight) _StarField(controller: _controller),

            ////////////////////////////////////////////////////////////
            /// 🌧️ WEATHER EFFECTS
            ////////////////////////////////////////////////////////////
            _WeatherEffects(
              condition: weather.condition,
              controller: _controller,
              isNight: weather.isNight,
            ),

            ////////////////////////////////////////////////////////////
            /// 🌫 LIGHT SCATTER / ATMOSPHERE
            ////////////////////////////////////////////////////////////
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: weather.isNight
                        ? Alignment.topCenter
                        : Alignment.topRight,
                    radius: weather.isNight ? 1.5 : 2.0,
                    colors: weather.isNight
                        ? [Colors.white.withOpacity(0.03), Colors.transparent]
                        : [
                            Colors.white.withOpacity(
                              weather.sunIntensity * 0.2,
                            ),
                            Colors.orange.withOpacity(
                              weather.sunIntensity * 0.1,
                            ),
                            Colors.transparent,
                          ],
                  ),
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////
            /// 🌫 HAZE OVERLAY
            ////////////////////////////////////////////////////////////
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(weather.isNight ? 0.1 : 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// ☀️ SUN
////////////////////////////////////////////////////////////

class _Sun extends StatelessWidget {
  final double intensity;

  const _Sun({required this.intensity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer atmospheric glow (soft and diffuse)
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.orange.withOpacity(0.08 * intensity),
                Colors.yellow.withOpacity(0.04 * intensity),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
        // Middle glow layer
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.yellow.withOpacity(0.25 * intensity),
                Colors.orange.withOpacity(0.15 * intensity),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Soft inner glow
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.yellow.withOpacity(0.6 * intensity),
                Colors.orange.withOpacity(0.4 * intensity),
                Colors.yellow.withOpacity(0.2 * intensity),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.5 * intensity),
                blurRadius: 60,
                spreadRadius: 30,
              ),
            ],
          ),
        ),
        // Bright core
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.yellow.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// 🌙 MOON
////////////////////////////////////////////////////////////

class _Moon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft atmospheric halo
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.blue.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
        // Moon glow
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.white.withOpacity(0.12), Colors.transparent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 15,
              ),
            ],
          ),
        ),
        // Moon surface
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// ☁️ CLOUD LAYER
////////////////////////////////////////////////////////////

class _CloudLayer extends StatelessWidget {
  final AnimationController controller;
  final double speed;
  final double opacity;
  final double scale;

  const _CloudLayer({
    required this.controller,
    required this.speed,
    required this.opacity,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final width = MediaQuery.of(context).size.width;

          return Stack(
            children: List.generate(5, (i) {
              final progress = (controller.value + i * 0.2) % 1;

              return Positioned(
                top: 80.0 + i * 40,
                left: width * (progress * 1.5 - 0.3),
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: _Cloud()),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ☁️ CLOUD SHAPE
////////////////////////////////////////////////////////////

class _Cloud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(160, 80), painter: _CloudPainter());
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final double baseY = size.height * 0.5;

    // Left puff
    canvas.drawCircle(
      Offset(size.width * 0.15, baseY),
      size.width * 0.18,
      paint,
    );

    // Left-center puff
    canvas.drawCircle(
      Offset(size.width * 0.35, baseY - size.height * 0.08),
      size.width * 0.22,
      paint,
    );

    // Center puff (largest)
    canvas.drawCircle(
      Offset(size.width * 0.5, baseY),
      size.width * 0.25,
      paint,
    );

    // Right-center puff
    canvas.drawCircle(
      Offset(size.width * 0.65, baseY - size.height * 0.08),
      size.width * 0.22,
      paint,
    );

    // Right puff
    canvas.drawCircle(
      Offset(size.width * 0.85, baseY),
      size.width * 0.18,
      paint,
    );

    // Soft edge enhancement with blur-like effect
    final softPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, baseY),
      size.width * 0.28,
      softPaint,
    );
  }

  @override
  bool shouldRepaint(_CloudPainter oldDelegate) => false;
}

////////////////////////////////////////////////////////////
/// ⭐ STAR FIELD
////////////////////////////////////////////////////////////

class _StarField extends StatelessWidget {
  final AnimationController controller;

  const _StarField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(painter: _StarPainter(controller.value));
        },
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final double animationValue;

  _StarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Generate consistent random stars using seeded generator
    final random = _SeededRandom(42);

    for (int i = 0; i < 80; i++) {
      // Natural random distribution across the sky
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * (size.height * 0.65);

      // Vary star size naturally
      final starSize = 0.8 + random.nextDouble() * 1.8;

      // Vary opacity with subtle twinkling
      final baseOpacity = 0.4 + random.nextDouble() * 0.5;
      final twinkle = 0.3 * ((sin(animationValue * 2 + i) + 1) / 2);
      final opacity = (baseOpacity + twinkle).clamp(0.3, 0.9);

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => true;
}

class _SeededRandom {
  late int _seed;

  _SeededRandom(int seed) {
    _seed = seed;
  }

  double nextDouble() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}

////////////////////////////////////////////////////////////
/// 🌧️ WEATHER EFFECTS
////////////////////////////////////////////////////////////

class _WeatherEffects extends StatelessWidget {
  final String condition;
  final AnimationController controller;
  final bool isNight;

  const _WeatherEffects({
    required this.condition,
    required this.controller,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    switch (condition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
        return _RainEffect(controller: controller, isNight: isNight);
      case 'snow':
        return _SnowEffect(controller: controller);
      case 'thunderstorm':
        return _ThunderEffect(controller: controller, isNight: isNight);
      case 'fog':
      case 'mist':
        return _FogEffect();
      default:
        return const SizedBox();
    }
  }
}

class _RainEffect extends StatelessWidget {
  final AnimationController controller;
  final bool isNight;

  const _RainEffect({required this.controller, required this.isNight});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(painter: _RainPainter(controller.value, isNight));
        },
      ),
    );
  }
}

class _RainPainter extends CustomPainter {
  final double animationValue;
  final bool isNight;

  _RainPainter(this.animationValue, this.isNight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isNight ? Colors.white70 : Colors.lightBlueAccent
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 100; i++) {
      final x = (i * 23 + animationValue * 200) % size.width;
      final y = (i * 17 + animationValue * 400) % size.height;
      final length = 10 + (i % 5) * 5;
      canvas.drawLine(Offset(x, y), Offset(x, y + length), paint);
    }
  }

  @override
  bool shouldRepaint(_RainPainter oldDelegate) => true;
}

class _SnowEffect extends StatelessWidget {
  final AnimationController controller;

  const _SnowEffect({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(painter: _SnowPainter(controller.value));
        },
      ),
    );
  }
}

class _SnowPainter extends CustomPainter {
  final double animationValue;

  _SnowPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);

    for (int i = 0; i < 50; i++) {
      final x = (i * 31 + animationValue * 50) % size.width;
      final y = (i * 29 + animationValue * 100) % size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(_SnowPainter oldDelegate) => true;
}

class _ThunderEffect extends StatefulWidget {
  final AnimationController controller;
  final bool isNight;

  const _ThunderEffect({required this.controller, required this.isNight});

  @override
  State<_ThunderEffect> createState() => _ThunderEffectState();
}

class _ThunderEffectState extends State<_ThunderEffect> {
  bool _flash = false;

  @override
  void initState() {
    super.initState();
    _startThunder();
  }

  void _startThunder() {
    Future.delayed(
      Duration(seconds: 3 + (DateTime.now().millisecondsSinceEpoch % 5)),
      () {
        if (mounted) {
          setState(() => _flash = true);
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) setState(() => _flash = false);
          });
          _startThunder();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _RainEffect(controller: widget.controller, isNight: widget.isNight),
        if (_flash)
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.3)),
          ),
      ],
    );
  }
}

class _FogEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(color: Colors.white.withOpacity(0.2)),
    );
  }
}
