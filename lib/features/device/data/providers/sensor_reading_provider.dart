import 'package:aquaguard/features/device/data/models/sensor_reading_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'device_remote_datasource_provider.dart';

part 'sensor_reading_provider.g.dart';

@riverpod
Future<SensorReadingModel?> sensorReadingProvider(
  SensorReadingProviderRef ref,
  String pondId,
  String deviceId,
) {
  final datasource = ref.watch(deviceRemoteDatasourceProvider);
  return datasource.getLatestReading(pondId: pondId, deviceId: deviceId);
}
