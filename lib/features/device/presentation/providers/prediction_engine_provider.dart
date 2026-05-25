import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/sensor_reading_model.dart';
import '../../data/providers/device_remote_datasource_provider.dart';

part 'prediction_engine_provider.g.dart';

////////////////////////////////////////////////////////////
/// PREDICTION SEVERITY ENUM
////////////////////////////////////////////////////////////

enum PredictionSeverity { low, moderate, critical }

////////////////////////////////////////////////////////////
/// PREDICTION DATA MODEL
////////////////////////////////////////////////////////////

class PredictionData {
  final String riskDescription;
  final double confidence;
  final String estimatedTimeframe;
  final PredictionSeverity severity;
  final String recommendation;
  final String affectedSensor;

  PredictionData({
    required this.riskDescription,
    required this.confidence,
    required this.estimatedTimeframe,
    required this.severity,
    required this.recommendation,
    required this.affectedSensor,
  });
}

////////////////////////////////////////////////////////////
/// PREDICTION ENGINE PROVIDER
////////////////////////////////////////////////////////////

@riverpod
Future<List<PredictionData>> predictionEngine(
  PredictionEngineRef ref,
  String pondId,
  String deviceId,
) async {
  final datasource = ref.watch(deviceRemoteDatasourceProvider);
  final predictions = <PredictionData>[];

  try {
    final supabase = datasource.supabase;

    // Fetch hourly statistics for trends (last 24 hours)
    final oneDayAgo = DateTime.now().subtract(Duration(days: 1));
    final hourlyStats = await supabase
        .from('hourly_stats')
        .select()
        .eq('pond_id', pondId)
        .gte('hour', oneDayAgo.toIso8601String())
        .order('hour', ascending: false)
        .limit(24);

    // Fetch daily statistics for long-term trends (last 30 days)
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    final dailyStats = await supabase
        .from('daily_stats')
        .select()
        .eq('pond_id', pondId)
        .gte('day', thirtyDaysAgo.toIso8601String())
        .order('day', ascending: false)
        .limit(30);

    // Analyze temperature trend
    final tempPredictions = _analyzeTemperatureTrend(hourlyStats, dailyStats);
    predictions.addAll(tempPredictions);

    // Analyze dissolved oxygen trend
    final doPredictions = _analyzeDissolvedOxygenTrend(hourlyStats, dailyStats);
    predictions.addAll(doPredictions);

    // Analyze pH trend
    final phPredictions = _analyzePhTrend(hourlyStats, dailyStats);
    predictions.addAll(phPredictions);

    // Analyze alert frequency patterns
    const sevenDaysAgo = Duration(days: 7);
    final weekAgo = DateTime.now().subtract(sevenDaysAgo);

    final recentAlerts = await supabase
        .from('alerts_history')
        .select()
        .eq('pond_id', pondId)
        .gte('created_at', weekAgo.toIso8601String());

    if (recentAlerts.length > 5) {
      predictions.add(PredictionData(
        riskDescription:
            'High alert frequency indicates potential system degradation',
        confidence: 75.0,
        estimatedTimeframe: '24-48 hours',
        severity: PredictionSeverity.moderate,
        recommendation: 'Schedule preventive maintenance and check sensor calibration',
        affectedSensor: 'System',
      ));
    }

    // Fetch recent sensor readings for threshold analysis
    const twoHours = Duration(hours: 2);
    final twoHoursAgo = DateTime.now().subtract(twoHours);

    final recentReadings = await supabase
        .from('sensor_readings')
        .select()
        .eq('device_id', deviceId)
        .gte('last_update', twoHoursAgo.toIso8601String())
        .order('last_update', ascending: false)
        .limit(120);

    if (recentReadings.isNotEmpty) {
      // Analyze recent readings for threshold breach risks
      final thresholdPredictions = _analyzeThresholdBreachRisk(recentReadings);
      predictions.addAll(thresholdPredictions);
    }

    // Analyze operational anomalies
    final operationalPredictions = _analyzeOperationalIssues(hourlyStats);
    predictions.addAll(operationalPredictions);

    return predictions;
  } catch (e) {
    return [];
  }
}

////////////////////////////////////////////////////////////
/// HELPER FUNCTIONS
////////////////////////////////////////////////////////////

List<PredictionData> _analyzeTemperatureTrend(
  List<Map<String, dynamic>> hourlyStats,
  List<Map<String, dynamic>> dailyStats,
) {
  final predictions = <PredictionData>[];

  if (hourlyStats.isEmpty) return predictions;

  try {
    final temps = hourlyStats
        .map((h) => (h['temp_avg'] as num?)?.toDouble() ?? 0.0)
        .toList();

    if (temps.length > 3) {
      final trend = _calculateTrend(temps);

      if (trend > 0.5) {
        // Rising temperature
        predictions.add(PredictionData(
          riskDescription:
              'Temperature consistently rising - potential cooling system malfunction',
          confidence: 70.0,
          estimatedTimeframe: '4-8 hours',
          severity: PredictionSeverity.moderate,
          recommendation: 'Verify chiller operation and check for hot water source leaks',
          affectedSensor: 'Temperature',
        ));
      } else if (trend < -0.5) {
        // Falling temperature
        predictions.add(PredictionData(
          riskDescription:
              'Temperature consistently falling - check heater performance',
          confidence: 65.0,
          estimatedTimeframe: '6-12 hours',
          severity: PredictionSeverity.low,
          recommendation: 'Test heater thermostat and heating element',
          affectedSensor: 'Temperature',
        ));
      }
    }

    // Check for extreme values
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final tempRange = maxTemp - minTemp;

    if (tempRange > 8.0) {
      predictions.add(PredictionData(
        riskDescription:
            'Large temperature fluctuations detected - indicates unstable environment',
        confidence: 80.0,
        estimatedTimeframe: 'tonight',
        severity: PredictionSeverity.moderate,
        recommendation:
            'Check insulation and environmental factors, verify heating/cooling calibration',
        affectedSensor: 'Temperature',
      ));
    }
  } catch (_) {
    // Analysis error
  }

  return predictions;
}

List<PredictionData> _analyzeDissolvedOxygenTrend(
  List<Map<String, dynamic>> hourlyStats,
  List<Map<String, dynamic>> dailyStats,
) {
  final predictions = <PredictionData>[];

  if (hourlyStats.isEmpty) return predictions;

  try {
    final doValues = hourlyStats
        .map((h) => (h['do_avg'] as num?)?.toDouble() ?? 0.0)
        .toList();

    if (doValues.length > 3) {
      final trend = _calculateTrend(doValues);

      if (trend < -0.3) {
        // Declining oxygen
        predictions.add(PredictionData(
          riskDescription:
              'Dissolved oxygen declining - potential bioload increase or aeration failure',
          confidence: 85.0,
          estimatedTimeframe: '2-4 hours',
          severity: PredictionSeverity.critical,
          recommendation:
              'Increase aeration immediately, check for dead zones, verify pump operation',
          affectedSensor: 'Dissolved Oxygen',
        ));
      }
    }

    // Check for dangerously low oxygen
    final minDo = doValues.reduce((a, b) => a < b ? a : b);
    if (minDo < 3.0) {
      predictions.add(PredictionData(
        riskDescription: 'Dissolved oxygen critically low - fish stress imminent',
        confidence: 95.0,
        estimatedTimeframe: '1-2 hours',
        severity: PredictionSeverity.critical,
        recommendation:
            'Activate emergency aeration, reduce stocking density, begin water exchange',
        affectedSensor: 'Dissolved Oxygen',
      ));
    }
  } catch (_) {
    // Analysis error
  }

  return predictions;
}

List<PredictionData> _analyzePhTrend(
  List<Map<String, dynamic>> hourlyStats,
  List<Map<String, dynamic>> dailyStats,
) {
  final predictions = <PredictionData>[];

  if (hourlyStats.isEmpty) return predictions;

  try {
    final phValues = hourlyStats
        .map((h) => (h['ph_avg'] as num?)?.toDouble() ?? 0.0)
        .toList();

    if (phValues.length > 3) {
      final minPh = phValues.reduce((a, b) => a < b ? a : b);
      final maxPh = phValues.reduce((a, b) => a > b ? a : b);
      final phRange = maxPh - minPh;

      if (minPh < 6.0 || maxPh > 8.5) {
        predictions.add(PredictionData(
          riskDescription:
              'pH outside optimal range - potential bacterial stress or chemical imbalance',
          confidence: 80.0,
          estimatedTimeframe: '24 hours',
          severity: PredictionSeverity.moderate,
          recommendation: 'Check buffer capacity, verify ammonia levels, adjust alkalinity',
          affectedSensor: 'pH',
        ));
      }

      if (phRange > 1.0) {
        predictions.add(PredictionData(
          riskDescription: 'pH fluctuations indicate unstable water chemistry',
          confidence: 70.0,
          estimatedTimeframe: '48 hours',
          severity: PredictionSeverity.low,
          recommendation:
              'Increase water change frequency, test carbonate hardness, add buffer',
          affectedSensor: 'pH',
        ));
      }
    }
  } catch (_) {
    // Analysis error
  }

  return predictions;
}

List<PredictionData> _analyzeThresholdBreachRisk(
  List<Map<String, dynamic>> readings,
) {
  final predictions = <PredictionData>[];

  try {
    final models = readings
        .map((r) => SensorReadingModel.fromJson(r))
        .toList();

    if (models.isEmpty) return predictions;

    // Check if approaching dangerous temperature
    final temps = models.map((m) => m.temperature).toList();
    final avgTemp = temps.reduce((a, b) => a + b) / temps.length;

    if (avgTemp > 32.0) {
      predictions.add(PredictionData(
        riskDescription: 'Temperature approaching critical threshold',
        confidence: 90.0,
        estimatedTimeframe: '2-4 hours',
        severity: PredictionSeverity.critical,
        recommendation: 'Activate cooling system, reduce lighting, check water source temperature',
        affectedSensor: 'Temperature',
      ));
    }

    // Check dissolved oxygen approach to danger zone
    final doValues = models.map((m) => m.dissolvedOxygen).toList();
    final avgDo = doValues.reduce((a, b) => a + b) / doValues.length;

    if (avgDo < 4.0 && avgDo > 2.0) {
      predictions.add(PredictionData(
        riskDescription: 'Dissolved oxygen approaching critical level',
        confidence: 85.0,
        estimatedTimeframe: '1-3 hours',
        severity: PredictionSeverity.moderate,
        recommendation: 'Increase aeration gradually, monitor closely for fish stress',
        affectedSensor: 'Dissolved Oxygen',
      ));
    }
  } catch (_) {
    // Analysis error
  }

  return predictions;
}

List<PredictionData> _analyzeOperationalIssues(
  List<Map<String, dynamic>> hourlyStats,
) {
  final predictions = <PredictionData>[];

  if (hourlyStats.length < 6) return predictions;

  try {
    // Check for stagnant data (all values identical)
    final tempAvgs = hourlyStats
        .map((h) => (h['temp_avg'] as num?)?.toDouble() ?? 0.0)
        .toList();

    final allIdentical = tempAvgs.every((v) => v == tempAvgs.first);

    if (allIdentical) {
      predictions.add(PredictionData(
        riskDescription:
            'Sensor may be malfunctioning - all readings identical',
        confidence: 90.0,
        estimatedTimeframe: 'immediately',
        severity: PredictionSeverity.moderate,
        recommendation:
            'Power cycle device, verify sensor connections, check for stuck probe',
        affectedSensor: 'Sensor System',
      ));
    }
  } catch (_) {
    // Analysis error
  }

  return predictions;
}

double _calculateTrend(List<double> values) {
  if (values.length < 2) return 0.0;

  double sum = 0.0;
  for (int i = 1; i < values.length; i++) {
    sum += values[i] - values[i - 1];
  }

  return sum / (values.length - 1);
}
