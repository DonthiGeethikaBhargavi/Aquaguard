import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:aquaguard/features/pond/domain/models/pond_with_reading.dart';

import '../../../../core/services/logger_service.dart';

////////////////////////////////////////////////////////////
/// CACHE
////////////////////////////////////////////////////////////

const String _pondCacheKey = 'cached_ponds';

const String _pondCacheTimeKey = 'cached_ponds_timestamp';

const Duration _cacheValidity = Duration(seconds: 1);

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

final pondProvider = AsyncNotifierProvider<PondNotifier, List<PondWithReading>>(
  PondNotifier.new,
);

////////////////////////////////////////////////////////////
/// NOTIFIER
////////////////////////////////////////////////////////////

class PondNotifier extends AsyncNotifier<List<PondWithReading>> {
  late final SupabaseClient _supabase;

  late final LoggerService _logger;

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Future<List<PondWithReading>> build() async {
    _supabase = Supabase.instance.client;

    _logger = LoggerService();

    return _loadPonds();
  }

  ////////////////////////////////////////////////////////////
  /// LOAD
  ////////////////////////////////////////////////////////////

  Future<List<PondWithReading>> _loadPonds() async {
    final prefs = await SharedPreferences.getInstance();

    //////////////////////////////////////////////////////////
    /// TRY CACHE
    //////////////////////////////////////////////////////////

    try {
      final cachedJson = prefs.getString(_pondCacheKey);

      final cacheTime = prefs.getString(_pondCacheTimeKey);

      if (cachedJson != null && cacheTime != null) {
        final parsedTime = DateTime.tryParse(cacheTime);

        final isFresh =
            parsedTime != null &&
            DateTime.now().difference(parsedTime) < _cacheValidity;

        final decoded = jsonDecode(cachedJson) as List;

        final cached = decoded
            .map((e) => PondWithReading.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        //////////////////////////////////////////////////////
        /// BACKGROUND REFRESH
        //////////////////////////////////////////////////////

        unawaited(refreshInBackground());

        if (isFresh) {
          return cached;
        }
      }
    } catch (e, st) {
      _logger.error(
        'Failed to load pond cache',

        tag: 'POND_CACHE',

        error: e,

        stackTrace: st,
      );
    }

    //////////////////////////////////////////////////////////
    /// FALLBACK NETWORK
    //////////////////////////////////////////////////////////

    return fetchFresh();
  }

  ////////////////////////////////////////////////////////////
  /// FETCH FRESH
  ////////////////////////////////////////////////////////////

  Future<List<PondWithReading>> fetchFresh() async {
    try {
      final stopwatch = Stopwatch()..start();

      final response = await _supabase
          .from('pond_with_readings')
          .select()
          .order('pond_name');

      stopwatch.stop();

      final data = List<Map<String, dynamic>>.from(response);

      final ponds = data.map((e) => PondWithReading.fromJson(e)).toList();

      ////////////////////////////////////////////////////////
      /// UPDATE STATE
      ////////////////////////////////////////////////////////

      state = AsyncData(ponds);

      ////////////////////////////////////////////////////////
      /// CACHE
      ////////////////////////////////////////////////////////

      final prefs = await SharedPreferences.getInstance();

      await _saveCache(prefs, ponds);

      ////////////////////////////////////////////////////////
      /// LOGGING
      ////////////////////////////////////////////////////////

      _logger.performance(operation: 'pond_fetch', duration: stopwatch.elapsed);

      _logger.provider(
        'pondProvider',

        action: 'network_fetch_success',

        data: {'count': ponds.length},
      );

      return ponds;
    } catch (e, st) {
      debugPrint('');
      debugPrint('================ POND FETCH ERROR ================');
      debugPrint('Error Type: ${e.runtimeType}');
      debugPrint('Error Message: $e');
      debugPrint('==================================================');
      debugPrint('');

      debugPrintStack(stackTrace: st);

      ////////////////////////////////////////////////////////
      /// LOGGING
      ////////////////////////////////////////////////////////

      _logger.error(
        'Failed to fetch ponds',
        tag: 'PONDS',
        error: e,
        stackTrace: st,
      );

      ////////////////////////////////////////////////////////
      /// OFFLINE CACHE FALLBACK
      ////////////////////////////////////////////////////////

      try {
        final prefs = await SharedPreferences.getInstance();

        final cachedJson = prefs.getString(_pondCacheKey);

        if (cachedJson != null) {
          final decoded = jsonDecode(cachedJson) as List;

          return decoded
              .map(
                (e) => PondWithReading.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();
        }
      } catch (_) {}

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// BACKGROUND REFRESH
  ////////////////////////////////////////////////////////////

  Future<void> refreshInBackground() async {
    try {
      final response = await _supabase
          .from('pond_with_readings')
          .select()
          .order('pond_name');

      final data = List<Map<String, dynamic>>.from(response);

      final ponds = data.map((e) => PondWithReading.fromJson(e)).toList();

      ////////////////////////////////////////////////////////
      /// UPDATE STATE
      ////////////////////////////////////////////////////////

      state = AsyncData(ponds);

      ////////////////////////////////////////////////////////
      /// UPDATE CACHE
      ////////////////////////////////////////////////////////

      final prefs = await SharedPreferences.getInstance();

      await _saveCache(prefs, ponds);

      ////////////////////////////////////////////////////////
      /// LOG
      ////////////////////////////////////////////////////////

      _logger.provider(
        'pondProvider',

        action: 'background_refresh_success',

        data: {'count': ponds.length},
      );
    } catch (e, st) {
      _logger.warning(
        'Background pond refresh failed',

        tag: 'PONDS',

        data: {'error': e.toString()},
      );

      _logger.error(
        'Background pond refresh exception',

        tag: 'PONDS',

        error: e,

        stackTrace: st,
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(fetchFresh);
  }

  ////////////////////////////////////////////////////////////
  /// OPTIMISTIC ADD
  ////////////////////////////////////////////////////////////

  void optimisticAdd(PondWithReading pond) {
    final current = state.value ?? [];

    state = AsyncData([pond, ...current]);
  }

  ////////////////////////////////////////////////////////////
  /// OPTIMISTIC REMOVE
  ////////////////////////////////////////////////////////////

  void optimisticRemove(String pondId) {
    final current = state.value ?? [];

    state = AsyncData(current.where((e) => e.pondId != pondId).toList());
  }

  ////////////////////////////////////////////////////////////
  /// ADD POND
  ////////////////////////////////////////////////////////////

  Future<void> addPond({required String pondName}) async {
    //////////////////////////////////////////////////////////
    /// INSERT INTO REAL TABLE
    //////////////////////////////////////////////////////////

    await _supabase.from('ponds').insert({'pond_name': pondName});

    //////////////////////////////////////////////////////////
    /// REFRESH VIEW
    //////////////////////////////////////////////////////////

    await refreshInBackground();
  }

  ////////////////////////////////////////////////////////////
  /// DELETE POND
  ////////////////////////////////////////////////////////////

  Future<void> deletePond(String pondId) async {
    //////////////////////////////////////////////////////////
    /// OPTIMISTIC UI
    //////////////////////////////////////////////////////////

    optimisticRemove(pondId);

    //////////////////////////////////////////////////////////
    /// DELETE FROM REAL TABLE
    //////////////////////////////////////////////////////////

    await _supabase.from('ponds').delete().eq('pond_id', pondId);

    //////////////////////////////////////////////////////////
    /// REFRESH VIEW
    //////////////////////////////////////////////////////////

    unawaited(refreshInBackground());
  }

  ////////////////////////////////////////////////////////////
  /// SAVE CACHE
  ////////////////////////////////////////////////////////////

  Future<void> _saveCache(
    SharedPreferences prefs,
    List<PondWithReading> ponds,
  ) async {
    await prefs.setString(
      _pondCacheKey,

      jsonEncode(ponds.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(_pondCacheTimeKey, DateTime.now().toIso8601String());
  }
}
