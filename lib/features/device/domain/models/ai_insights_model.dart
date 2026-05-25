class AIInsightsModel {
  final double predictionAccuracy;

  final int anomaliesDetected;

  final String stability;

  final double riskScore;

  final String recommendation;

  final bool tempCritical;

  final bool doCritical;

  final bool phCritical;

  const AIInsightsModel({
    required this.predictionAccuracy,
    required this.anomaliesDetected,
    required this.stability,
    required this.riskScore,
    required this.recommendation,
    required this.tempCritical,
    required this.doCritical,
    required this.phCritical,
  });
}
