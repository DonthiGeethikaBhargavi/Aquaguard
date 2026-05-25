import '../../domain/models/pond_with_reading.dart';

class PondMapper {
  static PondWithReading fromJson(Map<String, dynamic> json) {
    return PondWithReading(
      pondId: json['pond_id'] as String,
      userId: json['user_id'] as String,
      pondName: json['pond_name'] as String,

      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),

      temperature: (json['temperature'] as num?)?.toDouble(),
      minTemperature: (json['min_temperature'] as num?)?.toDouble(),

      dissolvedOxygen: (json['dissolved_oxygen'] as num?)?.toDouble(),
      minDo: (json['min_do'] as num?)?.toDouble(),

      ph: (json['ph'] as num?)?.toDouble(),
      minPh: (json['min_ph'] as num?)?.toDouble(),

      waterLevel: (json['water_level'] as num?)?.toDouble(),
      minWaterLevel: (json['min_water_level'] as num?)?.toDouble(),

      lastUpdate: json['last_update'] != null
          ? DateTime.parse(json['last_update'])
          : null,
    );
  }
}
