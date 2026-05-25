import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

////////////////////////////////////////////////////////////
/// SCREENS
////////////////////////////////////////////////////////////

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

import '../../features/home/presentation/screens/home_screen.dart';

import '../../features/device/presentation/screens/device_dashboard_screen.dart';
import '../../features/device/presentation/screens/device_list_screen.dart';

import '../../features/profile/presentation/screens/profile_screen.dart';

////////////////////////////////////////////////////////////
/// PROVIDERS
////////////////////////////////////////////////////////////

import '../../features/auth/application/providers/auth_provider.dart';

import '../../features/user/application/providers/user_provider.dart';

////////////////////////////////////////////////////////////
/// ROUTES
////////////////////////////////////////////////////////////

class AppRoutes {
  static const login = '/login';

  static const signup = '/signup';

  static const onboarding = '/onboarding';

  static const home = '/home';

  static const profile = '/profile';

  ////////////////////////////////////////////////////////////
  /// DEVICE
  ////////////////////////////////////////////////////////////

  static const pondDevices = '/pond-devices';

  static const device = '/device';
}

////////////////////////////////////////////////////////////
/// REFRESH STREAM
////////////////////////////////////////////////////////////

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();

    super.dispose();
  }
}

////////////////////////////////////////////////////////////
/// ROUTER PROVIDER
////////////////////////////////////////////////////////////

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  final userData = ref.watch(userDataProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,

    debugLogDiagnostics: false,

    //////////////////////////////////////////////////////
    /// REFRESH
    //////////////////////////////////////////////////////
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.stream),
    ),

    //////////////////////////////////////////////////////
    /// REDIRECT
    //////////////////////////////////////////////////////
    redirect: (context, state) {
      final location = state.matchedLocation;

      final isLogin = location == AppRoutes.login;

      final isSignup = location == AppRoutes.signup;

      final isOnboarding = location == AppRoutes.onboarding;

      ////////////////////////////////////////////////////
      /// LOADING
      ////////////////////////////////////////////////////

      if (authState.isLoading || userData.isLoading) {
        return null;
      }

      ////////////////////////////////////////////////////
      /// AUTH
      ////////////////////////////////////////////////////

      final session = authState.value?.session;

      final isLoggedIn = session != null;

      ////////////////////////////////////////////////////
      /// NOT LOGGED IN
      ////////////////////////////////////////////////////

      if (!isLoggedIn) {
        if (isLogin || isSignup) {
          return null;
        }

        return AppRoutes.login;
      }

      ////////////////////////////////////////////////////
      /// USER DATA
      ////////////////////////////////////////////////////

      final data = userData.value;

      if (data == null) {
        return AppRoutes.onboarding;
      }

      final aquaticType = data['aquatic_type'];

      final isMissing =
          aquaticType == null || aquaticType.toString().trim().isEmpty;

      ////////////////////////////////////////////////////
      /// NEED ONBOARDING
      ////////////////////////////////////////////////////

      if (isMissing && !isOnboarding) {
        return AppRoutes.onboarding;
      }

      ////////////////////////////////////////////////////
      /// BLOCK AUTH ROUTES
      ////////////////////////////////////////////////////

      if (!isMissing && (isLogin || isSignup || isOnboarding)) {
        return AppRoutes.home;
      }

      return null;
    },

    //////////////////////////////////////////////////////
    /// ROUTES
    //////////////////////////////////////////////////////
    routes: [
      ////////////////////////////////////////////////////
      /// LOGIN
      ////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.login,

        pageBuilder: (context, state) {
          return _fadeTransitionPage(state: state, child: const LoginScreen());
        },
      ),

      ////////////////////////////////////////////////////
      /// SIGNUP
      ////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.signup,

        pageBuilder: (context, state) {
          return _fadeTransitionPage(state: state, child: const SignupScreen());
        },
      ),

      ////////////////////////////////////////////////////
      /// ONBOARDING
      ////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.onboarding,

        pageBuilder: (context, state) {
          return _fadeTransitionPage(
            state: state,

            child: const OnboardingScreen(),
          );
        },
      ),

      ////////////////////////////////////////////////////
      /// HOME
      ////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.home,

        pageBuilder: (context, state) {
          return _fadeTransitionPage(state: state, child: const HomeScreen());
        },
      ),

      ////////////////////////////////////////////////////
      /// PROFILE
      ////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.profile,

        pageBuilder: (context, state) {
          return _cupertinoTransitionPage(
            state: state,

            child: const ProfileScreen(),
          );
        },
      ),

      ////////////////////////////////////////////////////
      /// PREMIUM DEVICE LIST
      ////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.pondDevices,

        pageBuilder: (context, state) {
          final pondId = state.uri.queryParameters['pondId'];

          //////////////////////////////////////////////////
          /// VALIDATION
          //////////////////////////////////////////////////

          if (pondId == null || pondId.isEmpty) {
            return _fadeTransitionPage(
              state: state,

              child: const Scaffold(
                backgroundColor: Color(0xFF070B14),

                body: Center(
                  child: Text(
                    'Invalid pond data',

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }

          //////////////////////////////////////////////////
          /// NEW PREMIUM SCREEN
          //////////////////////////////////////////////////

          return _sharedAxisPage(
            state: state,

            child: DeviceListScreen(pondId: pondId),
          );
        },
      ),

      ////////////////////////////////////////////////////
      /// DEVICE DASHBOARD
      ////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.device,

        pageBuilder: (context, state) {
          final deviceId = state.uri.queryParameters['deviceId'];

          final pondId = state.uri.queryParameters['pondId'];

          final deviceName = state.uri.queryParameters['deviceName'];

          //////////////////////////////////////////////////
          /// VALIDATION
          //////////////////////////////////////////////////

          if (deviceId == null ||
              pondId == null ||
              deviceId.isEmpty ||
              pondId.isEmpty) {
            return _fadeTransitionPage(
              state: state,

              child: const Scaffold(
                backgroundColor: Color(0xFF070B14),

                body: Center(
                  child: Text(
                    'Invalid navigation data',

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }

          //////////////////////////////////////////////////
          /// DASHBOARD
          //////////////////////////////////////////////////

          return _sharedAxisPage(
            state: state,

            child: DeviceDashboardScreen(
              pondId: pondId,

              deviceId: deviceId,

              deviceName: deviceName,
            ),
          );
        },
      ),
    ],
  );
});

////////////////////////////////////////////////////////////
/// FADE PAGE
////////////////////////////////////////////////////////////

CustomTransitionPage _fadeTransitionPage({
  required GoRouterState state,

  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,

    child: child,

    transitionDuration: const Duration(milliseconds: 420),

    reverseTransitionDuration: const Duration(milliseconds: 320),

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),

        child: child,
      );
    },
  );
}

////////////////////////////////////////////////////////////
/// CUPERTINO PAGE
////////////////////////////////////////////////////////////

CustomTransitionPage _cupertinoTransitionPage({
  required GoRouterState state,

  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,

    child: child,

    transitionDuration: const Duration(milliseconds: 500),

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,

        secondaryRouteAnimation: secondaryAnimation,

        linearTransition: false,

        child: child,
      );
    },
  );
}

////////////////////////////////////////////////////////////
/// SHARED AXIS PAGE
////////////////////////////////////////////////////////////

CustomTransitionPage _sharedAxisPage({
  required GoRouterState state,

  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,

    child: child,

    transitionDuration: const Duration(milliseconds: 650),

    reverseTransitionDuration: const Duration(milliseconds: 450),

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeAnimation = CurvedAnimation(
        parent: animation,

        curve: Curves.easeOutCubic,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.06),

        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final scaleAnimation = Tween<double>(
        begin: 0.985,

        end: 1,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: fadeAnimation,

        child: SlideTransition(
          position: slideAnimation,

          child: ScaleTransition(scale: scaleAnimation, child: child),
        ),
      );
    },
  );
}
