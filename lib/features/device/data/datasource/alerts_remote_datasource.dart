import 'package:supabase_flutter/supabase_flutter.dart';

class AlertsRemoteDatasource {
  final SupabaseClient supabase;

  AlertsRemoteDatasource(this.supabase);

  ////////////////////////////////////////////////////////////
  /// ACTIVE ALERTS
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> getActiveAlerts({
    required String pondId,
  }) async {
    final response = await supabase
        .from('alerts')
        .select()
        .eq('pond_id', pondId)
        .eq('is_resolved', false)
        .order('priority', ascending: false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// ALERT HISTORY
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> getAlertHistory({
    required String pondId,
  }) async {
    final response = await supabase
        .from('alerts_history')
        .select()
        .eq('pond_id', pondId)
        .order('created_at', ascending: false)
        .limit(100);

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// RESOLVE ALERT
  ////////////////////////////////////////////////////////////

  Future<void> resolveAlert({required int alertId}) async {
    //////////////////////////////////////////////////////////
    /// GET CURRENT ALERT
    //////////////////////////////////////////////////////////

    final alert = await supabase
        .from('alerts')
        .select()
        .eq('id', alertId)
        .single();

    //////////////////////////////////////////////////////////
    /// UPDATE ACTIVE ALERT
    //////////////////////////////////////////////////////////

    await supabase
        .from('alerts')
        .update({
          'is_resolved': true,
          'resolved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', alertId);

    //////////////////////////////////////////////////////////
    /// INSERT HISTORY
    //////////////////////////////////////////////////////////

    await supabase.from('alerts_history').insert({
      ...alert,

      'is_resolved': true,

      'resolved_at': DateTime.now().toIso8601String(),
    });
  }

  ////////////////////////////////////////////////////////////
  /// REALTIME ALERT STREAM
  ////////////////////////////////////////////////////////////

  Stream<List<Map<String, dynamic>>> subscribeToAlerts({
    required String pondId,
  }) {
    return supabase
        .from('alerts')
        .stream(primaryKey: ['id'])
        .eq('pond_id', pondId)
        .map((rows) => rows.where((e) => e['is_resolved'] == false).toList());
  }

  ////////////////////////////////////////////////////////////
  /// ALERT COUNTS
  ////////////////////////////////////////////////////////////

  Future<Map<String, int>> getAlertCounts({required String pondId}) async {
    final active = await supabase
        .from('alerts')
        .select()
        .eq('pond_id', pondId)
        .eq('is_resolved', false);

    final history = await supabase
        .from('alerts_history')
        .select()
        .eq('pond_id', pondId);

    int critical = 0;

    int warning = 0;

    int resolved = history.length;

    for (final alert in active) {
      final type = alert['alert_type']?.toString().toLowerCase();

      if (type == 'critical') {
        critical++;
      } else {
        warning++;
      }
    }

    return {'critical': critical, 'warning': warning, 'resolved': resolved};
  }
}
