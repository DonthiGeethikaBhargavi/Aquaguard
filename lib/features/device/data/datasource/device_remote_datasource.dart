import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/logger_service.dart';

import '../../presentation/providers/chart_range.dart';

import '../models/ai_insight_model.dart';
import '../models/alert_model.dart';
import '../models/device_status_model.dart';
import '../models/sensor_reading_model.dart';

class DeviceRemoteDatasource {
  final SupabaseClient supabase;

  final LoggerService _logger = LoggerService();

  DeviceRemoteDatasource(this.supabase);

  ////////////////////////////////////////////////////////////
  /// REALTIME SENSOR STREAM
  ////////////////////////////////////////////////////////////

  Stream<SensorReadingModel> subscribeToRealtimeReadings({
    required String pondId,
    required String deviceId,
  }) {
    return supabase
        .from('latest_readings')
        .stream(primaryKey: ['device_id', 'pond_id'])
        .eq('device_id', deviceId)
        .map((rows) {
          if (rows.isEmpty) {
            throw Exception('No realtime sensor data');
          }

          final row = rows.firstWhere(
            (item) =>
                item['device_id'] == deviceId && item['pond_id'] == pondId,
            orElse: () => rows.first,
          );

          return SensorReadingModel.fromJson(row);
        });
  }

  ////////////////////////////////////////////////////////////
  /// LATEST READING
  ////////////////////////////////////////////////////////////

  Future<SensorReadingModel?> getLatestReading({
    required String pondId,
    required String deviceId,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await supabase
          .from('latest_readings')
          .select()
          .eq('device_id', deviceId)
          .eq('pond_id', pondId)
          .maybeSingle();

      stopwatch.stop();

      _logger.performance(
        operation: 'getLatestReading',
        duration: stopwatch.elapsed,
      );

      if (response == null) {
        return null;
      }

      return SensorReadingModel.fromJson(response);
    } catch (e, st) {
      _logger.error(
        'Failed to fetch latest reading',
        tag: 'DATABASE',
        error: e,
        stackTrace: st,
      );

      return null;
    }
  }

  ////////////////////////////////////////////////////////////
  /// CHART READINGS
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> getChartReadings({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      late final List<Map<String, dynamic>> result;

      switch (range) {
        case ChartRange.hour:
          result = await _fetchHourlyReadings(pondId, deviceId);
          break;

        case ChartRange.day:
          result = await _fetchDailyReadings(pondId, deviceId);
          break;

        case ChartRange.week:
          result = await _fetchWeeklyReadings(pondId, deviceId);
          break;

        case ChartRange.month:
          result = await _fetchMonthlyReadings(pondId, deviceId);
          break;

        case ChartRange.year:
          result = await _fetchYearlyReadings(pondId, deviceId);
          break;
      }

      stopwatch.stop();

      _logger.performance(
        operation: 'chart_${range.name}',
        duration: stopwatch.elapsed,
      );

      return result;
    } catch (e, st) {
      _logger.error(
        'Chart analytics fetch failed',
        tag: 'ANALYTICS',
        error: e,
        stackTrace: st,
        data: {'range': range.name, 'deviceId': deviceId},
      );

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// HOUR
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> _fetchHourlyReadings(
    String pondId,
    String deviceId,
  ) async {
    final response = await supabase
        .from('hourly_stats')
        .select()
        .eq('pond_id', pondId)
        .not('temp_avg', 'is', null)
        .order('hour', ascending: true)
        .limit(24);

    print('HOURLY STATS => $response');
    return List<Map<String, dynamic>>.from(response);
  }
  ////////////////////////////////////////////////////////////
  /// DAY
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> _fetchDailyReadings(
    String pondId,
    String deviceId,
  ) async {
    final response = await supabase
        .from('daily_stats')
        .select()
        .eq('pond_id', pondId)
        .not('temp_avg', 'is', null)
        .order('day', ascending: true)
        .limit(30);

    print('DAILY STATS => $response');

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// WEEK
  ////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> _fetchWeeklyReadings(
    String pondId,
    String deviceId,
  ) async {
    final response = await supabase
        .from('weekly_stats')
        .select()
        .eq('pond_id', pondId)
        .not('temp_avg', 'is', null)
        .order('week', ascending: true)
        .limit(7);

    print('WEEKLY STATS => $response');

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// MONTH
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> _fetchMonthlyReadings(
    String pondId,
    String deviceId,
  ) async {
    final response = await supabase
        .from('monthly_stats')
        .select()
        .eq('pond_id', pondId)
        .not('temp_avg', 'is', null)
        .order('month', ascending: true)
        .limit(12);

    print('MONTHLY STATS => $response');

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// YEAR
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> _fetchYearlyReadings(
    String pondId,
    String deviceId,
  ) async {
    final response = await supabase
        .from('yearly_stats')
        .select()
        .eq('pond_id', pondId)
        .not('temp_avg', 'is', null)
        .order('year', ascending: true);

    print('YEARLY STATS => $response');

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// ALERT STREAM
  ////////////////////////////////////////////////////////////

  Stream<List<AlertModel>> subscribeToAlerts({
    required String pondId,
    required String deviceId,
  }) {
    return supabase
        .from('alerts')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .map((rows) => rows.map((e) => AlertModel.fromJson(e)).toList());
  }

  ////////////////////////////////////////////////////////////
  /// ALERTS
  ////////////////////////////////////////////////////////////

  Future<List<AlertModel>> getAlerts({
    required String pondId,
    required String deviceId,
    bool? resolved,
  }) async {
    try {
      print(
        '[DATASOURCE] Querying alerts - pondId=$pondId, deviceId=$deviceId, resolved=$resolved',
      );
      dynamic query = supabase
          .from('alerts')
          .select()
          .eq('device_id', deviceId);

      if (resolved != null) {
        query = query.eq('is_resolved', resolved);
      }

      final response = await query.order('created_at', ascending: false);
      print('[DATASOURCE] Raw response count: ${(response as List).length}');

      final result = response
          .map<AlertModel>((e) => AlertModel.fromJson(e))
          .toList();
      print('[DATASOURCE] Converted to ${result.length} AlertModels');

      return result;
    } catch (e, st) {
      print('[DATASOURCE] Error fetching alerts: $e');
      print(st);
      _logger.error(
        'Failed to fetch alerts',
        tag: 'ALERTS',
        error: e,
        stackTrace: st,
      );

      return [];
    }
  }

  ////////////////////////////////////////////////////////////
  /// RESOLVE ALERT
  ////////////////////////////////////////////////////////////

  Future<void> resolveAlert(String alertId) async {
    try {
      await supabase
          .from('alerts')
          .update({'is_resolved': true})
          .eq('id', alertId);

      _logger.info('Alert resolved', tag: 'ALERTS', data: {'alertId': alertId});
    } catch (e, st) {
      _logger.error(
        'Failed to resolve alert',
        tag: 'ALERTS',
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS STREAM
  ////////////////////////////////////////////////////////////

  Stream<DeviceStatusModel> subscribeToDeviceStatus(String deviceId) {
    return supabase
        .from('devices')
        .stream(primaryKey: ['device_id'])
        .eq('device_id', deviceId)
        .map((rows) {
          if (rows.isEmpty) {
            throw Exception('No device status');
          }

          final row = rows.first;

          return DeviceStatusModel(
            deviceId: row['device_id'],
            isOnline: row['is_online'] ?? false,
            lastSeen: row['last_seen'] != null
                ? DateTime.parse(row['last_seen'])
                : DateTime.now(),
          );
        });
  }

  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS
  ////////////////////////////////////////////////////////////

  Future<DeviceStatusModel?> getDeviceStatus(String deviceId) async {
    try {
      final response = await supabase
          .from('devices')
          .select()
          .eq('device_id', deviceId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return DeviceStatusModel(
        deviceId: response['device_id'],
        isOnline: response['is_online'] ?? false,
        lastSeen: response['last_seen'] != null
            ? DateTime.parse(response['last_seen'])
            : DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////
  /// DEVICES
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> getDevices(String pondId) async {
    try {
      final response = await supabase
          .from('devices')
          .select()
          .eq('pond_id', pondId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e, st) {
      _logger.error(
        'Failed to fetch devices',
        tag: 'DEVICES',
        error: e,
        stackTrace: st,
      );

      return [];
    }
  }

  ////////////////////////////////////////////////////////////
  /// ADD DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> addDevice({
    required String deviceId,
    required String pondId,
    required String userId,
  }) async {
    try {
      await supabase.from('devices').insert({
        'device_id': deviceId,
        'pond_id': pondId,
        'user_id': userId,
        'mac_address': 'AA:BB:CC:DD:EE:FF',
        'created_at': DateTime.now().toIso8601String(),
      });

      _logger.info(
        'Device added',
        tag: 'DEVICES',
        data: {'deviceId': deviceId},
      );
    } catch (e, st) {
      _logger.error(
        'Failed to add device',
        tag: 'DEVICES',
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// DELETE DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> deleteDevice(String deviceId) async {
    try {
      await supabase.from('devices').delete().eq('device_id', deviceId);

      _logger.info(
        'Device deleted',
        tag: 'DEVICES',
        data: {'deviceId': deviceId},
      );
    } catch (e, st) {
      _logger.error(
        'Failed to delete device',
        tag: 'DEVICES',
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS
  ////////////////////////////////////////////////////////////

  Future<List<AiInsightModel>> getAiInsights({
    required String pondId,
    required String deviceId,
  }) async {
    return [
      AiInsightModel(
        id: '1',
        pondId: pondId,
        deviceId: deviceId,
        type: AiInsightType.prediction,
        title: 'Oxygen Crash Risk',
        description: 'Dissolved oxygen levels are dropping rapidly.',
        confidence: 85,
        severity: AiInsightSeverity.high,
        recommendation: 'Check aeration system immediately.',
        timestamp: DateTime.now(),
      ),

      AiInsightModel(
        id: '2',
        pondId: pondId,
        deviceId: deviceId,
        type: AiInsightType.anomaly,
        title: 'pH Instability Detected',
        description: 'pH levels showing abnormal fluctuations.',
        confidence: 72,
        severity: AiInsightSeverity.medium,
        recommendation: 'Monitor pH levels closely.',
        timestamp: DateTime.now(),
      ),
    ];
  }
}
