class SensorReadingModel {
  ////////////////////////////////////////////////////////////
  /// IDS
  ////////////////////////////////////////////////////////////

  final String? deviceId;

  final String? pondId;

  ////////////////////////////////////////////////////////////
  /// WATER METRICS
  ////////////////////////////////////////////////////////////

  final double temperature;

  final double dissolvedOxygen;

  final double ph;

  final double waterLevel;

  ////////////////////////////////////////////////////////////
  /// OPTIONAL METRICS
  ////////////////////////////////////////////////////////////

  final double? turbidity;

  final double? salinity;

  final double? ammonia;

  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS
  ////////////////////////////////////////////////////////////

  final double? batteryLevel;

  final double? signalStrength;

  ////////////////////////////////////////////////////////////
  /// TIMESTAMP
  ////////////////////////////////////////////////////////////

  final DateTime? lastUpdate;

  ////////////////////////////////////////////////////////////
  /// CONSTRUCTOR
  ////////////////////////////////////////////////////////////

  const SensorReadingModel({
    this.deviceId,
    this.pondId,
    this.temperature = 0.0,
    this.dissolvedOxygen = 0.0,
    this.ph = 0.0,
    this.waterLevel = 0.0,
    this.turbidity,
    this.salinity,
    this.ammonia,
    this.batteryLevel,
    this.signalStrength,
    this.lastUpdate,
  });

  ////////////////////////////////////////////////////////////
  /// FROM JSON
  ////////////////////////////////////////////////////////////

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    return SensorReadingModel(
      deviceId: json['device_id']?.toString(),

      pondId: json['pond_id']?.toString(),

      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,

      dissolvedOxygen: (json['dissolved_oxygen'] as num?)?.toDouble() ?? 0.0,

      ph: (json['ph'] as num?)?.toDouble() ?? 0.0,

      waterLevel: (json['water_level'] as num?)?.toDouble() ?? 0.0,

      turbidity: (json['turbidity'] as num?)?.toDouble(),

      salinity: (json['salinity'] as num?)?.toDouble(),

      ammonia: (json['ammonia'] as num?)?.toDouble(),

      batteryLevel: (json['battery_level'] as num?)?.toDouble(),

      signalStrength: (json['signal_strength'] as num?)?.toDouble(),

      lastUpdate: json['last_update'] != null
          ? DateTime.tryParse(json['last_update'].toString())
          : (json['created_at'] != null
                ? DateTime.tryParse(json['created_at'].toString())
                : null),
    );
  }

  ////////////////////////////////////////////////////////////
  /// TO JSON
  ////////////////////////////////////////////////////////////

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,

      'pond_id': pondId,

      'temperature': temperature,

      'dissolved_oxygen': dissolvedOxygen,

      'ph': ph,

      'water_level': waterLevel,

      'turbidity': turbidity,

      'salinity': salinity,

      'ammonia': ammonia,

      'battery_level': batteryLevel,

      'signal_strength': signalStrength,

      'last_update': lastUpdate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
SensorReadingModel(
  temperature: $temperature,
  dissolvedOxygen: $dissolvedOxygen,
  ph: $ph,
  waterLevel: $waterLevel
)
''';
  }
}
