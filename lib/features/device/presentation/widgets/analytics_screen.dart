import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aquaguard/core/responsive/responsive_helper.dart';

import 'package:aquaguard/features/device/presentation/providers/device_dashboard_provider.dart';

import 'package:aquaguard/features/device/data/providers/device_status_provider.dart';
import 'package:aquaguard/features/device/data/models/device_status_model.dart';
import 'package:aquaguard/features/device/data/models/alert_model.dart';

import 'package:aquaguard/features/device/presentation/widgets/premium_sensor_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  final String pondId;
  final String deviceId;
  final String? deviceName;

  const AnalyticsScreen({
    super.key,
    required this.pondId,
    required this.deviceId,
    this.deviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final liveAsync = ref.watch(liveSensorDataProvider(pondId, deviceId));

    final alertsAsync = ref.watch(deviceAlertsProvider(pondId, deviceId));

    final statusAsync = ref.watch(deviceStatusProviderProvider(deviceId));

    final screenWidth = MediaQuery.of(context).size.width;

    final pageWidth = screenWidth > 1400 ? 1400.0 : screenWidth;

    final isWide = screenWidth > 1000;

    final leftWidth = isWide ? pageWidth - 390 : pageWidth;

    final leftPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroHealthCard(
          liveAsync: liveAsync,
          alertsAsync: alertsAsync,
          statusAsync: statusAsync,
        ),

        const SizedBox(height: 18),

        _SensorGrid(
          pondId: pondId,
          deviceId: deviceId,
          width: leftWidth,
          isMobile: isMobile,
        ),

        const SizedBox(height: 18),

        PremiumSensorChart(pondId: pondId, deviceId: deviceId),

        const SizedBox(height: 18),

        _AIInsightsCard(pondId: pondId, deviceId: deviceId),
      ],
    );

    final rightPanel = Column(
      children: [
        _AlertSummaryCard(alertsAsync: alertsAsync),

        const SizedBox(height: 14),

        _DeviceStatusCard(statusAsync: statusAsync),
      ],
    );

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 28,
          vertical: 18,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: pageWidth),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: leftWidth, child: leftPanel),

                      const SizedBox(width: 18),

                      SizedBox(width: 360, child: rightPanel),
                    ],
                  )
                : Column(
                    children: [
                      leftPanel,

                      const SizedBox(height: 18),

                      rightPanel,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HERO HEALTH CARD
////////////////////////////////////////////////////////////

class _HeroHealthCard extends StatelessWidget {
  final AsyncValue liveAsync;
  final AsyncValue<List<AlertModel>> alertsAsync;
  final AsyncValue<DeviceStatusModel?> statusAsync;

  const _HeroHealthCard({
    required this.liveAsync,
    required this.alertsAsync,
    required this.statusAsync,
  });

  @override
  Widget build(BuildContext context) {
    return liveAsync.when(
      data: (live) {
        final alerts = alertsAsync.maybeWhen(data: (a) => a, orElse: () => []);

        final criticalCount = alerts
            .where((e) => e.priority.toLowerCase().contains('critical'))
            .length;

        final online = statusAsync.maybeWhen(
          data: (s) => s?.isOnline ?? false,
          orElse: () => false,
        );

        final score =
            (((live.dissolvedOxygen / 10) * 30) +
                    (((14 - (live.ph - 7).abs()) / 14) * 25) +
                    (((100 - (live.temperature - 25).abs()) / 100) * 25) +
                    ((live.waterLevel / 100) * 20))
                .clamp(0, 100);

        final status = score > 75
            ? 'Healthy'
            : score > 50
            ? 'Warning'
            : 'Critical';

        final statusColor = score > 75
            ? Colors.greenAccent
            : score > 50
            ? Colors.amber
            : Colors.redAccent;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: [
                Colors.cyan.withOpacity(0.16),
                Colors.blue.withOpacity(0.04),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Pond Status',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: statusColor.withOpacity(0.14),
                    ),
                    child: Text(
                      '${score.toInt()}%',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                criticalCount > 0
                    ? '$criticalCount critical alerts require attention'
                    : 'All pond conditions are stable',
                style: TextStyle(
                  color: criticalCount > 0
                      ? Colors.redAccent
                      : Colors.greenAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _miniMetric('Temperature', '${live.temperature} °C'),

                  _miniMetric('DO', '${live.dissolvedOxygen} mg/L'),

                  _miniMetric('pH', '${live.ph}'),

                  _miniMetric('Device', online ? 'Online' : 'Offline'),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          Text('Error: $e', style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _miniMetric(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SENSOR GRID
////////////////////////////////////////////////////////////

class _SensorGrid extends ConsumerWidget {
  final String pondId;
  final String deviceId;
  final double width;
  final bool isMobile;

  const _SensorGrid({
    required this.pondId,
    required this.deviceId,
    required this.width,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(liveSensorDataProvider(pondId, deviceId));

    return liveAsync.when(
      data: (live) {
        final sensors = [
          _SensorCardData(
            title: 'Temperature',
            value: '${live.temperature} °C',
            safeRange: '18 - 30',
            health: _healthTemperature(live.temperature.toDouble()),
          ),

          _SensorCardData(
            title: 'Dissolved Oxygen',
            value: '${live.dissolvedOxygen} mg/L',
            safeRange: '5 - 12',
            health: _healthDO(live.dissolvedOxygen.toDouble()),
          ),

          _SensorCardData(
            title: 'pH',
            value: '${live.ph}',
            safeRange: '6.5 - 8.5',
            health: _healthPH(live.ph.toDouble()),
          ),

          _SensorCardData(
            title: 'Water Level',
            value: '${live.waterLevel}%',
            safeRange: '30 - 100',
            health: live.waterLevel.toDouble(),
          ),
        ];

        final itemWidth = isMobile ? width : (width - 14) / 2;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: sensors.map((s) {
            return SizedBox(
              width: itemWidth,
              child: _SensorCard(data: s),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          Text('Error: $e', style: const TextStyle(color: Colors.red)),
    );
  }

  double _healthTemperature(double value) {
    return (100 - ((value - 25).abs() * 4)).clamp(0, 100);
  }

  double _healthDO(double value) {
    return ((value / 12) * 100).clamp(0, 100);
  }

  double _healthPH(double value) {
    return (100 - ((value - 7).abs() * 20)).clamp(0, 100);
  }
}

class _SensorCardData {
  final String title;
  final String value;
  final String safeRange;
  final double health;

  _SensorCardData({
    required this.title,
    required this.value,
    required this.safeRange,
    required this.health,
  });
}

class _SensorCard extends StatelessWidget {
  final _SensorCardData data;

  const _SensorCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data.health > 75
        ? 'Normal'
        : data.health > 45
        ? 'Warning'
        : 'Critical';

    final color = data.health > 75
        ? Colors.greenAccent
        : data.health > 45
        ? Colors.amber
        : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: data.health / 100,
                  strokeWidth: 6,
                  color: color,
                  backgroundColor: Colors.white.withOpacity(0.06),
                ),

                Text(
                  '${data.health.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  data.value,
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 10,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      'Safe: ${data.safeRange}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// AI INSIGHTS
////////////////////////////////////////////////////////////

class _AIInsightsCard extends ConsumerWidget {
  final String pondId;
  final String deviceId;

  const _AIInsightsCard({required this.pondId, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(liveSensorDataProvider(pondId, deviceId));

    return liveAsync.when(
      data: (live) {
        final insights = <String>[];

        if (live.temperature > 32) {
          insights.add('Temperature unsafe for shrimp farming.');
        }

        if (live.dissolvedOxygen < 4) {
          insights.add('Low oxygen detected. Aeration recommended.');
        }

        if (live.waterLevel < 30) {
          insights.add('Water level critically low.');
        }

        if (live.ph < 6.5 || live.ph > 8.5) {
          insights.add('pH outside optimal aquaculture range.');
        }

        if (insights.isEmpty) {
          insights.add('All pond conditions are stable.');
        }

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 14),

              ...insights.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.cyanAccent,
                        size: 18,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          Text('Error: $e', style: const TextStyle(color: Colors.red)),
    );
  }
}

////////////////////////////////////////////////////////////
/// ALERT SUMMARY
////////////////////////////////////////////////////////////

class _AlertSummaryCard extends StatelessWidget {
  final AsyncValue<List<AlertModel>> alertsAsync;

  const _AlertSummaryCard({required this.alertsAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: alertsAsync.when(
        data: (alerts) {
          final critical = alerts
              .where((e) => e.priority.toLowerCase().contains('critical'))
              .length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alert Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _alertMetric(
                      'Total',
                      '${alerts.length}',
                      Colors.cyanAccent,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _alertMetric(
                      'Critical',
                      '$critical',
                      Colors.redAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Text(
                'Recent Alerts',
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 10),

              if (alerts.isEmpty)
                const Text(
                  'No active alerts',
                  style: TextStyle(color: Colors.white70),
                ),

              ...alerts.take(5).map((a) {
                final color = a.priority.toLowerCase().contains('critical')
                    ? Colors.redAccent
                    : Colors.amber;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: color, size: 18),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.alertType,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              a.message,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            Text('Error: $e', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _alertMetric(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.08),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// DEVICE STATUS
////////////////////////////////////////////////////////////

class _DeviceStatusCard extends StatelessWidget {
  final AsyncValue<DeviceStatusModel?> statusAsync;

  const _DeviceStatusCard({required this.statusAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: statusAsync.when(
        data: (s) {
          final online = s?.isOnline ?? false;

          return Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: online ? Colors.greenAccent : Colors.redAccent,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      online ? 'Device Online' : 'Device Offline',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Last synced: ${s?.lastSeen ?? ''}',
                      style: TextStyle(color: Colors.white.withOpacity(0.65)),
                    ),
                  ],
                ),
              ),

              Text(
                '${s?.batteryLevel ?? 0}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            Text('Error: $e', style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// COMMON CARD STYLE
////////////////////////////////////////////////////////////

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(22),
    color: Colors.white.withOpacity(0.03),
    border: Border.all(color: Colors.white.withOpacity(0.05)),
  );
}
