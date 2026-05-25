import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_insight_model.freezed.dart';
part 'ai_insight_model.g.dart';

@freezed
class AiInsightModel with _$AiInsightModel {
  const factory AiInsightModel({
    required String id,
    required String pondId,
    required String deviceId,
    required String title,
    required String description,
    required AiInsightType type,
    required AiInsightSeverity severity,
    required double confidence,
    required DateTime timestamp,
    String? recommendation,
  }) = _AiInsightModel;

  factory AiInsightModel.fromJson(Map<String, dynamic> json) =>
      _$AiInsightModelFromJson(json);
}

enum AiInsightType { prediction, anomaly, recommendation, warning }

enum AiInsightSeverity { low, medium, high, critical }
