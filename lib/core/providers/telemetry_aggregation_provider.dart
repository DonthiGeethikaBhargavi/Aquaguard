import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/telemetry_aggregation_service.dart';
import '../models/telemetry_datapoint.dart';

part 'telemetry_aggregation_provider.g.dart';

////////////////////////////////////////////////////////////
/// AGGREGATION SERVICE PROVIDER
////////////////////////////////////////////////////////////

final telemetryAggregationServiceProvider =
    Provider<TelemetryAggregationService>((ref) {
      final supabase = Supabase.instance.client;
      return TelemetryAggregationService(supabase);
    });

////////////////////////////////////////////////////////////
/// TELEMETRY SERIES PARAMETERS
////////////////////////////////////////////////////////////

class TelemetrySeriesParams {
  final String pondId;
  final String deviceId;
  final String parameter;
  final String timeframe;
  final DateTime endDate;
  final DateTime? startDate;

  TelemetrySeriesParams({
    required this.pondId,
    required this.deviceId,
    required this.parameter,
    required this.timeframe,
    required this.endDate,
    this.startDate,
  });

  @override
  String toString() {
    return '$pondId|$deviceId|$parameter|$timeframe|$endDate|$startDate';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TelemetrySeriesParams &&
          runtimeType == other.runtimeType &&
          pondId == other.pondId &&
          deviceId == other.deviceId &&
          parameter == other.parameter &&
          timeframe == other.timeframe &&
          endDate == other.endDate &&
          startDate == other.startDate;

  @override
  int get hashCode =>
      pondId.hashCode ^
      deviceId.hashCode ^
      parameter.hashCode ^
      timeframe.hashCode ^
      endDate.hashCode ^
      startDate.hashCode;
}

////////////////////////////////////////////////////////////
/// FETCH TELEMETRY SERIES
////////////////////////////////////////////////////////////

@riverpod
Future<TelemetrySeries> telemetrySeries(
  TelemetrySeriesRef ref,
  TelemetrySeriesParams params,
) async {
  final service = ref.watch(telemetryAggregationServiceProvider);

  return service.fetchTelemetrySeries(
    pondId: params.pondId,
    deviceId: params.deviceId,
    parameter: params.parameter,
    timeframe: params.timeframe,
    endDate: params.endDate,
    startDate: params.startDate,
  );
}

////////////////////////////////////////////////////////////
/// MULTIPLE PARAMETERS AT ONCE
////////////////////////////////////////////////////////////

class MultiParameterParams {
  final String pondId;
  final String deviceId;
  final List<String> parameters;
  final String timeframe;
  final DateTime endDate;
  final DateTime? startDate;

  MultiParameterParams({
    required this.pondId,
    required this.deviceId,
    required this.parameters,
    required this.timeframe,
    required this.endDate,
    this.startDate,
  });

  @override
  String toString() {
    return '$pondId|$deviceId|${parameters.join(',')}|$timeframe|$endDate|$startDate';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiParameterParams &&
          runtimeType == other.runtimeType &&
          pondId == other.pondId &&
          deviceId == other.deviceId &&
          parameters == other.parameters &&
          timeframe == other.timeframe &&
          endDate == other.endDate &&
          startDate == other.startDate;

  @override
  int get hashCode =>
      pondId.hashCode ^
      deviceId.hashCode ^
      parameters.hashCode ^
      timeframe.hashCode ^
      endDate.hashCode ^
      startDate.hashCode;
}

@riverpod
Future<Map<String, TelemetrySeries>> multiParameterTelemetry(
  MultiParameterTelemetryRef ref,
  MultiParameterParams params,
) async {
  final service = ref.watch(telemetryAggregationServiceProvider);

  return service.fetchMultipleParameters(
    pondId: params.pondId,
    deviceId: params.deviceId,
    parameters: params.parameters,
    timeframe: params.timeframe,
    endDate: params.endDate,
    startDate: params.startDate,
  );
}

////////////////////////////////////////////////////////////
/// COMPARISON DATA
////////////////////////////////////////////////////////////

class ComparisonParams {
  final String pondId;
  final String deviceId;
  final String parameter;
  final String timeframe;
  final DateTime currentEndDate;
  final DateTime? currentStartDate;

  ComparisonParams({
    required this.pondId,
    required this.deviceId,
    required this.parameter,
    required this.timeframe,
    required this.currentEndDate,
    this.currentStartDate,
  });

  @override
  String toString() {
    return '$pondId|$deviceId|$parameter|$timeframe|$currentEndDate|$currentStartDate';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComparisonParams &&
          runtimeType == other.runtimeType &&
          pondId == other.pondId &&
          deviceId == other.deviceId &&
          parameter == other.parameter &&
          timeframe == other.timeframe &&
          currentEndDate == other.currentEndDate &&
          currentStartDate == other.currentStartDate;

  @override
  int get hashCode =>
      pondId.hashCode ^
      deviceId.hashCode ^
      parameter.hashCode ^
      timeframe.hashCode ^
      currentEndDate.hashCode ^
      currentStartDate.hashCode;
}

@riverpod
Future<Map<String, TelemetrySeries>> comparisonTelemetry(
  ComparisonTelemetryRef ref,
  ComparisonParams params,
) async {
  final service = ref.watch(telemetryAggregationServiceProvider);

  return service.fetchComparison(
    pondId: params.pondId,
    deviceId: params.deviceId,
    parameter: params.parameter,
    timeframe: params.timeframe,
    currentEndDate: params.currentEndDate,
    currentStartDate: params.currentStartDate,
  );
}

////////////////////////////////////////////////////////////
/// SELECTED TIMEFRAME STATE
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class SelectedTimeframe extends _$SelectedTimeframe {
  @override
  String build() {
    return '24H'; // Default to 24 hours
  }

  void setTimeframe(String timeframe) {
    state = timeframe;
  }
}

////////////////////////////////////////////////////////////
/// SELECTED AGGREGATION STATE
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class SelectedAggregation extends _$SelectedAggregation {
  @override
  String build() {
    return 'Day'; // Default to daily aggregation
  }

  void setAggregation(String aggregation) {
    state = aggregation;
  }
}

////////////////////////////////////////////////////////////
/// TIME FORMAT PREFERENCE (12H/24H)
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class TimeFormatPreference extends _$TimeFormatPreference {
  @override
  String build() {
    // TODO: Load from SharedPreferences
    return '12H'; // Default to 12-hour format
  }

  void setTimeFormat(String format) {
    // TODO: Save to SharedPreferences
    state = format;
  }
}

////////////////////////////////////////////////////////////
/// EMPTY STATE HELPERS
////////////////////////////////////////////////////////////

enum EmptyStateReason {
  collectingBaseline,
  awaitingAggregation,
  insufficientData,
  unavailable,
}

class EmptyStateProvider {
  static String getEmptyStateMessage(EmptyStateReason reason) {
    switch (reason) {
      case EmptyStateReason.collectingBaseline:
        return 'Collecting operational baseline';
      case EmptyStateReason.awaitingAggregation:
        return 'Awaiting telemetry aggregation';
      case EmptyStateReason.insufficientData:
        return 'Insufficient telemetry signal';
      case EmptyStateReason.unavailable:
        return 'Operational history unavailable';
    }
  }

  static String getEmptyStateSubtitle(EmptyStateReason reason) {
    switch (reason) {
      case EmptyStateReason.collectingBaseline:
        return 'System is gathering initial operational data';
      case EmptyStateReason.awaitingAggregation:
        return 'Processing telemetry into aggregation intervals';
      case EmptyStateReason.insufficientData:
        return 'Not enough data available for analysis';
      case EmptyStateReason.unavailable:
        return 'Unable to retrieve historical telemetry';
    }
  }
}
