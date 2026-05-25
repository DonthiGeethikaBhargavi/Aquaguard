import '../../presentation/providers/chart_range.dart';

class TelemetryPoint {
  final DateTime time;
  final double? temperature;
  final double? dissolvedOxygen;
  final double? ph;
  final double? waterLevel;
  final ChartRange range;

  TelemetryPoint({
    required this.time,
    this.temperature,
    this.dissolvedOxygen,
    this.ph,
    this.waterLevel,
    required this.range,
  });

  factory TelemetryPoint.fromMap(Map<String, dynamic> map, ChartRange range) {
    final timestamp = _parseTimestamp(map, range);

    return TelemetryPoint(
      time: timestamp,
      temperature: _toDouble(map['temp_avg']),
      dissolvedOxygen: _toDouble(map['do_avg']),
      ph: _toDouble(map['ph_avg']),
      waterLevel: _toDouble(map['water_level']),
      range: range,
    );
  }

  static DateTime _parseTimestamp(Map<String, dynamic> map, ChartRange range) {
    final raw = map[range.apiParam];

    if (raw == null) {
      return DateTime.now();
    }

    if (raw is DateTime) {
      return raw;
    }

    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }

    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) return parsed;
      final numeric = int.tryParse(raw);
      if (numeric != null) return DateTime.fromMillisecondsSinceEpoch(numeric);
    }

    return DateTime.now();
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
