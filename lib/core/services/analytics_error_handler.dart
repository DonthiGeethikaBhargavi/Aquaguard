////////////////////////////////////////////////////////////
/// ENTERPRISE ANALYTICS ERROR HANDLER
///
/// Centralized error handling for telemetry operations.
/// Prevents UI crashes and provides graceful degradation.
///
/// Handles:
/// - Supabase query failures
/// - Realtime disconnects
/// - Parsing errors
/// - Export failures
/// - Offline state
/// - Timeout errors
////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';

enum AnalyticsErrorType {
  networkError,
  supabaseError,
  realtimeError,
  parsingError,
  timeoutError,
  exportError,
  offlineError,
  unknownError,
}

class AnalyticsException implements Exception {
  final AnalyticsErrorType type;
  final String message;
  final String? originalError;
  final StackTrace? stackTrace;

  AnalyticsException({
    required this.type,
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class AnalyticsErrorHandler {
  /// Convert exception to user-friendly message
  static String getErrorMessage(Object? error) {
    if (error is AnalyticsException) {
      return _formatAnalyticsError(error.type);
    }

    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Network connection error. Check your internet and retry.';
    }

    if (errorStr.contains('timeout')) {
      return 'Operation timed out. Telemetry unavailable momentarily.';
    }

    if (errorStr.contains('supabase') || errorStr.contains('database')) {
      return 'Telemetry service temporarily unavailable. Retrying...';
    }

    if (errorStr.contains('parsing') || errorStr.contains('json')) {
      return 'Telemetry data format error. Using cached data.';
    }

    return 'Telemetry unavailable. Operational resilience engaged.';
  }

  /// Format error type to message
  static String _formatAnalyticsError(AnalyticsErrorType type) {
    switch (type) {
      case AnalyticsErrorType.networkError:
        return 'Network unavailable. Telemetry is offline.';
      case AnalyticsErrorType.supabaseError:
        return 'Supabase service error. Retrying...';
      case AnalyticsErrorType.realtimeError:
        return 'Realtime connection lost. Reconnecting...';
      case AnalyticsErrorType.parsingError:
        return 'Telemetry format error. Using cached data.';
      case AnalyticsErrorType.timeoutError:
        return 'Operation timed out. Telemetry syncing...';
      case AnalyticsErrorType.exportError:
        return 'Export failed. Please retry.';
      case AnalyticsErrorType.offlineError:
        return 'Offline mode. Showing cached telemetry.';
      case AnalyticsErrorType.unknownError:
        return 'Telemetry temporarily unavailable.';
    }
  }

  /// Get icon for error state
  static IconData getErrorIcon(AnalyticsErrorType type) {
    switch (type) {
      case AnalyticsErrorType.networkError:
      case AnalyticsErrorType.offlineError:
        return Icons.wifi_off;
      case AnalyticsErrorType.supabaseError:
      case AnalyticsErrorType.realtimeError:
        return Icons.cloud_off;
      case AnalyticsErrorType.timeoutError:
        return Icons.schedule;
      case AnalyticsErrorType.parsingError:
        return Icons.warning;
      case AnalyticsErrorType.exportError:
        return Icons.download_rounded;
      case AnalyticsErrorType.unknownError:
        return Icons.error;
    }
  }

  /// Get color for error state
  static Color getErrorColor(AnalyticsErrorType type) {
    switch (type) {
      case AnalyticsErrorType.networkError:
      case AnalyticsErrorType.offlineError:
      case AnalyticsErrorType.supabaseError:
      case AnalyticsErrorType.realtimeError:
        return const Color(0xFFF87171);
      case AnalyticsErrorType.timeoutError:
      case AnalyticsErrorType.parsingError:
      case AnalyticsErrorType.exportError:
        return const Color(0xFFFBBF24);
      case AnalyticsErrorType.unknownError:
        return const Color(0xFF94A3B8);
    }
  }

  /// Get background color for error banner
  static Color getErrorBackground(AnalyticsErrorType type) {
    final color = getErrorColor(type);
    return color.withOpacity(0.12);
  }

  /// Build error banner widget
  static Widget buildErrorBanner(
    AnalyticsErrorType type, {
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    final message = _formatAnalyticsError(type);
    final color = getErrorColor(type);
    final bgColor = getErrorBackground(type);
    final icon = getErrorIcon(type);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: compact ? 10 : 16,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: bgColor,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: compact ? 16 : 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.82),
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 12),
            SizedBox(
              height: compact ? 28 : 32,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: compact ? 14 : 16),
                label: Text(
                  'Retry',
                  style: TextStyle(fontSize: compact ? 11 : 12),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 8 : 12,
                    vertical: compact ? 4 : 6,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build empty state widget
  static Widget buildEmptyState({
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onAction,
    bool isError = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.cloud_off : Icons.hourglass_empty,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.82),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.58),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DD4BF),
                  foregroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Safe error handler wrapper
  static Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    required String operationName,
    bool silentFail = true,
  }) async {
    try {
      return await operation();
    } catch (e, st) {
      if (!silentFail) {
        debugPrint('AnalyticsError in $operationName: $e\n$st');
      }
      return null;
    }
  }

  /// Convert parsed error to AnalyticsException
  static AnalyticsException parseException(Object error, StackTrace? st) {
    final errorStr = error.toString().toLowerCase();

    AnalyticsErrorType type = AnalyticsErrorType.unknownError;

    if (errorStr.contains('network')) {
      type = AnalyticsErrorType.networkError;
    } else if (errorStr.contains('supabase') || errorStr.contains('database')) {
      type = AnalyticsErrorType.supabaseError;
    } else if (errorStr.contains('realtime')) {
      type = AnalyticsErrorType.realtimeError;
    } else if (errorStr.contains('parsing') || errorStr.contains('json')) {
      type = AnalyticsErrorType.parsingError;
    } else if (errorStr.contains('timeout')) {
      type = AnalyticsErrorType.timeoutError;
    } else if (errorStr.contains('export') || errorStr.contains('download')) {
      type = AnalyticsErrorType.exportError;
    } else if (errorStr.contains('offline') ||
        errorStr.contains('connection')) {
      type = AnalyticsErrorType.offlineError;
    }

    return AnalyticsException(
      type: type,
      message: getErrorMessage(error),
      originalError: error.toString(),
      stackTrace: st,
    );
  }
}
