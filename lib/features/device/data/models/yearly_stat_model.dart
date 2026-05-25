import 'package:freezed_annotation/freezed_annotation.dart';

part 'yearly_stat_model.freezed.dart';
part 'yearly_stat_model.g.dart';

@freezed
class YearlyStatModel with _$YearlyStatModel {
  const factory YearlyStatModel({
    required String pondId,
    required DateTime year,
    required double tempAvg,
    required double doAvg,
    required double phAvg,
    required double tempMin,
    required double tempMax,
    required double doMin,
    required double doMax,
    required double phMin,
    required double phMax,
  }) = _YearlyStatModel;

  factory YearlyStatModel.fromJson(Map<String, dynamic> json) =>
      _$YearlyStatModelFromJson(json);
}
