import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/alerts_provider.dart';

class AlertsScreen extends ConsumerWidget {
  final String pondId;
  final String deviceId;

  const AlertsScreen({super.key, required this.pondId, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(realtimeAlertsProvider(pondId));

    final countsAsync = ref.watch(alertCountsProvider(pondId));

    return Scaffold(
      backgroundColor: const Color(0xFF020817),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ////////////////////////////////////////////////////////////
              /// HEADER
              ////////////////////////////////////////////////////////////
              Text(
                'Alerts',

                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Realtime monitoring and incident management',

                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              ////////////////////////////////////////////////////////////
              /// STATS
              ////////////////////////////////////////////////////////////
              countsAsync.when(
                loading: () => const SizedBox(),

                error: (_, __) => const SizedBox(),

                data: (counts) {
                  return Row(
                    children: [
                      Expanded(
                        child: _miniCard(
                          title: 'Critical',
                          value: counts['critical']?.toString() ?? '0',
                          color: Colors.redAccent,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _miniCard(
                          title: 'Warnings',
                          value: counts['warning']?.toString() ?? '0',
                          color: Colors.orangeAccent,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _miniCard(
                          title: 'Resolved',
                          value: counts['resolved']?.toString() ?? '0',
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 34),

              ////////////////////////////////////////////////////////////
              /// TITLE ROW
              ////////////////////////////////////////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    'Active Incidents',

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.94),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  _liveBadge(),
                ],
              ),

              const SizedBox(height: 22),

              ////////////////////////////////////////////////////////////
              /// ALERTS
              ////////////////////////////////////////////////////////////
              alertsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (e, _) => Center(
                  child: Text(
                    e.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

                data: (alerts) {
                  if (alerts.isEmpty) {
                    return _emptyState();
                  }

                  return Column(
                    children: alerts.map((alert) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),

                        child: _alertCard(context: context, alert: alert),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// ALERT CARD
  ////////////////////////////////////////////////////////////

  Widget _alertCard({
    required BuildContext context,
    required Map<String, dynamic> alert,
  }) {
    final type = alert['alert_type']?.toString().toLowerCase() ?? '';

    final parameter = alert['parameter']?.toString().toLowerCase() ?? '';

    final color = _severityColor(type);

    final icon = _parameterIcon(parameter);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: Container(
          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.015),
              ],
            ),

            border: Border.all(color: Colors.white.withOpacity(0.08)),

            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ////////////////////////////////////////////////////////////
              /// ICON
              ////////////////////////////////////////////////////////////
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.14),

                  border: Border.all(color: color.withOpacity(0.2)),
                ),

                child: Icon(icon, color: color, size: 28),
              ),

              const SizedBox(width: 18),

              ////////////////////////////////////////////////////////////
              /// CONTENT
              ////////////////////////////////////////////////////////////
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ////////////////////////////////////////////////////////
                    /// TOP ROW
                    ////////////////////////////////////////////////////////
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert['message'] ?? 'Unknown alert',

                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),

                        _severityChip(type, color),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ////////////////////////////////////////////////////////
                    /// VALUE
                    ////////////////////////////////////////////////////////
                    Text(
                      'Value: ${alert['value'] ?? '--'}',

                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ////////////////////////////////////////////////////////
                    /// FOOTER
                    ////////////////////////////////////////////////////////
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: Colors.white.withOpacity(0.4),
                          size: 16,
                        ),

                        const SizedBox(width: 8),

                        Text(
                          _formatTime(alert['created_at']),

                          style: TextStyle(
                            color: Colors.white.withOpacity(0.42),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// MINI CARD
  ////////////////////////////////////////////////////////////

  Widget _miniCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: Container(
          constraints: const BoxConstraints(minHeight: 150),

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
            ),

            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                value,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: color,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                title,

                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white.withOpacity(0.72),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// EMPTY STATE
  ////////////////////////////////////////////////////////////

  Widget _emptyState() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(40),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.03),

        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),

      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.greenAccent.withOpacity(0.08),
            ),

            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.greenAccent,
              size: 42,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'No active alerts',

            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'All systems operating normally.',

            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// LIVE BADGE
  ////////////////////////////////////////////////////////////

  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        color: Colors.greenAccent.withOpacity(0.12),

        border: Border.all(color: Colors.greenAccent.withOpacity(0.22)),
      ),

      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,

            decoration: const BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            'LIVE',

            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// CHIP
  ////////////////////////////////////////////////////////////

  Widget _severityChip(String type, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),

        color: color.withOpacity(0.12),

        border: Border.all(color: color.withOpacity(0.18)),
      ),

      child: Text(
        type.toUpperCase(),

        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// COLOR
  ////////////////////////////////////////////////////////////

  Color _severityColor(String type) {
    switch (type) {
      case 'critical':
        return Colors.redAccent;

      case 'warning':
        return Colors.orangeAccent;

      default:
        return Colors.cyanAccent;
    }
  }

  ////////////////////////////////////////////////////////////
  /// ICON
  ////////////////////////////////////////////////////////////

  IconData _parameterIcon(String parameter) {
    switch (parameter) {
      case 'temperature':
        return Icons.thermostat_rounded;

      case 'ph':
        return Icons.science_rounded;

      case 'dissolved_oxygen':
        return Icons.water_drop_rounded;

      default:
        return Icons.warning_amber_rounded;
    }
  }

  ////////////////////////////////////////////////////////////
  /// TIME
  ////////////////////////////////////////////////////////////

  String _formatTime(dynamic raw) {
    if (raw == null) {
      return '--';
    }

    final dt = DateTime.parse(raw.toString()).toLocal();

    return DateFormat('MMM d • h:mm a').format(dt);
  }
}
