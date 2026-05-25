// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_datapoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TelemetryDataPointImpl _$$TelemetryDataPointImplFromJson(
  Map<String, dynamic> json,
) => _$TelemetryDataPointImpl(
  timestamp: DateTime.parse(json['timestamp'] as String),
  value: (json['value'] as num).toDouble(),
  avg: (json['avg'] as num?)?.toDouble() ?? 0.0,
  min: (json['min'] as num?)?.toDouble() ?? 0.0,
  max: (json['max'] as num?)?.toDouble() ?? 0.0,
  variance: (json['variance'] as num?)?.toDouble() ?? 0.0,
  anomalyScore: (json['anomalyScore'] as num?)?.toDouble() ?? 0.0,
  trendDirection: (json['trendDirection'] as num?)?.toInt() ?? 0,
  trendVelocity: (json['trendVelocity'] as num?)?.toDouble() ?? 0.0,
  confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
  withinSafeRange: json['withinSafeRange'] as bool? ?? true,
  safeMin: (json['safeMin'] as num?)?.toDouble() ?? 0.0,
  safeMax: (json['safeMax'] as num?)?.toDouble() ?? 100.0,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$TelemetryDataPointImplToJson(
  _$TelemetryDataPointImpl instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp.toIso8601String(),
  'value': instance.value,
  'avg': instance.avg,
  'min': instance.min,
  'max': instance.max,
  'variance': instance.variance,
  'anomalyScore': instance.anomalyScore,
  'trendDirection': instance.trendDirection,
  'trendVelocity': instance.trendVelocity,
  'confidence': instance.confidence,
  'withinSafeRange': instance.withinSafeRange,
  'safeMin': instance.safeMin,
  'safeMax': instance.safeMax,
  'metadata': instance.metadata,
};

_$TelemetrySeriesImpl _$$TelemetrySeriesImplFromJson(
  Map<String, dynamic> json,
) => _$TelemetrySeriesImpl(
  parameter: json['parameter'] as String,
  aggregation: json['aggregation'] as String,
  timeframe: json['timeframe'] as String,
  dataPoints: (json['dataPoints'] as List<dynamic>)
      .map((e) => TelemetryDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  seriesAvg: (json['seriesAvg'] as num).toDouble(),
  seriesMin: (json['seriesMin'] as num).toDouble(),
  seriesMax: (json['seriesMax'] as num).toDouble(),
  seriesVariance: (json['seriesVariance'] as num).toDouble(),
  totalAnomalies: (json['totalAnomalies'] as num?)?.toInt() ?? 0,
  anomalyDensity: (json['anomalyDensity'] as num?)?.toDouble() ?? 0.0,
  seriesConfidence: (json['seriesConfidence'] as num?)?.toDouble() ?? 1.0,
  lastUpdate: DateTime.parse(json['lastUpdate'] as String),
  isComplete: json['isComplete'] as bool? ?? true,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$TelemetrySeriesImplToJson(
  _$TelemetrySeriesImpl instance,
) => <String, dynamic>{
  'parameter': instance.parameter,
  'aggregation': instance.aggregation,
  'timeframe': instance.timeframe,
  'dataPoints': instance.dataPoints,
  'seriesAvg': instance.seriesAvg,
  'seriesMin': instance.seriesMin,
  'seriesMax': instance.seriesMax,
  'seriesVariance': instance.seriesVariance,
  'totalAnomalies': instance.totalAnomalies,
  'anomalyDensity': instance.anomalyDensity,
  'seriesConfidence': instance.seriesConfidence,
  'lastUpdate': instance.lastUpdate.toIso8601String(),
  'isComplete': instance.isComplete,
  'metadata': instance.metadata,
};
