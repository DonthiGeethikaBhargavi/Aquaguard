import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'health_score_calculator_provider.dart';
import 'anomaly_detection_provider.dart';
import 'prediction_engine_provider.dart';

part 'action_recommendation_provider.g.dart';

////////////////////////////////////////////////////////////
/// ACTION PRIORITY ENUM
////////////////////////////////////////////////////////////

enum ActionPriority { high, medium, low }

////////////////////////////////////////////////////////////
/// ACTION CATEGORY ENUM
////////////////////////////////////////////////////////////

enum ActionCategory { aeration, inspection, maintenance, calibration }

////////////////////////////////////////////////////////////
/// ACTION ITEM MODEL
////////////////////////////////////////////////////////////

class ActionItem {
  final String title;
  final String description;
  final ActionPriority priority;
  final ActionCategory category;
  final String? estimatedDuration;

  ActionItem({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    this.estimatedDuration,
  });
}

////////////////////////////////////////////////////////////
/// ACTION RECOMMENDATION PROVIDER
////////////////////////////////////////////////////////////

@riverpod
Future<List<ActionItem>> actionRecommendation(
  ActionRecommendationRef ref,
  String pondId,
  String deviceId,
) async {
  final actions = <ActionItem>[];

  try {
    // Fetch health score
    final healthScore = await ref.watch(
      healthScoreCalculatorProvider(pondId, deviceId).future,
    );

    // Fetch anomalies
    final anomalies = await ref.watch(
      anomalyDetectionProvider(pondId, deviceId).future,
    );

    // Fetch predictions
    final predictions = await ref.watch(
      predictionEngineProvider(pondId, deviceId).future,
    );

    // Action based on health state
    if (healthScore.operationalState == OperationalState.critical) {
      actions.add(ActionItem(
        title: 'EMERGENCY: System in critical condition',
        description:
            'Immediate intervention required. Check for power, sensor, or equipment failures.',
        priority: ActionPriority.high,
        category: ActionCategory.inspection,
        estimatedDuration: '15 minutes',
      ));
    }

    // Actions based on anomalies
    for (final anomaly in anomalies) {
      if (anomaly.severity == AnomalySeverity.critical) {
        actions.addAll(
          _generateAnomalyActions(anomaly),
        );
      }
    }

    // Actions based on predictions
    for (final prediction in predictions) {
      if (prediction.severity == PredictionSeverity.critical) {
        actions.add(ActionItem(
          title: 'Prevent: ${prediction.riskDescription}',
          description: prediction.recommendation,
          priority: ActionPriority.high,
          category: _categorizeAction(prediction.recommendation),
          estimatedDuration: prediction.estimatedTimeframe,
        ));
      }
    }

    // Add preventive maintenance recommendations if health score is declining
    if (healthScore.operationalState == OperationalState.warning &&
        healthScore.score < 60) {
      actions.add(ActionItem(
        title: 'Schedule preventive maintenance',
        description:
            'System health is declining. Schedule equipment inspection and sensor calibration.',
        priority: ActionPriority.medium,
        category: ActionCategory.maintenance,
        estimatedDuration: '1-2 hours',
      ));
    }

    // Add sensor calibration if data quality is poor
    if (healthScore.stabilityScore < 50) {
      actions.add(ActionItem(
        title: 'Calibrate sensors',
        description:
            'Data stability is low. Perform sensor calibration to ensure accurate readings.',
        priority: ActionPriority.high,
        category: ActionCategory.calibration,
        estimatedDuration: '30 minutes',
      ));
    }

    // Add aeration recommendations if oxygen is low
    final hasOxygenIssue = anomalies.any((a) =>
        a.affectedSensor == SensorType.dissolvedOxygen &&
        a.severity == AnomalySeverity.critical);

    if (hasOxygenIssue) {
      actions.add(ActionItem(
        title: 'Increase aeration immediately',
        description:
            'Dissolved oxygen levels are critically low. Activate secondary aeration system.',
        priority: ActionPriority.high,
        category: ActionCategory.aeration,
        estimatedDuration: '5 minutes',
      ));
    }

    // Add system inspection if multiple anomalies
    if (anomalies.length > 3) {
      actions.add(ActionItem(
        title: 'Perform comprehensive system inspection',
        description:
            'Multiple anomalies detected. Conduct full system check including equipment, plumbing, and sensors.',
        priority: ActionPriority.high,
        category: ActionCategory.inspection,
        estimatedDuration: '2-3 hours',
      ));
    }

    // Sort by priority
    actions.sort((a, b) {
      final priorityOrder = {
        ActionPriority.high: 0,
        ActionPriority.medium: 1,
        ActionPriority.low: 2,
      };

      return (priorityOrder[a.priority] ?? 3)
          .compareTo(priorityOrder[b.priority] ?? 3);
    });

    // Limit to top 10 actions to prevent UI overload
    return actions.take(10).toList();
  } catch (e) {
    return [];
  }
}

////////////////////////////////////////////////////////////
/// HELPER FUNCTIONS
////////////////////////////////////////////////////////////

List<ActionItem> _generateAnomalyActions(AnomalyData anomaly) {
  final actions = <ActionItem>[];

  switch (anomaly.affectedSensor) {
    case SensorType.temperature:
      actions.add(ActionItem(
        title: 'Address temperature anomaly',
        description: anomaly.operationalImpact,
        priority: ActionPriority.high,
        category: ActionCategory.inspection,
        estimatedDuration: '20 minutes',
      ));
      break;

    case SensorType.dissolvedOxygen:
      actions.add(ActionItem(
        title: 'Increase water oxygenation',
        description:
            '${anomaly.operationalImpact} Check aeration equipment and increase pump speed.',
        priority: ActionPriority.high,
        category: ActionCategory.aeration,
        estimatedDuration: '10 minutes',
      ));
      break;

    case SensorType.ph:
      actions.add(ActionItem(
        title: 'Adjust pH levels',
        description:
            '${anomaly.operationalImpact} Test water chemistry and adjust buffering agents.',
        priority: ActionPriority.high,
        category: ActionCategory.maintenance,
        estimatedDuration: '30 minutes',
      ));
      break;

    case SensorType.waterLevel:
      actions.add(ActionItem(
        title: 'Correct water level',
        description:
            '${anomaly.operationalImpact} Add or remove water as needed.',
        priority: ActionPriority.high,
        category: ActionCategory.inspection,
        estimatedDuration: '15 minutes',
      ));
      break;
  }

  return actions;
}

ActionCategory _categorizeAction(String recommendation) {
  final rec = recommendation.toLowerCase();

  if (rec.contains('aerat') || rec.contains('pump')) {
    return ActionCategory.aeration;
  } else if (rec.contains('calibrat')) {
    return ActionCategory.calibration;
  } else if (rec.contains('inspect') || rec.contains('check')) {
    return ActionCategory.inspection;
  } else if (rec.contains('maintain') || rec.contains('replace')) {
    return ActionCategory.maintenance;
  }

  return ActionCategory.inspection;
}
