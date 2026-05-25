import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  ////////////////////////////////////////////////////////////
  /// HERO
  ////////////////////////////////////////////////////////////

  static const hero = TextStyle(
    fontSize: 31,

    fontWeight: FontWeight.w500,

    letterSpacing: -1.6,

    height: 0.98,

    color: AppColors.textPrimary,
  );

  static const largeTitle = TextStyle(
    fontSize: 26,

    fontWeight: FontWeight.w500,

    letterSpacing: -1.2,

    height: 1.02,

    color: AppColors.textPrimary,
  );

  ////////////////////////////////////////////////////////////
  /// SECTIONS
  ////////////////////////////////////////////////////////////

  static const sectionTitle = TextStyle(
    fontSize: 14,

    fontWeight: FontWeight.w500,

    letterSpacing: 0,

    height: 1.2,

    color: AppColors.textSecondary,
  );

  ////////////////////////////////////////////////////////////
  /// TITLES
  ////////////////////////////////////////////////////////////

  static const title = TextStyle(
    fontSize: 19,

    fontWeight: FontWeight.w500,

    letterSpacing: -0.7,

    height: 1.08,

    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 15,

    fontWeight: FontWeight.w400,

    letterSpacing: -0.15,

    height: 1.42,

    color: AppColors.textSecondary,
  );

  ////////////////////////////////////////////////////////////
  /// BODY
  ////////////////////////////////////////////////////////////

  static const body = TextStyle(
    fontSize: 15,

    fontWeight: FontWeight.w400,

    letterSpacing: -0.08,

    height: 1.55,

    color: AppColors.textPrimary,
  );

  static const bodySecondary = TextStyle(
    fontSize: 14,

    fontWeight: FontWeight.w400,

    letterSpacing: -0.05,

    height: 1.55,

    color: AppColors.textMuted,
  );

  ////////////////////////////////////////////////////////////
  /// CAPTIONS
  ////////////////////////////////////////////////////////////

  static const caption = TextStyle(
    fontSize: 12,

    fontWeight: FontWeight.w400,

    letterSpacing: 0,

    height: 1.45,

    color: AppColors.textMuted,
  );

  ////////////////////////////////////////////////////////////
  /// METRICS
  ////////////////////////////////////////////////////////////

  static const metric = TextStyle(
    fontSize: 28,

    fontWeight: FontWeight.w400,

    letterSpacing: -1.5,

    height: 1,

    color: AppColors.textPrimary,
  );

  static const metricSmall = TextStyle(
    fontSize: 20,

    fontWeight: FontWeight.w400,

    letterSpacing: -0.9,

    height: 1,

    color: AppColors.textPrimary,
  );

  ////////////////////////////////////////////////////////////
  /// LABELS
  ////////////////////////////////////////////////////////////

  static const label = TextStyle(
    fontSize: 12,

    fontWeight: FontWeight.w400,

    letterSpacing: 0.2,

    height: 1.2,

    color: AppColors.textSecondary,
  );

  static const microLabel = TextStyle(
    fontSize: 10,

    fontWeight: FontWeight.w500,

    letterSpacing: 0.45,

    height: 1.2,

    color: AppColors.textMuted,
  );

  ////////////////////////////////////////////////////////////
  /// BUTTONS
  ////////////////////////////////////////////////////////////

  static const button = TextStyle(
    fontSize: 14,

    fontWeight: FontWeight.w500,

    letterSpacing: -0.08,

    height: 1.1,

    color: AppColors.textPrimary,
  );
}
