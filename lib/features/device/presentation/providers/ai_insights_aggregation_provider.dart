import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'anomaly_detection_provider.dart';
import 'prediction_engine_provider.dart';

part 'ai_insights_aggregation_provider.g.dart';

////////////////////////////////////////////////////////////
/// AI INSIGHT SEVERITY ENUM
////////////////////////////////////////////////////////////

enum AiInsightSeverity { low, moderate, critical }

////////////////////////////////////////////////////////////
/// AI INSIGHT TYPE ENUM
////////////////////////////////////////////////////////////

enum AiInsightType { anomaly, prediction, recommendation }

////////////////////////////////////////////////////////////
/// AI INSIGHT MODEL
////////////////////////////////////////////////////////////

class AiInsight {
  final String title;
  final String description;
  final AiInsightSeverity severity;
  final String action;
  final AiInsightType type;
  final double? confidence;
  final DateTime timestamp;

  AiInsight({
    required this.title,
    required this.description,
    required this.severity,
    required this.action,
    required this.type,
    this.confidence,
    required this.timestamp,
  });
}

////////////////////////////////////////////////////////////
/// AI INSIGHTS AGGREGATION PROVIDER
////////////////////////////////////////////////////////////

@riverpod
Future<List<AiInsight>> aiInsightsAggregation(
  AiInsightsAggregationRef ref,
  String pondId,
  String deviceId,
) async {
  final insights = <AiInsight>[];

  try {
    // Fetch anomalies
    final anomalies = await ref.watch(
      anomalyDetectionProvider(pondId, deviceId).future,
    );

    // Fetch predictions
    final predictions = await ref.watch(
      predictionEngineProvider(pondId, deviceId).future,
    );

    // Convert anomalies to AI insights
    for (final anomaly in anomalies) {
      final severity = _mapAnomalySeverity(anomaly.severity);
      final title = _formatAnomalyTitle(anomaly.anomalyType);
      final description = _formatAnomalyDescription(
        anomaly.anomalyType,
        anomaly.operationalImpact,
        anomaly.repeatCount,
      );

      insights.add(AiInsight(
        title: title,
        description: description,
        severity: severity,
        action: anomaly.operationalImpact,
        type: AiInsightType.anomaly,
        confidence: null,
        timestamp: anomaly.firstDetected,
      ));
    }

    // Convert predictions to AI insights
    for (final prediction in predictions) {
      final severity = _mapPredictionSeverity(prediction.severity);
      final title = _formatPredictionTitle(prediction.riskDescription);

      insights.add(AiInsight(
        title: title,
        description: prediction.riskDescription,
        severity: severity,
        action: prediction.recommendation,
        type: AiInsightType.prediction,
        confidence: prediction.confidence,
        timestamp: DateTime.now(),
      ));
    }

    // Sort by severity (critical first) and confidence (high first)
    insights.sort((a, b) {
      // Sort by severity first
      final severityOrder = {
        AiInsightSeverity.critical: 0,
        AiInsightSeverity.moderate: 1,
        AiInsightSeverity.low: 2,
      };

      final aOrder = severityOrder[a.severity] ?? 3;
      final bOrder = severityOrder[b.severity] ?? 3;

      if (aOrder != bOrder) return aOrder.compareTo(bOrder);

      // Then by confidence (high first)
      if (a.confidence != null && b.confidence != null) {
        return b.confidence!.compareTo(a.confidence!);
      }

      // Then by timestamp (recent first)
      return b.timestamp.compareTo(a.timestamp);
    });

    // Filter duplicates by title
    final seen = <String>{};
    final filtered = <AiInsight>[];

    for (final insight in insights) {
      if (seen.add(insight.title)) {
        filtered.add(insight);
      }
    }

    // Return top insights (limit to prevent UI clutter)
    return filtered.take(15).toList();
  } catch (e) {
    return [];
  }
}

////////////////////////////////////////////////////////////
/// HELPER FUNCTIONS
////////////////////////////////////////////////////////////

AiInsightSeverity _mapAnomalySeverity(AnomalySeverity severity) {
  switch (severity) {
    case AnomalySeverity.critical:
      return AiInsightSeverity.critical;
    case AnomalySeverity.moderate:
      return AiInsightSeverity.moderate;
    case AnomalySeverity.low:
      return AiInsightSeverity.low;
  }
}

AiInsightSeverity _mapPredictionSeverity(PredictionSeverity severity) {
  switch (severity) {
    case PredictionSeverity.critical:
      return AiInsightSeverity.critical;
    case PredictionSeverity.moderate:
      return AiInsightSeverity.moderate;
    case PredictionSeverity.low:
      return AiInsightSeverity.low;
  }
}

String _formatAnomalyTitle(String anomalyType) {
  // Convert snake_case or camelCase to Title Case
  return anomalyType
      .replaceAllMapped(RegExp(r'(?:^|_)([a-z])'), (match) {
        return ' ${match.group(1)!.toUpperCase()}';
      })
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
        return '${match.group(1)} ${match.group(2)}';
      })
      .trim();
}

String _formatPredictionTitle(String riskDescription) {
  // Extract key words from risk description
  if (riskDescription.contains('oxygen')) {
    return 'Dissolved Oxygen Risk';
  } else if (riskDescription.contains('temperature')) {
    return 'Temperature Alert';
  } else if (riskDescription.contains('pH')) {
    return 'pH Level Alert';
  } else if (riskDescription.contains('sensor')) {
    return 'Sensor Alert';
  } else if (riskDescription.contains('alert')) {
    return 'System Alert Frequency';
  } else if (riskDescription.contains('water')) {
    return 'Water Level Alert';
  }

  return 'System Alert';
}

String _formatAnomalyDescription(
  String anomalyType,
  String operationalImpact,
  int repeatCount,
) {
  String base = operationalImpact;

  if (repeatCount > 1) {
    base += ' (Occurred $repeatCount times)';
  }

  return base;
}
