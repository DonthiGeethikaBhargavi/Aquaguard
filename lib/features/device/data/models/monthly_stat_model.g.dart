// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyStatModelImpl _$$MonthlyStatModelImplFromJson(
  Map<String, dynamic> json,
) => _$MonthlyStatModelImpl(
  pondId: json['pondId'] as String,
  deviceId: json['deviceId'] as String,
  month: DateTime.parse(json['month'] as String),
  tempAvg: (json['tempAvg'] as num).toDouble(),
  doAvg: (json['doAvg'] as num).toDouble(),
  phAvg: (json['phAvg'] as num).toDouble(),
  waterLevelAvg: (json['waterLevelAvg'] as num).toDouble(),
  tempMin: (json['tempMin'] as num).toDouble(),
  tempMax: (json['tempMax'] as num).toDouble(),
  doMin: (json['doMin'] as num).toDouble(),
  doMax: (json['doMax'] as num).toDouble(),
  phMin: (json['phMin'] as num).toDouble(),
  phMax: (json['phMax'] as num).toDouble(),
  waterLevelMin: (json['waterLevelMin'] as num).toDouble(),
  waterLevelMax: (json['waterLevelMax'] as num).toDouble(),
  anomalyCount: (json['anomalyCount'] as num).toInt(),
  alertCount: (json['alertCount'] as num).toInt(),
  tempVariance: (json['tempVariance'] as num?)?.toDouble() ?? 0.0,
  doVariance: (json['doVariance'] as num?)?.toDouble() ?? 0.0,
  phVariance: (json['phVariance'] as num?)?.toDouble() ?? 0.0,
  operationalConfidence:
      (json['operationalConfidence'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$MonthlyStatModelImplToJson(
  _$MonthlyStatModelImpl instance,
) => <String, dynamic>{
  'pondId': instance.pondId,
  'deviceId': instance.deviceId,
  'month': instance.month.toIso8601String(),
  'tempAvg': instance.tempAvg,
  'doAvg': instance.doAvg,
  'phAvg': instance.phAvg,
  'waterLevelAvg': instance.waterLevelAvg,
  'tempMin': instance.tempMin,
  'tempMax': instance.tempMax,
  'doMin': instance.doMin,
  'doMax': instance.doMax,
  'phMin': instance.phMin,
  'phMax': instance.phMax,
  'waterLevelMin': instance.waterLevelMin,
  'waterLevelMax': instance.waterLevelMax,
  'anomalyCount': instance.anomalyCount,
  'alertCount': instance.alertCount,
  'tempVariance': instance.tempVariance,
  'doVariance': instance.doVariance,
  'phVariance': instance.phVariance,
  'operationalConfidence': instance.operationalConfidence,
};
