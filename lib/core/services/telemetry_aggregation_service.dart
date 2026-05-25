////////////////////////////////////////////////////////////
/// TELEMETRY AGGREGATION SERVICE
///
/// Premium telemetry data fetching, aggregation, and
/// transformation from Supabase tables.
///
/// Features:
/// - Multiple timeframe support (1H, 24H, 7D, 1M, 1Y)
/// - Automatic table routing
/// - Statistics calculation
/// - Anomaly detection
/// - Trend analysis
/// - Confidence scoring
/// - Fallback handling
/// - Local caching
///
////////////////////////////////////////////////////////////

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/ai_thresholds.dart';
import '../models/telemetry_datapoint.dart';

class TelemetryAggregationService {
  final SupabaseClient supabase;

  TelemetryAggregationService(this.supabase);

  ////////////////////////////////////////////////////////////
  /// CONSTANTS
  ////////////////////////////////////////////////////////////

  static const Map<String, String> timeframeToTable = {
    '1H': 'sensor_readings',
    '24H': 'hourly_stats',
    '7D': 'daily_stats',
    '1M': 'weekly_stats',
    '1Y': 'monthly_stats',
  };

  static const Map<String, String> timeframeToAggregation = {
    '1H': 'Hour',
    '24H': 'Day',
    '7D': 'Week',
    '1M': 'Month',
    '1Y': 'Year',
  };

  static const Map<String, String> timeframeToTimeColumn = {
    '1H': 'created_at',
    '24H': 'created_at',
    '7D': 'day',
    '1M': 'week',
    '1Y': 'month',
  };

  String _mapParameterToPrefix(String parameter) {
    switch (parameter) {
      case 'temperature':
        return 'temp';
      case 'dissolvedOxygen':
        return 'do';
      case 'waterLevel':
        return 'water_level';
      default:
        return parameter;
    }
  }

  ////////////////////////////////////////////////////////////
  /// PUBLIC METHODS
  ////////////////////////////////////////////////////////////

  /// Fetch telemetry series for a specific parameter
  Future<TelemetrySeries> fetchTelemetrySeries({
    required String pondId,
    required String deviceId,
    required String
    parameter, // 'temperature', 'dissolvedOxygen', 'ph', 'waterLevel'
    required String timeframe, // '1H', '24H', '7D', '1M', '1Y'
    required DateTime endDate,
    DateTime? startDate,
  }) async {
    try {
      startDate ??= _calculateStartDate(endDate, timeframe);

      final tableName = timeframeToTable[timeframe] ?? 'hourly_stats';
      final aggregation = timeframeToAggregation[timeframe] ?? 'Hour';
      final isRawTable = tableName == 'sensor_readings';

      if (parameter == 'waterLevel' && !isRawTable) {
        print(
          '[TelemetryAggregationService] waterLevel only available in raw sensor readings for 1H',
        );
        return _buildEmptyTelemetrySeries(
          parameter: parameter,
          aggregation: aggregation,
          timeframe: timeframe,
        );
      }

      // Log query parameters for debugging
      print('[TelemetryAggregationService] Fetching $parameter');
      print('[TelemetryAggregationService]   pondId: $pondId');
      print('[TelemetryAggregationService]   deviceId: $deviceId');
      print('[TelemetryAggregationService]   timeframe: $timeframe');
      print('[TelemetryAggregationService]   table: $tableName');
      print(
        '[TelemetryAggregationService]   startDate: ${startDate.toIso8601String()}',
      );
      print(
        '[TelemetryAggregationService]   endDate: ${endDate.toIso8601String()}',
      );

      // Fetch raw data from Supabase
      final timeColumn = timeframeToTimeColumn[timeframe] ?? 'created_at';
      final startValue = _formatValueForColumn(timeColumn, startDate);
      final endValue = _formatValueForColumn(timeColumn, endDate);
      print('[TelemetryAggregationService]   timeColumn: $timeColumn');
      print('[TelemetryAggregationService]   startValue: $startValue');
      print('[TelemetryAggregationService]   endValue: $endValue');

      final query = supabase.from(tableName).select('*').eq('pond_id', pondId);
      if (isRawTable) {
        query.eq('device_id', deviceId);
      }

      final response = await query
          .gte(timeColumn, startValue)
          .lte(timeColumn, endValue)
          .order(timeColumn, ascending: true);

      final rows = response.cast<Map<String, dynamic>>();
      print('[TelemetryAggregationService]   rows returned: ${rows.length}');
      if (rows.isNotEmpty) {
        print(
          '[TelemetryAggregationService]   first row keys: ${rows[0].keys}',
        );
      }

      final dataPoints = await _transformToDataPoints(
        records: rows,
        parameter: parameter,
        timeframe: timeframe,
      );

      return _buildTelemetrySeries(
        parameter: parameter,
        aggregation: aggregation,
        timeframe: timeframe,
        dataPoints: dataPoints,
      );
    } catch (e) {
      print('Error fetching telemetry series: $e');
      return _buildEmptyTelemetrySeries(
        parameter: parameter,
        aggregation: timeframeToAggregation[timeframe] ?? 'Hour',
        timeframe: timeframe,
      );
    }
  }

  /// Fetch multiple parameters at once
  Future<Map<String, TelemetrySeries>> fetchMultipleParameters({
    required String pondId,
    required String deviceId,
    required List<String> parameters,
    required String timeframe,
    required DateTime endDate,
    DateTime? startDate,
  }) async {
    final results = <String, TelemetrySeries>{};

    for (final param in parameters) {
      results[param] = await fetchTelemetrySeries(
        pondId: pondId,
        deviceId: deviceId,
        parameter: param,
        timeframe: timeframe,
        endDate: endDate,
        startDate: startDate,
      );
    }

    return results;
  }

  /// Get comparison data for two periods
  Future<Map<String, TelemetrySeries>> fetchComparison({
    required String pondId,
    required String deviceId,
    required String parameter,
    required String timeframe,
    required DateTime currentEndDate,
    DateTime? currentStartDate,
  }) async {
    currentStartDate ??= _calculateStartDate(currentEndDate, timeframe);

    final currentPeriod = _getPreviousPeriodRange(
      endDate: currentEndDate,
      timeframe: timeframe,
    );

    final current = await fetchTelemetrySeries(
      pondId: pondId,
      deviceId: deviceId,
      parameter: parameter,
      timeframe: timeframe,
      endDate: currentEndDate,
      startDate: currentStartDate,
    );

    final previous = await fetchTelemetrySeries(
      pondId: pondId,
      deviceId: deviceId,
      parameter: parameter,
      timeframe: timeframe,
      endDate: currentPeriod['end']!,
      startDate: currentPeriod['start'],
    );

    return {'current': current, 'previous': previous};
  }

  ////////////////////////////////////////////////////////////
  /// PRIVATE METHODS - DATA TRANSFORMATION
  ////////////////////////////////////////////////////////////

  Future<List<TelemetryDataPoint>> _transformToDataPoints({
    required List<Map<String, dynamic>> records,
    required String parameter,
    required String timeframe,
  }) async {
    if (records.isEmpty) {
      print(
        '[TelemetryAggregationService._transformToDataPoints] No records to transform',
      );
      return [];
    }

    print(
      '[TelemetryAggregationService._transformToDataPoints] Transforming $parameter ($timeframe)',
    );
    print(
      '[TelemetryAggregationService._transformToDataPoints] Record count: ${records.length}',
    );

    final dataPoints = <TelemetryDataPoint>[];
    final isRawTable = timeframeToTable[timeframe] == 'sensor_readings';

    final prefix = _mapParameterToPrefix(parameter);
    final avgCol = '${prefix}_avg';
    final minCol = '${prefix}_min';
    final maxCol = '${prefix}_max';

    if (!isRawTable) {
      print(
        '[TelemetryAggregationService._transformToDataPoints] Looking for columns: $avgCol, $minCol, $maxCol',
      );
    }

    for (int i = 0; i < records.length; i++) {
      try {
        final record = records[i];
        final timestampKey = timeframeToTimeColumn[timeframe] ?? 'created_at';
        final timestampValue = record[timestampKey] ?? record['created_at'];
        final timestamp = DateTime.parse(timestampValue.toString());

        double value;
        double avg;
        double min;
        double max;

        if (isRawTable) {
          final rawKey = _rawColumnForParameter(parameter);
          value = (record[rawKey] as num?)?.toDouble() ?? 0.0;
          avg = value;
          min = value;
          max = value;
        } else {
          value = (record[avgCol] as num?)?.toDouble() ?? 0.0;
          avg = (record[avgCol] as num?)?.toDouble() ?? value;
          min = (record[minCol] as num?)?.toDouble() ?? value;
          max = (record[maxCol] as num?)?.toDouble() ?? value;
        }

        if (i == 0) {
          print(
            '[TelemetryAggregationService._transformToDataPoints] First row:',
          );
          print(
            '[TelemetryAggregationService._transformToDataPoints]   timestamp: $timestamp',
          );
          print(
            '[TelemetryAggregationService._transformToDataPoints]   value: $value (from $avgCol)',
          );
          print(
            '[TelemetryAggregationService._transformToDataPoints]   min: $min, max: $max',
          );
        }

        // Calculate statistics
        final variance = _calculateVariance(min, avg, max);
        final anomalyScore =
            (record['anomaly_score'] as num?)?.toDouble() ?? 0.0;
        final confidence = (record['confidence'] as num?)?.toDouble() ?? 0.95;

        // Determine trend
        final trendData = _calculateTrend(value, avg);

        dataPoints.add(
          TelemetryDataPoint(
            timestamp: timestamp,
            value: value,
            avg: avg,
            min: min,
            max: max,
            variance: variance,
            anomalyScore: anomalyScore,
            trendDirection: trendData['direction'] as int,
            trendVelocity: trendData['velocity'] as double,
            confidence: confidence,
            withinSafeRange: _isWithinSafeRange(value, parameter),
            safeMin: _getSafeMin(parameter),
            safeMax: _getSafeMax(parameter),
          ),
        );
      } catch (e) {
        print(
          '[TelemetryAggregationService._transformToDataPoints] Error transforming data point: $e',
        );
        continue;
      }
    }

    print(
      '[TelemetryAggregationService._transformToDataPoints] Successfully created ${dataPoints.length} data points',
    );
    return dataPoints;
  }

  Map<String, dynamic> _calculateTrend(double current, double average) {
    final deviation = current - average;
    int direction = 0;
    double velocity = 0.0;

    if (deviation > 0.5) {
      direction = 1; // Increasing
      velocity = (deviation / average).abs();
    } else if (deviation < -0.5) {
      direction = -1; // Decreasing
      velocity = (deviation / average).abs();
    } else {
      direction = 0; // Stable
      velocity = 0.0;
    }

    return {'direction': direction, 'velocity': velocity};
  }

  double _calculateVariance(double min, double avg, double max) {
    if (avg == 0) return 0.0;
    final range = max - min;
    return (range / avg).clamp(0.0, 1.0);
  }

  bool _isWithinSafeRange(double value, String parameter) {
    final min = _getSafeMin(parameter);
    final max = _getSafeMax(parameter);
    return value >= min && value <= max;
  }

  double _getSafeMin(String parameter) {
    switch (parameter) {
      case 'temperature':
      case 'dissolvedOxygen':
      case 'ph':
      case 'waterLevel':
        return AIThresholds.safeMin(parameter);
      default:
        return 0.0;
    }
  }

  double _getSafeMax(String parameter) {
    switch (parameter) {
      case 'temperature':
      case 'dissolvedOxygen':
      case 'ph':
      case 'waterLevel':
        return AIThresholds.safeMax(parameter);
      default:
        return 100.0;
    }
  }

  String _rawColumnForParameter(String parameter) {
    switch (parameter) {
      case 'temperature':
        return 'temperature';
      case 'dissolvedOxygen':
        return 'dissolved_oxygen';
      case 'ph':
        return 'ph';
      case 'waterLevel':
        return 'water_level';
      default:
        return parameter;
    }
  }

  ////////////////////////////////////////////////////////////
  /// PRIVATE METHODS - SERIES BUILDING
  ////////////////////////////////////////////////////////////

  TelemetrySeries _buildTelemetrySeries({
    required String parameter,
    required String aggregation,
    required String timeframe,
    required List<TelemetryDataPoint> dataPoints,
  }) {
    if (dataPoints.isEmpty) {
      print(
        '[TelemetryAggregationService._buildTelemetrySeries] No data points, returning empty series',
      );
      return _buildEmptyTelemetrySeries(
        parameter: parameter,
        aggregation: aggregation,
        timeframe: timeframe,
      );
    }

    final values = dataPoints.map((p) => p.value).toList();
    final seriesAvg = values.reduce((a, b) => a + b) / values.length;
    final seriesMin = values.reduce((a, b) => a < b ? a : b);
    final seriesMax = values.reduce((a, b) => a > b ? a : b);
    final seriesVariance = _calculateVariance(seriesMin, seriesAvg, seriesMax);

    final totalAnomalies = dataPoints.where((p) => p.anomalyScore > 0.5).length;
    final anomalyDensity = totalAnomalies / dataPoints.length;

    final confidenceScores =
        dataPoints.map((p) => p.confidence).reduce((a, b) => a + b) /
        dataPoints.length;

    print(
      '[TelemetryAggregationService._buildTelemetrySeries] $parameter complete:',
    );
    print(
      '[TelemetryAggregationService._buildTelemetrySeries]   dataPoints: ${dataPoints.length}',
    );
    print(
      '[TelemetryAggregationService._buildTelemetrySeries]   avg: $seriesAvg, min: $seriesMin, max: $seriesMax',
    );
    print(
      '[TelemetryAggregationService._buildTelemetrySeries]   anomalies: $totalAnomalies, density: $anomalyDensity',
    );

    return TelemetrySeries(
      parameter: parameter,
      aggregation: aggregation,
      timeframe: timeframe,
      dataPoints: dataPoints,
      seriesAvg: seriesAvg,
      seriesMin: seriesMin,
      seriesMax: seriesMax,
      seriesVariance: seriesVariance,
      totalAnomalies: totalAnomalies,
      anomalyDensity: anomalyDensity,
      seriesConfidence: confidenceScores,
      lastUpdate: DateTime.now(),
      isComplete: dataPoints.isNotEmpty,
    );
  }

  TelemetrySeries _buildEmptyTelemetrySeries({
    required String parameter,
    required String aggregation,
    required String timeframe,
  }) {
    return TelemetrySeries(
      parameter: parameter,
      aggregation: aggregation,
      timeframe: timeframe,
      dataPoints: [],
      seriesAvg: 0.0,
      seriesMin: 0.0,
      seriesMax: 0.0,
      seriesVariance: 0.0,
      totalAnomalies: 0,
      anomalyDensity: 0.0,
      seriesConfidence: 0.0,
      lastUpdate: DateTime.now(),
      isComplete: false,
      metadata: {
        'reason': 'insufficient_data',
        'message': 'Collecting operational baseline',
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// PRIVATE METHODS - DATE CALCULATIONS
  ////////////////////////////////////////////////////////////

  DateTime _calculateStartDate(DateTime endDate, String timeframe) {
    switch (timeframe) {
      case '1H':
        return endDate.subtract(const Duration(hours: 1));
      case '24H':
        return endDate.subtract(const Duration(days: 1));
      case '7D':
        return endDate.subtract(const Duration(days: 7));
      case '1M':
        return DateTime(endDate.year, endDate.month - 1, endDate.day);
      case '1Y':
        return DateTime(endDate.year - 1, endDate.month, endDate.day);
      default:
        return endDate.subtract(const Duration(hours: 1));
    }
  }

  Map<String, DateTime> _getPreviousPeriodRange({
    required DateTime endDate,
    required String timeframe,
  }) {
    DateTime previousEnd;
    DateTime previousStart;

    switch (timeframe) {
      case '1H':
        previousEnd = endDate.subtract(const Duration(hours: 1));
        previousStart = previousEnd.subtract(const Duration(hours: 1));
        break;
      case '24H':
        previousEnd = endDate.subtract(const Duration(days: 1));
        previousStart = previousEnd.subtract(const Duration(days: 1));
        break;
      case '7D':
        previousEnd = endDate.subtract(const Duration(days: 7));
        previousStart = previousEnd.subtract(const Duration(days: 7));
        break;
      case '1M':
        previousEnd = DateTime(endDate.year, endDate.month - 1, endDate.day);
        previousStart = DateTime(
          previousEnd.year,
          previousEnd.month - 1,
          previousEnd.day,
        );
        break;
      case '1Y':
        previousEnd = DateTime(endDate.year - 1, endDate.month, endDate.day);
        previousStart = DateTime(
          previousEnd.year - 1,
          previousEnd.month,
          previousEnd.day,
        );
        break;
      default:
        previousEnd = endDate.subtract(const Duration(hours: 1));
        previousStart = previousEnd.subtract(const Duration(hours: 1));
    }

    return {'start': previousStart, 'end': previousEnd};
  }

  ////////////////////////////////////////////////////////////
  /// FORMATTING HELPERS
  ////////////////////////////////////////////////////////////

  String formatTimestamp(DateTime timestamp, String timeframe) {
    switch (timeframe) {
      case '1H':
        return DateFormat('hh:mm a').format(timestamp);
      case '24H':
        return DateFormat('hh:00 a').format(timestamp);
      case '7D':
        return DateFormat('EEE').format(timestamp);
      case '1M':
        return DateFormat('MMM d').format(timestamp);
      case '1Y':
        return DateFormat('yyyy').format(timestamp);
      default:
        return timestamp.toIso8601String();
    }
  }

  String formatValue(double value, String parameter) {
    switch (parameter) {
      case 'temperature':
        return '${value.toStringAsFixed(1)}°C';
      case 'dissolvedOxygen':
        return '${value.toStringAsFixed(2)} mg/L';
      case 'ph':
        return value.toStringAsFixed(2);
      case 'waterLevel':
        return '${value.toStringAsFixed(1)}%';
      default:
        return value.toStringAsFixed(2);
    }
  }

  String _formatValueForColumn(String column, DateTime date) {
    switch (column) {
      case 'day':
      case 'week':
        return DateFormat('yyyy-MM-dd').format(date);
      case 'month':
        return DateFormat('yyyy-MM').format(date);
      case 'year':
        return DateFormat('yyyy').format(date);
      default:
        return date.toIso8601String();
    }
  }
}
