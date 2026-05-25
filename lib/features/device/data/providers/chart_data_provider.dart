import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/providers/chart_range.dart';
import 'analytics_repository_provider.dart';

part 'chart_data_provider.g.dart';

@riverpod
class ChartDataProvider extends _$ChartDataProvider {
  @override
  Future<List<Map<String, dynamic>>> build(
    String pondId,
    String deviceId,
    ChartRange range,
  ) {
    final repository = ref.watch(analyticsRepositoryProvider);
    return repository.getChartData(
      pondId: pondId,
      deviceId: deviceId,
      range: range,
    );
  }
}
