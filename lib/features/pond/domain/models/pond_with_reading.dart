class PondWithReading {
  final String pondId;

  final String userId;

  final String pondName;

  ////////////////////////////////////////////////////////////
  /// DEVICE
  ////////////////////////////////////////////////////////////

  final String? deviceId;

  ////////////////////////////////////////////////////////////
  /// LOCATION
  ////////////////////////////////////////////////////////////

  final double? latitude;

  final double? longitude;

  ////////////////////////////////////////////////////////////
  /// SENSOR DATA
  ////////////////////////////////////////////////////////////

  final double? temperature;

  final double? minTemperature;

  final double? dissolvedOxygen;

  final double? minDo;

  final double? ph;

  final double? minPh;

  final double? waterLevel;

  final double? minWaterLevel;

  ////////////////////////////////////////////////////////////
  /// STATUS
  ////////////////////////////////////////////////////////////

  final DateTime? lastUpdate;

  ////////////////////////////////////////////////////////////
  /// CONSTRUCTOR
  ////////////////////////////////////////////////////////////

  const PondWithReading({
    required this.pondId,
    required this.userId,
    required this.pondName,
    this.deviceId,
    this.latitude,
    this.longitude,
    this.temperature,
    this.minTemperature,
    this.dissolvedOxygen,
    this.minDo,
    this.ph,
    this.minPh,
    this.waterLevel,
    this.minWaterLevel,
    this.lastUpdate,
  });

  ////////////////////////////////////////////////////////////
  /// SAFE DOUBLE PARSER
  ////////////////////////////////////////////////////////////

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }

  ////////////////////////////////////////////////////////////
  /// FROM JSON
  ////////////////////////////////////////////////////////////

  factory PondWithReading.fromJson(Map<String, dynamic> json) {
    return PondWithReading(
      pondId: json['pond_id']?.toString() ?? '',

      userId: json['user_id']?.toString() ?? '',

      pondName: json['pond_name']?.toString() ?? 'Unnamed Pond',

      ////////////////////////////////////////////////////////
      /// DEVICE
      ////////////////////////////////////////////////////////
      deviceId: json['device_id']?.toString(),

      ////////////////////////////////////////////////////////
      /// LOCATION
      ////////////////////////////////////////////////////////
      latitude: _toDouble(json['latitude']),

      longitude: _toDouble(json['longitude']),

      ////////////////////////////////////////////////////////
      /// SENSOR DATA
      ////////////////////////////////////////////////////////
      temperature: _toDouble(json['temperature']),

      minTemperature: _toDouble(json['min_temperature']),

      dissolvedOxygen: _toDouble(json['dissolved_oxygen']),

      minDo: _toDouble(json['min_do']),

      ph: _toDouble(json['ph']),

      minPh: _toDouble(json['min_ph']),

      waterLevel: _toDouble(json['water_level']),

      minWaterLevel: _toDouble(json['min_water_level']),

      ////////////////////////////////////////////////////////
      /// LAST UPDATE
      ////////////////////////////////////////////////////////
      lastUpdate: json['last_update'] != null
          ? DateTime.tryParse(json['last_update'].toString())
          : null,
    );
  }

  ////////////////////////////////////////////////////////////
  /// TO JSON
  ////////////////////////////////////////////////////////////

  Map<String, dynamic> toJson() {
    return {
      'pond_id': pondId,
      'user_id': userId,
      'pond_name': pondName,

      ////////////////////////////////////////////////////////
      /// DEVICE
      ////////////////////////////////////////////////////////
      'device_id': deviceId,

      ////////////////////////////////////////////////////////
      /// LOCATION
      ////////////////////////////////////////////////////////
      'latitude': latitude,
      'longitude': longitude,

      ////////////////////////////////////////////////////////
      /// SENSOR DATA
      ////////////////////////////////////////////////////////
      'temperature': temperature,
      'min_temperature': minTemperature,
      'dissolved_oxygen': dissolvedOxygen,
      'min_do': minDo,
      'ph': ph,
      'min_ph': minPh,
      'water_level': waterLevel,
      'min_water_level': minWaterLevel,

      ////////////////////////////////////////////////////////
      /// STATUS
      ////////////////////////////////////////////////////////
      'last_update': lastUpdate?.toIso8601String(),
    };
  }
}
