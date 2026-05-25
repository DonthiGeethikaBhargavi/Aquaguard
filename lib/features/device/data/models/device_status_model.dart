import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_status_model.freezed.dart';

@freezed
class DeviceStatusModel with _$DeviceStatusModel {
  ////////////////////////////////////////////////////////////
  /// PRIVATE CONSTRUCTOR
  ////////////////////////////////////////////////////////////

  const DeviceStatusModel._();

  ////////////////////////////////////////////////////////////
  /// FACTORY
  ////////////////////////////////////////////////////////////

  const factory DeviceStatusModel({
    //////////////////////////////////////////////////////////
    /// DEVICE
    //////////////////////////////////////////////////////////
    required String deviceId,

    //////////////////////////////////////////////////////////
    /// STATUS
    //////////////////////////////////////////////////////////
    @Default(false) bool isOnline,

    //////////////////////////////////////////////////////////
    /// LAST SEEN
    //////////////////////////////////////////////////////////
    required DateTime lastSeen,

    //////////////////////////////////////////////////////////
    /// BATTERY
    //////////////////////////////////////////////////////////
    @Default(0.0) double batteryLevel,

    //////////////////////////////////////////////////////////
    /// SIGNAL
    //////////////////////////////////////////////////////////
    @Default(0) int signalStrength,

    //////////////////////////////////////////////////////////
    /// NETWORK
    //////////////////////////////////////////////////////////
    String? firmwareVersion,

    String? wifiSsid,

    String? ipAddress,

    //////////////////////////////////////////////////////////
    /// SYSTEM
    //////////////////////////////////////////////////////////
    int? uptimeSeconds,

    double? memoryUsage,

    double? cpuUsage,
  }) = _DeviceStatusModel;

  ////////////////////////////////////////////////////////////
  /// FROM JSON
  ////////////////////////////////////////////////////////////

  factory DeviceStatusModel.fromJson(Map<String, dynamic> json) {
    return DeviceStatusModel(
      deviceId: json['device_id']?.toString() ?? '',

      isOnline: json['is_online'] ?? false,

      lastSeen:
          DateTime.tryParse(json['last_seen']?.toString() ?? '') ??
          DateTime.now(),

      batteryLevel: (json['battery_level'] as num?)?.toDouble() ?? 0.0,

      signalStrength: (json['signal_strength'] as num?)?.toInt() ?? 0,

      firmwareVersion: json['firmware_version']?.toString(),

      wifiSsid: json['wifi_ssid']?.toString(),

      ipAddress: json['ip_address']?.toString(),

      uptimeSeconds: (json['uptime_seconds'] as num?)?.toInt(),

      memoryUsage: (json['memory_usage'] as num?)?.toDouble(),

      cpuUsage: (json['cpu_usage'] as num?)?.toDouble(),
    );
  }

  ////////////////////////////////////////////////////////////
  /// TO JSON
  ////////////////////////////////////////////////////////////

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,

      'is_online': isOnline,

      'last_seen': lastSeen.toIso8601String(),

      'battery_level': batteryLevel,

      'signal_strength': signalStrength,

      'firmware_version': firmwareVersion,

      'wifi_ssid': wifiSsid,

      'ip_address': ipAddress,

      'uptime_seconds': uptimeSeconds,

      'memory_usage': memoryUsage,

      'cpu_usage': cpuUsage,
    };
  }
}
