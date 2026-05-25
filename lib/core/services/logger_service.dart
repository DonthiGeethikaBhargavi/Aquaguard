import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

////////////////////////////////////////////////////////////
/// ENVIRONMENT
////////////////////////////////////////////////////////////

enum LoggerEnvironment { development, staging, production }

////////////////////////////////////////////////////////////
/// LOG LEVEL
////////////////////////////////////////////////////////////

enum LogLevel { debug, info, warning, error, critical }

////////////////////////////////////////////////////////////
/// LOGGER SERVICE
////////////////////////////////////////////////////////////

class LoggerService {
  LoggerService._internal();

  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() => _instance;

  ////////////////////////////////////////////////////////////
  /// ENVIRONMENT
  ////////////////////////////////////////////////////////////

  static const LoggerEnvironment environment = kReleaseMode
      ? LoggerEnvironment.production
      : LoggerEnvironment.development;

  ////////////////////////////////////////////////////////////
  /// CONFIG
  ////////////////////////////////////////////////////////////

  static const bool enableConsoleLogs = true;

  static const bool enableCrashlytics = true;

  static const bool enablePrettyJson = true;

  static const int maxLogLength = 8000;

  ////////////////////////////////////////////////////////////
  /// DEBUG
  ////////////////////////////////////////////////////////////

  void debug(String message, {String tag = 'APP', Object? data}) {
    if (environment == LoggerEnvironment.production) {
      return;
    }

    _log(level: LogLevel.debug, message: message, tag: tag, data: data);
  }

  ////////////////////////////////////////////////////////////
  /// INFO
  ////////////////////////////////////////////////////////////

  void info(String message, {String tag = 'APP', Object? data}) {
    _log(level: LogLevel.info, message: message, tag: tag, data: data);
  }

  ////////////////////////////////////////////////////////////
  /// WARNING
  ////////////////////////////////////////////////////////////

  void warning(String message, {String tag = 'APP', Object? data}) {
    _log(level: LogLevel.warning, message: message, tag: tag, data: data);
  }

  ////////////////////////////////////////////////////////////
  /// ERROR
  ////////////////////////////////////////////////////////////

  Future<void> error(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) async {
    await _log(
      level: LogLevel.error,

      message: message,

      tag: tag,

      error: error,

      stackTrace: stackTrace,

      data: data,
    );
  }

  ////////////////////////////////////////////////////////////
  /// CRITICAL
  ////////////////////////////////////////////////////////////

  Future<void> critical(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) async {
    await _log(
      level: LogLevel.critical,

      message: message,

      tag: tag,

      error: error,

      stackTrace: stackTrace,

      data: data,
    );
  }

  ////////////////////////////////////////////////////////////
  /// CORE LOGGER
  ////////////////////////////////////////////////////////////

  Future<void> _log({
    required LogLevel level,

    required String message,

    required String tag,

    Object? error,

    StackTrace? stackTrace,

    Object? data,
  }) async {
    final timestamp = DateTime.now().toIso8601String();

    final emoji = _emoji(level);

    final levelName = level.name.toUpperCase();

    final environmentName = environment.name.toUpperCase();

    final buffer = StringBuffer();

    //////////////////////////////////////////////////////////
    /// HEADER
    //////////////////////////////////////////////////////////

    buffer.writeln('$emoji [$levelName][$tag][$environmentName] $timestamp');

    //////////////////////////////////////////////////////////
    /// MESSAGE
    //////////////////////////////////////////////////////////

    buffer.writeln(message);

    //////////////////////////////////////////////////////////
    /// DATA
    //////////////////////////////////////////////////////////

    if (data != null) {
      try {
        final encoded = enablePrettyJson
            ? const JsonEncoder.withIndent('  ').convert(data)
            : jsonEncode(data);

        buffer.writeln('DATA:');

        buffer.writeln(encoded);
      } catch (_) {
        buffer.writeln('DATA: $data');
      }
    }

    //////////////////////////////////////////////////////////
    /// ERROR
    //////////////////////////////////////////////////////////

    if (error != null) {
      buffer.writeln('ERROR:');

      buffer.writeln(error.toString());
    }

    //////////////////////////////////////////////////////////
    /// STACKTRACE
    //////////////////////////////////////////////////////////

    if (stackTrace != null) {
      buffer.writeln('STACKTRACE:');

      buffer.writeln(stackTrace.toString());
    }

    //////////////////////////////////////////////////////////
    /// FINAL LOG
    //////////////////////////////////////////////////////////

    String finalLog = buffer.toString();

    //////////////////////////////////////////////////////////
    /// TRUNCATION SAFETY
    //////////////////////////////////////////////////////////

    if (finalLog.length > maxLogLength) {
      finalLog = '${finalLog.substring(0, maxLogLength)}\n...[TRUNCATED]';
    }

    //////////////////////////////////////////////////////////
    /// CONSOLE
    //////////////////////////////////////////////////////////

    if (enableConsoleLogs) {
      developer.log(finalLog, name: tag, error: error, stackTrace: stackTrace);

      if (kDebugMode) {
        debugPrint(finalLog);
      }
    }

    //////////////////////////////////////////////////////////
    /// CRASHLYTICS
    //////////////////////////////////////////////////////////

    if (enableCrashlytics &&
        !kIsWeb &&
        (level == LogLevel.error || level == LogLevel.critical)) {
      try {
        await FirebaseCrashlytics.instance.log(finalLog);

        if (error != null) {
          await FirebaseCrashlytics.instance.recordError(
            error,

            stackTrace,

            reason: message,

            fatal: level == LogLevel.critical,
          );
        }
      } catch (_) {}
    }
  }

  ////////////////////////////////////////////////////////////
  /// PERFORMANCE
  ////////////////////////////////////////////////////////////

  void performance({
    required String operation,

    required Duration duration,

    String tag = 'PERFORMANCE',

    Object? data,
  }) {
    info(
      '$operation completed in ${duration.inMilliseconds}ms',

      tag: tag,

      data: data,
    );
  }

  ////////////////////////////////////////////////////////////
  /// REALTIME
  ////////////////////////////////////////////////////////////

  void realtime(String event, {String tag = 'REALTIME', Object? data}) {
    info(event, tag: tag, data: data);
  }

  ////////////////////////////////////////////////////////////
  /// API
  ////////////////////////////////////////////////////////////

  void api(
    String endpoint, {
    String method = 'GET',

    int? statusCode,

    Duration? duration,

    Object? data,
  }) {
    info(
      '$method $endpoint'
      '${statusCode != null ? ' [$statusCode]' : ''}'
      '${duration != null ? ' (${duration.inMilliseconds}ms)' : ''}',

      tag: 'API',

      data: data,
    );
  }

  ////////////////////////////////////////////////////////////
  /// PROVIDER
  ////////////////////////////////////////////////////////////

  void provider(String providerName, {String action = 'update', Object? data}) {
    debug('$providerName -> $action', tag: 'PROVIDER', data: data);
  }

  ////////////////////////////////////////////////////////////
  /// NAVIGATION
  ////////////////////////////////////////////////////////////

  void navigation(String route, {Object? data}) {
    info('Navigate -> $route', tag: 'ROUTER', data: data);
  }

  ////////////////////////////////////////////////////////////
  /// AUTH
  ////////////////////////////////////////////////////////////

  void auth(String event, {Object? data}) {
    info(event, tag: 'AUTH', data: data);
  }

  ////////////////////////////////////////////////////////////
  /// DATABASE
  ////////////////////////////////////////////////////////////

  void database(String operation, {Object? data}) {
    info(operation, tag: 'DATABASE', data: data);
  }

  ////////////////////////////////////////////////////////////
  /// AI
  ////////////////////////////////////////////////////////////

  void ai(String event, {Object? data}) {
    info(event, tag: 'AI', data: data);
  }

  ////////////////////////////////////////////////////////////
  /// EMOJI
  ////////////////////////////////////////////////////////////

  String _emoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🟣';

      case LogLevel.info:
        return '🔵';

      case LogLevel.warning:
        return '🟠';

      case LogLevel.error:
        return '🔴';

      case LogLevel.critical:
        return '💥';
    }
  }
}
