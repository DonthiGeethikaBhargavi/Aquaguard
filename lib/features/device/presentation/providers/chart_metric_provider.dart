import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChartMetric { temperature, dissolvedOxygen, ph, waterLevel }

final selectedMetricProvider = StateProvider<ChartMetric>(
  (ref) => ChartMetric.temperature,
);
