import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:aquaguard/core/responsive/responsive_helper.dart';

import 'package:aquaguard/core/widgets/adaptive_loading.dart';
import 'package:aquaguard/core/widgets/adaptive_scroll_view.dart';
import 'package:aquaguard/core/widgets/adaptive_sensor_card.dart';
import 'package:aquaguard/core/widgets/adaptive_status_indicator.dart';

import 'package:aquaguard/features/device/presentation/providers/device_dashboard_provider.dart';

import 'package:aquaguard/features/device/presentation/widgets/ai_predictions_widget.dart';
import 'package:aquaguard/features/device/presentation/widgets/animated_water_level_hero_card.dart';
import 'package:aquaguard/features/device/presentation/widgets/premium_sensor_chart.dart';
import 'package:aquaguard/features/device/presentation/widgets/recent_alerts_widget.dart';
import 'package:aquaguard/features/device/presentation/widgets/time_range_selector.dart';

class OverviewScreen extends ConsumerWidget {
  final String pondId;
  final String deviceId;
  final String? deviceName;

  const OverviewScreen({
    super.key,
    required this.pondId,
    required this.deviceId,
    this.deviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////
    /// PROVIDERS
    ////////////////////////////////////////////////////////////

    final liveDataAsync = ref.watch(liveSensorDataProvider(pondId, deviceId));

    final selectedRange = ref.watch(selectedRangeProvider);

    ////////////////////////////////////////////////////////////
    /// RESPONSIVE
    ////////////////////////////////////////////////////////////

    final isMobile = ResponsiveHelper.isMobile(context);

    ////////////////////////////////////////////////////////////
    /// MAIN
    ////////////////////////////////////////////////////////////

    return AdaptiveScrollView(
      useSafeArea: false,
      bounce: true,

      children: [
        ////////////////////////////////////////////////////////
        /// HERO CARD
        ////////////////////////////////////////////////////////
        liveDataAsync.when(
          data: (data) {
            debugPrint('HERO LIVE DATA => $data');

            final hasCriticalState =
                data.temperature > 34 ||
                data.temperature < 18 ||
                data.ph > 9 ||
                data.ph < 5 ||
                data.dissolvedOxygen < 3 ||
                data.waterLevel < 20;

            final hasWarningState =
                !hasCriticalState &&
                (data.temperature > 30 ||
                    data.temperature < 22 ||
                    data.ph > 8 ||
                    data.ph < 6 ||
                    data.dissolvedOxygen < 5 ||
                    data.waterLevel < 40);

            return Column(
              children: [
                //////////////////////////////////////////////////////////
                /// COMPACT ALERT CHIP
                //////////////////////////////////////////////////////////
                if (hasCriticalState || hasWarningState)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,

                        end: Alignment.bottomRight,

                        colors: [
                          hasCriticalState
                              ? Colors.red.withValues(alpha: 0.14)
                              : Colors.orange.withValues(alpha: 0.12),

                          Colors.white.withValues(alpha: 0.02),
                        ],
                      ),

                      border: Border.all(
                        color: hasCriticalState
                            ? Colors.red.withValues(alpha: 0.18)
                            : Colors.orange.withValues(alpha: 0.16),
                      ),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,

                          color: hasCriticalState
                              ? Colors.redAccent
                              : Colors.orangeAccent,

                          size: 20,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            hasCriticalState
                                ? 'Critical telemetry instability detected'
                                : 'Moderate telemetry deviations detected',

                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),

                              fontWeight: FontWeight.w600,

                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (hasCriticalState || hasWarningState)
                  SizedBox(height: isMobile ? 18 : 24),

                //////////////////////////////////////////////////////////
                /// HERO
                //////////////////////////////////////////////////////////
                AnimatedWaterLevelHeroCard(
                  key: ValueKey(data.lastUpdate),

                  waterLevel: data.waterLevel.toDouble(),

                  aiRisk: hasCriticalState
                      ? 92
                      : hasWarningState
                      ? 58
                      : 14,

                  isOnline: true,

                  deviceName: deviceName ?? 'AquaGuard Device',
                ),
              ],
            );
          },

          loading: () => _buildHeroSkeleton(),

          error: (e, st) {
            debugPrint('HERO ERROR => $e');

            return _buildHeroSkeleton();
          },
        ),

        SizedBox(height: isMobile ? 24 : 34),

        ////////////////////////////////////////////////////////
        /// SENSOR HEADER
        ////////////////////////////////////////////////////////
        _buildSectionHeader(
          title: 'Realtime Sensors',

          subtitle: 'Realtime aquatic telemetry',

          isMobile: isMobile,
        ),

        SizedBox(height: isMobile ? 18 : 24),

        ////////////////////////////////////////////////////////
        /// SENSOR GRID
        ////////////////////////////////////////////////////////
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isMobile
                ? ((constraints.maxWidth - 20) / 2).toDouble()
                : 280.0;

            return Wrap(
              spacing: 20,
              runSpacing: 20,

              children: [
                SizedBox(
                  width: cardWidth,

                  child: _buildTemperatureCard(liveDataAsync),
                ),

                SizedBox(width: cardWidth, child: _buildPhCard(liveDataAsync)),

                SizedBox(width: cardWidth, child: _buildDoCard(liveDataAsync)),

                SizedBox(
                  width: cardWidth,

                  child: _buildWaterCard(liveDataAsync),
                ),
              ],
            );
          },
        ),

        SizedBox(height: isMobile ? 26 : 40),

        ////////////////////////////////////////////////////////
        /// ANALYTICS
        ////////////////////////////////////////////////////////
        _buildSectionHeader(
          title: 'Sensor Analytics',

          subtitle: 'Realtime and historical telemetry insights',

          isMobile: isMobile,
        ),

        SizedBox(height: isMobile ? 18 : 24),

        ////////////////////////////////////////////////////////
        /// RANGE SELECTOR
        ////////////////////////////////////////////////////////
        TimeRangeSelector(
          selectedRange: selectedRange,

          onRangeChanged: (range) {
            ref.read(selectedRangeProvider.notifier).change(range);
          },
        ),

        SizedBox(height: isMobile ? 20 : 28),

        ////////////////////////////////////////////////////////
        /// CHART
        ////////////////////////////////////////////////////////
        PremiumSensorChart(
          key: ValueKey(selectedRange),
          pondId: pondId,
          deviceId: deviceId,
        ),

        SizedBox(height: isMobile ? 26 : 40),

        ////////////////////////////////////////////////////////
        /// AI
        ////////////////////////////////////////////////////////
        _buildSectionHeader(
          title: 'AI Forecast Intelligence',

          subtitle: 'Machine learning powered aquatic intelligence',

          isMobile: isMobile,
        ),

        SizedBox(height: isMobile ? 18 : 24),

        const AiPredictionsWidget(),

        SizedBox(height: isMobile ? 26 : 40),

        ////////////////////////////////////////////////////////
        /// ALERTS
        ////////////////////////////////////////////////////////
        _buildSectionHeader(
          title: 'Recent Alerts',

          subtitle: 'Latest telemetry activity',

          isMobile: isMobile,
        ),

        SizedBox(height: isMobile ? 18 : 24),

        const RecentAlertsWidget(),

        SizedBox(height: isMobile ? 70 : 110),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// TEMPERATURE CARD
  ////////////////////////////////////////////////////////////

  Widget _buildTemperatureCard(AsyncValue<dynamic> async) {
    return async.when(
      data: (data) {
        debugPrint('TEMP DATA => $data');

        return AdaptiveSensorCard(
          title: 'Temperature',

          value: data.temperature.toStringAsFixed(1),

          unit: '°C',

          icon: Icons.thermostat,

          color: Colors.orange,

          status: _getTemperatureStatus(data.temperature),

          trend: 'Stable',
        );
      },

      loading: () => const AdaptiveLoading(compact: true),

      error: (e, st) {
        debugPrint('TEMP ERROR => $e');

        return const AdaptiveLoading(compact: true);
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// PH CARD
  ////////////////////////////////////////////////////////////

  Widget _buildPhCard(AsyncValue<dynamic> async) {
    return async.when(
      data: (data) {
        debugPrint('PH DATA => $data');

        return AdaptiveSensorCard(
          title: 'pH Level',

          value: data.ph.toStringAsFixed(1),

          unit: 'pH',

          icon: Icons.science,

          color: Colors.purpleAccent,

          status: _getPhStatus(data.ph),

          trend: 'Optimal',
        );
      },

      loading: () => const AdaptiveLoading(compact: true),

      error: (e, st) {
        debugPrint('PH ERROR => $e');

        return const AdaptiveLoading(compact: true);
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// DO CARD
  ////////////////////////////////////////////////////////////

  Widget _buildDoCard(AsyncValue<dynamic> async) {
    return async.when(
      data: (data) {
        debugPrint('DO DATA => $data');

        return AdaptiveSensorCard(
          title: 'Dissolved Oxygen',

          value: data.dissolvedOxygen.toStringAsFixed(1),

          unit: 'mg/L',

          icon: Icons.water_drop,

          color: Colors.cyanAccent,

          status: _getDoStatus(data.dissolvedOxygen),

          trend: 'Healthy',
        );
      },

      loading: () => const AdaptiveLoading(compact: true),

      error: (e, st) {
        debugPrint('DO ERROR => $e');

        return const AdaptiveLoading(compact: true);
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// WATER CARD
  ////////////////////////////////////////////////////////////

  Widget _buildWaterCard(AsyncValue<dynamic> async) {
    return async.when(
      data: (data) {
        debugPrint('WATER DATA => $data');

        return AdaptiveSensorCard(
          title: 'Water Level',

          value: data.waterLevel.toStringAsFixed(1),

          unit: '%',

          icon: Icons.waves,

          color: Colors.blue,

          status: _getWaterStatus(data.waterLevel),

          trend: 'Normal',
        );
      },

      loading: () => const AdaptiveLoading(compact: true),

      error: (e, st) {
        debugPrint('WATER ERROR => $e');

        return const AdaptiveLoading(compact: true);
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// HERO SKELETON
  ////////////////////////////////////////////////////////////

  Widget _buildHeroSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.04),

      highlightColor: Colors.white.withValues(alpha: 0.10),

      child: Container(
        height: 230,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),

          gradient: LinearGradient(
            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [
              Colors.white.withValues(alpha: 0.08),

              Colors.white.withValues(alpha: 0.03),
            ],
          ),

          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// SECTION HEADER
  ////////////////////////////////////////////////////////////

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: TextStyle(
            color: Colors.white,

            fontSize: isMobile ? 20 : 28,

            fontWeight: FontWeight.w700,

            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          subtitle,

          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.62),

            fontSize: isMobile ? 12 : 14,

            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// STATUS HELPERS
  ////////////////////////////////////////////////////////////

  static AdaptiveStatus _getTemperatureStatus(double value) {
    if (value > 34 || value < 18) {
      return AdaptiveStatus.critical;
    }

    if (value > 30 || value < 22) {
      return AdaptiveStatus.warning;
    }

    return AdaptiveStatus.healthy;
  }

  static AdaptiveStatus _getPhStatus(double value) {
    if (value < 5 || value > 9) {
      return AdaptiveStatus.critical;
    }

    if (value < 6 || value > 8) {
      return AdaptiveStatus.warning;
    }

    return AdaptiveStatus.healthy;
  }

  static AdaptiveStatus _getDoStatus(double value) {
    if (value < 3) {
      return AdaptiveStatus.critical;
    }

    if (value < 5) {
      return AdaptiveStatus.warning;
    }

    return AdaptiveStatus.healthy;
  }

  static AdaptiveStatus _getWaterStatus(double value) {
    if (value < 20) {
      return AdaptiveStatus.critical;
    }

    if (value < 40) {
      return AdaptiveStatus.warning;
    }

    return AdaptiveStatus.healthy;
  }
}
