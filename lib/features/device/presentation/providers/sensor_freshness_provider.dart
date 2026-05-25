import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/device_remote_datasource_provider.dart';

part 'sensor_freshness_provider.g.dart';

////////////////////////////////////////////////////////////
/// SENSOR FRESHNESS STATE ENUM
////////////////////////////////////////////////////////////

enum SensorFreshnessState { live, delayed, offline }

////////////////////////////////////////////////////////////
/// SENSOR FRESHNESS RESULT
////////////////////////////////////////////////////////////

class SensorFreshnessResult {
  final SensorFreshnessState state;
  final String timeAgo;
  final int minutesOld;
  final DateTime? lastReadingTime;

  SensorFreshnessResult({
    required this.state,
    required this.timeAgo,
    required this.minutesOld,
    required this.lastReadingTime,
  });
}

////////////////////////////////////////////////////////////
/// SENSOR FRESHNESS PROVIDER
////////////////////////////////////////////////////////////

@riverpod
Future<SensorFreshnessResult> sensorFreshness(
  SensorFreshnessRef ref,
  String deviceId,
) async {
  final datasource = ref.watch(deviceRemoteDatasourceProvider);

  try {
    final supabase = datasource.supabase;

    // Query latest_readings table for most recent update
    final response = await supabase
        .from('latest_readings')
        .select('last_update')
        .eq('device_id', deviceId)
        .limit(1);

    if (response.isEmpty) {
      // No reading found, device offline
      return SensorFreshnessResult(
        state: SensorFreshnessState.offline,
        timeAgo: 'No data',
        minutesOld: 9999,
        lastReadingTime: null,
      );
    }

    final lastUpdateStr = response.first['last_update']?.toString();

    if (lastUpdateStr == null) {
      return SensorFreshnessResult(
        state: SensorFreshnessState.offline,
        timeAgo: 'No timestamp',
        minutesOld: 9999,
        lastReadingTime: null,
      );
    }

    final lastReadingTime = DateTime.tryParse(lastUpdateStr);

    if (lastReadingTime == null) {
      return SensorFreshnessResult(
        state: SensorFreshnessState.offline,
        timeAgo: 'Invalid timestamp',
        minutesOld: 9999,
        lastReadingTime: null,
      );
    }

    final now = DateTime.now();
    final minutesOld = now.difference(lastReadingTime).inMinutes;

    // Determine freshness state
    final state = _determineFreshnessState(minutesOld);

    // Generate human-readable time ago string
    final timeAgo = _formatTimeAgo(minutesOld);

    return SensorFreshnessResult(
      state: state,
      timeAgo: timeAgo,
      minutesOld: minutesOld,
      lastReadingTime: lastReadingTime,
    );
  } catch (e) {
    // Error querying, assume offline
    return SensorFreshnessResult(
      state: SensorFreshnessState.offline,
      timeAgo: 'Error',
      minutesOld: 9999,
      lastReadingTime: null,
    );
  }
}

////////////////////////////////////////////////////////////
/// HELPER FUNCTIONS
////////////////////////////////////////////////////////////

SensorFreshnessState _determineFreshnessState(int minutesOld) {
  if (minutesOld <= 2) return SensorFreshnessState.live;
  if (minutesOld <= 10) return SensorFreshnessState.delayed;
  return SensorFreshnessState.offline;
}

String _formatTimeAgo(int minutesOld) {
  if (minutesOld == 0) {
    return 'Just now';
  }

  if (minutesOld < 60) {
    return '${minutesOld}m ago';
  }

  final hoursOld = minutesOld ~/ 60;
  final remainingMinutes = minutesOld % 60;

  if (hoursOld == 1) {
    if (remainingMinutes == 0) {
      return '1h ago';
    }
    return '1h ${remainingMinutes}m ago';
  }

  if (remainingMinutes == 0) {
    return '${hoursOld}h ago';
  }

  return '${hoursOld}h ${remainingMinutes}m ago';
}
