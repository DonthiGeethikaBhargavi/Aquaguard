import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:aquaguard/core/constants/ai_thresholds.dart';

import '../../domain/models/ai_insights_model.dart';

part 'ai_insights_provider.g.dart';

@riverpod
Stream<AIInsightsModel> aiInsights(AiInsightsRef ref, String deviceId) async* {
  final supabase = Supabase.instance.client;

  ////////////////////////////////////////////////////////////
  /// REALTIME STREAM
  ////////////////////////////////////////////////////////////

  await for (final data
      in supabase
          .from('latest_readings')
          .stream(primaryKey: ['device_id'])
          .eq('device_id', deviceId)) {
    //////////////////////////////////////////////////////////
    /// EMPTY
    //////////////////////////////////////////////////////////

    if (data.isEmpty) {
      continue;
    }

    final reading = data.first;

    //////////////////////////////////////////////////////////
    /// VALUES
    //////////////////////////////////////////////////////////

    final temp = (reading['temperature'] ?? 0).toDouble();

    final oxygen = (reading['dissolved_oxygen'] ?? 0).toDouble();

    final ph = (reading['ph'] ?? 0).toDouble();

    //////////////////////////////////////////////////////////
    /// CRITICAL DETECTION
    //////////////////////////////////////////////////////////

    final tempCritical =
        temp < AIThresholds.tempMin || temp > AIThresholds.tempMax;

    final doCritical =
        oxygen < AIThresholds.doMin || oxygen > AIThresholds.doMax;

    final phCritical = ph < AIThresholds.phMin || ph > AIThresholds.phMax;

    //////////////////////////////////////////////////////////
    /// RISK ENGINE
    //////////////////////////////////////////////////////////

    double risk = 0;

    if (tempCritical) risk += 35;

    if (doCritical) risk += 40;

    if (phCritical) risk += 25;

    //////////////////////////////////////////////////////////
    /// STABILITY
    //////////////////////////////////////////////////////////

    String stability;

    if (risk < 30) {
      stability = 'Optimal';
    } else if (risk < 70) {
      stability = 'Warning';
    } else {
      stability = 'Critical';
    }

    //////////////////////////////////////////////////////////
    /// PREDICTION ACCURACY
    //////////////////////////////////////////////////////////

    double accuracy = 96 - risk;

    if (accuracy < 50) {
      accuracy = 50;
    }

    //////////////////////////////////////////////////////////
    /// ALERT COUNT
    //////////////////////////////////////////////////////////

    final alerts = await supabase
        .from('alerts_history')
        .select()
        .eq('device_id', deviceId)
        .eq('is_resolved', false);

    //////////////////////////////////////////////////////////
    /// AI RECOMMENDATION
    //////////////////////////////////////////////////////////

    String recommendation =
        'Telemetry stable. Continue current aquaculture cycle.';

    if (doCritical) {
      recommendation =
          'Dissolved oxygen levels are critical. Increase aeration immediately.';
    } else if (tempCritical) {
      recommendation =
          'Temperature fluctuation detected. Monitor thermal stability.';
    } else if (phCritical) {
      recommendation =
          'pH imbalance detected. Adjust pond chemistry gradually.';
    }

    //////////////////////////////////////////////////////////
    /// MODEL
    //////////////////////////////////////////////////////////

    yield AIInsightsModel(
      predictionAccuracy: accuracy,
      anomaliesDetected: alerts.length,
      stability: stability,
      riskScore: risk,
      recommendation: recommendation,
      tempCritical: tempCritical,
      doCritical: doCritical,
      phCritical: phCritical,
    );
  }
}
