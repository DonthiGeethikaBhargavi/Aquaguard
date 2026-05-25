import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

class ResponsiveHelper {
  ////////////////////////////////////////////////////////////
  /// DEVICE TYPES
  ////////////////////////////////////////////////////////////

  static bool isMobile(BuildContext context) {
    return screenWidth(context) < AppBreakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);

    return width >= AppBreakpoints.mobile && width < AppBreakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= AppBreakpoints.desktop;
  }

  static bool isUltraWide(BuildContext context) {
    return screenWidth(context) >= AppBreakpoints.ultraWide;
  }

  ////////////////////////////////////////////////////////////
  /// SCREEN SIZE
  ////////////////////////////////////////////////////////////

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  ////////////////////////////////////////////////////////////
  /// ORIENTATION
  ////////////////////////////////////////////////////////////

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  ////////////////////////////////////////////////////////////
  /// SCALE FACTOR
  ////////////////////////////////////////////////////////////

  static double scaleFactor(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 2200) {
      return 1.28;
    }

    if (width >= 1800) {
      return 1.18;
    }

    if (width >= 1400) {
      return 1.08;
    }

    if (width >= 1000) {
      return 1.0;
    }

    if (width >= 700) {
      return 0.94;
    }

    return 0.88;
  }

  ////////////////////////////////////////////////////////////
  /// PADDING
  ////////////////////////////////////////////////////////////

  static double screenPadding(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 1800) {
      return 44;
    }

    if (width >= 1400) {
      return 38;
    }

    if (width >= 1000) {
      return 32;
    }

    if (width >= 700) {
      return 24;
    }

    return 16;
  }

  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 2200) {
      return width * 0.18;
    }

    if (width >= 1800) {
      return width * 0.14;
    }

    if (width >= 1600) {
      return width * 0.11;
    }

    if (width >= 1400) {
      return width * 0.08;
    }

    if (width >= 1000) {
      return 36;
    }

    if (width >= 700) {
      return 24;
    }

    return 16;
  }

  static double verticalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 32;
    }

    if (isTablet(context)) {
      return 24;
    }

    return 18;
  }

  ////////////////////////////////////////////////////////////
  /// CONTENT WIDTH
  ////////////////////////////////////////////////////////////

  static double contentMaxWidth(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 2400) {
      return 1900;
    }

    if (width >= 2200) {
      return 1750;
    }

    if (width >= 1800) {
      return 1550;
    }

    if (width >= 1400) {
      return 1380;
    }

    if (width >= 1200) {
      return 1220;
    }

    return width;
  }

  ////////////////////////////////////////////////////////////
  /// SPACING
  ////////////////////////////////////////////////////////////

  static double sectionSpacing(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 1800) {
      return 44;
    }

    if (width >= 1400) {
      return 40;
    }

    if (width >= 1000) {
      return 34;
    }

    if (width >= 700) {
      return 28;
    }

    return 22;
  }

  static double gridSpacing(BuildContext context) {
    if (isDesktop(context)) {
      return 22;
    }

    if (isTablet(context)) {
      return 18;
    }

    return 14;
  }

  static double cardPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 28;
    }

    if (isTablet(context)) {
      return 22;
    }

    return 18;
  }

  ////////////////////////////////////////////////////////////
  /// TYPOGRAPHY
  ////////////////////////////////////////////////////////////

  static double titleSize(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 1800) {
      return 48;
    }

    if (width >= 1400) {
      return 42;
    }

    if (width >= 1000) {
      return 36;
    }

    if (width >= 700) {
      return 32;
    }

    return 26;
  }

  static double sectionTitleSize(BuildContext context) {
    if (isDesktop(context)) {
      return 28;
    }

    if (isTablet(context)) {
      return 24;
    }

    return 20;
  }

  static double subtitleSize(BuildContext context) {
    if (isDesktop(context)) {
      return 17;
    }

    if (isTablet(context)) {
      return 15;
    }

    return 13;
  }

  static double bodySize(BuildContext context) {
    if (isDesktop(context)) {
      return 15;
    }

    return 14;
  }

  static double captionSize(BuildContext context) {
    if (isDesktop(context)) {
      return 13;
    }

    return 12;
  }

  ////////////////////////////////////////////////////////////
  /// GRID COUNTS
  ////////////////////////////////////////////////////////////

  static int analyticsGridCount(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 2200) {
      return 6;
    }

    if (width >= 1800) {
      return 5;
    }

    if (width >= 1400) {
      return 4;
    }

    if (width >= 1000) {
      return 3;
    }

    if (width >= 700) {
      return 2;
    }

    return 1;
  }

  ////////////////////////////////////////////////////////////
  /// ASPECT RATIOS
  ////////////////////////////////////////////////////////////

  static double analyticsCardAspectRatio(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 2200) {
      return 1.55;
    }

    if (width >= 1800) {
      return 1.45;
    }

    if (width >= 1400) {
      return 1.34;
    }

    if (width >= 1000) {
      return 1.22;
    }

    if (width >= 700) {
      return 1.12;
    }

    return 1.02;
  }

  static double chartAspectRatio(BuildContext context) {
    if (isUltraWide(context)) {
      return 2.4;
    }

    if (isDesktop(context)) {
      return 2.0;
    }

    if (isTablet(context)) {
      return 1.6;
    }

    return 1.0;
  }

  ////////////////////////////////////////////////////////////
  /// SAFE AREAS
  ////////////////////////////////////////////////////////////

  static EdgeInsets safeHorizontalPadding(BuildContext context) {
    final padding = screenPadding(context);

    return EdgeInsets.symmetric(horizontal: padding);
  }

  static EdgeInsets safePagePadding(BuildContext context) {
    return EdgeInsets.only(
      left: screenPadding(context),

      right: screenPadding(context),

      bottom: isMobile(context) ? 120 : 40,
    );
  }

  ////////////////////////////////////////////////////////////
  /// CONSTRAINTS
  ////////////////////////////////////////////////////////////

  static BoxConstraints contentConstraints(BuildContext context) {
    return BoxConstraints(maxWidth: contentMaxWidth(context));
  }

  ////////////////////////////////////////////////////////////
  /// RESPONSIVE VALUE
  ////////////////////////////////////////////////////////////

  static T responsiveValue<T>({
    required BuildContext context,

    required T mobile,

    T? tablet,

    T? desktop,

    T? ultraWide,
  }) {
    if (isUltraWide(context)) {
      return ultraWide ?? desktop ?? tablet ?? mobile;
    }

    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}
