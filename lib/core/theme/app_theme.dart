import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  ////////////////////////////////////////////////////////////
  /// DARK THEME
  ////////////////////////////////////////////////////////////

  static final ThemeData darkTheme = ThemeData(
    //////////////////////////////////////////////////////////
    /// CORE
    //////////////////////////////////////////////////////////
    useMaterial3: true,

    brightness: Brightness.dark,

    fontFamily: 'Inter',

    scaffoldBackgroundColor: AppColors.background,

    visualDensity: VisualDensity.standard,

    //////////////////////////////////////////////////////////
    /// REMOVE MATERIAL FEEL
    //////////////////////////////////////////////////////////
    splashFactory: NoSplash.splashFactory,

    highlightColor: Colors.transparent,

    splashColor: Colors.transparent,

    hoverColor: Colors.transparent,

    focusColor: Colors.transparent,

    //////////////////////////////////////////////////////////
    /// COLORS
    //////////////////////////////////////////////////////////
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,

      primary: AppColors.cyan,

      secondary: AppColors.cyanBright,

      surface: AppColors.surface,

      error: AppColors.danger,
    ),

    //////////////////////////////////////////////////////////
    /// TYPOGRAPHY
    //////////////////////////////////////////////////////////
    textTheme: TextTheme(
      ////////////////////////////////////////////////////////
      /// HERO
      ////////////////////////////////////////////////////////
      displayLarge: AppTextStyles.hero,

      displayMedium: AppTextStyles.largeTitle,

      ////////////////////////////////////////////////////////
      /// HEADINGS
      ////////////////////////////////////////////////////////
      headlineLarge: AppTextStyles.sectionTitle,

      headlineMedium: AppTextStyles.title,

      titleLarge: AppTextStyles.title,

      titleMedium: AppTextStyles.subtitle,

      ////////////////////////////////////////////////////////
      /// BODY
      ////////////////////////////////////////////////////////
      bodyLarge: AppTextStyles.body,

      bodyMedium: AppTextStyles.bodySecondary,

      bodySmall: AppTextStyles.caption,

      ////////////////////////////////////////////////////////
      /// LABELS
      ////////////////////////////////////////////////////////
      labelLarge: AppTextStyles.button,

      labelMedium: AppTextStyles.label,

      labelSmall: AppTextStyles.microLabel,
    ),

    //////////////////////////////////////////////////////////
    /// APP BAR
    //////////////////////////////////////////////////////////
    appBarTheme: const AppBarTheme(
      elevation: 0,

      scrolledUnderElevation: 0,

      centerTitle: false,

      backgroundColor: Colors.transparent,

      surfaceTintColor: Colors.transparent,

      titleSpacing: 24,
    ),

    //////////////////////////////////////////////////////////
    /// ICONS
    //////////////////////////////////////////////////////////
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,

      size: 20,

      opacity: 0.84,
    ),

    //////////////////////////////////////////////////////////
    /// DIVIDERS
    //////////////////////////////////////////////////////////
    dividerColor: AppColors.border,

    dividerTheme: const DividerThemeData(thickness: 0.35, space: 1),

    //////////////////////////////////////////////////////////
    /// CARDS
    //////////////////////////////////////////////////////////
    cardColor: AppColors.card,

    cardTheme: CardThemeData(
      elevation: 0,

      color: AppColors.card,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),

        side: BorderSide(color: AppColors.border, width: 0.8),
      ),
    ),

    //////////////////////////////////////////////////////////
    /// INPUTS
    //////////////////////////////////////////////////////////
    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.inputFill,

      hintStyle: AppTextStyles.bodySecondary,

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),

        borderSide: BorderSide(color: AppColors.border, width: 0.8),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),

        borderSide: BorderSide(color: AppColors.border, width: 0.8),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),

        borderSide: BorderSide(
          color: AppColors.cyan.withOpacity(0.16),

          width: 1,
        ),
      ),
    ),

    //////////////////////////////////////////////////////////
    /// SNACKBAR
    //////////////////////////////////////////////////////////
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.elevatedSurface.withOpacity(0.88),

      contentTextStyle: AppTextStyles.body,

      behavior: SnackBarBehavior.floating,

      elevation: 0,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),

    //////////////////////////////////////////////////////////
    /// BOTTOM SHEETS
    //////////////////////////////////////////////////////////
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,

      surfaceTintColor: Colors.transparent,

      elevation: 0,
    ),

    //////////////////////////////////////////////////////////
    /// LIST TILES
    //////////////////////////////////////////////////////////
    listTileTheme: const ListTileThemeData(
      dense: false,

      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    ),

    //////////////////////////////////////////////////////////
    /// SCROLLBARS
    //////////////////////////////////////////////////////////
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white.withOpacity(0.08)),

      trackColor: WidgetStateProperty.all(Colors.transparent),

      thickness: WidgetStateProperty.all(4),

      radius: const Radius.circular(100),
    ),

    //////////////////////////////////////////////////////////
    /// PAGE TRANSITIONS
    //////////////////////////////////////////////////////////
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        //////////////////////////////////////////////////
        /// IOS-LIKE
        //////////////////////////////////////////////////
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),

        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),

        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),

        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),

        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
