import 'package:freezed_annotation/freezed_annotation.dart';

part 'hourly_stat_model.freezed.dart';
part 'hourly_stat_model.g.dart';

@freezed
class HourlyStatModel with _$HourlyStatModel {
  const factory HourlyStatModel({
    required String pondId,
    required DateTime hour,
    required double tempAvg,
    required double doAvg,
    required double phAvg,
    required double tempMin,
    required double tempMax,
    required double doMin,
    required double doMax,
    required double phMin,
    required double phMax,
  }) = _HourlyStatModel;

  factory HourlyStatModel.fromJson(Map<String, dynamic> json) =>
      _$HourlyStatModelFromJson(json);
}
