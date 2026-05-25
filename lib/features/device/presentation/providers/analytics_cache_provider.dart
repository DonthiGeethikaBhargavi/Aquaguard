import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'analytics_cache_provider.g.dart';

////////////////////////////////////////////////////////////
/// ANALYTICS CACHE MODEL
////////////////////////////////////////////////////////////

class AnalyticsCacheSnapshot {
  final Map<String, dynamic> data;
  final DateTime cacheTimestamp;
  final String version;

  AnalyticsCacheSnapshot({
    required this.data,
    required this.cacheTimestamp,
    required this.version,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'cacheTimestamp': cacheTimestamp.toIso8601String(),
      'version': version,
    };
  }

  factory AnalyticsCacheSnapshot.fromJson(Map<String, dynamic> json) {
    return AnalyticsCacheSnapshot(
      data: json['data'] as Map<String, dynamic>? ?? {},
      cacheTimestamp:
          DateTime.tryParse(json['cacheTimestamp']?.toString() ?? '') ??
              DateTime.now(),
      version: json['version']?.toString() ?? '1.0',
    );
  }
}

////////////////////////////////////////////////////////////
/// ANALYTICS CACHE SERVICE
////////////////////////////////////////////////////////////

class AnalyticsCacheService {
  static const String _cacheFileName = 'analytics_cache.json';
  static const String _version = '1.0';
  static const Duration _maxCacheAge = Duration(hours: 6);

  /// Get cache file path
  Future<File> _getCacheFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_cacheFileName');
  }

  /// Save analytics snapshot to cache
  Future<void> saveCache(
    String pondId,
    String deviceId,
    Map<String, dynamic> analyticsData,
  ) async {
    try {
      final cacheFile = await _getCacheFile();

      final snapshot = AnalyticsCacheSnapshot(
        data: {
          'pondId': pondId,
          'deviceId': deviceId,
          'analytics': analyticsData,
        },
        cacheTimestamp: DateTime.now(),
        version: _version,
      );

      final jsonData = jsonEncode(snapshot.toJson());
      await cacheFile.writeAsString(jsonData);
    } catch (e) {
      // Silently fail - cache is not critical
    }
  }

  /// Load analytics snapshot from cache
  Future<AnalyticsCacheSnapshot?> loadCache(
    String pondId,
    String deviceId,
  ) async {
    try {
      final cacheFile = await _getCacheFile();

      if (!await cacheFile.exists()) {
        return null;
      }

      final jsonString = await cacheFile.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      final snapshot = AnalyticsCacheSnapshot.fromJson(json);

      // Check if cache is still valid
      final cacheAge = DateTime.now().difference(snapshot.cacheTimestamp);
      if (cacheAge > _maxCacheAge) {
        // Cache is too old
        await clearCache();
        return null;
      }

      // Verify cache is for the correct device
      if (snapshot.data['pondId'] != pondId ||
          snapshot.data['deviceId'] != deviceId) {
        return null;
      }

      return snapshot;
    } catch (e) {
      // Silently fail - cache is not critical
      return null;
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      final cacheFile = await _getCacheFile();
      if (await cacheFile.exists()) {
        await cacheFile.delete();
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Check if cache exists and is valid
  Future<bool> isCacheValid(String pondId, String deviceId) async {
    final snapshot = await loadCache(pondId, deviceId);
    return snapshot != null;
  }

  /// Get cache age in minutes
  Future<int?> getCacheAge(String pondId, String deviceId) async {
    final snapshot = await loadCache(pondId, deviceId);
    if (snapshot == null) return null;

    final age = DateTime.now().difference(snapshot.cacheTimestamp);
    return age.inMinutes;
  }
}

////////////////////////////////////////////////////////////
/// ANALYTICS CACHE PROVIDER SERVICE
////////////////////////////////////////////////////////////

final analyticsCacheServiceProvider = Provider<AnalyticsCacheService>((ref) {
  return AnalyticsCacheService();
});

////////////////////////////////////////////////////////////
/// LOAD CACHED ANALYTICS
////////////////////////////////////////////////////////////

@riverpod
Future<Map<String, dynamic>?> loadCachedAnalytics(
  LoadCachedAnalyticsRef ref,
  String pondId,
  String deviceId,
) async {
  final cacheService = ref.watch(analyticsCacheServiceProvider);

  try {
    final snapshot = await cacheService.loadCache(pondId, deviceId);

    if (snapshot != null && snapshot.data['analytics'] != null) {
      return snapshot.data['analytics'] as Map<String, dynamic>;
    }

    return null;
  } catch (e) {
    return null;
  }
}

////////////////////////////////////////////////////////////
/// SAVE ANALYTICS TO CACHE
////////////////////////////////////////////////////////////

@riverpod
Future<void> saveAnalyticsToCache(
  SaveAnalyticsToCacheRef ref,
  String pondId,
  String deviceId,
  Map<String, dynamic> analyticsData,
) async {
  final cacheService = ref.watch(analyticsCacheServiceProvider);

  try {
    await cacheService.saveCache(pondId, deviceId, analyticsData);
  } catch (e) {
    // Silently fail - cache is not critical
  }
}

////////////////////////////////////////////////////////////
/// CLEAR ANALYTICS CACHE
////////////////////////////////////////////////////////////

@riverpod
Future<void> clearAnalyticsCache(ClearAnalyticsCacheRef ref) async {
  final cacheService = ref.watch(analyticsCacheServiceProvider);

  try {
    await cacheService.clearCache();
  } catch (e) {
    // Silently fail
  }
}

////////////////////////////////////////////////////////////
/// CHECK CACHE VALIDITY
////////////////////////////////////////////////////////////

@riverpod
Future<bool> isCacheValid(
  IsCacheValidRef ref,
  String pondId,
  String deviceId,
) async {
  final cacheService = ref.watch(analyticsCacheServiceProvider);

  try {
    return await cacheService.isCacheValid(pondId, deviceId);
  } catch (e) {
    return false;
  }
}

////////////////////////////////////////////////////////////
/// GET CACHE AGE
////////////////////////////////////////////////////////////

@riverpod
Future<int?> getCacheAge(
  GetCacheAgeRef ref,
  String pondId,
  String deviceId,
) async {
  final cacheService = ref.watch(analyticsCacheServiceProvider);

  try {
    return await cacheService.getCacheAge(pondId, deviceId);
  } catch (e) {
    return null;
  }
}
