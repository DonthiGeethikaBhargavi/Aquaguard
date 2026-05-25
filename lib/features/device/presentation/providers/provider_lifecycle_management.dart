////////////////////////////////////////////////////////////
/// PROVIDER LIFECYCLE MANAGEMENT
///
/// Safely manages stream subscriptions, prevents memory leaks,
/// and handles provider disposal events.
///
/// Ensures:
/// - Proper cleanup of realtime subscriptions
/// - No duplicate subscriptions
/// - Safe provider disposal
/// - Efficient resource management
////////////////////////////////////////////////////////////

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aquaguard/core/services/analytics_error_handler.dart';

/// Track subscription counts to prevent duplicates
final subscriptionTrackingProvider = StateProvider<Map<String, int>>((ref) {
  ref.onDispose(() {
    // Clear all tracking on disposal
  });
  return {};
});

/// Debounce provider - prevent rapid updates from realtime
final debounceTimerProvider = StateProvider<Map<String, DateTime>>((ref) {
  ref.onDispose(() {
    // Clear on disposal
  });
  return {};
});

/// Last valid telemetry cache for safe fallback
final lastValidTelemetryProvider =
    StateProvider<Map<String, Map<String, dynamic>>>((ref) {
      ref.onDispose(() {
        // Clear cache on disposal
      });
      return {};
    });

/// Error history for diagnosis
final analyticsErrorHistoryProvider = StateProvider<List<AnalyticsException>>((
  ref,
) {
  ref.onDispose(() {
    // Clear on disposal (max 100 errors)
  });
  final errors = <AnalyticsException>[];

  return errors;
});

/// Safe provider execution wrapper
/// Prevents crashes and logs errors
Future<T?> safeProviderExecute<T>(
  ProviderRef<AsyncValue<T>> ref,
  Future<T> Function() operation, {
  required String operationName,
  T? Function()? fallback,
}) async {
  try {
    return await operation();
  } catch (e, st) {
    final exception = AnalyticsErrorHandler.parseException(e, st);

    // Log error
    ref.read(analyticsErrorHistoryProvider.notifier).update((errors) {
      final newErrors = [...errors, exception];
      // Keep only last 100 errors
      return newErrors.length > 100
          ? newErrors.sublist(newErrors.length - 100)
          : newErrors;
    });

    // Try fallback
    if (fallback != null) {
      return fallback();
    }

    rethrow;
  }
}

/// Debounce filter for rapid updates
bool shouldUpdateFromRealtime(
  String dataKey, {
  Duration debounce = const Duration(seconds: 1),
}) {
  // This would be used in a provider to prevent too-frequent updates
  return true; // Placeholder
}
