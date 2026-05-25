// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telemetry_datapoint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TelemetryDataPoint _$TelemetryDataPointFromJson(Map<String, dynamic> json) {
  return _TelemetryDataPoint.fromJson(json);
}

/// @nodoc
mixin _$TelemetryDataPoint {
  /// Timestamp of the data point
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Primary telemetry value
  double get value => throw _privateConstructorUsedError;

  /// Average value for the period
  double get avg => throw _privateConstructorUsedError;

  /// Minimum value for the period
  double get min => throw _privateConstructorUsedError;

  /// Maximum value for the period
  double get max => throw _privateConstructorUsedError;

  /// Operational variance (0-1)
  double get variance => throw _privateConstructorUsedError;

  /// Anomaly indicator (0-1, where 1 is definitely anomalous)
  double get anomalyScore => throw _privateConstructorUsedError;

  /// Trend direction (-1: decreasing, 0: stable, 1: increasing)
  int get trendDirection => throw _privateConstructorUsedError;

  /// Trend velocity (rate of change)
  double get trendVelocity => throw _privateConstructorUsedError;

  /// Confidence score for this data point (0-1)
  double get confidence => throw _privateConstructorUsedError;

  /// Whether this point is within safe operating range
  bool get withinSafeRange => throw _privateConstructorUsedError;

  /// Safe range minimum
  double get safeMin => throw _privateConstructorUsedError;

  /// Safe range maximum
  double get safeMax => throw _privateConstructorUsedError;

  /// Optional metadata
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this TelemetryDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TelemetryDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TelemetryDataPointCopyWith<TelemetryDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TelemetryDataPointCopyWith<$Res> {
  factory $TelemetryDataPointCopyWith(
    TelemetryDataPoint value,
    $Res Function(TelemetryDataPoint) then,
  ) = _$TelemetryDataPointCopyWithImpl<$Res, TelemetryDataPoint>;
  @useResult
  $Res call({
    DateTime timestamp,
    double value,
    double avg,
    double min,
    double max,
    double variance,
    double anomalyScore,
    int trendDirection,
    double trendVelocity,
    double confidence,
    bool withinSafeRange,
    double safeMin,
    double safeMax,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$TelemetryDataPointCopyWithImpl<$Res, $Val extends TelemetryDataPoint>
    implements $TelemetryDataPointCopyWith<$Res> {
  _$TelemetryDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TelemetryDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
    Object? avg = null,
    Object? min = null,
    Object? max = null,
    Object? variance = null,
    Object? anomalyScore = null,
    Object? trendDirection = null,
    Object? trendVelocity = null,
    Object? confidence = null,
    Object? withinSafeRange = null,
    Object? safeMin = null,
    Object? safeMax = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            avg: null == avg
                ? _value.avg
                : avg // ignore: cast_nullable_to_non_nullable
                      as double,
            min: null == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as double,
            max: null == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as double,
            variance: null == variance
                ? _value.variance
                : variance // ignore: cast_nullable_to_non_nullable
                      as double,
            anomalyScore: null == anomalyScore
                ? _value.anomalyScore
                : anomalyScore // ignore: cast_nullable_to_non_nullable
                      as double,
            trendDirection: null == trendDirection
                ? _value.trendDirection
                : trendDirection // ignore: cast_nullable_to_non_nullable
                      as int,
            trendVelocity: null == trendVelocity
                ? _value.trendVelocity
                : trendVelocity // ignore: cast_nullable_to_non_nullable
                      as double,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            withinSafeRange: null == withinSafeRange
                ? _value.withinSafeRange
                : withinSafeRange // ignore: cast_nullable_to_non_nullable
                      as bool,
            safeMin: null == safeMin
                ? _value.safeMin
                : safeMin // ignore: cast_nullable_to_non_nullable
                      as double,
            safeMax: null == safeMax
                ? _value.safeMax
                : safeMax // ignore: cast_nullable_to_non_nullable
                      as double,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TelemetryDataPointImplCopyWith<$Res>
    implements $TelemetryDataPointCopyWith<$Res> {
  factory _$$TelemetryDataPointImplCopyWith(
    _$TelemetryDataPointImpl value,
    $Res Function(_$TelemetryDataPointImpl) then,
  ) = __$$TelemetryDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime timestamp,
    double value,
    double avg,
    double min,
    double max,
    double variance,
    double anomalyScore,
    int trendDirection,
    double trendVelocity,
    double confidence,
    bool withinSafeRange,
    double safeMin,
    double safeMax,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$TelemetryDataPointImplCopyWithImpl<$Res>
    extends _$TelemetryDataPointCopyWithImpl<$Res, _$TelemetryDataPointImpl>
    implements _$$TelemetryDataPointImplCopyWith<$Res> {
  __$$TelemetryDataPointImplCopyWithImpl(
    _$TelemetryDataPointImpl _value,
    $Res Function(_$TelemetryDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TelemetryDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
    Object? avg = null,
    Object? min = null,
    Object? max = null,
    Object? variance = null,
    Object? anomalyScore = null,
    Object? trendDirection = null,
    Object? trendVelocity = null,
    Object? confidence = null,
    Object? withinSafeRange = null,
    Object? safeMin = null,
    Object? safeMax = null,
    Object? metadata = null,
  }) {
    return _then(
      _$TelemetryDataPointImpl(
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        avg: null == avg
            ? _value.avg
            : avg // ignore: cast_nullable_to_non_nullable
                  as double,
        min: null == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as double,
        max: null == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as double,
        variance: null == variance
            ? _value.variance
            : variance // ignore: cast_nullable_to_non_nullable
                  as double,
        anomalyScore: null == anomalyScore
            ? _value.anomalyScore
            : anomalyScore // ignore: cast_nullable_to_non_nullable
                  as double,
        trendDirection: null == trendDirection
            ? _value.trendDirection
            : trendDirection // ignore: cast_nullable_to_non_nullable
                  as int,
        trendVelocity: null == trendVelocity
            ? _value.trendVelocity
            : trendVelocity // ignore: cast_nullable_to_non_nullable
                  as double,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        withinSafeRange: null == withinSafeRange
            ? _value.withinSafeRange
            : withinSafeRange // ignore: cast_nullable_to_non_nullable
                  as bool,
        safeMin: null == safeMin
            ? _value.safeMin
            : safeMin // ignore: cast_nullable_to_non_nullable
                  as double,
        safeMax: null == safeMax
            ? _value.safeMax
            : safeMax // ignore: cast_nullable_to_non_nullable
                  as double,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TelemetryDataPointImpl implements _TelemetryDataPoint {
  const _$TelemetryDataPointImpl({
    required this.timestamp,
    required this.value,
    this.avg = 0.0,
    this.min = 0.0,
    this.max = 0.0,
    this.variance = 0.0,
    this.anomalyScore = 0.0,
    this.trendDirection = 0,
    this.trendVelocity = 0.0,
    this.confidence = 1.0,
    this.withinSafeRange = true,
    this.safeMin = 0.0,
    this.safeMax = 100.0,
    final Map<String, dynamic> metadata = const {},
  }) : _metadata = metadata;

  factory _$TelemetryDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$TelemetryDataPointImplFromJson(json);

  /// Timestamp of the data point
  @override
  final DateTime timestamp;

  /// Primary telemetry value
  @override
  final double value;

  /// Average value for the period
  @override
  @JsonKey()
  final double avg;

  /// Minimum value for the period
  @override
  @JsonKey()
  final double min;

  /// Maximum value for the period
  @override
  @JsonKey()
  final double max;

  /// Operational variance (0-1)
  @override
  @JsonKey()
  final double variance;

  /// Anomaly indicator (0-1, where 1 is definitely anomalous)
  @override
  @JsonKey()
  final double anomalyScore;

  /// Trend direction (-1: decreasing, 0: stable, 1: increasing)
  @override
  @JsonKey()
  final int trendDirection;

  /// Trend velocity (rate of change)
  @override
  @JsonKey()
  final double trendVelocity;

  /// Confidence score for this data point (0-1)
  @override
  @JsonKey()
  final double confidence;

  /// Whether this point is within safe operating range
  @override
  @JsonKey()
  final bool withinSafeRange;

  /// Safe range minimum
  @override
  @JsonKey()
  final double safeMin;

  /// Safe range maximum
  @override
  @JsonKey()
  final double safeMax;

  /// Optional metadata
  final Map<String, dynamic> _metadata;

  /// Optional metadata
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'TelemetryDataPoint(timestamp: $timestamp, value: $value, avg: $avg, min: $min, max: $max, variance: $variance, anomalyScore: $anomalyScore, trendDirection: $trendDirection, trendVelocity: $trendVelocity, confidence: $confidence, withinSafeRange: $withinSafeRange, safeMin: $safeMin, safeMax: $safeMax, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TelemetryDataPointImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.avg, avg) || other.avg == avg) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.variance, variance) ||
                other.variance == variance) &&
            (identical(other.anomalyScore, anomalyScore) ||
                other.anomalyScore == anomalyScore) &&
            (identical(other.trendDirection, trendDirection) ||
                other.trendDirection == trendDirection) &&
            (identical(other.trendVelocity, trendVelocity) ||
                other.trendVelocity == trendVelocity) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.withinSafeRange, withinSafeRange) ||
                other.withinSafeRange == withinSafeRange) &&
            (identical(other.safeMin, safeMin) || other.safeMin == safeMin) &&
            (identical(other.safeMax, safeMax) || other.safeMax == safeMax) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timestamp,
    value,
    avg,
    min,
    max,
    variance,
    anomalyScore,
    trendDirection,
    trendVelocity,
    confidence,
    withinSafeRange,
    safeMin,
    safeMax,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of TelemetryDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TelemetryDataPointImplCopyWith<_$TelemetryDataPointImpl> get copyWith =>
      __$$TelemetryDataPointImplCopyWithImpl<_$TelemetryDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TelemetryDataPointImplToJson(this);
  }
}

abstract class _TelemetryDataPoint implements TelemetryDataPoint {
  const factory _TelemetryDataPoint({
    required final DateTime timestamp,
    required final double value,
    final double avg,
    final double min,
    final double max,
    final double variance,
    final double anomalyScore,
    final int trendDirection,
    final double trendVelocity,
    final double confidence,
    final bool withinSafeRange,
    final double safeMin,
    final double safeMax,
    final Map<String, dynamic> metadata,
  }) = _$TelemetryDataPointImpl;

  factory _TelemetryDataPoint.fromJson(Map<String, dynamic> json) =
      _$TelemetryDataPointImpl.fromJson;

  /// Timestamp of the data point
  @override
  DateTime get timestamp;

  /// Primary telemetry value
  @override
  double get value;

  /// Average value for the period
  @override
  double get avg;

  /// Minimum value for the period
  @override
  double get min;

  /// Maximum value for the period
  @override
  double get max;

  /// Operational variance (0-1)
  @override
  double get variance;

  /// Anomaly indicator (0-1, where 1 is definitely anomalous)
  @override
  double get anomalyScore;

  /// Trend direction (-1: decreasing, 0: stable, 1: increasing)
  @override
  int get trendDirection;

  /// Trend velocity (rate of change)
  @override
  double get trendVelocity;

  /// Confidence score for this data point (0-1)
  @override
  double get confidence;

  /// Whether this point is within safe operating range
  @override
  bool get withinSafeRange;

  /// Safe range minimum
  @override
  double get safeMin;

  /// Safe range maximum
  @override
  double get safeMax;

  /// Optional metadata
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of TelemetryDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TelemetryDataPointImplCopyWith<_$TelemetryDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TelemetrySeries _$TelemetrySeriesFromJson(Map<String, dynamic> json) {
  return _TelemetrySeries.fromJson(json);
}

/// @nodoc
mixin _$TelemetrySeries {
  /// Parameter name (temperature, dissolvedOxygen, ph, waterLevel)
  String get parameter => throw _privateConstructorUsedError;

  /// Aggregation level (Hour, Day, Week, Month, Year)
  String get aggregation => throw _privateConstructorUsedError;

  /// Timeframe (1H, 24H, 7D, 1M, 1Y)
  String get timeframe => throw _privateConstructorUsedError;

  /// Data points sorted by timestamp
  List<TelemetryDataPoint> get dataPoints => throw _privateConstructorUsedError;

  /// Overall series statistics
  double get seriesAvg => throw _privateConstructorUsedError;
  double get seriesMin => throw _privateConstructorUsedError;
  double get seriesMax => throw _privateConstructorUsedError;
  double get seriesVariance => throw _privateConstructorUsedError;

  /// Anomaly statistics
  int get totalAnomalies => throw _privateConstructorUsedError;
  double get anomalyDensity => throw _privateConstructorUsedError;

  /// Confidence in entire series
  double get seriesConfidence => throw _privateConstructorUsedError;

  /// Last update timestamp
  DateTime get lastUpdate => throw _privateConstructorUsedError;

  /// Whether data is complete for this period
  bool get isComplete => throw _privateConstructorUsedError;

  /// Metadata
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this TelemetrySeries to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TelemetrySeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TelemetrySeriesCopyWith<TelemetrySeries> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TelemetrySeriesCopyWith<$Res> {
  factory $TelemetrySeriesCopyWith(
    TelemetrySeries value,
    $Res Function(TelemetrySeries) then,
  ) = _$TelemetrySeriesCopyWithImpl<$Res, TelemetrySeries>;
  @useResult
  $Res call({
    String parameter,
    String aggregation,
    String timeframe,
    List<TelemetryDataPoint> dataPoints,
    double seriesAvg,
    double seriesMin,
    double seriesMax,
    double seriesVariance,
    int totalAnomalies,
    double anomalyDensity,
    double seriesConfidence,
    DateTime lastUpdate,
    bool isComplete,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$TelemetrySeriesCopyWithImpl<$Res, $Val extends TelemetrySeries>
    implements $TelemetrySeriesCopyWith<$Res> {
  _$TelemetrySeriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TelemetrySeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parameter = null,
    Object? aggregation = null,
    Object? timeframe = null,
    Object? dataPoints = null,
    Object? seriesAvg = null,
    Object? seriesMin = null,
    Object? seriesMax = null,
    Object? seriesVariance = null,
    Object? totalAnomalies = null,
    Object? anomalyDensity = null,
    Object? seriesConfidence = null,
    Object? lastUpdate = null,
    Object? isComplete = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            parameter: null == parameter
                ? _value.parameter
                : parameter // ignore: cast_nullable_to_non_nullable
                      as String,
            aggregation: null == aggregation
                ? _value.aggregation
                : aggregation // ignore: cast_nullable_to_non_nullable
                      as String,
            timeframe: null == timeframe
                ? _value.timeframe
                : timeframe // ignore: cast_nullable_to_non_nullable
                      as String,
            dataPoints: null == dataPoints
                ? _value.dataPoints
                : dataPoints // ignore: cast_nullable_to_non_nullable
                      as List<TelemetryDataPoint>,
            seriesAvg: null == seriesAvg
                ? _value.seriesAvg
                : seriesAvg // ignore: cast_nullable_to_non_nullable
                      as double,
            seriesMin: null == seriesMin
                ? _value.seriesMin
                : seriesMin // ignore: cast_nullable_to_non_nullable
                      as double,
            seriesMax: null == seriesMax
                ? _value.seriesMax
                : seriesMax // ignore: cast_nullable_to_non_nullable
                      as double,
            seriesVariance: null == seriesVariance
                ? _value.seriesVariance
                : seriesVariance // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAnomalies: null == totalAnomalies
                ? _value.totalAnomalies
                : totalAnomalies // ignore: cast_nullable_to_non_nullable
                      as int,
            anomalyDensity: null == anomalyDensity
                ? _value.anomalyDensity
                : anomalyDensity // ignore: cast_nullable_to_non_nullable
                      as double,
            seriesConfidence: null == seriesConfidence
                ? _value.seriesConfidence
                : seriesConfidence // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdate: null == lastUpdate
                ? _value.lastUpdate
                : lastUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isComplete: null == isComplete
                ? _value.isComplete
                : isComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TelemetrySeriesImplCopyWith<$Res>
    implements $TelemetrySeriesCopyWith<$Res> {
  factory _$$TelemetrySeriesImplCopyWith(
    _$TelemetrySeriesImpl value,
    $Res Function(_$TelemetrySeriesImpl) then,
  ) = __$$TelemetrySeriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String parameter,
    String aggregation,
    String timeframe,
    List<TelemetryDataPoint> dataPoints,
    double seriesAvg,
    double seriesMin,
    double seriesMax,
    double seriesVariance,
    int totalAnomalies,
    double anomalyDensity,
    double seriesConfidence,
    DateTime lastUpdate,
    bool isComplete,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$TelemetrySeriesImplCopyWithImpl<$Res>
    extends _$TelemetrySeriesCopyWithImpl<$Res, _$TelemetrySeriesImpl>
    implements _$$TelemetrySeriesImplCopyWith<$Res> {
  __$$TelemetrySeriesImplCopyWithImpl(
    _$TelemetrySeriesImpl _value,
    $Res Function(_$TelemetrySeriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TelemetrySeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parameter = null,
    Object? aggregation = null,
    Object? timeframe = null,
    Object? dataPoints = null,
    Object? seriesAvg = null,
    Object? seriesMin = null,
    Object? seriesMax = null,
    Object? seriesVariance = null,
    Object? totalAnomalies = null,
    Object? anomalyDensity = null,
    Object? seriesConfidence = null,
    Object? lastUpdate = null,
    Object? isComplete = null,
    Object? metadata = null,
  }) {
    return _then(
      _$TelemetrySeriesImpl(
        parameter: null == parameter
            ? _value.parameter
            : parameter // ignore: cast_nullable_to_non_nullable
                  as String,
        aggregation: null == aggregation
            ? _value.aggregation
            : aggregation // ignore: cast_nullable_to_non_nullable
                  as String,
        timeframe: null == timeframe
            ? _value.timeframe
            : timeframe // ignore: cast_nullable_to_non_nullable
                  as String,
        dataPoints: null == dataPoints
            ? _value._dataPoints
            : dataPoints // ignore: cast_nullable_to_non_nullable
                  as List<TelemetryDataPoint>,
        seriesAvg: null == seriesAvg
            ? _value.seriesAvg
            : seriesAvg // ignore: cast_nullable_to_non_nullable
                  as double,
        seriesMin: null == seriesMin
            ? _value.seriesMin
            : seriesMin // ignore: cast_nullable_to_non_nullable
                  as double,
        seriesMax: null == seriesMax
            ? _value.seriesMax
            : seriesMax // ignore: cast_nullable_to_non_nullable
                  as double,
        seriesVariance: null == seriesVariance
            ? _value.seriesVariance
            : seriesVariance // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAnomalies: null == totalAnomalies
            ? _value.totalAnomalies
            : totalAnomalies // ignore: cast_nullable_to_non_nullable
                  as int,
        anomalyDensity: null == anomalyDensity
            ? _value.anomalyDensity
            : anomalyDensity // ignore: cast_nullable_to_non_nullable
                  as double,
        seriesConfidence: null == seriesConfidence
            ? _value.seriesConfidence
            : seriesConfidence // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdate: null == lastUpdate
            ? _value.lastUpdate
            : lastUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isComplete: null == isComplete
            ? _value.isComplete
            : isComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TelemetrySeriesImpl implements _TelemetrySeries {
  const _$TelemetrySeriesImpl({
    required this.parameter,
    required this.aggregation,
    required this.timeframe,
    required final List<TelemetryDataPoint> dataPoints,
    required this.seriesAvg,
    required this.seriesMin,
    required this.seriesMax,
    required this.seriesVariance,
    this.totalAnomalies = 0,
    this.anomalyDensity = 0.0,
    this.seriesConfidence = 1.0,
    required this.lastUpdate,
    this.isComplete = true,
    final Map<String, dynamic> metadata = const {},
  }) : _dataPoints = dataPoints,
       _metadata = metadata;

  factory _$TelemetrySeriesImpl.fromJson(Map<String, dynamic> json) =>
      _$$TelemetrySeriesImplFromJson(json);

  /// Parameter name (temperature, dissolvedOxygen, ph, waterLevel)
  @override
  final String parameter;

  /// Aggregation level (Hour, Day, Week, Month, Year)
  @override
  final String aggregation;

  /// Timeframe (1H, 24H, 7D, 1M, 1Y)
  @override
  final String timeframe;

  /// Data points sorted by timestamp
  final List<TelemetryDataPoint> _dataPoints;

  /// Data points sorted by timestamp
  @override
  List<TelemetryDataPoint> get dataPoints {
    if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataPoints);
  }

  /// Overall series statistics
  @override
  final double seriesAvg;
  @override
  final double seriesMin;
  @override
  final double seriesMax;
  @override
  final double seriesVariance;

  /// Anomaly statistics
  @override
  @JsonKey()
  final int totalAnomalies;
  @override
  @JsonKey()
  final double anomalyDensity;

  /// Confidence in entire series
  @override
  @JsonKey()
  final double seriesConfidence;

  /// Last update timestamp
  @override
  final DateTime lastUpdate;

  /// Whether data is complete for this period
  @override
  @JsonKey()
  final bool isComplete;

  /// Metadata
  final Map<String, dynamic> _metadata;

  /// Metadata
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'TelemetrySeries(parameter: $parameter, aggregation: $aggregation, timeframe: $timeframe, dataPoints: $dataPoints, seriesAvg: $seriesAvg, seriesMin: $seriesMin, seriesMax: $seriesMax, seriesVariance: $seriesVariance, totalAnomalies: $totalAnomalies, anomalyDensity: $anomalyDensity, seriesConfidence: $seriesConfidence, lastUpdate: $lastUpdate, isComplete: $isComplete, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TelemetrySeriesImpl &&
            (identical(other.parameter, parameter) ||
                other.parameter == parameter) &&
            (identical(other.aggregation, aggregation) ||
                other.aggregation == aggregation) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            const DeepCollectionEquality().equals(
              other._dataPoints,
              _dataPoints,
            ) &&
            (identical(other.seriesAvg, seriesAvg) ||
                other.seriesAvg == seriesAvg) &&
            (identical(other.seriesMin, seriesMin) ||
                other.seriesMin == seriesMin) &&
            (identical(other.seriesMax, seriesMax) ||
                other.seriesMax == seriesMax) &&
            (identical(other.seriesVariance, seriesVariance) ||
                other.seriesVariance == seriesVariance) &&
            (identical(other.totalAnomalies, totalAnomalies) ||
                other.totalAnomalies == totalAnomalies) &&
            (identical(other.anomalyDensity, anomalyDensity) ||
                other.anomalyDensity == anomalyDensity) &&
            (identical(other.seriesConfidence, seriesConfidence) ||
                other.seriesConfidence == seriesConfidence) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    parameter,
    aggregation,
    timeframe,
    const DeepCollectionEquality().hash(_dataPoints),
    seriesAvg,
    seriesMin,
    seriesMax,
    seriesVariance,
    totalAnomalies,
    anomalyDensity,
    seriesConfidence,
    lastUpdate,
    isComplete,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of TelemetrySeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TelemetrySeriesImplCopyWith<_$TelemetrySeriesImpl> get copyWith =>
      __$$TelemetrySeriesImplCopyWithImpl<_$TelemetrySeriesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TelemetrySeriesImplToJson(this);
  }
}

abstract class _TelemetrySeries implements TelemetrySeries {
  const factory _TelemetrySeries({
    required final String parameter,
    required final String aggregation,
    required final String timeframe,
    required final List<TelemetryDataPoint> dataPoints,
    required final double seriesAvg,
    required final double seriesMin,
    required final double seriesMax,
    required final double seriesVariance,
    final int totalAnomalies,
    final double anomalyDensity,
    final double seriesConfidence,
    required final DateTime lastUpdate,
    final bool isComplete,
    final Map<String, dynamic> metadata,
  }) = _$TelemetrySeriesImpl;

  factory _TelemetrySeries.fromJson(Map<String, dynamic> json) =
      _$TelemetrySeriesImpl.fromJson;

  /// Parameter name (temperature, dissolvedOxygen, ph, waterLevel)
  @override
  String get parameter;

  /// Aggregation level (Hour, Day, Week, Month, Year)
  @override
  String get aggregation;

  /// Timeframe (1H, 24H, 7D, 1M, 1Y)
  @override
  String get timeframe;

  /// Data points sorted by timestamp
  @override
  List<TelemetryDataPoint> get dataPoints;

  /// Overall series statistics
  @override
  double get seriesAvg;
  @override
  double get seriesMin;
  @override
  double get seriesMax;
  @override
  double get seriesVariance;

  /// Anomaly statistics
  @override
  int get totalAnomalies;
  @override
  double get anomalyDensity;

  /// Confidence in entire series
  @override
  double get seriesConfidence;

  /// Last update timestamp
  @override
  DateTime get lastUpdate;

  /// Whether data is complete for this period
  @override
  bool get isComplete;

  /// Metadata
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of TelemetrySeries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TelemetrySeriesImplCopyWith<_$TelemetrySeriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
