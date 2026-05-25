import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_stat_model.freezed.dart';
part 'weekly_stat_model.g.dart';

@freezed
class WeeklyStatModel with _$WeeklyStatModel {
  const factory WeeklyStatModel({
    required String pondId,
    required DateTime week,
    required double tempAvg,
    required double doAvg,
    required double phAvg,
    required double tempMin,
    required double tempMax,
    required double doMin,
    required double doMax,
    required double phMin,
    required double phMax,
  }) = _WeeklyStatModel;

  factory WeeklyStatModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyStatModelFromJson(json);
}
