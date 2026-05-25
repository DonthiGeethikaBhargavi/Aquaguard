import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_history_model.freezed.dart';
part 'alert_history_model.g.dart';

@freezed
class AlertHistoryModel with _$AlertHistoryModel {
  const factory AlertHistoryModel({
    required String id,
    required String deviceId,
    required String pondId,
    required String alertType,
    required String parameter,
    required String message,
    required double value,
    required bool isResolved,
    required DateTime createdAt,
    DateTime? resolvedAt,
    required String priority,
    required bool escalated,
  }) = _AlertHistoryModel;

  factory AlertHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$AlertHistoryModelFromJson(json);
}
