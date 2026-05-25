import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PremiumPondEmpty extends StatelessWidget {
  final VoidCallback onAdd;

  const PremiumPondEmpty({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 24),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          //////////////////////////////////////////////////////
          /// ATMOSPHERIC NODE
          //////////////////////////////////////////////////////
          Stack(
            alignment: Alignment.center,

            children: [
              ////////////////////////////////////////////////
              /// OUTER GLOW
              ////////////////////////////////////////////////
              Container(
                width: 130,
                height: 130,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.cyan.withOpacity(0.03),
                ),
              ),

              ////////////////////////////////////////////////
              /// GLASS NODE
              ////////////////////////////////////////////////
              ClipRRect(
                borderRadius: BorderRadius.circular(100),

                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                  child: Container(
                    width: 88,
                    height: 88,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,

                        end: Alignment.bottomRight,

                        colors: [
                          Colors.white.withOpacity(0.05),

                          Colors.white.withOpacity(0.015),
                        ],
                      ),

                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),

                    child: Center(
                      child: Icon(
                        Icons.water_drop_rounded,

                        color: Colors.white.withOpacity(0.72),

                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 34),

          //////////////////////////////////////////////////////
          /// TITLE
          //////////////////////////////////////////////////////
          Text(
            'No active pond systems',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,

              fontSize: 24,

              fontWeight: FontWeight.w500,

              letterSpacing: -1,

              height: 1,
            ),
          ),

          const SizedBox(height: 14),

          //////////////////////////////////////////////////////
          /// SUBTITLE
          //////////////////////////////////////////////////////
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),

            child: Text(
              'Create your first aquatic monitoring environment to begin realtime telemetry and environmental analysis.',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white.withOpacity(0.46),

                fontSize: 14,

                fontWeight: FontWeight.w400,

                height: 1.6,

                letterSpacing: -0.1,
              ),
            ),
          ),

          const SizedBox(height: 36),

          //////////////////////////////////////////////////////
          /// CTA
          //////////////////////////////////////////////////////
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();

              onAdd();
            },

            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                child: Container(
                  height: 54,

                  padding: const EdgeInsets.symmetric(horizontal: 22),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,

                      colors: [
                        Colors.white.withOpacity(0.05),

                        Colors.white.withOpacity(0.02),
                      ],
                    ),

                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      ////////////////////////////////////////////
                      /// ICON
                      ////////////////////////////////////////////
                      Icon(
                        Icons.add_rounded,

                        size: 17,

                        color: Colors.white.withOpacity(0.82),
                      ),

                      const SizedBox(width: 10),

                      ////////////////////////////////////////////
                      /// LABEL
                      ////////////////////////////////////////////
                      Text(
                        'Create Pond',

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),

                          fontSize: 14,

                          fontWeight: FontWeight.w500,

                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
