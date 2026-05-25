import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/sensor_reading_model.dart';
import '../../data/models/alert_model.dart';
import '../../data/providers/device_remote_datasource_provider.dart';

part 'anomaly_detection_provider.g.dart';

////////////////////////////////////////////////////////////
/// SENSOR TYPE ENUM
////////////////////////////////////////////////////////////

enum SensorType { temperature, dissolvedOxygen, ph, waterLevel }

////////////////////////////////////////////////////////////
/// ANOMALY SEVERITY ENUM
////////////////////////////////////////////////////////////

enum AnomalySeverity { low, moderate, critical }

////////////////////////////////////////////////////////////
/// ANOMALY DATA MODEL
////////////////////////////////////////////////////////////

class AnomalyData {
  final String anomalyType;
  final SensorType affectedSensor;
  final AnomalySeverity severity;
  final String operationalImpact;
  final DateTime firstDetected;
  final int repeatCount;

  AnomalyData({
    required this.anomalyType,
    required this.affectedSensor,
    required this.severity,
    required this.operationalImpact,
    required this.firstDetected,
    required this.repeatCount,
  });
}

////////////////////////////////////////////////////////////
/// ANOMALY DETECTION PROVIDER
////////////////////////////////////////////////////////////

@riverpod
Future<List<AnomalyData>> anomalyDetection(
  AnomalyDetectionRef ref,
  String pondId,
  String deviceId,
) async {
  final datasource = ref.watch(deviceRemoteDatasourceProvider);
  final anomalies = <AnomalyData>[];

  try {
    final supabase = datasource.supabase;

    // Fetch active alerts with severity
    final activeAlerts = await supabase
        .from('alerts')
        .select()
        .eq('pond_id', pondId)
        .eq('is_resolved', false)
        .order('created_at', ascending: false);

    for (final alertData in activeAlerts) {
      try {
        final alert = AlertModel.fromJson(alertData);
        final sensorType = _parseSensorType(alert.parameter);
        final severity = _mapAlertSeverity(alert.severity);
        final impact = _getOperationalImpact(alert.parameter, alert.severity);

        anomalies.add(
          AnomalyData(
            anomalyType: alert.alertType,
            affectedSensor: sensorType,
            severity: severity,
            operationalImpact: impact,
            firstDetected: alert.firstSeen ?? alert.createdAt,
            repeatCount: 1, // Will be updated with history
          ),
        );
      } catch (_) {
        continue;
      }
    }

    // Fetch recent alert history to detect recurring patterns (last 48 hours)
    final twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
    final alertHistory = await supabase
        .from('alerts_history')
        .select()
        .eq('pond_id', pondId)
        .gte('created_at', twoDaysAgo.toIso8601String())
        .order('created_at', ascending: false);

    // Count recurring patterns
    final patternCounts = <String, int>{};
    for (final historyData in alertHistory) {
      final alertType = historyData['alert_type']?.toString() ?? '';
      final parameter = historyData['parameter']?.toString() ?? '';
      final key = '$alertType::$parameter';

      patternCounts[key] = (patternCounts[key] ?? 0) + 1;
    }

    // Update repeat counts and add high-frequency patterns as anomalies
    for (int i = 0; i < anomalies.length; i++) {
      final anomaly = anomalies[i];
      final key = '${anomaly.anomalyType}::${anomaly.affectedSensor.name}';
      final repeatCount = patternCounts[key] ?? 1;

      anomalies[i] = AnomalyData(
        anomalyType: anomaly.anomalyType,
        affectedSensor: anomaly.affectedSensor,
        severity: repeatCount > 5
            ? AnomalySeverity.critical
            : repeatCount > 3
                ? AnomalySeverity.moderate
                : anomaly.severity,
        operationalImpact: anomaly.operationalImpact,
        firstDetected: anomaly.firstDetected,
        repeatCount: repeatCount,
      );
    }

    // Detect sensor value spikes from recent readings
    final oneHourAgo = DateTime.now().subtract(Duration(hours: 1));
    final recentReadings = await supabase
        .from('sensor_readings')
        .select()
        .eq('device_id', deviceId)
        .gte('last_update', oneHourAgo.toIso8601String())
        .order('last_update', ascending: false)
        .limit(60);

    if (recentReadings.length > 10) {
      try {
        final spikeAnomalies = _detectSpikeAnomalies(
          recentReadings,
          pondId,
        );
        anomalies.addAll(spikeAnomalies);
      } catch (_) {
        // Spike detection failed, continue
      }
    }

    return anomalies;
  } catch (e) {
    return [];
  }
}

////////////////////////////////////////////////////////////
/// HELPER FUNCTIONS
////////////////////////////////////////////////////////////

SensorType _parseSensorType(String parameter) {
  final param = parameter.toLowerCase();
  if (param.contains('temperature') || param.contains('temp')) {
    return SensorType.temperature;
  } else if (param.contains('oxygen') || param.contains('do')) {
    return SensorType.dissolvedOxygen;
  } else if (param.contains('ph')) {
    return SensorType.ph;
  } else if (param.contains('water') || param.contains('level')) {
    return SensorType.waterLevel;
  }
  return SensorType.temperature;
}

AnomalySeverity _mapAlertSeverity(AlertSeverity severity) {
  switch (severity) {
    case AlertSeverity.critical:
      return AnomalySeverity.critical;
    case AlertSeverity.warning:
      return AnomalySeverity.moderate;
    case AlertSeverity.info:
      return AnomalySeverity.low;
  }
}

String _getOperationalImpact(String parameter, AlertSeverity severity) {
  final param = parameter.toLowerCase();

  if (param.contains('oxygen') || param.contains('do')) {
    if (severity == AlertSeverity.critical) {
      return 'Fish oxygen deprivation risk - immediate aeration needed';
    } else {
      return 'Reduced oxygen levels - monitor closely';
    }
  } else if (param.contains('temperature')) {
    if (severity == AlertSeverity.critical) {
      return 'Thermal stress on aquatic life - adjust heating/cooling';
    } else {
      return 'Temperature fluctuation - check equipment';
    }
  } else if (param.contains('ph')) {
    if (severity == AlertSeverity.critical) {
      return 'Extreme pH affecting water chemistry - adjust alkalinity';
    } else {
      return 'pH drift - monitor bacterial growth';
    }
  } else if (param.contains('water') || param.contains('level')) {
    if (severity == AlertSeverity.critical) {
      return 'Critical water level - potential pump/filter damage';
    } else {
      return 'Water level changes - verify filtration system';
    }
  }

  return 'System anomaly detected - investigate';
}

List<AnomalyData> _detectSpikeAnomalies(
  List<Map<String, dynamic>> readings,
  String pondId,
) {
  final anomalies = <AnomalyData>[];

  try {
    final models = readings
        .map((r) => SensorReadingModel.fromJson(r))
        .where((m) => m.lastUpdate != null)
        .toList();

    if (models.length < 5) return anomalies;

    // Check temperature spikes
    final tempSpike = _detectSpike(
      models.map((m) => m.temperature).toList(),
      2.0, // 2 degrees spike threshold
    );
    if (tempSpike) {
      anomalies.add(AnomalyData(
        anomalyType: 'Temperature Spike',
        affectedSensor: SensorType.temperature,
        severity: AnomalySeverity.moderate,
        operationalImpact: 'Rapid temperature change detected',
        firstDetected: DateTime.now(),
        repeatCount: 1,
      ));
    }

    // Check dissolved oxygen spikes
    final doSpike = _detectSpike(
      models.map((m) => m.dissolvedOxygen).toList(),
      1.5, // 1.5 mg/L spike threshold
    );
    if (doSpike) {
      anomalies.add(AnomalyData(
        anomalyType: 'Dissolved Oxygen Spike',
        affectedSensor: SensorType.dissolvedOxygen,
        severity: AnomalySeverity.low,
        operationalImpact: 'Rapid oxygen level change',
        firstDetected: DateTime.now(),
        repeatCount: 1,
      ));
    }

    // Check pH spikes
    final phSpike = _detectSpike(
      models.map((m) => m.ph).toList(),
      0.5, // 0.5 pH spike threshold
    );
    if (phSpike) {
      anomalies.add(AnomalyData(
        anomalyType: 'pH Spike',
        affectedSensor: SensorType.ph,
        severity: AnomalySeverity.moderate,
        operationalImpact: 'Rapid pH change affecting chemistry',
        firstDetected: DateTime.now(),
        repeatCount: 1,
      ));
    }
  } catch (_) {
    // Spike detection error
  }

  return anomalies;
}

bool _detectSpike(List<double> values, double threshold) {
  if (values.length < 2) return false;

  for (int i = 1; i < values.length; i++) {
    final diff = (values[i - 1] - values[i]).abs();
    if (diff > threshold) return true;
  }

  return false;
}
