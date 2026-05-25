import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/telemetry_point.dart';
import '../providers/chart_range.dart';

class TelemetryTrendsChart extends StatelessWidget {
  final AsyncValue<List<TelemetryPoint>> chartAsync;
  final ChartRange range;
  final ValueChanged<ChartRange> onRangeChanged;

  const TelemetryTrendsChart({
    super.key,
    required this.chartAsync,
    required this.range,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Realtime Trends',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Actual telemetry patterns with projected performance.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: ChartRange.values.map((option) {
                  final selected = option == range;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(option.label),
                      selected: selected,
                      onSelected: (_) => onRangeChanged(option),
                      selectedColor: Colors.cyanAccent.withOpacity(0.18),
                      backgroundColor: Colors.white.withOpacity(0.06),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 320,
            child: chartAsync.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                      'No historical telemetry available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return LineChart(_buildChart(data));
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.cyan),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Chart unavailable',
                  style: TextStyle(color: Colors.white.withOpacity(0.75)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChart(List<TelemetryPoint> points) {
    final temperature = points
        .map((point) => point.temperature)
        .whereType<double>()
        .toList();
    final oxygen = points
        .map((point) => point.dissolvedOxygen)
        .whereType<double>()
        .toList();
    final ph = points.map((point) => point.ph).whereType<double>().toList();
    final water = points
        .map((point) => point.waterLevel)
        .whereType<double>()
        .toList();

    final maxValue = [
      ...temperature,
      ...oxygen,
      ...ph,
      ...water,
      10.0,
    ].fold<double>(0, (previous, value) => value > previous ? value : previous);

    final minValue = [...temperature, ...oxygen, ...ph, ...water, 0.0]
        .fold<double>(double.infinity, (previous, value) {
          return value < previous ? value : previous;
        });

    final baseline = minValue * 0.95;

    return LineChartData(
      minY: baseline,
      maxY: maxValue * 1.08,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxValue - baseline) / 4,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.white.withOpacity(0.08), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: (maxValue - baseline) / 4,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(0),
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        if (temperature.isNotEmpty)
          _lineBarData(
            points,
            (point) => point.temperature,
            Colors.orangeAccent,
          ),
        if (oxygen.isNotEmpty)
          _lineBarData(
            points,
            (point) => point.dissolvedOxygen,
            Colors.cyanAccent,
          ),
        if (ph.isNotEmpty)
          _lineBarData(points, (point) => point.ph, Colors.purpleAccent),
        if (water.isNotEmpty)
          _lineBarData(
            points,
            (point) => point.waterLevel,
            Colors.lightBlueAccent,
          ),
      ],
    );
  }

  LineChartBarData _lineBarData(
    List<TelemetryPoint> points,
    double? Function(TelemetryPoint) selector,
    Color color,
  ) {
    final dataPoints = points
        .asMap()
        .entries
        .map((entry) {
          final value = selector(entry.value);
          return value == null ? null : FlSpot(entry.key.toDouble(), value);
        })
        .whereType<FlSpot>()
        .toList();

    return LineChartBarData(
      isCurved: true,
      spots: dataPoints,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.14)),
    );
  }
}
