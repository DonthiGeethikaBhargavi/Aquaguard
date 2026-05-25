import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/analytics_repository_provider.dart';
import '../models/prediction_model.dart';
import 'chart_range.dart';

part 'prediction_provider.g.dart';

class PredictionRequest {
  final String pondId;
  final String deviceId;
  final ChartRange range;

  PredictionRequest({
    required this.pondId,
    required this.deviceId,
    required this.range,
  });
}

@riverpod
Future<List<PredictionModel>> predictionEngine(
  PredictionEngineRef ref,
  PredictionRequest request,
) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final predictions = await repository.getPredictiveAlerts(
    pondId: request.pondId,
    deviceId: request.deviceId,
    range: request.range,
  );

  return predictions
      .map((item) => PredictionModel.fromMap(item))
      .take(5)
      .toList();
}
