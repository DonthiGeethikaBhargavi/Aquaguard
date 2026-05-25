// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlertHistoryModel _$AlertHistoryModelFromJson(Map<String, dynamic> json) {
  return _AlertHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$AlertHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String get pondId => throw _privateConstructorUsedError;
  String get alertType => throw _privateConstructorUsedError;
  String get parameter => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  bool get escalated => throw _privateConstructorUsedError;

  /// Serializes this AlertHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertHistoryModelCopyWith<AlertHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertHistoryModelCopyWith<$Res> {
  factory $AlertHistoryModelCopyWith(
    AlertHistoryModel value,
    $Res Function(AlertHistoryModel) then,
  ) = _$AlertHistoryModelCopyWithImpl<$Res, AlertHistoryModel>;
  @useResult
  $Res call({
    String id,
    String deviceId,
    String pondId,
    String alertType,
    String parameter,
    String message,
    double value,
    bool isResolved,
    DateTime createdAt,
    DateTime? resolvedAt,
    String priority,
    bool escalated,
  });
}

/// @nodoc
class _$AlertHistoryModelCopyWithImpl<$Res, $Val extends AlertHistoryModel>
    implements $AlertHistoryModelCopyWith<$Res> {
  _$AlertHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? pondId = null,
    Object? alertType = null,
    Object? parameter = null,
    Object? message = null,
    Object? value = null,
    Object? isResolved = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? priority = null,
    Object? escalated = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            pondId: null == pondId
                ? _value.pondId
                : pondId // ignore: cast_nullable_to_non_nullable
                      as String,
            alertType: null == alertType
                ? _value.alertType
                : alertType // ignore: cast_nullable_to_non_nullable
                      as String,
            parameter: null == parameter
                ? _value.parameter
                : parameter // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            isResolved: null == isResolved
                ? _value.isResolved
                : isResolved // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            escalated: null == escalated
                ? _value.escalated
                : escalated // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertHistoryModelImplCopyWith<$Res>
    implements $AlertHistoryModelCopyWith<$Res> {
  factory _$$AlertHistoryModelImplCopyWith(
    _$AlertHistoryModelImpl value,
    $Res Function(_$AlertHistoryModelImpl) then,
  ) = __$$AlertHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String deviceId,
    String pondId,
    String alertType,
    String parameter,
    String message,
    double value,
    bool isResolved,
    DateTime createdAt,
    DateTime? resolvedAt,
    String priority,
    bool escalated,
  });
}

/// @nodoc
class __$$AlertHistoryModelImplCopyWithImpl<$Res>
    extends _$AlertHistoryModelCopyWithImpl<$Res, _$AlertHistoryModelImpl>
    implements _$$AlertHistoryModelImplCopyWith<$Res> {
  __$$AlertHistoryModelImplCopyWithImpl(
    _$AlertHistoryModelImpl _value,
    $Res Function(_$AlertHistoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? pondId = null,
    Object? alertType = null,
    Object? parameter = null,
    Object? message = null,
    Object? value = null,
    Object? isResolved = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? priority = null,
    Object? escalated = null,
  }) {
    return _then(
      _$AlertHistoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        pondId: null == pondId
            ? _value.pondId
            : pondId // ignore: cast_nullable_to_non_nullable
                  as String,
        alertType: null == alertType
            ? _value.alertType
            : alertType // ignore: cast_nullable_to_non_nullable
                  as String,
        parameter: null == parameter
            ? _value.parameter
            : parameter // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        isResolved: null == isResolved
            ? _value.isResolved
            : isResolved // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        escalated: null == escalated
            ? _value.escalated
            : escalated // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertHistoryModelImpl implements _AlertHistoryModel {
  const _$AlertHistoryModelImpl({
    required this.id,
    required this.deviceId,
    required this.pondId,
    required this.alertType,
    required this.parameter,
    required this.message,
    required this.value,
    required this.isResolved,
    required this.createdAt,
    this.resolvedAt,
    required this.priority,
    required this.escalated,
  });

  factory _$AlertHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String deviceId;
  @override
  final String pondId;
  @override
  final String alertType;
  @override
  final String parameter;
  @override
  final String message;
  @override
  final double value;
  @override
  final bool isResolved;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String priority;
  @override
  final bool escalated;

  @override
  String toString() {
    return 'AlertHistoryModel(id: $id, deviceId: $deviceId, pondId: $pondId, alertType: $alertType, parameter: $parameter, message: $message, value: $value, isResolved: $isResolved, createdAt: $createdAt, resolvedAt: $resolvedAt, priority: $priority, escalated: $escalated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.pondId, pondId) || other.pondId == pondId) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.parameter, parameter) ||
                other.parameter == parameter) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.escalated, escalated) ||
                other.escalated == escalated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    deviceId,
    pondId,
    alertType,
    parameter,
    message,
    value,
    isResolved,
    createdAt,
    resolvedAt,
    priority,
    escalated,
  );

  /// Create a copy of AlertHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertHistoryModelImplCopyWith<_$AlertHistoryModelImpl> get copyWith =>
      __$$AlertHistoryModelImplCopyWithImpl<_$AlertHistoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertHistoryModelImplToJson(this);
  }
}

abstract class _AlertHistoryModel implements AlertHistoryModel {
  const factory _AlertHistoryModel({
    required final String id,
    required final String deviceId,
    required final String pondId,
    required final String alertType,
    required final String parameter,
    required final String message,
    required final double value,
    required final bool isResolved,
    required final DateTime createdAt,
    final DateTime? resolvedAt,
    required final String priority,
    required final bool escalated,
  }) = _$AlertHistoryModelImpl;

  factory _AlertHistoryModel.fromJson(Map<String, dynamic> json) =
      _$AlertHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get deviceId;
  @override
  String get pondId;
  @override
  String get alertType;
  @override
  String get parameter;
  @override
  String get message;
  @override
  double get value;
  @override
  bool get isResolved;
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt;
  @override
  String get priority;
  @override
  bool get escalated;

  /// Create a copy of AlertHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertHistoryModelImplCopyWith<_$AlertHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
