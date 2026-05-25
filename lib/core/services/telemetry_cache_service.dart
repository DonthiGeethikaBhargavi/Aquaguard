////////////////////////////////////////////////////////////
/// OFFLINE TELEMETRY CACHING SERVICE
///
/// Enterprise persistence layer for analytics data.
/// Preserves telemetry during offline mode.
///
/// Caches:
/// - Latest readings snapshot
/// - Graph history (hourly, daily, weekly)
/// - Anomaly timeline
/// - AI insights
/// - Alert summaries
/// - Stability score
///
/// Storage: shared_preferences for simplicity + speed
////////////////////////////////////////////////////////////

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TelemetryCacheService {
  static const String _cachePrefix = 'aquaguard_telemetry_';
  static const String _summaryKey = '${_cachePrefix}summary';
  static const String _chartDataKey = '${_cachePrefix}chart_';
  static const String _anomalyKey = '${_cachePrefix}anomaly_';
  static const String _insightsKey = '${_cachePrefix}insights_';
  static const String _alertsKey = '${_cachePrefix}alerts_';
  static const String _timestampKey = '${_cachePrefix}timestamp_';

  final SharedPreferences _prefs;

  TelemetryCacheService(this._prefs);

  ////////////////////////////////////////////////////////////
  /// LATEST TELEMETRY SNAPSHOT
  ////////////////////////////////////////////////////////////

  /// Cache latest telemetry summary
  Future<void> cacheSummary(String pondId, Map<String, dynamic> summary) async {
    try {
      final key = '$_summaryKey$pondId';
      await _prefs.setString(key, jsonEncode(summary));
      await _prefs.setInt(
        '$_timestampKey$key',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      // Silent fail - cache is non-critical
    }
  }

  /// Retrieve cached telemetry summary
  Map<String, dynamic>? getSummary(String pondId) {
    try {
      final key = '$_summaryKey$pondId';
      final cached = _prefs.getString(key);
      if (cached == null) return null;
      return jsonDecode(cached) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Check if cache is fresh (< 5 minutes old)
  bool isCacheFresh(
    String cacheKey, {
    Duration maxAge = const Duration(minutes: 5),
  }) {
    try {
      final key = '$_timestampKey$cacheKey';
      final timestamp = _prefs.getInt(key);
      if (timestamp == null) return false;

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cachedTime) < maxAge;
    } catch (_) {
      return false;
    }
  }

  ////////////////////////////////////////////////////////////
  /// CHART DATA CACHING
  ////////////////////////////////////////////////////////////

  /// Cache chart data for time range
  Future<void> cacheChartData(
    String pondId,
    String range,
    List<Map<String, dynamic>> data,
  ) async {
    try {
      final key = '$_chartDataKey${pondId}_$range';
      await _prefs.setString(key, jsonEncode(data));
      await _prefs.setInt(
        '$_timestampKey$key',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      // Silent fail
    }
  }

  /// Retrieve cached chart data
  List<Map<String, dynamic>>? getChartData(String pondId, String range) {
    try {
      final key = '$_chartDataKey${pondId}_$range';
      final cached = _prefs.getString(key);
      if (cached == null) return null;

      final list = jsonDecode(cached) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////
  /// ANOMALY TIMELINE CACHING
  ////////////////////////////////////////////////////////////

  /// Cache anomaly timeline
  Future<void> cacheAnomalyTimeline(
    String pondId,
    List<Map<String, dynamic>> anomalies,
  ) async {
    try {
      final key = '$_anomalyKey$pondId';
      await _prefs.setString(key, jsonEncode(anomalies));
      await _prefs.setInt(
        '$_timestampKey$key',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      // Silent fail
    }
  }

  /// Retrieve cached anomalies
  List<Map<String, dynamic>>? getAnomalyTimeline(String pondId) {
    try {
      final key = '$_anomalyKey$pondId';
      final cached = _prefs.getString(key);
      if (cached == null) return null;

      final list = jsonDecode(cached) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS CACHING
  ////////////////////////////////////////////////////////////

  /// Cache AI insights
  Future<void> cacheInsights(
    String pondId,
    List<Map<String, dynamic>> insights,
  ) async {
    try {
      final key = '$_insightsKey$pondId';
      await _prefs.setString(key, jsonEncode(insights));
      await _prefs.setInt(
        '$_timestampKey$key',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      // Silent fail
    }
  }

  /// Retrieve cached insights
  List<Map<String, dynamic>>? getInsights(String pondId) {
    try {
      final key = '$_insightsKey$pondId';
      final cached = _prefs.getString(key);
      if (cached == null) return null;

      final list = jsonDecode(cached) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////
  /// ALERT SUMMARIES CACHING
  ////////////////////////////////////////////////////////////

  /// Cache alert summary
  Future<void> cacheAlertSummary(
    String pondId,
    Map<String, dynamic> summary,
  ) async {
    try {
      final key = '$_alertsKey$pondId';
      await _prefs.setString(key, jsonEncode(summary));
      await _prefs.setInt(
        '$_timestampKey$key',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      // Silent fail
    }
  }

  /// Retrieve cached alert summary
  Map<String, dynamic>? getAlertSummary(String pondId) {
    try {
      final key = '$_alertsKey$pondId';
      final cached = _prefs.getString(key);
      if (cached == null) return null;
      return jsonDecode(cached) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////
  /// CACHE MANAGEMENT
  ////////////////////////////////////////////////////////////

  /// Clear all cached data for pond
  Future<void> clearPondCache(String pondId) async {
    try {
      final keys = _prefs.getKeys();
      final pondKeys = keys.where((k) => k.contains(pondId)).toList();
      for (final key in pondKeys) {
        await _prefs.remove(key);
      }
    } catch (_) {
      // Silent fail
    }
  }

  /// Clear all analytics cache
  Future<void> clearAll() async {
    try {
      final keys = _prefs.getKeys();
      final cacheKeys = keys.where((k) => k.startsWith(_cachePrefix)).toList();
      for (final key in cacheKeys) {
        await _prefs.remove(key);
      }
    } catch (_) {
      // Silent fail
    }
  }

  /// Get cache size estimate (for debugging)
  int getCacheSizeEstimate() {
    try {
      final keys = _prefs.getKeys();
      final cacheKeys = keys.where((k) => k.startsWith(_cachePrefix));
      int totalSize = 0;
      for (final key in cacheKeys) {
        final value = _prefs.getString(key);
        if (value != null) {
          totalSize += value.length;
        }
      }
      return totalSize;
    } catch (_) {
      return 0;
    }
  }
}

/// Get cache service provider (for DI)
Future<TelemetryCacheService> createTelemetryCacheService() async {
  final prefs = await SharedPreferences.getInstance();
  return TelemetryCacheService(prefs);
}
