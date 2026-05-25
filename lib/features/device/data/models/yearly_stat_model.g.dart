// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$YearlyStatModelImpl _$$YearlyStatModelImplFromJson(
  Map<String, dynamic> json,
) => _$YearlyStatModelImpl(
  pondId: json['pondId'] as String,
  year: DateTime.parse(json['year'] as String),
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

Map<String, dynamic> _$$YearlyStatModelImplToJson(
  _$YearlyStatModelImpl instance,
) => <String, dynamic>{
  'pondId': instance.pondId,
  'year': instance.year.toIso8601String(),
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
