import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/alerts_remote_datasource_provider.dart';

////////////////////////////////////////////////////////////
/// ACTIVE ALERTS
////////////////////////////////////////////////////////////

final activeAlertsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      pondId,
    ) async {
      final datasource = ref.watch(alertsRemoteDatasourceProvider);

      return datasource.getActiveAlerts(pondId: pondId);
    });

////////////////////////////////////////////////////////////
/// ALERT HISTORY
////////////////////////////////////////////////////////////

final alertHistoryProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      pondId,
    ) async {
      final datasource = ref.watch(alertsRemoteDatasourceProvider);

      return datasource.getAlertHistory(pondId: pondId);
    });

////////////////////////////////////////////////////////////
/// REALTIME ALERTS
////////////////////////////////////////////////////////////

final realtimeAlertsProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, pondId) {
      final datasource = ref.watch(alertsRemoteDatasourceProvider);

      return datasource.subscribeToAlerts(pondId: pondId);
    });

////////////////////////////////////////////////////////////
/// ALERT COUNTS
////////////////////////////////////////////////////////////

final alertCountsProvider = FutureProvider.family<Map<String, int>, String>((
  ref,
  pondId,
) async {
  final datasource = ref.watch(alertsRemoteDatasourceProvider);

  return datasource.getAlertCounts(pondId: pondId);
});
