import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiInsightsProvider = Provider.family<String, Map<String, dynamic>>((
  ref,
  data,
) {
  final temp = data['temperature'] ?? 0;
  final ph = data['ph'] ?? 0;
  final doVal = data['dissolved_oxygen'] ?? 0;

  if (temp > 32) {
    return "⚠️ Water temperature is high. Fish stress risk.";
  }

  if (ph < 6.5 || ph > 8.5) {
    return "⚠️ pH imbalance detected. Adjust immediately.";
  }

  if (doVal < 5) {
    return "🚨 Low oxygen level. Aeration required.";
  }

  return "✅ Water quality is stable and safe.";
});
