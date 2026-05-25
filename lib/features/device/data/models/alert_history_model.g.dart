// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertHistoryModelImpl _$$AlertHistoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$AlertHistoryModelImpl(
  id: json['id'] as String,
  deviceId: json['deviceId'] as String,
  pondId: json['pondId'] as String,
  alertType: json['alertType'] as String,
  parameter: json['parameter'] as String,
  message: json['message'] as String,
  value: (json['value'] as num).toDouble(),
  isResolved: json['isResolved'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
  priority: json['priority'] as String,
  escalated: json['escalated'] as bool,
);

Map<String, dynamic> _$$AlertHistoryModelImplToJson(
  _$AlertHistoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'deviceId': instance.deviceId,
  'pondId': instance.pondId,
  'alertType': instance.alertType,
  'parameter': instance.parameter,
  'message': instance.message,
  'value': instance.value,
  'isResolved': instance.isResolved,
  'createdAt': instance.createdAt.toIso8601String(),
  'resolvedAt': instance.resolvedAt?.toIso8601String(),
  'priority': instance.priority,
  'escalated': instance.escalated,
};
