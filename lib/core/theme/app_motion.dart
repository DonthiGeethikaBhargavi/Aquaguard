import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  ////////////////////////////////////////////////////////////
  /// DURATIONS
  ////////////////////////////////////////////////////////////

  /// Ultra-fast tactile feedback
  static const Duration instant = Duration(milliseconds: 120);

  /// Tap feedback
  static const Duration fast = Duration(milliseconds: 180);

  /// Small UI changes
  static const Duration medium = Duration(milliseconds: 280);

  /// Card transitions
  static const Duration slow = Duration(milliseconds: 420);

  /// Modal transitions
  static const Duration modal = Duration(milliseconds: 520);

  /// Atmospheric transitions
  static const Duration atmosphere = Duration(milliseconds: 1800);

  ////////////////////////////////////////////////////////////
  /// CURVES
  ////////////////////////////////////////////////////////////

  /// Primary premium easing
  static const Curve standard = Curves.easeOutCubic;

  /// Softer fade motion
  static const Curve soft = Curves.easeInOutCubic;

  /// Atmospheric movement
  static const Curve atmosphereCurve = Curves.easeInOut;

  /// Interactive press feedback
  static const Curve press = Curves.easeOutQuad;

  ////////////////////////////////////////////////////////////
  /// SCALE VALUES
  ////////////////////////////////////////////////////////////

  /// Soft press scale
  static const double pressScale = 0.985;

  /// Card touch scale
  static const double cardScale = 0.992;

  ////////////////////////////////////////////////////////////
  /// OPACITY
  ////////////////////////////////////////////////////////////

  /// Soft border opacity
  static const double borderOpacity = 0.05;

  /// Atmospheric glow opacity
  static const double glowOpacity = 0.08;

  /// Subtle overlays
  static const double overlayOpacity = 0.12;
}
