import 'dart:ui';

import 'package:flutter/material.dart';

import '../../domain/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  final bool isNight;

  const WeatherCard({super.key, required this.weather, required this.isNight});

  ////////////////////////////////////////////////////////////
  /// WEATHER STATES
  ////////////////////////////////////////////////////////////

  bool get isRain {
    final c = weather.condition.toLowerCase();

    return c.contains('rain') || c.contains('drizzle') || c.contains('shower');
  }

  bool get isStorm {
    final c = weather.condition.toLowerCase();

    return c.contains('storm') || c.contains('thunder');
  }

  bool get isCloudy {
    final c = weather.condition.toLowerCase();

    return c.contains('cloud') ||
        c.contains('overcast') ||
        c.contains('broken');
  }

  ////////////////////////////////////////////////////////////
  /// ICON
  ////////////////////////////////////////////////////////////

  IconData get weatherIcon {
    if (isStorm) {
      return Icons.thunderstorm_rounded;
    }

    if (isRain) {
      return Icons.water_drop_rounded;
    }

    if (isCloudy) {
      return Icons.cloud_rounded;
    }

    if (isNight) {
      return Icons.nightlight_round;
    }

    return Icons.wb_sunny_rounded;
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final small = width < 390;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: Container(
          width: double.infinity,

          padding: EdgeInsets.all(small ? 18 : 24),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                const Color(0xFF121C2C).withOpacity(isNight ? 0.88 : 0.82),

                const Color(0xFF0A111C).withOpacity(isNight ? 0.82 : 0.76),
              ],
            ),

            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [
              //////////////////////////////////////////////////
              /// TOP ROW
              //////////////////////////////////////////////////
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  ////////////////////////////////////////////////
                  /// LEFT
                  ////////////////////////////////////////////////
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        ////////////////////////////////////////////
                        /// TITLE
                        ////////////////////////////////////////////
                        Text(
                          'Environmental Conditions',

                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.white.withOpacity(0.92),

                            fontSize: small ? 17 : 19,

                            fontWeight: FontWeight.w500,

                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: 8),

                        ////////////////////////////////////////////
                        /// SUBTITLE
                        ////////////////////////////////////////////
                        Text(
                          isNight
                              ? 'Night telemetry'
                              : 'Realtime atmospheric telemetry',

                          style: TextStyle(
                            color: Colors.white.withOpacity(0.46),

                            fontSize: 12,

                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  ////////////////////////////////////////////////
                  /// CONDITION CAPSULE
                  ////////////////////////////////////////////////
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),

                        color: Colors.white.withOpacity(0.03),

                        border: Border.all(
                          color: Colors.white.withOpacity(0.03),
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Icon(
                            weatherIcon,

                            size: 14,

                            color: Colors.white.withOpacity(0.84),
                          ),

                          const SizedBox(width: 7),

                          Flexible(
                            child: Text(
                              weather.condition,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                color: Colors.white.withOpacity(0.82),

                                fontSize: 11,

                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: small ? 24 : 30),

              //////////////////////////////////////////////////
              /// TEMPERATURE
              //////////////////////////////////////////////////
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  ////////////////////////////////////////////////
                  /// VALUE
                  ////////////////////////////////////////////////
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,

                            alignment: Alignment.centerLeft,

                            child: Text(
                              weather.temp.toStringAsFixed(0),

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: small ? 44 : 52,

                                fontWeight: FontWeight.w400,

                                height: 0.95,

                                letterSpacing: -3,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8),

                          child: Text(
                            '°',

                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),

                              fontSize: small ? 20 : 26,

                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////////////////////////////////////////////////
                  /// ICON NODE
                  ////////////////////////////////////////////////
                  Container(
                    width: small ? 50 : 58,
                    height: small ? 50 : 58,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white.withOpacity(0.028),

                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),

                    child: Icon(
                      weatherIcon,

                      color: Colors.white.withOpacity(0.88),

                      size: small ? 24 : 28,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18),

              //////////////////////////////////////////////////
              /// STATS
              //////////////////////////////////////////////////
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      icon: Icons.water_drop_rounded,
                      label: 'Humidity',
                      value: '${weather.humidity}%',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _InfoTile(
                      icon: Icons.air_rounded,
                      label: 'Wind',
                      value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _InfoTile(
                      icon: Icons.cloud_rounded,
                      label: 'Clouds',
                      value: '${weather.cloudCoverage}%',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// INFO TILE
////////////////////////////////////////////////////////////

class _InfoTile extends StatelessWidget {
  final IconData icon;

  final String label;

  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final small = MediaQuery.of(context).size.width < 390;

    return Container(
      constraints: const BoxConstraints(minHeight: 72),

      padding: EdgeInsets.symmetric(
        horizontal: small ? 12 : 14,

        vertical: small ? 14 : 16,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        color: Colors.white.withOpacity(0.02),

        border: Border.all(color: Colors.white.withOpacity(0.025)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          ////////////////////////////////////////////////
          /// ICON
          ////////////////////////////////////////////////
          Icon(
            icon,

            size: small ? 18 : 19,

            color: Colors.white.withOpacity(0.76),
          ),

          const SizedBox(height: 10),

          ////////////////////////////////////////////////
          /// VALUE
          ////////////////////////////////////////////////
          FittedBox(
            fit: BoxFit.scaleDown,

            child: Text(
              value,

              maxLines: 1,

              style: TextStyle(
                color: Colors.white.withOpacity(0.92),

                fontSize: small ? 15 : 16,

                fontWeight: FontWeight.w500,

                letterSpacing: -0.4,
              ),
            ),
          ),

          const SizedBox(height: 6),

          ////////////////////////////////////////////////
          /// LABEL
          ////////////////////////////////////////////////
          Text(
            label,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              color: Colors.white.withOpacity(0.42),

              fontSize: 11,

              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
