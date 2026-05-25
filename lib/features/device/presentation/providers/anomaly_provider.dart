import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/anomaly_model.dart';

part 'anomaly_provider.g.dart';

@riverpod
Future<List<AnomalyModel>> anomalyDetection(
  AnomalyDetectionRef ref,
  String pondId,
) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('alerts')
      .select()
      .eq('pond_id', pondId)
      .eq('is_resolved', false)
      .order('created_at', ascending: false)
      .limit(6);

  return List<Map<String, dynamic>>.from(response).map((row) {
    final normalized = {
      ...row,
      'confidence': _estimateConfidence(row),
      'recommendation': _recommendationFromRow(row),
    };
    return AnomalyModel.fromMap(normalized);
  }).toList();
}

@riverpod
Stream<List<AnomalyModel>> anomalyTimeline(
  AnomalyTimelineRef ref,
  String pondId,
) async* {
  final supabase = Supabase.instance.client;

  final stream = supabase
      .from('alerts_history')
      .stream(primaryKey: ['id'])
      .eq('pond_id', pondId)
      .order('created_at', ascending: false);

  await for (final data in stream) {
    final rows = List<Map<String, dynamic>>.from(data);
    rows.sort((a, b) {
      final aTime =
          DateTime.tryParse(a['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bTime =
          DateTime.tryParse(b['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    yield rows.take(10).map((row) {
      return AnomalyModel.fromMap({
        ...row,
        'confidence': _estimateConfidence(row),
        'recommendation': _recommendationFromRow(row),
      });
    }).toList();
  }
}

String _recommendationFromRow(Map<String, dynamic> row) {
  final parameter = (row['parameter']?.toString() ?? '').toLowerCase();
  if (parameter.contains('oxygen')) {
    return 'Check aeration and circulation systems immediately.';
  }

  if (parameter.contains('temperature')) {
    return 'Verify heating or cooling and review recent weather changes.';
  }

  if (parameter.contains('ph')) {
    return 'Inspect buffering and feeding schedule for chemical balance.';
  }

  if (parameter.contains('water')) {
    return 'Inspect inlet valves and refill systems for steady volume.';
  }

  return 'Review the sensor health and alert details to validate the next action.';
}

double _estimateConfidence(Map<String, dynamic> row) {
  final alertType = row['alert_type']?.toString().toLowerCase() ?? '';
  if (alertType.contains('critical')) {
    return 92.0;
  }

  if (alertType.contains('warning')) {
    return 78.0;
  }

  return 66.0;
}
