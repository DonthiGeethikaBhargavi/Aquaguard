import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart';

import 'core/config/env.dart';

import 'core/services/logger_service.dart';

import 'core/services/sound_manager.dart';

////////////////////////////////////////////////////////////
/// LOGGER
////////////////////////////////////////////////////////////

final LoggerService _logger = LoggerService();

////////////////////////////////////////////////////////////
/// MAIN
////////////////////////////////////////////////////////////

Future<void> main() async {
  ////////////////////////////////////////////////////////////
  /// GUARDED ZONE
  ////////////////////////////////////////////////////////////

  runZonedGuarded(
    () async {
      ////////////////////////////////////////////////////////
      /// FLUTTER INIT
      ////////////////////////////////////////////////////////

      WidgetsFlutterBinding.ensureInitialized();

      ////////////////////////////////////////////////////////
      /// SYSTEM UI
      ////////////////////////////////////////////////////////

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,

          statusBarIconBrightness: Brightness.light,

          systemNavigationBarColor: Colors.transparent,

          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      ////////////////////////////////////////////////////////
      /// LOAD ENV
      ////////////////////////////////////////////////////////

      await dotenv.load(fileName: "assets/.env");

      _logger.info('Environment loaded', tag: 'BOOT');

      ////////////////////////////////////////////////////////
      /// VALIDATE ENV
      ////////////////////////////////////////////////////////

      Env.validate();

      _logger.info('Environment validated', tag: 'BOOT');

      ////////////////////////////////////////////////////////
      /// SUPABASE INIT
      ////////////////////////////////////////////////////////

      await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);

      _logger.info('Supabase initialized', tag: 'BOOT');

      ////////////////////////////////////////////////////////
      /// SOUND INIT
      ////////////////////////////////////////////////////////

      await SoundManager().initialize();

      _logger.info('Sound manager initialized', tag: 'BOOT');

      ////////////////////////////////////////////////////////
      /// FIREBASE INIT
      ////////////////////////////////////////////////////////

      if (!kIsWeb) {
        await Firebase.initializeApp();

        _logger.info('Firebase initialized', tag: 'BOOT');

        ////////////////////////////////////////////////////
        /// NOTIFICATION PERMISSION
        ////////////////////////////////////////////////////

        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        ////////////////////////////////////////////////////
        /// GET FCM TOKEN
        ////////////////////////////////////////////////////

        final token = await FirebaseMessaging.instance.getToken();

        _logger.info('FCM TOKEN: $token', tag: 'FCM');

        ////////////////////////////////////////////////////
        /// SAVE TOKEN TO SUPABASE
        ////////////////////////////////////////////////////

        final user = Supabase.instance.client.auth.currentUser;

        if (user != null && token != null) {
          await Supabase.instance.client.from('user_fcm_tokens').upsert({
            'user_id': user.id,
            'token': token,
          });

          _logger.info('FCM token saved to Supabase', tag: 'FCM');
        }

        ////////////////////////////////////////////////////
        /// FOREGROUND NOTIFICATIONS
        ////////////////////////////////////////////////////

        FirebaseMessaging.onMessage.listen((message) {
          _logger.info(
            'Push notification received: ${message.notification?.title}',
            tag: 'FCM',
          );
        });

        ////////////////////////////////////////////////////
        /// FLUTTER ERRORS
        ////////////////////////////////////////////////////

        FlutterError.onError = (FlutterErrorDetails details) async {
          ////////////////////////////////////////////////////
          /// CONSOLE
          ////////////////////////////////////////////////////

          FlutterError.presentError(details);

          ////////////////////////////////////////////////////
          /// LOGGER
          ////////////////////////////////////////////////////

          await _logger.error(
            'Flutter framework error',

            tag: 'FLUTTER',

            error: details.exception,

            stackTrace: details.stack,
          );

          ////////////////////////////////////////////////////
          /// CRASHLYTICS
          ////////////////////////////////////////////////////

          await FirebaseCrashlytics.instance.recordFlutterError(details);
        };

        //////////////////////////////////////////////////////
        /// PLATFORM ERRORS
        //////////////////////////////////////////////////////

        PlatformDispatcher.instance.onError = (error, stack) {
          _logger.critical(
            'Platform dispatcher error',

            tag: 'PLATFORM',

            error: error,

            stackTrace: stack,
          );

          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

          return true;
        };
      }

      ////////////////////////////////////////////////////////
      /// GLOBAL ERROR WIDGET
      ////////////////////////////////////////////////////////

      ErrorWidget.builder = (FlutterErrorDetails details) {
        _logger.error(
          'Widget build failure',

          tag: 'WIDGET',

          error: details.exception,

          stackTrace: details.stack,
        );

        return Material(
          color: const Color(0xFF070B14),

          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  //////////////////////////////////////////////////////////
                  /// ICON
                  //////////////////////////////////////////////////////////
                  Container(
                    width: 84,
                    height: 84,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.redAccent.withOpacity(0.12),

                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.18),
                      ),
                    ),

                    child: const Icon(
                      Icons.error_outline,

                      color: Colors.redAccent,

                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 28),

                  //////////////////////////////////////////////////////////
                  /// TITLE
                  //////////////////////////////////////////////////////////
                  const Text(
                    'Something went wrong',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 22,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  //////////////////////////////////////////////////////////
                  /// MESSAGE
                  //////////////////////////////////////////////////////////
                  Text(
                    kDebugMode
                        ? details.exception.toString()
                        : 'A runtime UI error occurred. The issue has been automatically reported.',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),

                      fontSize: 14,

                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  //////////////////////////////////////////////////////////
                  /// RETRY BUTTON
                  //////////////////////////////////////////////////////////
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },

                    child: const Text('Close App'),
                  ),
                ],
              ),
            ),
          ),
        );
      };

      ////////////////////////////////////////////////////////
      /// RUN APP
      ////////////////////////////////////////////////////////

      _logger.info('Application started', tag: 'BOOT');

      runApp(const ProviderScope(child: AquaguardApp()));
    },

    //////////////////////////////////////////////////////////
    /// UNCAUGHT ASYNC ERRORS
    //////////////////////////////////////////////////////////
    (error, stack) async {
      await _logger.critical(
        'Uncaught async zone error',

        tag: 'ZONE',

        error: error,

        stackTrace: stack,
      );

      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,

          fatal: true,
        );
      }
    },
  );
}
