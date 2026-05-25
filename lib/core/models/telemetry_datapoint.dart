import 'package:freezed_annotation/freezed_annotation.dart';

part 'telemetry_datapoint.freezed.dart';
part 'telemetry_datapoint.g.dart';

/// Premium telemetry data point with comprehensive operational intelligence
@freezed
class TelemetryDataPoint with _$TelemetryDataPoint {
  const factory TelemetryDataPoint({
    /// Timestamp of the data point
    required DateTime timestamp,

    /// Primary telemetry value
    required double value,

    /// Average value for the period
    @Default(0.0) double avg,

    /// Minimum value for the period
    @Default(0.0) double min,

    /// Maximum value for the period
    @Default(0.0) double max,

    /// Operational variance (0-1)
    @Default(0.0) double variance,

    /// Anomaly indicator (0-1, where 1 is definitely anomalous)
    @Default(0.0) double anomalyScore,

    /// Trend direction (-1: decreasing, 0: stable, 1: increasing)
    @Default(0) int trendDirection,

    /// Trend velocity (rate of change)
    @Default(0.0) double trendVelocity,

    /// Confidence score for this data point (0-1)
    @Default(1.0) double confidence,

    /// Whether this point is within safe operating range
    @Default(true) bool withinSafeRange,

    /// Safe range minimum
    @Default(0.0) double safeMin,

    /// Safe range maximum
    @Default(100.0) double safeMax,

    /// Optional metadata
    @Default({}) Map<String, dynamic> metadata,
  }) = _TelemetryDataPoint;

  factory TelemetryDataPoint.fromJson(Map<String, dynamic> json) =>
      _$TelemetryDataPointFromJson(json);
}

/// Aggregated telemetry series with premium analytics
@freezed
class TelemetrySeries with _$TelemetrySeries {
  const factory TelemetrySeries({
    /// Parameter name (temperature, dissolvedOxygen, ph, waterLevel)
    required String parameter,

    /// Aggregation level (Hour, Day, Week, Month, Year)
    required String aggregation,

    /// Timeframe (1H, 24H, 7D, 1M, 1Y)
    required String timeframe,

    /// Data points sorted by timestamp
    required List<TelemetryDataPoint> dataPoints,

    /// Overall series statistics
    required double seriesAvg,
    required double seriesMin,
    required double seriesMax,
    required double seriesVariance,

    /// Anomaly statistics
    @Default(0) int totalAnomalies,
    @Default(0.0) double anomalyDensity,

    /// Confidence in entire series
    @Default(1.0) double seriesConfidence,

    /// Last update timestamp
    required DateTime lastUpdate,

    /// Whether data is complete for this period
    @Default(true) bool isComplete,

    /// Metadata
    @Default({}) Map<String, dynamic> metadata,
  }) = _TelemetrySeries;

  factory TelemetrySeries.fromJson(Map<String, dynamic> json) =>
      _$TelemetrySeriesFromJson(json);
}
