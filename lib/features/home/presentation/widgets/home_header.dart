import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:aquaguard/core/router/app_router.dart';
import 'package:aquaguard/core/theme/app_colors.dart';
import 'package:aquaguard/core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  ////////////////////////////////////////////////////////////
  /// CONTEXTUAL GREETING
  ////////////////////////////////////////////////////////////

  String _greeting() {
    final hour = DateTime.now().hour;

    //////////////////////////////////////////////////////////
    /// MORNING
    //////////////////////////////////////////////////////////

    if (hour >= 5 && hour < 11) {
      return 'Good morning';
    }

    //////////////////////////////////////////////////////////
    /// AFTERNOON
    //////////////////////////////////////////////////////////

    if (hour >= 11 && hour < 17) {
      return 'Good afternoon';
    }

    //////////////////////////////////////////////////////////
    /// EVENING
    //////////////////////////////////////////////////////////

    if (hour >= 17 && hour < 21) {
      return 'Good evening';
    }

    //////////////////////////////////////////////////////////
    /// NIGHT
    //////////////////////////////////////////////////////////

    return 'Good night';
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          //////////////////////////////////////////////////////
          /// LEFT CONTENT
          //////////////////////////////////////////////////////
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //////////////////////////////////////////////////
                /// GREETING
                //////////////////////////////////////////////////
                Text(
                  _greeting(),

                  style: AppTextStyles.label.copyWith(
                    color: Colors.white.withOpacity(0.48),

                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 10),

                //////////////////////////////////////////////////
                /// TITLE
                //////////////////////////////////////////////////
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Color(0xFFD6E7FF)],
                    ).createShader(bounds);
                  },

                  child: Text(
                    'AquaGuard',

                    style: AppTextStyles.hero.copyWith(
                      fontSize: 31,

                      fontWeight: FontWeight.w500,

                      letterSpacing: -1.6,

                      color: Colors.white,

                      height: 0.95,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                //////////////////////////////////////////////////
                /// STATUS CAPSULE
                //////////////////////////////////////////////////
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),

                        color: Colors.white.withOpacity(0.035),

                        border: Border.all(
                          color: Colors.white.withOpacity(0.04),
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          //////////////////////////////////////////
                          /// LIVE DOT
                          //////////////////////////////////////////
                          Container(
                            width: 7,
                            height: 7,

                            decoration: BoxDecoration(
                              color: const Color(0xFF7DD3FC),

                              shape: BoxShape.circle,

                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7DD3FC,
                                  ).withOpacity(0.35),

                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          //////////////////////////////////////////
                          /// STATUS TEXT
                          //////////////////////////////////////////
                          Text(
                            'Realtime telemetry active',

                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withOpacity(0.68),

                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          //////////////////////////////////////////////////////
          /// PROFILE BUTTON
          //////////////////////////////////////////////////////
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.profile);
            },

            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 450),

              tween: Tween(begin: 0.96, end: 1),

              curve: Curves.easeOutCubic,

              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },

              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),

                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),

                    curve: Curves.easeOutCubic,

                    width: 56,
                    height: 56,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,

                        colors: [
                          Colors.white.withOpacity(0.055),
                          Colors.white.withOpacity(0.018),
                        ],
                      ),

                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),

                    child: Stack(
                      children: [
                        ////////////////////////////////////////////
                        /// ICON
                        ////////////////////////////////////////////
                        Center(
                          child: Icon(
                            Icons.person_rounded,

                            color: Colors.white.withOpacity(0.82),

                            size: 22,
                          ),
                        ),

                        ////////////////////////////////////////////
                        /// ONLINE INDICATOR
                        ////////////////////////////////////////////
                        Positioned(
                          right: 11,
                          bottom: 11,

                          child: Container(
                            width: 9,
                            height: 9,

                            decoration: BoxDecoration(
                              color: const Color(0xFF4ADE80),

                              shape: BoxShape.circle,

                              border: Border.all(
                                color: AppColors.background,

                                width: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
