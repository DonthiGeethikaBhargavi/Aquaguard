import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/analytics_repository_provider.dart';
import '../models/telemetry_point.dart';
import 'chart_range.dart';

part 'analytics_chart_provider.g.dart';

class AnalyticsChartRequest {
  final String pondId;
  final String deviceId;
  final ChartRange range;

  AnalyticsChartRequest({
    required this.pondId,
    required this.deviceId,
    required this.range,
  });
}

@riverpod
Future<List<TelemetryPoint>> analyticsChart(
  AnalyticsChartRef ref,
  AnalyticsChartRequest request,
) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final rows = await repository.getChartData(
    pondId: request.pondId,
    deviceId: request.deviceId,
    range: request.range,
  );

  return rows.map((row) => TelemetryPoint.fromMap(row, request.range)).toList();
}
