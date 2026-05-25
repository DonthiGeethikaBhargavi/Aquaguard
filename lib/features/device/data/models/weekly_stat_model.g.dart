// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyStatModelImpl _$$WeeklyStatModelImplFromJson(
  Map<String, dynamic> json,
) => _$WeeklyStatModelImpl(
  pondId: json['pondId'] as String,
  week: DateTime.parse(json['week'] as String),
  tempAvg: (json['tempAvg'] as num).toDouble(),
  doAvg: (json['doAvg'] as num).toDouble(),
  phAvg: (json['phAvg'] as num).toDouble(),
  tempMin: (json['tempMin'] as num).toDouble(),
  tempMax: (json['tempMax'] as num).toDouble(),
  doMin: (json['doMin'] as num).toDouble(),
  doMax: (json['doMax'] as num).toDouble(),
  phMin: (json['phMin'] as num).toDouble(),
  phMax: (json['phMax'] as num).toDouble(),
);

Map<String, dynamic> _$$WeeklyStatModelImplToJson(
  _$WeeklyStatModelImpl instance,
) => <String, dynamic>{
  'pondId': instance.pondId,
  'week': instance.week.toIso8601String(),
  'tempAvg': instance.tempAvg,
  'doAvg': instance.doAvg,
  'phAvg': instance.phAvg,
  'tempMin': instance.tempMin,
  'tempMax': instance.tempMax,
  'doMin': instance.doMin,
  'doMax': instance.doMax,
  'phMin': instance.phMin,
  'phMax': instance.phMax,
};
