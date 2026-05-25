import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aquaguard/core/responsive/responsive_helper.dart';
import 'package:aquaguard/features/device/presentation/providers/chart_range.dart';
import 'package:aquaguard/features/device/presentation/providers/device_dashboard_provider.dart';

class PremiumSensorChart extends ConsumerStatefulWidget {
  final String pondId;
  final String deviceId;

  const PremiumSensorChart({
    super.key,
    required this.pondId,
    required this.deviceId,
  });

  @override
  ConsumerState<PremiumSensorChart> createState() => _PremiumSensorChartState();
}

class _PremiumSensorChartState extends ConsumerState<PremiumSensorChart> {
  ////////////////////////////////////////////////////////////
  /// RANGE
  ////////////////////////////////////////////////////////////

  ChartRange selectedRange = ChartRange.hour;

  ////////////////////////////////////////////////////////////
  /// METRICS
  ////////////////////////////////////////////////////////////

  final Set<String> selectedMetrics = {'temperature', 'ph', 'do'};

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    ////////////////////////////////////////////////////////////
    /// FETCH
    ////////////////////////////////////////////////////////////

    final tempAsync = ref.watch(
      telemetryChartProvider(
        widget.pondId,
        widget.deviceId,
        selectedRange,
        'temperature',
      ),
    );

    final phAsync = ref.watch(
      telemetryChartProvider(
        widget.pondId,
        widget.deviceId,
        selectedRange,
        'ph',
      ),
    );

    final doAsync = ref.watch(
      telemetryChartProvider(
        widget.pondId,
        widget.deviceId,
        selectedRange,
        'do',
      ),
    );

    ////////////////////////////////////////////////////////////
    /// LOADING
    ////////////////////////////////////////////////////////////

    if (tempAsync.isLoading || phAsync.isLoading || doAsync.isLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    ////////////////////////////////////////////////////////////
    /// ERROR
    ////////////////////////////////////////////////////////////

    if (tempAsync.hasError || phAsync.hasError || doAsync.hasError) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: const Text(
          'Failed to load telemetry',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    ////////////////////////////////////////////////////////////
    /// SAFE DATA
    ////////////////////////////////////////////////////////////

    final safeTemp = (tempAsync.value ?? [])
        .where((e) => e.isFinite && e > 0)
        .map((e) => e.toDouble())
        .toList();

    final safePh = (phAsync.value ?? [])
        .where((e) => e.isFinite && e > 0)
        .map((e) => e.toDouble())
        .toList();

    final safeDo = (doAsync.value ?? [])
        .where((e) => e.isFinite && e > 0)
        .map((e) => e.toDouble())
        .toList();

    ////////////////////////////////////////////////////////////
    /// DEBUG
    ////////////////////////////////////////////////////////////

    print('TEMP => $safeTemp');
    print('PH => $safePh');
    print('DO => $safeDo');

    ////////////////////////////////////////////////////////////
    /// MAX LENGTH
    ////////////////////////////////////////////////////////////

    final maxLength = [
      safeTemp.length,
      safePh.length,
      safeDo.length,
    ].reduce((a, b) => a > b ? a : b);

    ////////////////////////////////////////////////////////////
    /// EMPTY
    ////////////////////////////////////////////////////////////

    if (maxLength == 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: const Center(
          child: Text(
            'No telemetry data available',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    ////////////////////////////////////////////////////////////
    /// CHART RANGE
    ////////////////////////////////////////////////////////////

    final allValues = [...safeTemp, ...safePh, ...safeDo];

    final minChartY = allValues.isEmpty ? 0 : allValues.reduce(min);

    final maxChartY = allValues.isEmpty ? 100 : allValues.reduce(max);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////
          /// TITLE
          //////////////////////////////////////////////////////
          const Text(
            'Telemetry Trends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          //////////////////////////////////////////////////////
          /// RANGE
          //////////////////////////////////////////////////////
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ChartRange.values.map((range) {
                final selected = selectedRange == range;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRange = range;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.cyanAccent.withAlpha(30)
                            : Colors.white.withAlpha(8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? Colors.cyanAccent
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        range.label,
                        style: TextStyle(
                          color: selected ? Colors.cyanAccent : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          //////////////////////////////////////////////////////
          /// CHIPS
          //////////////////////////////////////////////////////
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _metricChip('temperature', 'Temp', Colors.orange),

              _metricChip('ph', 'pH', Colors.greenAccent),

              _metricChip('do', 'DO', Colors.cyanAccent),
            ],
          ),

          const SizedBox(height: 26),

          //////////////////////////////////////////////////////
          /// CHART
          //////////////////////////////////////////////////////
          AspectRatio(
            aspectRatio: isMobile ? 1.2 : 2.2,
            child: LineChart(
              LineChartData(
                minX: 0,

                maxX: maxLength <= 1 ? 1 : (maxLength - 1).toDouble(),

                minY: minChartY - 2,

                maxY: maxChartY + 2,

                //////////////////////////////////////////////////
                /// GRID
                //////////////////////////////////////////////////
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxChartY - minChartY) <= 0
                      ? 1
                      : (maxChartY - minChartY) / 5,
                  getDrawingHorizontalLine: (_) {
                    return FlLine(
                      color: Colors.white.withAlpha(10),
                      strokeWidth: 1,
                    );
                  },
                ),

                //////////////////////////////////////////////////
                /// BORDER
                //////////////////////////////////////////////////
                borderData: FlBorderData(show: false),

                //////////////////////////////////////////////////
                /// TITLES
                //////////////////////////////////////////////////
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: (maxChartY - minChartY) <= 0
                          ? 1
                          : (maxChartY - minChartY) / 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,

                      interval: selectedRange == ChartRange.hour
                          ? 4
                          : selectedRange == ChartRange.day
                          ? 4
                          : selectedRange == ChartRange.week
                          ? 2
                          : 5,

                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _formatBottomLabel(value.toInt()),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                //////////////////////////////////////////////////
                /// TOUCH
                //////////////////////////////////////////////////
                lineTouchData: LineTouchData(
                  enabled: true,

                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 16,

                    getTooltipColor: (_) => Colors.black87,

                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          spot.y.toStringAsFixed(1),
                          TextStyle(
                            color: spot.bar.color,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),

                //////////////////////////////////////////////////
                /// LINES
                //////////////////////////////////////////////////
                lineBarsData: [
                  if (selectedMetrics.contains('temperature'))
                    _lineData(safeTemp, Colors.orange),

                  if (selectedMetrics.contains('ph'))
                    _lineData(safePh, Colors.greenAccent),

                  if (selectedMetrics.contains('do'))
                    _lineData(safeDo, Colors.cyanAccent),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          //////////////////////////////////////////////////////
          /// LEGEND
          //////////////////////////////////////////////////////
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: [
              if (selectedMetrics.contains('temperature'))
                _legend('Temperature', Colors.orange),

              if (selectedMetrics.contains('ph'))
                _legend('pH', Colors.greenAccent),

              if (selectedMetrics.contains('do'))
                _legend('DO', Colors.cyanAccent),
            ],
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// LINE
  ////////////////////////////////////////////////////////////

  LineChartBarData _lineData(List<double> values, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,

      dotData: FlDotData(show: false),

      belowBarData: BarAreaData(show: true, color: color.withAlpha(20)),

      spots: List.generate(
        values.length,
        (index) => FlSpot(index.toDouble(), values[index]),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// CHIP
  ////////////////////////////////////////////////////////////

  Widget _metricChip(String metric, String label, Color color) {
    final selected = selectedMetrics.contains(metric);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            selectedMetrics.remove(metric);
          } else {
            selectedMetrics.add(metric);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(25) : Colors.white.withAlpha(8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : Colors.white.withAlpha(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 10, color: color),

            const SizedBox(width: 8),

            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// LEGEND
  ////////////////////////////////////////////////////////////

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 8),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// LABELS
  ////////////////////////////////////////////////////////////

  String _formatBottomLabel(int index) {
    if (selectedRange == ChartRange.hour) {
      final hour = (DateTime.now().hour + index) % 24;

      final suffix = hour >= 12 ? 'PM' : 'AM';

      final displayHour = hour == 0
          ? 12
          : hour > 12
          ? hour - 12
          : hour;

      return '$displayHour$suffix';
    }

    if (selectedRange == ChartRange.day) {
      return '${index}h';
    }

    if (selectedRange == ChartRange.week) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      return days[index % 7];
    }

    return 'D$index';
  }

  ////////////////////////////////////////////////////////////
  /// CARD
  ////////////////////////////////////////////////////////////

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(30),

      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withAlpha(12), Colors.white.withAlpha(5)],
      ),

      border: Border.all(color: Colors.white.withAlpha(15)),
    );
  }
}
