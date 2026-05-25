// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DeviceStatusModel {
  //////////////////////////////////////////////////////////
  /// DEVICE
  //////////////////////////////////////////////////////////
  String get deviceId =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// STATUS
  //////////////////////////////////////////////////////////
  bool get isOnline =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// LAST SEEN
  //////////////////////////////////////////////////////////
  DateTime get lastSeen =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// BATTERY
  //////////////////////////////////////////////////////////
  double get batteryLevel =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// SIGNAL
  //////////////////////////////////////////////////////////
  int get signalStrength =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// NETWORK
  //////////////////////////////////////////////////////////
  String? get firmwareVersion => throw _privateConstructorUsedError;
  String? get wifiSsid => throw _privateConstructorUsedError;
  String? get ipAddress =>
      throw _privateConstructorUsedError; //////////////////////////////////////////////////////////
  /// SYSTEM
  //////////////////////////////////////////////////////////
  int? get uptimeSeconds => throw _privateConstructorUsedError;
  double? get memoryUsage => throw _privateConstructorUsedError;
  double? get cpuUsage => throw _privateConstructorUsedError;

  /// Create a copy of DeviceStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceStatusModelCopyWith<DeviceStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceStatusModelCopyWith<$Res> {
  factory $DeviceStatusModelCopyWith(
    DeviceStatusModel value,
    $Res Function(DeviceStatusModel) then,
  ) = _$DeviceStatusModelCopyWithImpl<$Res, DeviceStatusModel>;
  @useResult
  $Res call({
    String deviceId,
    bool isOnline,
    DateTime lastSeen,
    double batteryLevel,
    int signalStrength,
    String? firmwareVersion,
    String? wifiSsid,
    String? ipAddress,
    int? uptimeSeconds,
    double? memoryUsage,
    double? cpuUsage,
  });
}

/// @nodoc
class _$DeviceStatusModelCopyWithImpl<$Res, $Val extends DeviceStatusModel>
    implements $DeviceStatusModelCopyWith<$Res> {
  _$DeviceStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? isOnline = null,
    Object? lastSeen = null,
    Object? batteryLevel = null,
    Object? signalStrength = null,
    Object? firmwareVersion = freezed,
    Object? wifiSsid = freezed,
    Object? ipAddress = freezed,
    Object? uptimeSeconds = freezed,
    Object? memoryUsage = freezed,
    Object? cpuUsage = freezed,
  }) {
    return _then(
      _value.copyWith(
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastSeen: null == lastSeen
                ? _value.lastSeen
                : lastSeen // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            batteryLevel: null == batteryLevel
                ? _value.batteryLevel
                : batteryLevel // ignore: cast_nullable_to_non_nullable
                      as double,
            signalStrength: null == signalStrength
                ? _value.signalStrength
                : signalStrength // ignore: cast_nullable_to_non_nullable
                      as int,
            firmwareVersion: freezed == firmwareVersion
                ? _value.firmwareVersion
                : firmwareVersion // ignore: cast_nullable_to_non_nullable
                      as String?,
            wifiSsid: freezed == wifiSsid
                ? _value.wifiSsid
                : wifiSsid // ignore: cast_nullable_to_non_nullable
                      as String?,
            ipAddress: freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            uptimeSeconds: freezed == uptimeSeconds
                ? _value.uptimeSeconds
                : uptimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            memoryUsage: freezed == memoryUsage
                ? _value.memoryUsage
                : memoryUsage // ignore: cast_nullable_to_non_nullable
                      as double?,
            cpuUsage: freezed == cpuUsage
                ? _value.cpuUsage
                : cpuUsage // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceStatusModelImplCopyWith<$Res>
    implements $DeviceStatusModelCopyWith<$Res> {
  factory _$$DeviceStatusModelImplCopyWith(
    _$DeviceStatusModelImpl value,
    $Res Function(_$DeviceStatusModelImpl) then,
  ) = __$$DeviceStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deviceId,
    bool isOnline,
    DateTime lastSeen,
    double batteryLevel,
    int signalStrength,
    String? firmwareVersion,
    String? wifiSsid,
    String? ipAddress,
    int? uptimeSeconds,
    double? memoryUsage,
    double? cpuUsage,
  });
}

/// @nodoc
class __$$DeviceStatusModelImplCopyWithImpl<$Res>
    extends _$DeviceStatusModelCopyWithImpl<$Res, _$DeviceStatusModelImpl>
    implements _$$DeviceStatusModelImplCopyWith<$Res> {
  __$$DeviceStatusModelImplCopyWithImpl(
    _$DeviceStatusModelImpl _value,
    $Res Function(_$DeviceStatusModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? isOnline = null,
    Object? lastSeen = null,
    Object? batteryLevel = null,
    Object? signalStrength = null,
    Object? firmwareVersion = freezed,
    Object? wifiSsid = freezed,
    Object? ipAddress = freezed,
    Object? uptimeSeconds = freezed,
    Object? memoryUsage = freezed,
    Object? cpuUsage = freezed,
  }) {
    return _then(
      _$DeviceStatusModelImpl(
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSeen: null == lastSeen
            ? _value.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        batteryLevel: null == batteryLevel
            ? _value.batteryLevel
            : batteryLevel // ignore: cast_nullable_to_non_nullable
                  as double,
        signalStrength: null == signalStrength
            ? _value.signalStrength
            : signalStrength // ignore: cast_nullable_to_non_nullable
                  as int,
        firmwareVersion: freezed == firmwareVersion
            ? _value.firmwareVersion
            : firmwareVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
        wifiSsid: freezed == wifiSsid
            ? _value.wifiSsid
            : wifiSsid // ignore: cast_nullable_to_non_nullable
                  as String?,
        ipAddress: freezed == ipAddress
            ? _value.ipAddress
            : ipAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        uptimeSeconds: freezed == uptimeSeconds
            ? _value.uptimeSeconds
            : uptimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        memoryUsage: freezed == memoryUsage
            ? _value.memoryUsage
            : memoryUsage // ignore: cast_nullable_to_non_nullable
                  as double?,
        cpuUsage: freezed == cpuUsage
            ? _value.cpuUsage
            : cpuUsage // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$DeviceStatusModelImpl extends _DeviceStatusModel {
  const _$DeviceStatusModelImpl({
    required this.deviceId,
    this.isOnline = false,
    required this.lastSeen,
    this.batteryLevel = 0.0,
    this.signalStrength = 0,
    this.firmwareVersion,
    this.wifiSsid,
    this.ipAddress,
    this.uptimeSeconds,
    this.memoryUsage,
    this.cpuUsage,
  }) : super._();

  //////////////////////////////////////////////////////////
  /// DEVICE
  //////////////////////////////////////////////////////////
  @override
  final String deviceId;
  //////////////////////////////////////////////////////////
  /// STATUS
  //////////////////////////////////////////////////////////
  @override
  @JsonKey()
  final bool isOnline;
  //////////////////////////////////////////////////////////
  /// LAST SEEN
  //////////////////////////////////////////////////////////
  @override
  final DateTime lastSeen;
  //////////////////////////////////////////////////////////
  /// BATTERY
  //////////////////////////////////////////////////////////
  @override
  @JsonKey()
  final double batteryLevel;
  //////////////////////////////////////////////////////////
  /// SIGNAL
  //////////////////////////////////////////////////////////
  @override
  @JsonKey()
  final int signalStrength;
  //////////////////////////////////////////////////////////
  /// NETWORK
  //////////////////////////////////////////////////////////
  @override
  final String? firmwareVersion;
  @override
  final String? wifiSsid;
  @override
  final String? ipAddress;
  //////////////////////////////////////////////////////////
  /// SYSTEM
  //////////////////////////////////////////////////////////
  @override
  final int? uptimeSeconds;
  @override
  final double? memoryUsage;
  @override
  final double? cpuUsage;

  @override
  String toString() {
    return 'DeviceStatusModel(deviceId: $deviceId, isOnline: $isOnline, lastSeen: $lastSeen, batteryLevel: $batteryLevel, signalStrength: $signalStrength, firmwareVersion: $firmwareVersion, wifiSsid: $wifiSsid, ipAddress: $ipAddress, uptimeSeconds: $uptimeSeconds, memoryUsage: $memoryUsage, cpuUsage: $cpuUsage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceStatusModelImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.signalStrength, signalStrength) ||
                other.signalStrength == signalStrength) &&
            (identical(other.firmwareVersion, firmwareVersion) ||
                other.firmwareVersion == firmwareVersion) &&
            (identical(other.wifiSsid, wifiSsid) ||
                other.wifiSsid == wifiSsid) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.uptimeSeconds, uptimeSeconds) ||
                other.uptimeSeconds == uptimeSeconds) &&
            (identical(other.memoryUsage, memoryUsage) ||
                other.memoryUsage == memoryUsage) &&
            (identical(other.cpuUsage, cpuUsage) ||
                other.cpuUsage == cpuUsage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    deviceId,
    isOnline,
    lastSeen,
    batteryLevel,
    signalStrength,
    firmwareVersion,
    wifiSsid,
    ipAddress,
    uptimeSeconds,
    memoryUsage,
    cpuUsage,
  );

  /// Create a copy of DeviceStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceStatusModelImplCopyWith<_$DeviceStatusModelImpl> get copyWith =>
      __$$DeviceStatusModelImplCopyWithImpl<_$DeviceStatusModelImpl>(
        this,
        _$identity,
      );
}

abstract class _DeviceStatusModel extends DeviceStatusModel {
  const factory _DeviceStatusModel({
    required final String deviceId,
    final bool isOnline,
    required final DateTime lastSeen,
    final double batteryLevel,
    final int signalStrength,
    final String? firmwareVersion,
    final String? wifiSsid,
    final String? ipAddress,
    final int? uptimeSeconds,
    final double? memoryUsage,
    final double? cpuUsage,
  }) = _$DeviceStatusModelImpl;
  const _DeviceStatusModel._() : super._();

  //////////////////////////////////////////////////////////
  /// DEVICE
  //////////////////////////////////////////////////////////
  @override
  String get deviceId; //////////////////////////////////////////////////////////
  /// STATUS
  //////////////////////////////////////////////////////////
  @override
  bool get isOnline; //////////////////////////////////////////////////////////
  /// LAST SEEN
  //////////////////////////////////////////////////////////
  @override
  DateTime get lastSeen; //////////////////////////////////////////////////////////
  /// BATTERY
  //////////////////////////////////////////////////////////
  @override
  double get batteryLevel; //////////////////////////////////////////////////////////
  /// SIGNAL
  //////////////////////////////////////////////////////////
  @override
  int get signalStrength; //////////////////////////////////////////////////////////
  /// NETWORK
  //////////////////////////////////////////////////////////
  @override
  String? get firmwareVersion;
  @override
  String? get wifiSsid;
  @override
  String? get ipAddress; //////////////////////////////////////////////////////////
  /// SYSTEM
  //////////////////////////////////////////////////////////
  @override
  int? get uptimeSeconds;
  @override
  double? get memoryUsage;
  @override
  double? get cpuUsage;

  /// Create a copy of DeviceStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceStatusModelImplCopyWith<_$DeviceStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
