import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';

class AquaguardApp extends ConsumerWidget {
  const AquaguardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    //////////////////////////////////////////////////////////
    /// BASE COLORS
    //////////////////////////////////////////////////////////

    const background = Color(0xFF070B14);

    const primary = Color(0xFF00D4FF);

    const secondary = Color(0xFF7B61FF);

    //////////////////////////////////////////////////////////
    /// TEXT THEME
    //////////////////////////////////////////////////////////

    final textTheme = GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          headlineLarge: GoogleFonts.notoSans(
            fontWeight: FontWeight.w800,

            fontSize: 34,

            color: Colors.white,

            letterSpacing: -1,
          ),

          headlineMedium: GoogleFonts.notoSans(
            fontWeight: FontWeight.w800,

            fontSize: 28,

            color: Colors.white,

            letterSpacing: -0.6,
          ),

          titleLarge: GoogleFonts.notoSans(
            fontWeight: FontWeight.w700,

            fontSize: 20,

            color: Colors.white,
          ),

          titleMedium: GoogleFonts.notoSans(
            fontWeight: FontWeight.w600,

            fontSize: 16,

            color: Colors.white,
          ),

          bodyLarge: GoogleFonts.notoSans(
            fontWeight: FontWeight.w500,

            fontSize: 15,

            height: 1.5,

            color: Colors.white,
          ),

          bodyMedium: GoogleFonts.notoSans(
            fontWeight: FontWeight.w500,

            fontSize: 13,

            height: 1.5,

            color: Colors.white70,
          ),
        );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'Aquaguard',

      ////////////////////////////////////////////////////////
      /// THEME
      ////////////////////////////////////////////////////////
      theme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        fontFamily: GoogleFonts.notoSans().fontFamily,

        scaffoldBackgroundColor: background,

        splashFactory: InkRipple.splashFactory,

        dividerColor: Colors.white.withOpacity(0.06),

        //////////////////////////////////////////////////////
        /// COLOR SCHEME
        //////////////////////////////////////////////////////
        colorScheme: const ColorScheme.dark(
          primary: primary,

          secondary: secondary,

          surface: Color(0xFF0F172A),

          error: Colors.redAccent,
        ),

        //////////////////////////////////////////////////////
        /// TEXT
        //////////////////////////////////////////////////////
        textTheme: textTheme,

        //////////////////////////////////////////////////////
        /// APP BAR
        //////////////////////////////////////////////////////
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,

          elevation: 0,

          centerTitle: false,

          surfaceTintColor: Colors.transparent,

          titleTextStyle: GoogleFonts.notoSans(
            color: Colors.white,

            fontSize: 22,

            fontWeight: FontWeight.w700,
          ),

          iconTheme: const IconThemeData(color: Colors.white),
        ),

        //////////////////////////////////////////////////////
        /// CARD THEME
        //////////////////////////////////////////////////////
        cardTheme: CardThemeData(
          elevation: 0,

          color: Colors.white.withOpacity(0.04),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),

            side: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
        ),

        //////////////////////////////////////////////////////
        /// INPUTS
        //////////////////////////////////////////////////////
        inputDecorationTheme: InputDecorationTheme(
          filled: true,

          fillColor: Colors.white.withOpacity(0.04),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          hintStyle: GoogleFonts.notoSans(
            color: Colors.white.withOpacity(0.42),

            fontWeight: FontWeight.w500,
          ),

          labelStyle: GoogleFonts.notoSans(
            color: Colors.white.withOpacity(0.68),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),

            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),

            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),

            borderSide: const BorderSide(color: primary, width: 1.4),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),

            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),

        //////////////////////////////////////////////////////
        /// BUTTONS
        //////////////////////////////////////////////////////
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,

            backgroundColor: primary,

            foregroundColor: Colors.black,

            minimumSize: const Size(double.infinity, 58),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),

            textStyle: GoogleFonts.notoSans(
              fontSize: 15,

              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        //////////////////////////////////////////////////////
        /// SWITCH
        //////////////////////////////////////////////////////
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(primary),

          trackColor: WidgetStateProperty.all(primary.withOpacity(0.28)),
        ),

        //////////////////////////////////////////////////////
        /// SCROLLBAR
        //////////////////////////////////////////////////////
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white.withOpacity(0.16)),

          radius: const Radius.circular(30),

          thickness: WidgetStateProperty.all(6),
        ),

        //////////////////////////////////////////////////////
        /// TEXT SELECTION
        //////////////////////////////////////////////////////
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primary,

          selectionColor: primary.withOpacity(0.28),

          selectionHandleColor: primary,
        ),

        //////////////////////////////////////////////////////
        /// PAGE TRANSITIONS
        //////////////////////////////////////////////////////
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),

            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),

            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      ////////////////////////////////////////////////////////
      /// ROUTER
      ////////////////////////////////////////////////////////
      routerConfig: router,
    );
  }
}
