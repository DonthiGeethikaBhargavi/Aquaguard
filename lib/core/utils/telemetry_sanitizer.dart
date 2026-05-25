////////////////////////////////////////////////////////////
/// ENTERPRISE TELEMETRY SANITIZATION LAYER
///
/// Centralized safe data validation for all analytics.
/// Prevents crashes from malformed Supabase payloads.
/// Handles int→double conversion, null values, NaN/Infinity.
///
/// CRITICAL: Never use unsafe casts. Always validate.
////////////////////////////////////////////////////////////

/// Convert raw value to safe double
///
/// Safely handles:
/// - int → double conversion
/// - String parsing
/// - null values
/// - NaN/Infinity rejection
/// - malformed data
double? safeDouble(dynamic value, {double? fallback}) {
  if (value == null) return fallback;

  try {
    double result;

    if (value is double) {
      result = value;
    } else if (value is int) {
      result = value.toDouble();
    } else if (value is num) {
      result = value.toDouble();
    } else if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed == null) return fallback;
      result = parsed;
    } else {
      return fallback;
    }

    // Reject infinite or NaN values
    if (!result.isFinite) return fallback;

    return result;
  } catch (_) {
    return fallback;
  }
}

/// Convert raw value to safe integer
///
/// Safely handles:
/// - double → int conversion (with rounding)
/// - String parsing
/// - null values
/// - out-of-range values
int? safeInt(dynamic value, {int? fallback}) {
  if (value == null) return fallback;

  try {
    int result;

    if (value is int) {
      result = value;
    } else if (value is double) {
      if (!value.isFinite) return fallback;
      result = value.round();
    } else if (value is num) {
      if (!value.isFinite) return fallback;
      result = value.toInt();
    } else if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed == null) return fallback;
      result = parsed;
    } else {
      return fallback;
    }

    return result;
  } catch (_) {
    return fallback;
  }
}

/// Convert raw value to safe string
///
/// Safely handles:
/// - null values
/// - toString() conversion
/// - empty string fallback
String safeString(dynamic value, {String fallback = '--'}) {
  if (value == null) return fallback;

  try {
    final str = value.toString();
    return str.isEmpty ? fallback : str;
  } catch (_) {
    return fallback;
  }
}

/// Parse ISO 8601 datetime safely
///
/// Safely handles:
/// - String parsing
/// - null values
/// - malformed ISO strings
/// - timezone handling
DateTime? safeDateTime(dynamic value) {
  if (value == null) return null;

  try {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.parse(value);
    }
    return null;
  } catch (_) {
    return null;
  }
}

/// Safe map extraction from dynamic
///
/// Prevents crashes when casting lists to maps
Map<String, dynamic> safeMap(dynamic value, {Map<String, dynamic>? fallback}) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    try {
      return Map<String, dynamic>.from(value);
    } catch (_) {
      return fallback ?? {};
    }
  }
  return fallback ?? {};
}

/// Safe list extraction from dynamic
///
/// Prevents crashes from type mismatches
List<T> safeList<T>(
  dynamic value,
  T Function(dynamic) converter, {
  List<T>? fallback,
}) {
  if (value == null) return fallback ?? [];

  try {
    if (value is List) {
      final result = <T>[];
      for (final item in value) {
        try {
          result.add(converter(item));
        } catch (_) {
          // Skip invalid items
        }
      }
      return result;
    }
    return fallback ?? [];
  } catch (_) {
    return fallback ?? [];
  }
}

/// Safe list extraction for maps
List<Map<String, dynamic>> safeListMap(
  dynamic value, {
  List<Map<String, dynamic>>? fallback,
}) {
  return safeList<Map<String, dynamic>>(
    value,
    (item) => safeMap(item),
    fallback: fallback,
  );
}

/// Validate numeric data for chart rendering
///
/// Ensures:
/// - finite values
/// - no NaN/Infinity
/// - valid timestamps
class TelemetryValidator {
  /// Check if value is safe for chart
  static bool isValidChartValue(double? value) {
    if (value == null) return false;
    if (!value.isFinite) return false;
    return true;
  }

  /// Validate entire dataset before rendering
  static bool isValidDataset(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return false;

    for (final item in data) {
      // Should have at least a timestamp
      if (!item.containsKey('created_at') && !item.containsKey('timestamp')) {
        return false;
      }
    }

    return true;
  }

  /// Validate telemetry reading
  static bool isValidReading(Map<String, dynamic> reading) {
    if (reading.isEmpty) return false;

    // Check for at least one valid numeric parameter
    final temp = safeDouble(reading['temperature']);
    final do_ = safeDouble(reading['dissolved_oxygen']);
    final ph = safeDouble(reading['ph']);
    final level = safeDouble(reading['water_level']);

    return temp != null || do_ != null || ph != null || level != null;
  }

  /// Sanitize dataset for chart rendering
  static List<Map<String, dynamic>> sanitizeDataset(
    List<Map<String, dynamic>> data,
  ) {
    final result = <Map<String, dynamic>>[];

    for (final item in data) {
      final map = safeMap(item);
      if (map.isEmpty) continue;

      // Ensure timestamp exists
      final timestamp = safeDateTime(map['created_at'] ?? map['timestamp']);
      if (timestamp == null) continue;

      // Sanitize numeric values
      final sanitized = <String, dynamic>{
        ...map,
        'created_at': timestamp.toIso8601String(),
        'temperature': safeDouble(map['temperature']),
        'dissolved_oxygen': safeDouble(map['dissolved_oxygen']),
        'ph': safeDouble(map['ph']),
        'water_level': safeDouble(map['water_level']),
        'turbidity': safeDouble(map['turbidity']),
        'salinity': safeDouble(map['salinity']),
        'ammonia': safeDouble(map['ammonia']),
      };

      result.add(sanitized);
    }

    return result;
  }
}

/// Compute statistics safely from telemetry data
class TelemetryStats {
  /// Calculate average of safe values
  static double? average(List<double?> values) {
    final validValues = values.whereType<double>().toList();
    if (validValues.isEmpty) return null;
    return validValues.reduce((a, b) => a + b) / validValues.length;
  }

  /// Calculate standard deviation
  static double? standardDeviation(List<double?> values) {
    final validValues = values.whereType<double>().toList();
    if (validValues.length < 2) return null;

    final avg = average(values);
    if (avg == null) return null;

    final variance =
        validValues.map((v) => (v - avg) * (v - avg)).reduce((a, b) => a + b) /
        validValues.length;

    // Calculate standard deviation using pow since sqrt() requires dart:math import
    // stdDev = sqrt(variance)
    final sqrtVariance = _calculateSqrt(variance.abs());
    if (!sqrtVariance.isFinite) return null;
    return sqrtVariance;
  }

  /// Calculate trend (acceleration)
  /// Returns: 0 = stable, >0 = increasing, <0 = decreasing
  static double? trend(List<double?> values) {
    final validValues = values.whereType<double>().toList();
    if (validValues.length < 3) return null;

    // Simple linear regression slope
    double sumX = 0;
    double sumY = 0;
    double sumXY = 0;
    double sumX2 = 0;

    for (int i = 0; i < validValues.length; i++) {
      final x = i.toDouble();
      final y = validValues[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }

    final n = validValues.length.toDouble();
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);

    if (!slope.isFinite) return null;
    return slope;
  }

  /// Calculate confidence in data quality
  /// Based on: consistency, recent updates, variance stability
  static int calculateConfidence({
    required List<double?> values,
    required DateTime? lastUpdate,
    required int consecutiveValid,
  }) {
    // Start at 50
    int confidence = 50;

    // Data consistency: +15 for good consistency
    final stdDev = standardDeviation(values);
    if (stdDev != null && stdDev < 5) {
      confidence += 15;
    }

    // Freshness: +20 if updated in last hour
    if (lastUpdate != null) {
      final age = DateTime.now().difference(lastUpdate).inMinutes;
      if (age < 60) {
        confidence += 20;
      } else if (age < 300) {
        confidence += 10;
      }
    }

    // Consecutive valid readings: +15
    if (consecutiveValid >= 10) {
      confidence += 15;
    }

    return confidence.clamp(0, 100);
  }

  /// Helper function to calculate square root
  /// Uses Newton's method to approximate sqrt(x)
  static double _calculateSqrt(double x) {
    if (x < 0) return double.nan;
    if (x == 0) return 0;

    // Newton's method: x_{n+1} = (x_n + x / x_n) / 2
    double guess = x / 2;
    double prevGuess = 0;

    while ((guess - prevGuess).abs() > 1e-10) {
      prevGuess = guess;
      guess = (guess + x / guess) / 2;
    }

    return guess;
  }
}
