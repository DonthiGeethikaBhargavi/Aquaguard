import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/ai_insight_model.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/device_status_model.dart';
import '../../data/models/sensor_reading_model.dart';
import 'chart_range.dart';
import '../../data/providers/device_repository_provider.dart';
import 'package:flutter/foundation.dart';
part 'device_dashboard_provider.g.dart';

////////////////////////////////////////////////////////////
/// CONSTANTS
////////////////////////////////////////////////////////////

const _sensorTimeout = Duration(minutes: 2);

const _statusTimeout = Duration(minutes: 3);

const _sensorHealthInterval = Duration(seconds: 15);

const _statusHealthInterval = Duration(seconds: 20);

const _aiRefreshInterval = Duration(minutes: 3);

////////////////////////////////////////////////////////////
/// SELECTED RANGE
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class SelectedRange extends _$SelectedRange {
  @override
  ChartRange build() {
    return ChartRange.hour;
  }

  void change(ChartRange range) {
    if (state == range) {
      return;
    }

    state = range;
  }
}

////////////////////////////////////////////////////////////
/// LIVE SENSOR DATA
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class LiveSensorData extends _$LiveSensorData {
  StreamSubscription<SensorReadingModel>? _subscription;

  Timer? _healthTimer;

  DateTime? _lastEventTime;

  bool _disposed = false;

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  FutureOr<SensorReadingModel> build(String pondId, String deviceId) async {
    ref.onDispose(_dispose);

    final repo = ref.read(deviceRepositoryProvider);

    //////////////////////////////////////////////////////////
    /// FALLBACK MODEL
    //////////////////////////////////////////////////////////

    final fallback = SensorReadingModel(
      deviceId: deviceId,

      pondId: pondId,

      temperature: 0,

      dissolvedOxygen: 0,

      ph: 0,

      waterLevel: 0,

      lastUpdate: DateTime.now(),
    );

    //////////////////////////////////////////////////////////
    /// INITIAL LOAD
    //////////////////////////////////////////////////////////

    SensorReadingModel initial = fallback;

    try {
      final result = await repo.getLatestReading(
        pondId: pondId,
        deviceId: deviceId,
      );

      print('INITIAL SENSOR DATA => $result');

      ////////////////////////////////////////////////////////
      /// USE DATABASE VALUE
      ////////////////////////////////////////////////////////

      if (result != null) {
        initial = result;
      }

      ////////////////////////////////////////////////////////
      /// CACHE INITIAL VALUE
      ////////////////////////////////////////////////////////

      if (!_disposed) {
        _lastEventTime = DateTime.now();

        state = AsyncData(initial);
      }
    } catch (e) {
      print('INITIAL SENSOR ERROR => $e');

      ////////////////////////////////////////////////////////
      /// SAFE FALLBACK
      ////////////////////////////////////////////////////////

      if (!_disposed) {
        state = AsyncData(fallback);
      }
    }

    //////////////////////////////////////////////////////////
    /// SINGLE REALTIME SUBSCRIPTION
    //////////////////////////////////////////////////////////

    await _subscription?.cancel();

    _subscription = repo
        .subscribeToRealtimeReadings(pondId: pondId, deviceId: deviceId)
        .listen(
          _handleSensorEvent,
          onError: _handleSensorError,
          cancelOnError: false,
        );

    //////////////////////////////////////////////////////////
    /// HEALTH MONITOR
    //////////////////////////////////////////////////////////

    _startSensorHealthCheck();

    //////////////////////////////////////////////////////////
    /// RETURN INITIAL VALUE
    //////////////////////////////////////////////////////////

    return initial;
  }

  ////////////////////////////////////////////////////////////
  /// SENSOR EVENT
  ////////////////////////////////////////////////////////////

  void _handleSensorEvent(SensorReadingModel event) {
    if (_disposed) {
      return;
    }

    print('LIVE SENSOR EVENT => $event');

    _lastEventTime = DateTime.now();

    state = AsyncData(event);
  }

  ////////////////////////////////////////////////////////////
  /// SENSOR ERROR
  ////////////////////////////////////////////////////////////

  void _handleSensorError(Object error, StackTrace stackTrace) {
    if (_disposed) {
      return;
    }

    print('LIVE SENSOR ERROR => $error');

    //////////////////////////////////////////////////////////
    /// KEEP LAST KNOWN VALUES
    //////////////////////////////////////////////////////////

    if (state.hasValue) {
      return;
    }

    state = AsyncError(error, stackTrace);
  }

  ////////////////////////////////////////////////////////////
  /// HEALTH CHECK
  ////////////////////////////////////////////////////////////

  void _startSensorHealthCheck() {
    _healthTimer?.cancel();

    _healthTimer = Timer.periodic(_sensorHealthInterval, (_) {
      if (_disposed || _lastEventTime == null) {
        return;
      }

      final elapsed = DateTime.now().difference(_lastEventTime!);

      if (elapsed > _sensorTimeout) {
        print('SENSOR TIMEOUT DETECTED');
      }
    });
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  Future<void> _dispose() async {
    _disposed = true;

    _healthTimer?.cancel();

    await _subscription?.cancel();
  }
}

////////////////////////////////////////////////////////////
/// ALERTS
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class DeviceAlerts extends _$DeviceAlerts {
  StreamSubscription<List<AlertModel>>? _subscription;

  bool _disposed = false;

  @override
  FutureOr<List<AlertModel>> build(String pondId, String deviceId) async {
    ref.onDispose(_dispose);

    final repo = ref.read(deviceRepositoryProvider);

    final initial = await repo.getAlerts(pondId: pondId, deviceId: deviceId);

    await _subscription?.cancel();

    _subscription = repo
        .subscribeToAlerts(pondId: pondId, deviceId: deviceId)
        .listen(
          (alerts) {
            if (_disposed) {
              return;
            }

            state = AsyncData(alerts);
          },
          onError: (e, st) {
            if (_disposed) {
              return;
            }

            state = AsyncError(e, st);
          },
          cancelOnError: false,
        );

    return initial;
  }

  Future<void> resolveAlert(String alertId) async {
    final repo = ref.read(deviceRepositoryProvider);

    await repo.resolveAlert(alertId);

    if (_disposed) {
      return;
    }

    state = await AsyncValue.guard(
      () => repo.getAlerts(pondId: pondId, deviceId: deviceId),
    );
  }

  Future<void> _dispose() async {
    _disposed = true;

    await _subscription?.cancel();
  }
}

////////////////////////////////////////////////////////////
/// AI INSIGHTS
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class DeviceAiInsights extends _$DeviceAiInsights {
  Timer? _refreshTimer;

  bool _disposed = false;

  @override
  FutureOr<List<AiInsightModel>> build(String pondId, String deviceId) async {
    ref.onDispose(_dispose);

    final repo = ref.read(deviceRepositoryProvider);

    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(_aiRefreshInterval, (_) async {
      if (_disposed) {
        return;
      }

      try {
        final insights = await repo.getAiInsights(
          pondId: pondId,
          deviceId: deviceId,
        );

        if (!_disposed) {
          state = AsyncData(insights);
        }
      } catch (e, st) {
        if (!_disposed) {
          state = AsyncError(e, st);
        }
      }
    });

    return repo.getAiInsights(pondId: pondId, deviceId: deviceId);
  }

  void _dispose() {
    _disposed = true;

    _refreshTimer?.cancel();
  }
}

////////////////////////////////////////////////////////////
/// DEVICE STATUS
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class DeviceStatus extends _$DeviceStatus {
  StreamSubscription<DeviceStatusModel>? _subscription;

  Timer? _offlineTimer;

  DateTime? _lastHeartbeat;

  bool _disposed = false;

  @override
  FutureOr<DeviceStatusModel> build(String deviceId) async {
    ref.onDispose(_dispose);

    final repo = ref.read(deviceRepositoryProvider);

    //////////////////////////////////////////////////////////
    /// FALLBACK STATUS
    //////////////////////////////////////////////////////////

    final fallback = DeviceStatusModel(
      deviceId: deviceId,

      isOnline: false,

      lastSeen: DateTime.now(),

      batteryLevel: 0,
    );

    try {
      final result = await repo.getDeviceStatus(deviceId);

      print('INITIAL DEVICE STATUS => $result');

      final initial = result ?? fallback;

      if (!_disposed) {
        _lastHeartbeat = DateTime.now();

        state = AsyncData(initial);
      }

      await _subscription?.cancel();

      _subscription = repo
          .subscribeToDeviceStatus(deviceId)
          .listen(
            _handleStatusEvent,
            onError: _handleStatusError,
            cancelOnError: false,
          );

      _startOfflineMonitor();

      return initial;
    } catch (e) {
      print('DEVICE STATUS ERROR => $e');

      if (!_disposed) {
        state = AsyncData(fallback);
      }

      return fallback;
    }
  }

  void _handleStatusEvent(DeviceStatusModel event) {
    if (_disposed) {
      return;
    }

    print('LIVE DEVICE STATUS => $event');

    _lastHeartbeat = DateTime.now();

    state = AsyncData(event);
  }

  void _handleStatusError(Object error, StackTrace stackTrace) {
    if (_disposed) {
      return;
    }

    print('DEVICE STATUS STREAM ERROR => $error');

    if (state.hasValue) {
      return;
    }

    state = AsyncError(error, stackTrace);
  }

  void _startOfflineMonitor() {
    _offlineTimer?.cancel();

    _offlineTimer = Timer.periodic(_statusHealthInterval, (_) {
      if (_disposed || _lastHeartbeat == null) {
        return;
      }

      final elapsed = DateTime.now().difference(_lastHeartbeat!);

      if (elapsed > _statusTimeout) {
        print('DEVICE OFFLINE DETECTED');
      }
    });
  }

  Future<void> _dispose() async {
    _disposed = true;

    _offlineTimer?.cancel();

    await _subscription?.cancel();
  }
}
////////////////////////////////////////////////////////////
/// TELEMETRY CHART
////////////////////////////////////////////////////////////

@riverpod
Future<List<double>> telemetryChart(
  Ref ref,
  String pondId,
  String deviceId,
  dynamic range,
  String metric,
) async {
  final repo = ref.read(deviceRepositoryProvider);

  final chartRange = range is ChartRange ? range : ChartRange.hour;

  List<Map<String, dynamic>> rows = [];

  try {
    rows = await repo.getChartReadings(
      pondId: pondId,
      deviceId: deviceId,
      range: chartRange,
    );
  } catch (e) {
    debugPrint('CHART FETCH ERROR: $e');

    return [];
  }

  final values = <double>[];

  for (final row in rows) {
    double value = 0.0;

    //////////////////////////////////////////////////////////
    /// TEMPERATURE
    //////////////////////////////////////////////////////////

    if (metric == 'temperature') {
      value =
          (row['temperature'] as num?)?.toDouble() ??
          (row['temp_avg'] as num?)?.toDouble() ??
          0.0;
    }
    //////////////////////////////////////////////////////////
    /// PH
    //////////////////////////////////////////////////////////
    else if (metric == 'ph') {
      value =
          (row['ph'] as num?)?.toDouble() ??
          (row['ph_avg'] as num?)?.toDouble() ??
          0.0;
    }
    //////////////////////////////////////////////////////////
    /// DISSOLVED OXYGEN
    //////////////////////////////////////////////////////////
    else if (metric == 'do') {
      value =
          (row['dissolved_oxygen'] as num?)?.toDouble() ??
          (row['do_avg'] as num?)?.toDouble() ??
          0.0;
    }
    //////////////////////////////////////////////////////////
    /// WATER LEVEL
    //////////////////////////////////////////////////////////
    else if (metric == 'water_level') {
      value = (row['water_level'] as num?)?.toDouble() ?? 0.0;
    }

    //////////////////////////////////////////////////////////
    /// FILTER INVALID VALUES
    //////////////////////////////////////////////////////////

    if (value > 0) {
      values.add(value);
    }
  }

  return values;
}
