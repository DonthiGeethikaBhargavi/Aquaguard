import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_stat_model.freezed.dart';
part 'monthly_stat_model.g.dart';

@freezed
class MonthlyStatModel with _$MonthlyStatModel {
  const factory MonthlyStatModel({
    required String pondId,
    required String deviceId,
    required DateTime month,
    required double tempAvg,
    required double doAvg,
    required double phAvg,
    required double waterLevelAvg,
    required double tempMin,
    required double tempMax,
    required double doMin,
    required double doMax,
    required double phMin,
    required double phMax,
    required double waterLevelMin,
    required double waterLevelMax,
    required int anomalyCount,
    required int alertCount,
    @Default(0.0) double tempVariance,
    @Default(0.0) double doVariance,
    @Default(0.0) double phVariance,
    @Default(0.0) double operationalConfidence,
  }) = _MonthlyStatModel;

  factory MonthlyStatModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatModelFromJson(json);
}
