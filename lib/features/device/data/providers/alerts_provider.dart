import 'package:aquaguard/features/device/data/models/alert_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'device_remote_datasource_provider.dart';

part 'alerts_provider.g.dart';

@riverpod
Future<List<AlertModel>> alertsProvider(
  AlertsProviderRef ref,
  String pondId,
  String deviceId,
) {
  final datasource = ref.watch(deviceRemoteDatasourceProvider);
  return datasource.getAlerts(pondId: pondId, deviceId: deviceId);
}
