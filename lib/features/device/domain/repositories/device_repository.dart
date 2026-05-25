import 'dart:async';

import 'device_repository_interface.dart';

import '../../presentation/providers/chart_range.dart';

import '../../data/datasource/device_remote_datasource.dart';

import '../../data/models/ai_insight_model.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/device_status_model.dart';
import '../../data/models/sensor_reading_model.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDatasource remoteDatasource;

  DeviceRepositoryImpl(this.remoteDatasource);

  ////////////////////////////////////////////////////////////
  /// CONSTANTS
  ////////////////////////////////////////////////////////////

  static const Duration _retryDelay = Duration(seconds: 3);

  // static const Duration _streamTimeout = Duration(seconds: 45);

  ////////////////////////////////////////////////////////////
  /// REALTIME SENSOR STREAM
  ////////////////////////////////////////////////////////////

  @override
  Stream<SensorReadingModel> subscribeToRealtimeReadings({
    required String pondId,
    required String deviceId,
  }) {
    return _resilientStream<SensorReadingModel>(
      () => remoteDatasource.subscribeToRealtimeReadings(
        pondId: pondId,
        deviceId: deviceId,
      ),
      streamName: 'sensor_readings',
    );
  }

  ////////////////////////////////////////////////////////////
  /// CHART READINGS
  ////////////////////////////////////////////////////////////

  @override
  Future<List<Map<String, dynamic>>> getChartReadings({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  }) async {
    try {
      final result = await remoteDatasource
          .getChartReadings(pondId: pondId, deviceId: deviceId, range: range)
          .timeout(const Duration(seconds: 12));

      result.sort((a, b) {
        final aTs = DateTime.tryParse(
          a['hour']?.toString() ??
              a['day']?.toString() ??
              a['week']?.toString() ??
              a['month']?.toString() ??
              a['year']?.toString() ??
              a['created_at']?.toString() ??
              '',
        );

        final bTs = DateTime.tryParse(
          b['hour']?.toString() ??
              b['day']?.toString() ??
              b['week']?.toString() ??
              b['month']?.toString() ??
              b['year']?.toString() ??
              b['created_at']?.toString() ??
              '',
        );

        if (aTs == null || bTs == null) {
          return 0;
        }

        return aTs.compareTo(bTs);
      });

      //////////////////////////////////////////////////////////
      /// REMOVE INVALID ZERO ROWS
      //////////////////////////////////////////////////////////

      final cleaned = result.where((row) {
        final temp =
            (row['temperature'] as num?)?.toDouble() ??
            (row['temp_avg'] as num?)?.toDouble();

        final ph =
            (row['ph'] as num?)?.toDouble() ??
            (row['ph_avg'] as num?)?.toDouble();

        final oxygen =
            (row['dissolved_oxygen'] as num?)?.toDouble() ??
            (row['do_avg'] as num?)?.toDouble();

        return (temp != null && temp > 0) ||
            (ph != null && ph > 0) ||
            (oxygen != null && oxygen > 0);
      }).toList();

      print('CLEANED CHART ROWS => $cleaned');

      return cleaned;
    } on TimeoutException {
      return [];
    } catch (e) {
      print('CHART ERROR => $e');
      return [];
    }
  }

  ////////////////////////////////////////////////////////////
  /// LATEST SENSOR READING
  ////////////////////////////////////////////////////////////

  @override
  Future<SensorReadingModel?> getLatestReading({
    required String pondId,
    required String deviceId,
  }) async {
    try {
      final result = await remoteDatasource
          .getLatestReading(pondId: pondId, deviceId: deviceId)
          .timeout(const Duration(seconds: 10));

      print('LATEST READING => $result');

      return result;
    } on TimeoutException catch (e) {
      print('LATEST READING TIMEOUT => $e');

      rethrow;
    } catch (e, st) {
      print('LATEST READING ERROR => $e');

      print(st);

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// ALERT STREAM
  ////////////////////////////////////////////////////////////

  @override
  Stream<List<AlertModel>> subscribeToAlerts({
    required String pondId,
    required String deviceId,
  }) {
    return _resilientStream<List<AlertModel>>(
      () => remoteDatasource.subscribeToAlerts(
        pondId: pondId,
        deviceId: deviceId,
      ),
      streamName: 'alerts',
    );
  }

  ////////////////////////////////////////////////////////////
  /// GET ALERTS
  ////////////////////////////////////////////////////////////

  @override
  Future<List<AlertModel>> getAlerts({
    required String pondId,
    required String deviceId,
    bool? resolved,
  }) async {
    try {
      print(
        '[REPOSITORY] Fetching alerts for pond=$pondId, device=$deviceId, resolved=$resolved',
      );
      final alerts = await remoteDatasource
          .getAlerts(pondId: pondId, deviceId: deviceId, resolved: resolved)
          .timeout(const Duration(seconds: 10));

      print('[REPOSITORY] Fetched ${alerts.length} alerts');
      alerts.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });

      return alerts;
    } on TimeoutException {
      print('[REPOSITORY] Get alerts timeout!');
      return [];
    } catch (e) {
      print('[REPOSITORY] Error fetching alerts: $e');
      return [];
    }
  }

  ////////////////////////////////////////////////////////////
  /// RESOLVE ALERT
  ////////////////////////////////////////////////////////////

  @override
  Future<void> resolveAlert(String alertId) async {
    try {
      await remoteDatasource
          .resolveAlert(alertId)
          .timeout(const Duration(seconds: 8));
    } on TimeoutException {
      throw Exception('Alert resolution timed out');
    } catch (_) {
      throw Exception('Failed to resolve alert');
    }
  }

  ////////////////////////////////////////////////////////////
  /// ACKNOWLEDGE ALERT
  ////////////////////////////////////////////////////////////

  @override
  Future<void> acknowledgeAlert({
    required String alertId,
    required String userId,
  }) async {
    try {
      await remoteDatasource
          .resolveAlert(alertId)
          .timeout(const Duration(seconds: 8));
    } on TimeoutException {
      throw Exception('Alert acknowledgement timed out');
    } catch (_) {
      throw Exception('Failed to acknowledge alert');
    }
  }

  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS
  ////////////////////////////////////////////////////////////

  @override
  Future<List<AiInsightModel>> getAiInsights({
    required String pondId,
    required String deviceId,
  }) async {
    try {
      final insights = await remoteDatasource
          .getAiInsights(pondId: pondId, deviceId: deviceId)
          .timeout(const Duration(seconds: 12));

      insights.sort((a, b) {
        return b.confidence.compareTo(a.confidence);
      });

      return insights;
    } on TimeoutException {
      return [];
    } catch (_) {
      return [];
    }
  }

  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS STREAM
  ////////////////////////////////////////////////////////////

  @override
  Stream<DeviceStatusModel> subscribeToDeviceStatus(String deviceId) {
    return _resilientStream<DeviceStatusModel>(
      () => remoteDatasource.subscribeToDeviceStatus(deviceId),
      streamName: 'device_status',
    );
  }

  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS
  ////////////////////////////////////////////////////////////

  @override
  Future<DeviceStatusModel?> getDeviceStatus(String deviceId) async {
    try {
      final result = await remoteDatasource
          .getDeviceStatus(deviceId)
          .timeout(const Duration(seconds: 10));

      print('DEVICE STATUS => $result');

      return result;
    } on TimeoutException catch (e) {
      print('DEVICE STATUS TIMEOUT => $e');

      rethrow;
    } catch (e, st) {
      print('DEVICE STATUS ERROR => $e');

      print(st);

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// ADD DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> addDevice({
    required String deviceId,
    String? deviceName,
    required String pondId,
    required String userId,
  }) async {
    throw UnimplementedError();
  }

  ////////////////////////////////////////////////////////////
  /// UPDATE DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> updateDevice({
    required String deviceId,
    required Map<String, dynamic> updates,
  }) async {
    throw UnimplementedError();
  }

  ////////////////////////////////////////////////////////////
  /// DELETE DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> deleteDevice(String deviceId) async {
    throw UnimplementedError();
  }

  ////////////////////////////////////////////////////////////
  /// GET DEVICES
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> getDevices() async {
    return [];
  }

  ////////////////////////////////////////////////////////////
  /// TELEMETRY SNAPSHOT
  ////////////////////////////////////////////////////////////

  Future<Map<String, dynamic>> getTelemetrySnapshot({
    required String pondId,
    required String deviceId,
  }) async {
    return {};
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  Future<void> dispose() async {}

  ////////////////////////////////////////////////////////////
  /// RESILIENT STREAM
  ////////////////////////////////////////////////////////////

  Stream<T> _resilientStream<T>(
    Stream<T> Function() streamFactory, {
    required String streamName,
  }) async* {
    while (true) {
      StreamSubscription<T>? subscription;

      final controller = StreamController<T>();

      try {
        subscription = streamFactory().listen(
          controller.add,
          onError: controller.addError,
          cancelOnError: false,
        );

        yield* controller.stream;
      } catch (_) {
        await Future.delayed(_retryDelay);
      } finally {
        await subscription?.cancel();

        await controller.close();
      }
    }
  }
}
