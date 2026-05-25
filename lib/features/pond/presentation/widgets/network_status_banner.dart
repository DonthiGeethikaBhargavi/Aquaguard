import 'dart:ui';

import 'package:flutter/material.dart';

class NetworkStatusBanner extends StatelessWidget {
  final bool isOnline;

  const NetworkStatusBanner({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),

      switchInCurve: Curves.easeOutCubic,

      switchOutCurve: Curves.easeInOut,

      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,

          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.15),

              end: Offset.zero,
            ).animate(animation),

            child: child,
          ),
        );
      },

      child: isOnline
          ? const SizedBox.shrink()
          : Padding(
              key: const ValueKey('offline'),

              padding: const EdgeInsets.only(left: 18, right: 18, top: 12),

              child: Align(
                alignment: Alignment.topCenter,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),

                        gradient: LinearGradient(
                          begin: Alignment.topLeft,

                          end: Alignment.bottomRight,

                          colors: [
                            Colors.orange.withOpacity(0.08),

                            Colors.white.withOpacity(0.02),
                          ],
                        ),

                        border: Border.all(
                          color: Colors.white.withOpacity(0.04),
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          ////////////////////////////////////////////
                          /// ICON
                          ////////////////////////////////////////////
                          Icon(
                            Icons.wifi_off_rounded,

                            size: 16,

                            color: Colors.orange.withOpacity(0.75),
                          ),

                          const SizedBox(width: 10),

                          ////////////////////////////////////////////
                          /// TEXT
                          ////////////////////////////////////////////
                          Text(
                            'Offline mode active',

                            style: TextStyle(
                              color: Colors.white.withOpacity(0.72),

                              fontSize: 13,

                              fontWeight: FontWeight.w400,

                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
