import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  ////////////////////////////////////////////////////////////
  /// ATMOSPHERIC BACKGROUNDS
  ////////////////////////////////////////////////////////////

  static const LinearGradient morning = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF102038), Color(0xFF070B14)],
  );

  static const LinearGradient afternoon = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF132238), Color(0xFF08111D)],
  );

  static const LinearGradient evening = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A2238), Color(0xFF090D16)],
  );

  static const LinearGradient night = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF05070D), Color(0xFF02040A)],
  );

  ////////////////////////////////////////////////////////////
  /// PREMIUM GLASS CARD
  ////////////////////////////////////////////////////////////

  static final LinearGradient glassCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white.withOpacity(0.055), Colors.white.withOpacity(0.018)],
  );

  ////////////////////////////////////////////////////////////
  /// ATMOSPHERIC CYAN GLOW
  ////////////////////////////////////////////////////////////

  static final LinearGradient cyanGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.cyan.withOpacity(0.12),
      AppColors.cyan.withOpacity(0.015),
    ],
  );

  ////////////////////////////////////////////////////////////
  /// LIVE BADGE
  ////////////////////////////////////////////////////////////

  static final LinearGradient liveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.cyanBright.withOpacity(0.18),
      AppColors.cyan.withOpacity(0.08),
    ],
  );
}
