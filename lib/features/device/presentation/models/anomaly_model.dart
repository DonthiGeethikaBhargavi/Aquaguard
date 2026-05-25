enum AnomalySeverity { low, moderate, critical }

class AnomalyModel {
  final String id;
  final String title;
  final String parameter;
  final String message;
  final AnomalySeverity severity;
  final double confidence;
  final DateTime timestamp;
  final String recommendation;

  const AnomalyModel({
    required this.id,
    required this.title,
    required this.parameter,
    required this.message,
    required this.severity,
    required this.confidence,
    required this.timestamp,
    required this.recommendation,
  });

  factory AnomalyModel.fromMap(Map<String, dynamic> map) {
    final alertType = (map['alert_type']?.toString() ?? '').toLowerCase();
    final severity = alertType.contains('critical')
        ? AnomalySeverity.critical
        : alertType.contains('warning')
        ? AnomalySeverity.moderate
        : AnomalySeverity.low;

    final timestamp = map['created_at'] is DateTime
        ? map['created_at'] as DateTime
        : DateTime.tryParse(map['created_at']?.toString() ?? '') ??
              DateTime.now();

    return AnomalyModel(
      id: map['id']?.toString() ?? timestamp.microsecondsSinceEpoch.toString(),
      title: map['message']?.toString() ?? 'Operational anomaly detected',
      parameter: map['parameter']?.toString() ?? 'Telemetry',
      message: map['message']?.toString() ?? 'Anomaly detected',
      severity: severity,
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      timestamp: timestamp,
      recommendation:
          map['recommendation']?.toString() ?? 'Review latest alert details.',
    );
  }
}
