enum PredictionSeverity { low, moderate, high }

class PredictionModel {
  final String id;
  final String title;
  final String detail;
  final double confidence;
  final String timeframe;
  final PredictionSeverity severity;
  final String recommendation;
  final String parameter;

  const PredictionModel({
    required this.id,
    required this.title,
    required this.detail,
    required this.confidence,
    required this.timeframe,
    required this.severity,
    required this.recommendation,
    required this.parameter,
  });

  factory PredictionModel.fromMap(Map<String, dynamic> map) {
    final rawSeverity = map['severity']?.toString().toLowerCase() ?? 'low';
    final severity = rawSeverity.contains('high')
        ? PredictionSeverity.high
        : rawSeverity.contains('medium')
        ? PredictionSeverity.moderate
        : PredictionSeverity.low;

    return PredictionModel(
      id:
          map['title']?.toString().hashCode.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: map['title']?.toString() ?? 'Prediction available',
      detail:
          map['detail']?.toString() ?? map['riskDescription']?.toString() ?? '',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      timeframe: map['estimatedTimeframe']?.toString() ?? 'Soon',
      severity: severity,
      recommendation:
          map['recommendation']?.toString() ?? 'Investigate sensor data.',
      parameter: map['sensor']?.toString() ?? 'System',
    );
  }
}
