// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AlertModel {
  //////////////////////////////////////////////////////////
  /// IDS
  //////////////////////////////////////////////////////////
  String get id => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String get pondId =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// ALERT DETAILS
  //////////////////////////////////////////////////////////
  String get alertType => throw _privateConstructorUsedError;
  String get parameter => throw _privateConstructorUsedError;
  String get message =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// VALUE
  //////////////////////////////////////////////////////////
  double get value =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// RESOLUTION
  //////////////////////////////////////////////////////////
  bool get isResolved => throw _privateConstructorUsedError;
  bool get isRead =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// TIMESTAMPS
  //////////////////////////////////////////////////////////
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// PRIORITY
  //////////////////////////////////////////////////////////
  String get priority =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// ESCALATION
  //////////////////////////////////////////////////////////
  bool get escalated =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// TRACKING
  //////////////////////////////////////////////////////////
  DateTime? get firstSeen => throw _privateConstructorUsedError;
  DateTime? get lastSeen =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// GROUPING
  //////////////////////////////////////////////////////////
  String? get groupId =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// ACKNOWLEDGEMENT
  //////////////////////////////////////////////////////////
  String? get acknowledgedBy =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// NOTES
  //////////////////////////////////////////////////////////
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertModelCopyWith<AlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertModelCopyWith<$Res> {
  factory $AlertModelCopyWith(
    AlertModel value,
    $Res Function(AlertModel) then,
  ) = _$AlertModelCopyWithImpl<$Res, AlertModel>;
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
    bool isRead,
    DateTime createdAt,
    DateTime? resolvedAt,
    String priority,
    bool escalated,
    DateTime? firstSeen,
    DateTime? lastSeen,
    String? groupId,
    String? acknowledgedBy,
    String? notes,
  });
}

/// @nodoc
class _$AlertModelCopyWithImpl<$Res, $Val extends AlertModel>
    implements $AlertModelCopyWith<$Res> {
  _$AlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertModel
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
    Object? isRead = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? priority = null,
    Object? escalated = null,
    Object? firstSeen = freezed,
    Object? lastSeen = freezed,
    Object? groupId = freezed,
    Object? acknowledgedBy = freezed,
    Object? notes = freezed,
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
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
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
            firstSeen: freezed == firstSeen
                ? _value.firstSeen
                : firstSeen // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastSeen: freezed == lastSeen
                ? _value.lastSeen
                : lastSeen // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            acknowledgedBy: freezed == acknowledgedBy
                ? _value.acknowledgedBy
                : acknowledgedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertModelImplCopyWith<$Res>
    implements $AlertModelCopyWith<$Res> {
  factory _$$AlertModelImplCopyWith(
    _$AlertModelImpl value,
    $Res Function(_$AlertModelImpl) then,
  ) = __$$AlertModelImplCopyWithImpl<$Res>;
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
    bool isRead,
    DateTime createdAt,
    DateTime? resolvedAt,
    String priority,
    bool escalated,
    DateTime? firstSeen,
    DateTime? lastSeen,
    String? groupId,
    String? acknowledgedBy,
    String? notes,
  });
}

/// @nodoc
class __$$AlertModelImplCopyWithImpl<$Res>
    extends _$AlertModelCopyWithImpl<$Res, _$AlertModelImpl>
    implements _$$AlertModelImplCopyWith<$Res> {
  __$$AlertModelImplCopyWithImpl(
    _$AlertModelImpl _value,
    $Res Function(_$AlertModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertModel
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
    Object? isRead = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? priority = null,
    Object? escalated = null,
    Object? firstSeen = freezed,
    Object? lastSeen = freezed,
    Object? groupId = freezed,
    Object? acknowledgedBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$AlertModelImpl(
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
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
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
        firstSeen: freezed == firstSeen
            ? _value.firstSeen
            : firstSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastSeen: freezed == lastSeen
            ? _value.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        acknowledgedBy: freezed == acknowledgedBy
            ? _value.acknowledgedBy
            : acknowledgedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AlertModelImpl extends _AlertModel {
  const _$AlertModelImpl({
    required this.id,
    required this.deviceId,
    required this.pondId,
    required this.alertType,
    required this.parameter,
    required this.message,
    this.value = 0.0,
    this.isResolved = false,
    this.isRead = false,
    required this.createdAt,
    this.resolvedAt,
    this.priority = 'warning',
    this.escalated = false,
    this.firstSeen,
    this.lastSeen,
    this.groupId,
    this.acknowledgedBy,
    this.notes,
  }) : super._();

  //////////////////////////////////////////////////////////
  /// IDS
  //////////////////////////////////////////////////////////
  @override
  final String id;
  @override
  final String deviceId;
  @override
  final String pondId;
  //////////////////////////////////////////////////////////
  /// ALERT DETAILS
  //////////////////////////////////////////////////////////
  @override
  final String alertType;
  @override
  final String parameter;
  @override
  final String message;
  //////////////////////////////////////////////////////////
  /// VALUE
  //////////////////////////////////////////////////////////
  @override
  @JsonKey()
  final double value;
  //////////////////////////////////////////////////////////
  /// RESOLUTION
  //////////////////////////////////////////////////////////
  @override
  @JsonKey()
  final bool isResolved;
  @override
  @JsonKey()
  final bool isRead;
  //////////////////////////////////////////////////////////
  /// TIMESTAMPS
  //////////////////////////////////////////////////////////
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  //////////////////////////////////////////////////////////
  /// PRIORITY
  //////////////////////////////////////////////////////////
  @override
  @JsonKey()
  final String priority;
  //////////////////////////////////////////////////////////
  /// ESCALATION
  //////////////////////////////////////////////////////////
  @override
  @JsonKey()
  final bool escalated;
  //////////////////////////////////////////////////////////
  /// TRACKING
  //////////////////////////////////////////////////////////
  @override
  final DateTime? firstSeen;
  @override
  final DateTime? lastSeen;
  //////////////////////////////////////////////////////////
  /// GROUPING
  //////////////////////////////////////////////////////////
  @override
  final String? groupId;
  //////////////////////////////////////////////////////////
  /// ACKNOWLEDGEMENT
  //////////////////////////////////////////////////////////
  @override
  final String? acknowledgedBy;
  //////////////////////////////////////////////////////////
  /// NOTES
  //////////////////////////////////////////////////////////
  @override
  final String? notes;

  @override
  String toString() {
    return 'AlertModel(id: $id, deviceId: $deviceId, pondId: $pondId, alertType: $alertType, parameter: $parameter, message: $message, value: $value, isResolved: $isResolved, isRead: $isRead, createdAt: $createdAt, resolvedAt: $resolvedAt, priority: $priority, escalated: $escalated, firstSeen: $firstSeen, lastSeen: $lastSeen, groupId: $groupId, acknowledgedBy: $acknowledgedBy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertModelImpl &&
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
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.escalated, escalated) ||
                other.escalated == escalated) &&
            (identical(other.firstSeen, firstSeen) ||
                other.firstSeen == firstSeen) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.acknowledgedBy, acknowledgedBy) ||
                other.acknowledgedBy == acknowledgedBy) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

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
    isRead,
    createdAt,
    resolvedAt,
    priority,
    escalated,
    firstSeen,
    lastSeen,
    groupId,
    acknowledgedBy,
    notes,
  );

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertModelImplCopyWith<_$AlertModelImpl> get copyWith =>
      __$$AlertModelImplCopyWithImpl<_$AlertModelImpl>(this, _$identity);
}

abstract class _AlertModel extends AlertModel {
  const factory _AlertModel({
    required final String id,
    required final String deviceId,
    required final String pondId,
    required final String alertType,
    required final String parameter,
    required final String message,
    final double value,
    final bool isResolved,
    final bool isRead,
    required final DateTime createdAt,
    final DateTime? resolvedAt,
    final String priority,
    final bool escalated,
    final DateTime? firstSeen,
    final DateTime? lastSeen,
    final String? groupId,
    final String? acknowledgedBy,
    final String? notes,
  }) = _$AlertModelImpl;
  const _AlertModel._() : super._();

  //////////////////////////////////////////////////////////
  /// IDS
  //////////////////////////////////////////////////////////
  @override
  String get id;
  @override
  String get deviceId;
  @override
  String get pondId; //////////////////////////////////////////////////////////
  /// ALERT DETAILS
  //////////////////////////////////////////////////////////
  @override
  String get alertType;
  @override
  String get parameter;
  @override
  String get message; //////////////////////////////////////////////////////////
  /// VALUE
  //////////////////////////////////////////////////////////
  @override
  double get value; //////////////////////////////////////////////////////////
  /// RESOLUTION
  //////////////////////////////////////////////////////////
  @override
  bool get isResolved;
  @override
  bool get isRead; //////////////////////////////////////////////////////////
  /// TIMESTAMPS
  //////////////////////////////////////////////////////////
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt; //////////////////////////////////////////////////////////
  /// PRIORITY
  //////////////////////////////////////////////////////////
  @override
  String get priority; //////////////////////////////////////////////////////////
  /// ESCALATION
  //////////////////////////////////////////////////////////
  @override
  bool get escalated; //////////////////////////////////////////////////////////
  /// TRACKING
  //////////////////////////////////////////////////////////
  @override
  DateTime? get firstSeen;
  @override
  DateTime? get lastSeen; //////////////////////////////////////////////////////////
  /// GROUPING
  //////////////////////////////////////////////////////////
  @override
  String? get groupId; //////////////////////////////////////////////////////////
  /// ACKNOWLEDGEMENT
  //////////////////////////////////////////////////////////
  @override
  String? get acknowledgedBy; //////////////////////////////////////////////////////////
  /// NOTES
  //////////////////////////////////////////////////////////
  @override
  String? get notes;

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertModelImplCopyWith<_$AlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
