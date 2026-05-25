import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/ai_thresholds.dart';
import '../../data/models/ai_insight_model.dart';
import '../../presentation/providers/chart_range.dart';

abstract class AnalyticsRepository {
  Future<Map<String, dynamic>> getTelemetrySummary({
    required String pondId,
    required String deviceId,
  });

  Future<List<Map<String, dynamic>>> getChartData({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  });

  Future<List<Map<String, dynamic>>> getSensorHealth({
    required String pondId,
    required String deviceId,
  });

  Future<List<Map<String, dynamic>>> getAnomalyTimeline({
    required String pondId,
  });

  Future<Map<String, int>> getAlertDistribution({required String pondId});

  Future<double> getStabilityScore({required String pondId});

  Future<List<AiInsightModel>> getAiInsights({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  });

  Future<List<Map<String, dynamic>>> getPredictiveAlerts({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  });

  Future<Map<String, dynamic>> getSystemEfficiency({required String pondId});

  Future<String> exportTelemetryCsv({
    required String pondId,
    required ChartRange range,
  });

  Future<String> exportAlertHistoryCsv({required String pondId});

  Future<List<Map<String, dynamic>>> comparePonds({required String pondId});

  Future<void> logAnalyticsEvent({
    required String event,
    required Map<String, dynamic> details,
  });
}

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final SupabaseClient supabase;

  AnalyticsRepositoryImpl(this.supabase);

  @override
  Future<Map<String, dynamic>> getTelemetrySummary({
    required String pondId,
    required String deviceId,
  }) async {
    final latestResponse = await supabase
        .from('latest_readings')
        .select()
        .eq('device_id', deviceId)
        .maybeSingle();

    final latest = latestResponse is Map<String, dynamic>
        ? latestResponse
        : <String, dynamic>{};

    final recent = await supabase
        .from('hourly_stats')
        .select('temp_avg,do_avg,ph_avg')
        .eq('pond_id', pondId)
        .order('hour', ascending: false)
        .limit(24);

    final temperatureAverage = _rollingAverage(recent, 'temp_avg');
    final oxygenAverage = _rollingAverage(recent, 'do_avg');
    final phAverage = _rollingAverage(recent, 'ph_avg');

    final activeAlerts = await _countActiveAlerts(pondId);
    final stabilityScore = await getStabilityScore(pondId: pondId);

    return {
      'temperatureAverage': temperatureAverage,
      'oxygenAverage': oxygenAverage,
      'phAverage': phAverage,
      'activeAlerts': activeAlerts,
      'stabilityScore': stabilityScore,
      'liveTemperature': _toDouble(latest['temperature']),
      'liveOxygen': _toDouble(latest['dissolved_oxygen']),
      'livePh': _toDouble(latest['ph']),
      'liveWaterLevel': _toDouble(latest['water_level']),
      'lastUpdate': latest['last_update'] != null
          ? DateTime.tryParse(latest['last_update'].toString())
          : null,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getChartData({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  }) async {
    switch (range) {
      case ChartRange.hour:
        return _fetchTableData('hourly_stats', 'hour', pondId, limit: 24);
      case ChartRange.day:
        return _fetchTableData('daily_stats', 'day', pondId, limit: 30);
      case ChartRange.week:
        return _fetchTableData('weekly_stats', 'week', pondId, limit: 7);
      case ChartRange.month:
        return _fetchTableData('monthly_stats', 'month', pondId, limit: 12);
      case ChartRange.year:
        return _fetchTableData('yearly_stats', 'year', pondId);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSensorHealth({
    required String pondId,
    required String deviceId,
  }) async {
    final latestResponse = await supabase
        .from('latest_readings')
        .select()
        .eq('device_id', deviceId)
        .maybeSingle();

    final latest = latestResponse is Map<String, dynamic>
        ? latestResponse
        : <String, dynamic>{};

    final alerts = await supabase
        .from('alerts_history')
        .select('parameter,alert_type,created_at')
        .eq('pond_id', pondId)
        .order('created_at', ascending: false)
        .limit(50);

    final now = DateTime.now();
    final lastUpdate = latest['last_update'] != null
        ? DateTime.tryParse(latest['last_update'].toString())
        : null;

    final elapsedMinutes = lastUpdate != null
        ? now.difference(lastUpdate).inMinutes
        : 999;
    final isDelayed = elapsedMinutes > 3;

    final countsByParameter = <String, int>{};
    for (final item in alerts) {
      final parameter = item['parameter']?.toString() ?? 'unknown';
      countsByParameter[parameter] = (countsByParameter[parameter] ?? 0) + 1;
    }

    return [
      _buildHealthEntry(
        title: 'Temperature',
        unit: '°C',
        value: _toDouble(latest['temperature']),
        safeRange: [AIThresholds.tempNormalMin, AIThresholds.tempNormalMax],
        alerts: countsByParameter['temperature'] ?? 0,
        isDelayed: isDelayed,
      ),
      _buildHealthEntry(
        title: 'Dissolved Oxygen',
        unit: 'mg/L',
        value: _toDouble(latest['dissolved_oxygen']),
        safeRange: [AIThresholds.doNormalMin, AIThresholds.doNormalMax],
        alerts: countsByParameter['dissolved_oxygen'] ?? 0,
        isDelayed: isDelayed,
      ),
      _buildHealthEntry(
        title: 'pH',
        unit: 'pH',
        value: _toDouble(latest['ph']),
        safeRange: [AIThresholds.phNormalMin, AIThresholds.phNormalMax],
        alerts: countsByParameter['ph'] ?? 0,
        isDelayed: isDelayed,
      ),
      _buildHealthEntry(
        title: 'Water Level',
        unit: '%',
        value: _toDouble(latest['water_level']),
        safeRange: [
          AIThresholds.waterLevelNormalMin,
          AIThresholds.waterLevelNormalMax,
        ],
        alerts: countsByParameter['water_level'] ?? 0,
        isDelayed: isDelayed,
      ),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getAnomalyTimeline({
    required String pondId,
  }) async {
    final response = await supabase
        .from('alerts_history')
        .select('created_at,parameter,alert_type,message,value')
        .eq('pond_id', pondId)
        .order('created_at', ascending: false)
        .limit(8);

    return List<Map<String, dynamic>>.from(response).map((row) {
      final createdAt = row['created_at'] != null
          ? DateTime.tryParse(row['created_at'].toString())
          : null;
      final parameter = row['parameter']?.toString() ?? 'Telemetry';
      final alertType = row['alert_type']?.toString() ?? 'ALERT';
      final message =
          row['message']?.toString() ?? 'Operational anomaly detected';
      final value = row['value'] != null ? _toDouble(row['value']) : null;

      return {
        'timestamp': createdAt,
        'label': _formatAnomalyLabel(parameter, alertType),
        'message': message,
        'parameter': parameter,
        'value': value,
      };
    }).toList();
  }

  @override
  Future<Map<String, int>> getAlertDistribution({
    required String pondId,
  }) async {
    final response = await supabase
        .from('alerts_history')
        .select('parameter')
        .eq('pond_id', pondId);

    final counts = <String, int>{};
    for (final row in response) {
      final parameter = row['parameter']?.toString() ?? 'unknown';
      counts[parameter] = (counts[parameter] ?? 0) + 1;
    }

    return counts;
  }

  @override
  Future<double> getStabilityScore({required String pondId}) async {
    final alerts = await supabase
        .from('alerts_history')
        .select('alert_type,created_at,resolved_at')
        .eq('pond_id', pondId)
        .order('created_at', ascending: false)
        .limit(100);

    final unresolved = alerts.where((row) => row['resolved_at'] == null).length;
    final critical = alerts
        .where((row) => row['alert_type'] == 'CRITICAL')
        .length;
    final warning = alerts
        .where((row) => row['alert_type'] == 'WARNING')
        .length;

    final recentStats = await supabase
        .from('hourly_stats')
        .select('temp_min,temp_max,do_min,do_max,ph_min,ph_max')
        .eq('pond_id', pondId)
        .order('hour', ascending: false)
        .limit(24);

    final tempVolatility = _rangeAverage(recentStats, 'temp_max', 'temp_min');
    final oxygenVolatility = _rangeAverage(recentStats, 'do_max', 'do_min');
    final phVolatility = _rangeAverage(recentStats, 'ph_max', 'ph_min');

    final alertPenalty =
        (critical * 3.5) + (warning * 1.8) + (unresolved * 2.2);
    final volatilityPenalty =
        (tempVolatility * 1.1) +
        (oxygenVolatility * 2.4) +
        (phVolatility * 4.2);
    final rawScore = 100 - (alertPenalty + volatilityPenalty);

    return rawScore.clamp(18.0, 98.0);
  }

  @override
  Future<List<AiInsightModel>> getAiInsights({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  }) async {
    final chart = await getChartData(
      pondId: pondId,
      deviceId: deviceId,
      range: range,
    );

    final latestResponse = await supabase
        .from('latest_readings')
        .select('temperature,dissolved_oxygen,ph,water_level')
        .eq('device_id', deviceId)
        .maybeSingle();

    final latest = latestResponse is Map<String, dynamic>
        ? latestResponse
        : <String, dynamic>{};

    final temperature = _toDouble(latest['temperature']);
    final oxygen = _toDouble(latest['dissolved_oxygen']);
    final ph = _toDouble(latest['ph']);
    final waterLevel = _toDouble(latest['water_level']);

    final tempChange = _rangeChange(chart, 'temp_avg');
    final doChange = _rangeChange(chart, 'do_avg');
    final phChange = _rangeChange(chart, 'ph_avg');

    final insights = <AiInsightModel>[];

    if (temperature > AIThresholds.tempNormalMax ||
        temperature < AIThresholds.tempNormalMin) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'Temperature outside optimal band',
          description:
              'Latest temperature is ${temperature.toStringAsFixed(1)}°C, outside the normal ${AIThresholds.tempNormalMin.toStringAsFixed(1)}°C–${AIThresholds.tempNormalMax.toStringAsFixed(1)}°C range.',
          type: AiInsightType.warning,
          severity: AiInsightSeverity.high,
          confidence: 0.9,
          recommendation:
              'Check heating/cooling circuits and validate sensor calibration.',
        ),
      );
    }

    if (oxygen < AIThresholds.doNormalMin) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'Dissolved oxygen below healthy levels',
          description:
              'Current DO is ${oxygen.toStringAsFixed(2)} mg/L, below safe baseline of ${AIThresholds.doNormalMin.toStringAsFixed(1)} mg/L.',
          type: AiInsightType.warning,
          severity: AiInsightSeverity.high,
          confidence: 0.93,
          recommendation:
              'Inspect aeration and water circulation systems immediately.',
        ),
      );
    }

    if (ph < AIThresholds.phNormalMin || ph > AIThresholds.phNormalMax) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'pH drift detected',
          description:
              'Latest pH is ${ph.toStringAsFixed(2)}, outside the preferred ${AIThresholds.phNormalMin.toStringAsFixed(2)}–${AIThresholds.phNormalMax.toStringAsFixed(2)} range.',
          type: AiInsightType.anomaly,
          severity: AiInsightSeverity.medium,
          confidence: 0.82,
          recommendation:
              'Review buffering and feeding schedule, and consider gradual corrective dosing.',
        ),
      );
    }

    if (waterLevel < AIThresholds.waterLevelNormalMin) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'Water level is low',
          description:
              'Water level is ${waterLevel.toStringAsFixed(1)}%, below the healthy threshold of ${AIThresholds.waterLevelNormalMin.toStringAsFixed(0)}%.',
          type: AiInsightType.warning,
          severity: AiInsightSeverity.high,
          confidence: 0.88,
          recommendation:
              'Verify inlet valves and top-up systems to restore optimal volume.',
        ),
      );
    }

    if (doChange < -2.0) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'DO declining trend',
          description:
              'Dissolved oxygen has declined by ${doChange.abs().toStringAsFixed(1)}% over ${range.fullLabel}.',
          type: AiInsightType.prediction,
          severity: AiInsightSeverity.medium,
          confidence: 0.81,
          recommendation:
              'Monitor aeration closely and prepare corrective action if the trend continues.',
        ),
      );
    }

    if (phChange.abs() > 0.5) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'pH variability increasing',
          description:
              'pH has shifted by ${phChange.toStringAsFixed(2)} units over ${range.fullLabel}.',
          type: AiInsightType.anomaly,
          severity: AiInsightSeverity.medium,
          confidence: 0.76,
          recommendation:
              'Check feeding and buffering patterns to prevent chemical swings.',
        ),
      );
    }

    if (tempChange.abs() < 1.5 &&
        doChange.abs() < 1.5 &&
        phChange.abs() < 0.25) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'Telemetry remains stable',
          description:
              'Temperature, DO, and pH are tracking within expected operational baselines.',
          type: AiInsightType.recommendation,
          severity: AiInsightSeverity.low,
          confidence: 0.82,
          recommendation:
              'Continue with standard monitoring cadence and log any system changes.',
        ),
      );
    }

    if (insights.isEmpty) {
      insights.add(
        _buildInsight(
          pondId: pondId,
          deviceId: deviceId,
          title: 'No immediate risks detected',
          description:
              'Current telemetry is within normal operational thresholds and trends are stable.',
          type: AiInsightType.recommendation,
          severity: AiInsightSeverity.low,
          confidence: 0.7,
        ),
      );
    }

    insights.sort((a, b) => b.confidence.compareTo(a.confidence));
    return insights;
  }

  @override
  Future<List<Map<String, dynamic>>> getPredictiveAlerts({
    required String pondId,
    required String deviceId,
    required ChartRange range,
  }) async {
    final chart = await getChartData(
      pondId: pondId,
      deviceId: deviceId,
      range: range,
    );

    final tempSlope = _trendSlope(chart, 'temp_avg');
    final doSlope = _trendSlope(chart, 'do_avg');
    final phSlope = _trendSlope(chart, 'ph_avg');
    final tempChange = _rangeChange(chart, 'temp_avg');
    final doChange = _rangeChange(chart, 'do_avg');
    final phChange = _rangeChange(chart, 'ph_avg');

    final latestReading = await supabase
        .from('latest_readings')
        .select('temperature,dissolved_oxygen,ph,water_level,last_update')
        .eq('device_id', deviceId)
        .maybeSingle();

    final temperature = _toDouble(latestReading?['temperature']);
    final oxygen = _toDouble(latestReading?['dissolved_oxygen']);
    final ph = _toDouble(latestReading?['ph']);
    final waterLevel = _toDouble(latestReading?['water_level']);

    final activeAlerts = await supabase
        .from('alerts')
        .select('parameter')
        .eq('pond_id', pondId)
        .eq('is_resolved', false);

    final activeByParameter = <String, int>{};
    for (final row in activeAlerts) {
      final parameter = row['parameter']?.toString() ?? 'unknown';
      activeByParameter[parameter] = (activeByParameter[parameter] ?? 0) + 1;
    }

    final suggestions = <Map<String, dynamic>>[];

    if (tempSlope.abs() > 1.0 &&
        temperature > AIThresholds.tempNormalMax - 0.5) {
      suggestions.add({
        'title': 'Temperature acceleration exceeds baseline',
        'detail':
            'Temperature is rising faster than historical bounds over ${range.fullLabel}.',
        'confidence': (65 + tempSlope.abs() * 8).clamp(65, 92),
        'severity': 'High',
      });
    }

    if (doSlope < -0.75 && oxygen < AIThresholds.doNormalMin + 1.2) {
      suggestions.add({
        'title': 'DO recovery slope weakening',
        'detail':
            'Dissolved oxygen is losing ground while remaining below safe baselines.',
        'confidence': (62 + (doSlope.abs() * 10)).clamp(62, 90),
        'severity': 'High',
      });
    }

    if (phSlope.abs() > 0.3 &&
        (ph < AIThresholds.phNormalMin || ph > AIThresholds.phNormalMax)) {
      suggestions.add({
        'title': 'pH volatility increasing',
        'detail': 'pH shows abnormal drift and may destabilize pond chemistry.',
        'confidence': (60 + phSlope.abs() * 12).clamp(60, 88),
        'severity': 'Medium',
      });
    }

    if (waterLevel < 35) {
      suggestions.add({
        'title': 'Water level degradation detected',
        'detail': 'Water level remains low and historical recovery is slow.',
        'confidence': 84,
        'severity': 'High',
      });
    }

    if (activeByParameter.isNotEmpty) {
      final dominantActive = activeByParameter.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final parameter = dominantActive.first.key
          .replaceAll('_', ' ')
          .toUpperCase();
      final count = dominantActive.first.value;
      suggestions.add({
        'title': 'Persistent $parameter alerts',
        'detail':
            '$count active unresolved alerts show sustained operational risk.',
        'confidence': (58 + count * 6).clamp(58, 92),
        'severity': 'Medium',
      });
    }

    if (tempChange.abs() < 2 && doChange.abs() < 5 && phChange.abs() < 0.4) {
      suggestions.add({
        'title': 'Telemetry remains operational',
        'detail':
            'Temperature, DO, and pH are tracking within expected variance ranges.',
        'confidence': 78,
        'severity': 'Low',
      });
    }

    if (suggestions.isEmpty) {
      suggestions.add({
        'title': 'No critical anomalies detected',
        'detail':
            'Realtime telemetry does not currently show a sustained operational risk.',
        'confidence': 70,
        'severity': 'Low',
      });
    }

    return suggestions;
  }

  @override
  Future<Map<String, dynamic>> getSystemEfficiency({
    required String pondId,
  }) async {
    final alerts = await supabase
        .from('alerts_history')
        .select('created_at,resolved_at,is_resolved')
        .eq('pond_id', pondId);

    final resolved = alerts.where((row) => row['is_resolved'] == true).toList();
    final total = alerts.length;

    final averageResolution = resolved.isEmpty
        ? 0.0
        : resolved
                  .map((row) {
                    final created = DateTime.tryParse(
                      row['created_at'].toString(),
                    );
                    final resolvedAt = DateTime.tryParse(
                      row['resolved_at'].toString(),
                    );
                    return created != null && resolvedAt != null
                        ? resolvedAt.difference(created).inMinutes.toDouble()
                        : 0.0;
                  })
                  .fold<double>(0, (sum, value) => sum + value) /
              resolved.length;

    final resolutionRate = total == 0 ? 1.0 : resolved.length / total;
    final activeStability =
        ((1 - ((total - resolved.length) / (total == 0 ? 1 : total))) * 100)
            .clamp(0, 100);
    final recoveryScore =
        ((resolutionRate * 0.4) +
            ((100 - _penaltyFromAlertCount(total - resolved.length)) /
                100 *
                0.6)) *
        100;

    return {
      'avgResolutionTime': averageResolution,
      'resolutionRate': resolutionRate * 100,
      'activeStability': activeStability,
      'recoveryScore': recoveryScore.clamp(12, 100),
    };
  }

  @override
  Future<String> exportTelemetryCsv({
    required String pondId,
    required ChartRange range,
  }) async {
    final latestResponse = await supabase
        .from('latest_readings')
        .select('temperature,dissolved_oxygen,ph,water_level,last_update')
        .eq('pond_id', pondId)
        .order('last_update', ascending: false)
        .limit(1)
        .maybeSingle();

    final latest = latestResponse is Map<String, dynamic>
        ? latestResponse
        : <String, dynamic>{};

    final data = await getChartData(pondId: pondId, deviceId: '', range: range);

    final headers = [
      'source',
      'timestamp',
      'temperature',
      'dissolved_oxygen',
      'ph',
      'water_level',
    ];

    final rows = <String>[];

    if (latest.isNotEmpty) {
      rows.add(
        [
          'current_snapshot',
          latest['last_update'] ?? '',
          _toString(latest['temperature']),
          _toString(latest['dissolved_oxygen']),
          _toString(latest['ph']),
          _toString(latest['water_level']),
        ].join(','),
      );
    }

    for (final row in data) {
      final timestamp =
          row['hour'] ??
          row['day'] ??
          row['week'] ??
          row['month'] ??
          row['year'] ??
          '';
      rows.add(
        [
          'historical',
          timestamp,
          _toString(row['temp_avg']),
          _toString(row['do_avg']),
          _toString(row['ph_avg']),
          _toString(row['water_level'] ?? ''),
        ].join(','),
      );
    }

    return [headers.join(','), ...rows].join('\n');
  }

  @override
  Future<String> exportAlertHistoryCsv({required String pondId}) async {
    final historyRows = await supabase
        .from('alerts_history')
        .select(
          'id,created_at,alert_type,parameter,message,value,is_resolved,resolved_at,escalated',
        )
        .eq('pond_id', pondId)
        .order('created_at', ascending: true);

    final activeRows = await supabase
        .from('alerts')
        .select(
          'id,created_at,alert_type,parameter,message,value,is_resolved,resolved_at,escalated',
        )
        .eq('pond_id', pondId)
        .order('created_at', ascending: true);

    final seenIds = <String>{};
    final csvRows = <String>[];
    csvRows.add(
      'timestamp,type,parameter,message,value,resolved,escalated,resolved_at,source',
    );

    for (final row in [...historyRows, ...activeRows]) {
      final id =
          row['id']?.toString() ??
          '${row['created_at'] ?? ''}_${row['parameter'] ?? ''}';
      if (!seenIds.add(id)) continue;
      csvRows.add(
        [
          row['created_at'] ?? '',
          row['alert_type'] ?? '',
          row['parameter'] ?? '',
          _escapeCsv(row['message']?.toString() ?? ''),
          _toString(row['value']),
          row['is_resolved'] == true ? 'yes' : 'no',
          row['escalated'] == true ? 'yes' : 'no',
          row['resolved_at'] ?? '',
          historyRows.contains(row) ? 'history' : 'active',
        ].join(','),
      );
    }

    return csvRows.join('\n');
  }

  @override
  Future<List<Map<String, dynamic>>> comparePonds({
    required String pondId,
  }) async {
    final current = await supabase
        .from('latest_readings')
        .select()
        .eq('pond_id', pondId)
        .limit(1)
        .maybeSingle();

    final global = await supabase
        .from('latest_readings')
        .select('temperature,dissolved_oxygen,ph,water_level')
        .neq('pond_id', pondId)
        .limit(100);

    final currentValues = current is Map<String, dynamic>
        ? current
        : <String, dynamic>{};
    final globalList = List<Map<String, dynamic>>.from(global);

    final globalAverage = {
      'temperature': globalList.isEmpty
          ? 0.0
          : globalList
                    .map((row) => _toDouble(row['temperature']))
                    .reduce((a, b) => a + b) /
                globalList.length,
      'dissolvedOxygen': globalList.isEmpty
          ? 0.0
          : globalList
                    .map((row) => _toDouble(row['dissolved_oxygen']))
                    .reduce((a, b) => a + b) /
                globalList.length,
      'ph': globalList.isEmpty
          ? 0.0
          : globalList
                    .map((row) => _toDouble(row['ph']))
                    .reduce((a, b) => a + b) /
                globalList.length,
      'waterLevel': globalList.isEmpty
          ? 0.0
          : globalList
                    .map((row) => _toDouble(row['water_level']))
                    .reduce((a, b) => a + b) /
                globalList.length,
      'source': 'Peer Average',
    };

    return [
      {
        'temperature': _toDouble(currentValues['temperature']),
        'dissolvedOxygen': _toDouble(currentValues['dissolved_oxygen']),
        'ph': _toDouble(currentValues['ph']),
        'waterLevel': _toDouble(currentValues['water_level']),
        'source': 'Current Pond',
      },
      globalAverage,
    ];
  }

  @override
  Future<void> logAnalyticsEvent({
    required String event,
    required Map<String, dynamic> details,
  }) async {
    // Analytics event logging is intentionally lightweight.
    // This method can be extended to persist telemetry events in a remote audit store.
    final payload = {
      'event': event,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Keep this lightweight for mobile.
    // A production implementation should route this to a telemetry collector.
    // ignore: avoid_print
    print('ANALYTICS EVENT: $payload');
  }

  ////////////////////////////////////////////////////////////
  /// HELPERS
  ////////////////////////////////////////////////////////////

  Map<String, dynamic> _buildHealthEntry({
    required String title,
    required String unit,
    required double value,
    required List<num> safeRange,
    required int alerts,
    required bool isDelayed,
  }) {
    final status = isDelayed
        ? 'Delayed'
        : value <= 0
        ? 'Calibration Required'
        : value < safeRange[0] || value > safeRange[1]
        ? 'Unstable'
        : 'Stable';

    final trend = alerts > 0
        ? '$alerts alerts in last 24h'
        : isDelayed
        ? 'Delayed telemetry'
        : 'Within expected range';

    final confidence = isDelayed
        ? 52
        : status == 'Stable'
        ? 92
        : status == 'Unstable'
        ? 72
        : 60;

    return {
      'title': title,
      'unit': unit,
      'value': value,
      'status': status,
      'trend': trend,
      'confidence': confidence,
    };
  }

  double _rollingAverage(List<dynamic> rows, String key) {
    final values = rows
        .map((row) => _toDouble((row as Map<String, dynamic>)[key]))
        .where((value) => value.isFinite)
        .toList();

    if (values.isEmpty) {
      return 0.0;
    }

    return values.reduce((a, b) => a + b) / values.length;
  }

  double _rangeAverage(List<dynamic> rows, String maxKey, String minKey) {
    final values = rows
        .map((row) {
          final item = row as Map<String, dynamic>;
          return _toDouble(item[maxKey]) - _toDouble(item[minKey]);
        })
        .where((value) => value.isFinite)
        .toList();

    if (values.isEmpty) {
      return 0.0;
    }

    return values.reduce((a, b) => a + b) / values.length;
  }

  double _rangeChange(List<Map<String, dynamic>> values, String key) {
    if (values.length < 2) {
      return 0;
    }

    final first = _toDouble(values.first[key]);
    final last = _toDouble(values.last[key]);
    if (first == 0) {
      return 0;
    }

    return ((last - first) / (first.abs() + 0.0001)) * 100;
  }

  double _trendSlope(List<Map<String, dynamic>> values, String key) {
    if (values.length < 2) {
      return 0;
    }

    final first = _toDouble(values.first[key]);
    final last = _toDouble(values.last[key]);
    final steps = values.length - 1;
    if (steps <= 0) {
      return 0;
    }

    return (last - first) / steps;
  }

  String _formatAnomalyLabel(String parameter, String alertType) {
    final name = parameter.replaceAll('_', ' ').toUpperCase();
    final type = alertType.toLowerCase() == 'critical' ? 'Critical' : 'Warning';
    return '$name $type';
  }

  double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  String _toString(Object? value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  String _escapeCsv(String value) {
    return '"${value.replaceAll('"', '""')}"';
  }

  double _penaltyFromAlertCount(int count) {
    return (count * 1.8).clamp(0, 70).toDouble();
  }

  Future<List<Map<String, dynamic>>> _fetchTableData(
    String table,
    String sortKey,
    String pondId, {
    int? limit,
  }) async {
    final query = supabase
        .from(table)
        .select()
        .eq('pond_id', pondId)
        .order(sortKey, ascending: true);
    final response = limit != null ? await query.limit(limit) : await query;
    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> _countActiveAlerts(String pondId) async {
    final response = await supabase
        .from('alerts')
        .select('id')
        .eq('pond_id', pondId)
        .eq('is_resolved', false);
    return (response as List).length;
  }

  AiInsightModel _buildInsight({
    required String pondId,
    required String deviceId,
    required String title,
    required String description,
    required AiInsightType type,
    required AiInsightSeverity severity,
    required double confidence,
    String? recommendation,
  }) {
    return AiInsightModel(
      id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
      pondId: pondId,
      deviceId: deviceId,
      title: title,
      description: description,
      type: type,
      severity: severity,
      confidence: confidence * 100,
      recommendation: recommendation,
      timestamp: DateTime.now(),
    );
  }
}
