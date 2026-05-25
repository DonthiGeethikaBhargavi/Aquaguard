import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/sensor_reading_model.dart';
import '../../data/models/alert_model.dart';
import '../../data/providers/device_remote_datasource_provider.dart';

part 'health_score_calculator_provider.g.dart';

////////////////////////////////////////////////////////////
/// OPERATIONAL STATE ENUM
////////////////////////////////////////////////////////////

enum OperationalState { optimal, stable, warning, critical }

////////////////////////////////////////////////////////////
/// HEALTH SCORE RESULT
////////////////////////////////////////////////////////////

class HealthScoreResult {
  final int score;
  final double stabilityScore;
  final OperationalState operationalState;
  final DateTime lastUpdate;

  HealthScoreResult({
    required this.score,
    required this.stabilityScore,
    required this.operationalState,
    required this.lastUpdate,
  });
}

////////////////////////////////////////////////////////////
/// HEALTH SCORE PROVIDER
////////////////////////////////////////////////////////////

@riverpod
Future<HealthScoreResult> healthScoreCalculator(
  HealthScoreCalculatorRef ref,
  String pondId,
  String deviceId,
) async {
  final datasource = ref.watch(deviceRemoteDatasourceProvider);

  try {
    // Fetch sensor readings for the last 2 hours
    final supabase = datasource.supabase;
    final twoHoursAgo = DateTime.now().subtract(Duration(hours: 2));

    final readings = await supabase
        .from('sensor_readings')
        .select()
        .eq('device_id', deviceId)
        .gte('last_update', twoHoursAgo.toIso8601String())
        .order('last_update', ascending: false)
        .limit(120);

    final temperatureValues = <double>[];
    final doValues = <double>[];
    final phValues = <double>[];
    final waterLevelValues = <double>[];

    for (final reading in readings) {
      try {
        final model = SensorReadingModel.fromJson(reading);
        temperatureValues.add(model.temperature);
        doValues.add(model.dissolvedOxygen);
        phValues.add(model.ph);
        waterLevelValues.add(model.waterLevel);
      } catch (_) {
        continue;
      }
    }

    // Fetch active alerts
    final alerts = await supabase
        .from('alerts')
        .select()
        .eq('pond_id', pondId)
        .eq('is_resolved', false);

    int activeAlertCount = 0;
    int criticalAlertCount = 0;

    for (final alert in alerts) {
      try {
        final model = AlertModel.fromJson(alert);
        activeAlertCount++;
        if (model.isCritical) {
          criticalAlertCount++;
        }
      } catch (_) {
        continue;
      }
    }

    // Fetch anomalies from alerts_history (last 24 hours)
    final oneDayAgo = DateTime.now().subtract(Duration(days: 1));
    final anomalies = await supabase
        .from('alerts_history')
        .select()
        .eq('pond_id', pondId)
        .gte('created_at', oneDayAgo.toIso8601String());

    int anomalyCount = anomalies.length;

    // Get latest sensor reading for freshness check
    final latestReadings = await supabase
        .from('latest_readings')
        .select()
        .eq('device_id', deviceId)
        .limit(1);

    DateTime lastReadingTime = DateTime.now();
    if (latestReadings.isNotEmpty) {
      final lastReading = SensorReadingModel.fromJson(latestReadings.first);
      if (lastReading.lastUpdate != null) {
        lastReadingTime = lastReading.lastUpdate!;
      }
    }

    // Calculate component scores
    double stabilityScore = _calculateStabilityScore(
      temperatureValues,
      doValues,
      phValues,
      waterLevelValues,
    );

    int sensorFreshnessScore = _calculateSensorFreshnessScore(lastReadingTime);

    int alertScore = _calculateAlertScore(activeAlertCount, criticalAlertCount);

    int anomalyScore = _calculateAnomalyScore(anomalyCount);

    // Calculate composite health score
    final int healthScore = (
      (stabilityScore * 0.35) +
      (sensorFreshnessScore * 0.25) +
      (alertScore * 0.25) +
      (anomalyScore * 0.15)
    ).round().clamp(0, 100);

    // Determine operational state
    final operationalState = _determineOperationalState(
      healthScore,
      criticalAlertCount,
      stabilityScore,
    );

    return HealthScoreResult(
      score: healthScore,
      stabilityScore: stabilityScore,
      operationalState: operationalState,
      lastUpdate: DateTime.now(),
    );
  } catch (e) {
    // Return degraded health score on error
    return HealthScoreResult(
      score: 50,
      stabilityScore: 50.0,
      operationalState: OperationalState.warning,
      lastUpdate: DateTime.now(),
    );
  }
}

////////////////////////////////////////////////////////////
/// HELPER FUNCTIONS
////////////////////////////////////////////////////////////

double _calculateStabilityScore(
  List<double> tempValues,
  List<double> doValues,
  List<double> phValues,
  List<double> waterLevelValues,
) {
  if (tempValues.isEmpty) return 50.0;

  final tempVariance = _calculateVariance(tempValues);
  final doVariance = _calculateVariance(doValues);
  final phVariance = _calculateVariance(phValues);
  final waterLevelVariance = _calculateVariance(waterLevelValues);

  // Thresholds for acceptable variance
  const tempThreshold = 5.0;
  const doThreshold = 2.0;
  const phThreshold = 1.0;
  const waterLevelThreshold = 10.0;

  final tempScore = _scoreFromVariance(tempVariance, tempThreshold);
  final doScore = _scoreFromVariance(doVariance, doThreshold);
  final phScore = _scoreFromVariance(phVariance, phThreshold);
  final waterLevelScore =
      _scoreFromVariance(waterLevelVariance, waterLevelThreshold);

  // Average the scores
  return (tempScore + doScore + phScore + waterLevelScore) / 4;
}

double _calculateVariance(List<double> values) {
  if (values.length < 2) return 0.0;

  final mean = values.reduce((a, b) => a + b) / values.length;
  final variance = values
      .map((x) => (x - mean) * (x - mean))
      .reduce((a, b) => a + b)
      .toDouble();

  return variance / values.length;
}

double _scoreFromVariance(double variance, double threshold) {
  if (variance <= threshold) return 100.0;
  if (variance >= threshold * 3) return 0.0;

  return 100.0 * (1 - (variance - threshold) / (threshold * 2));
}

int _calculateSensorFreshnessScore(DateTime lastReadingTime) {
  final minutesAgo =
      DateTime.now().difference(lastReadingTime).inMinutes;

  if (minutesAgo <= 2) return 100;
  if (minutesAgo <= 10) return 70;
  if (minutesAgo <= 30) return 40;
  return 10;
}

int _calculateAlertScore(int activeAlerts, int criticalAlerts) {
  if (activeAlerts == 0) return 100;
  if (criticalAlerts > 0) return 20;
  if (activeAlerts >= 5) return 40;
  if (activeAlerts >= 3) return 60;
  return 80;
}

int _calculateAnomalyScore(int anomalyCount) {
  if (anomalyCount == 0) return 100;
  if (anomalyCount >= 10) return 20;
  if (anomalyCount >= 5) return 40;
  if (anomalyCount >= 2) return 70;
  return 85;
}

OperationalState _determineOperationalState(
  int healthScore,
  int criticalAlerts,
  double stabilityScore,
) {
  if (criticalAlerts > 0) return OperationalState.critical;
  if (healthScore >= 80 && stabilityScore >= 75) return OperationalState.optimal;
  if (healthScore >= 60) return OperationalState.stable;
  if (healthScore >= 40) return OperationalState.warning;
  return OperationalState.critical;
}
