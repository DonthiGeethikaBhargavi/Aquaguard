import 'package:supabase_flutter/supabase_flutter.dart';

class AlertAnalyticsRemoteDatasource {
  final SupabaseClient supabase;

  AlertAnalyticsRemoteDatasource(this.supabase);

  ////////////////////////////////////////////////////////////
  /// OVERVIEW
  ////////////////////////////////////////////////////////////

  Future<Map<String, dynamic>> getOverview({required String pondId}) async {
    final response = await supabase
        .from('alerts_history')
        .select()
        .eq('pond_id', pondId);

    final critical = response
        .where((e) => e['alert_type'] == 'CRITICAL')
        .length;

    final warnings = response.where((e) => e['alert_type'] == 'WARNING').length;

    final resolved = response.where((e) => e['is_resolved'] == true).length;

    return {'critical': critical, 'warnings': warnings, 'resolved': resolved};
  }

  ////////////////////////////////////////////////////////////
  /// PARAMETER COUNTS
  ////////////////////////////////////////////////////////////

  Future<Map<String, int>> getParameterCounts({required String pondId}) async {
    final response = await supabase
        .from('alerts_history')
        .select('parameter')
        .eq('pond_id', pondId);

    final Map<String, int> counts = {};

    for (final row in response) {
      final parameter = row['parameter']?.toString() ?? 'unknown';

      counts[parameter] = (counts[parameter] ?? 0) + 1;
    }

    return counts;
  }

  ////////////////////////////////////////////////////////////
  /// TREND
  ////////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> getTrend({required String pondId}) async {
    final response = await supabase
        .from('alerts_history')
        .select('created_at, alert_type')
        .eq('pond_id', pondId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// MOST TRIGGERED
  ////////////////////////////////////////////////////////////

  Future<String> getMostTriggered({required String pondId}) async {
    final counts = await getParameterCounts(pondId: pondId);

    if (counts.isEmpty) {
      return 'None';
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  ////////////////////////////////////////////////////////////
  /// AVG RESOLUTION
  ////////////////////////////////////////////////////////////

  Future<String> getAverageResolutionTime({required String pondId}) async {
    final response = await supabase
        .from('alerts_history')
        .select('created_at, resolved_at')
        .eq('pond_id', pondId)
        .not('resolved_at', 'is', null);

    if (response.isEmpty) {
      return '0 min';
    }

    double totalMinutes = 0;

    for (final row in response) {
      final created = DateTime.parse(row['created_at']);

      final resolved = DateTime.parse(row['resolved_at']);

      totalMinutes += resolved.difference(created).inMinutes;
    }

    final avg = totalMinutes / response.length;

    return '${avg.round()} min';
  }
}
