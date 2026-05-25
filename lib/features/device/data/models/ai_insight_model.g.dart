// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_insight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiInsightModelImpl _$$AiInsightModelImplFromJson(Map<String, dynamic> json) =>
    _$AiInsightModelImpl(
      id: json['id'] as String,
      pondId: json['pondId'] as String,
      deviceId: json['deviceId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$AiInsightTypeEnumMap, json['type']),
      severity: $enumDecode(_$AiInsightSeverityEnumMap, json['severity']),
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      recommendation: json['recommendation'] as String?,
    );

Map<String, dynamic> _$$AiInsightModelImplToJson(
  _$AiInsightModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'pondId': instance.pondId,
  'deviceId': instance.deviceId,
  'title': instance.title,
  'description': instance.description,
  'type': _$AiInsightTypeEnumMap[instance.type]!,
  'severity': _$AiInsightSeverityEnumMap[instance.severity]!,
  'confidence': instance.confidence,
  'timestamp': instance.timestamp.toIso8601String(),
  'recommendation': instance.recommendation,
};

const _$AiInsightTypeEnumMap = {
  AiInsightType.prediction: 'prediction',
  AiInsightType.anomaly: 'anomaly',
  AiInsightType.recommendation: 'recommendation',
  AiInsightType.warning: 'warning',
};

const _$AiInsightSeverityEnumMap = {
  AiInsightSeverity.low: 'low',
  AiInsightSeverity.medium: 'medium',
  AiInsightSeverity.high: 'high',
  AiInsightSeverity.critical: 'critical',
};
