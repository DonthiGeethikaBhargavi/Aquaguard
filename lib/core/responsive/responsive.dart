import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

class Responsive {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < AppBreakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= AppBreakpoints.mobile &&
        width(context) < AppBreakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= AppBreakpoints.desktop;
  }

  static bool isUltraWide(BuildContext context) {
    return width(context) >= AppBreakpoints.ultraWide;
  }

  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) return 16;
    if (isTablet(context)) return 24;
    return 32;
  }

  static double sectionSpacing(BuildContext context) {
    if (isMobile(context)) return 24;
    if (isTablet(context)) return 32;
    return 40;
  }

  static double cardSpacing(BuildContext context) {
    if (isMobile(context)) return 12;
    if (isTablet(context)) return 16;
    return 20;
  }

  static int sensorGridCount(BuildContext context) {
    if (isUltraWide(context)) return 4;
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static double titleSize(BuildContext context) {
    if (isMobile(context)) return 26;
    if (isTablet(context)) return 32;
    return 38;
  }

  static double subtitleSize(BuildContext context) {
    if (isMobile(context)) return 14;
    if (isTablet(context)) return 15;
    return 16;
  }
}
