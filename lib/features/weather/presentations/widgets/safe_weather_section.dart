import 'package:flutter/material.dart';

import 'weather_card.dart';
import '../../domain/models/weather_model.dart';

////////////////////////////////////////////////////////////
/// SAFE WEATHER SECTION
///
/// Prevents:
/// - white screens
/// - render crashes
/// - layout assertion failures
/// - weather widget crashes affecting HomeScreen
////////////////////////////////////////////////////////////

class SafeWeatherSection extends StatelessWidget {
  final WeatherModel? weather;

  final bool isNight;

  const SafeWeatherSection({
    super.key,
    required this.weather,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////
    /// SAFETY WRAPPER
    //////////////////////////////////////////////////////////

    try {
      ////////////////////////////////////////////////////////
      /// NULL SAFETY
      ////////////////////////////////////////////////////////

      if (weather == null) {
        return const _WeatherFallbackCard(
          title: 'Weather Unavailable',
          subtitle: 'Unable to load weather data',
        );
      }

      ////////////////////////////////////////////////////////
      /// MAIN WEATHER CARD
      ////////////////////////////////////////////////////////

      return RepaintBoundary(
        child: WeatherCard(weather: weather!, isNight: isNight),
      );
    } catch (e, stack) {
      ////////////////////////////////////////////////////////
      /// LOG ERROR
      ////////////////////////////////////////////////////////

      debugPrint('WeatherCard crash: $e');

      debugPrintStack(stackTrace: stack);

      ////////////////////////////////////////////////////////
      /// FAIL-SAFE UI
      ////////////////////////////////////////////////////////

      return const _WeatherFallbackCard(
        title: 'Weather Error',
        subtitle: 'Something went wrong while rendering weather',
      );
    }
  }
}

////////////////////////////////////////////////////////////
/// FALLBACK CARD
////////////////////////////////////////////////////////////

class _WeatherFallbackCard extends StatelessWidget {
  final String title;

  final String subtitle;

  const _WeatherFallbackCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final small = screenWidth < 390;

    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(small ? 18 : 22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.04),
          ],
        ),

        border: Border.all(color: Colors.white.withOpacity(0.08)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),

            blurRadius: 28,

            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          //////////////////////////////////////////////////////
          /// ICON
          //////////////////////////////////////////////////////
          Container(
            width: small ? 58 : 66,
            height: small ? 58 : 66,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.08),
            ),

            child: Icon(
              Icons.cloud_off_rounded,

              color: Colors.white.withOpacity(0.85),

              size: small ? 28 : 32,
            ),
          ),

          SizedBox(height: small ? 14 : 18),

          //////////////////////////////////////////////////////
          /// TITLE
          //////////////////////////////////////////////////////
          Text(
            title,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,

              fontSize: small ? 16 : 18,

              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          //////////////////////////////////////////////////////
          /// SUBTITLE
          //////////////////////////////////////////////////////
          Text(
            subtitle,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white.withOpacity(0.55),

              fontSize: small ? 11 : 12,
            ),
          ),

          SizedBox(height: small ? 18 : 22),

          //////////////////////////////////////////////////////
          /// RETRY BUTTON LOOK
          //////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),

              color: Colors.white.withOpacity(0.06),

              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(
                  Icons.refresh_rounded,

                  size: 16,

                  color: Colors.white.withOpacity(0.85),
                ),

                const SizedBox(width: 8),

                Text(
                  'Reload Weather',

                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),

                    fontSize: 12,

                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
