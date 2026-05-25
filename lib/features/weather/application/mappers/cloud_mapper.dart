import '../../domain/models/cloud_model.dart';

CloudModel mapCloud(Map<String, dynamic> data) {
  return CloudModel(
    coverage: data['clouds']['all'],
    windSpeed: (data['wind']['speed'] as num).toDouble(),
    windDeg: (data['wind']['deg'] as num).toDouble(),
  );
}
