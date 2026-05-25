import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:aquaguard/features/device/data/models/alert_model.dart';
import 'package:aquaguard/features/device/presentation/providers/device_dashboard_provider.dart';

class NotificationScreen extends ConsumerWidget {
  final String pondId;
  final String deviceId;

  const NotificationScreen({
    super.key,
    required this.pondId,
    required this.deviceId,
  });

  ////////////////////////////////////////////////////////////
  /// TIME FORMAT
  ////////////////////////////////////////////////////////////

  String _formatTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(deviceAlertsProvider(pondId, deviceId));

    ////////////////////////////////////////////////////////////
    /// AUTO MARK READ
    ////////////////////////////////////////////////////////////

    Future.microtask(() async {
      await Supabase.instance.client
          .from('alerts')
          .update({'is_read': true})
          .eq('device_id', deviceId)
          .eq('is_read', false);
    });

    return Scaffold(
      backgroundColor: const Color(0xFF020817),

      body: Stack(
        children: [
          _background(),

          SafeArea(
            child: Column(
              children: [
                _header(context),

                Expanded(
                  child: alertsAsync.when(
                    //////////////////////////////////////////////////////////
                    /// DATA
                    //////////////////////////////////////////////////////////
                    data: (alerts) {
                      final criticalCount = alerts.where((e) {
                        return e.priority == 3;
                      }).length;

                      final unreadCount = alerts.where((e) {
                        return !(e.isRead);
                      }).length;

                      ////////////////////////////////////////////////////////
                      /// EMPTY
                      ////////////////////////////////////////////////////////

                      if (alerts.isEmpty) {
                        return _emptyState();
                      }

                      ////////////////////////////////////////////////////////
                      /// CONTENT
                      ////////////////////////////////////////////////////////

                      return Column(
                        children: [
                          _statsRow(criticalCount, unreadCount, alerts.length),

                          const SizedBox(height: 14),

                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                left: 18,
                                right: 18,
                                bottom: 40,
                              ),

                              itemCount: alerts.length,

                              itemBuilder: (context, index) {
                                final alert = alerts[index];

                                final isCritical = alert.priority == 3;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),

                                  child: Dismissible(
                                    key: ValueKey(alert.id),

                                    direction: DismissDirection.endToStart,

                                    background: Container(
                                      alignment: Alignment.centerRight,

                                      padding: const EdgeInsets.only(right: 24),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(28),

                                        color: Colors.redAccent.withOpacity(
                                          .18,
                                        ),
                                      ),

                                      child: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.redAccent,
                                      ),
                                    ),

                                    onDismissed: (_) async {
                                      await Supabase.instance.client
                                          .from('alerts')
                                          .delete()
                                          .eq('id', alert.id);
                                    },

                                    child: _NotificationCard(
                                      title: _title(alert),

                                      message: alert.message,

                                      time: _formatTime(alert.createdAt),

                                      icon: _icon(alert),

                                      color: _color(alert),

                                      critical: isCritical,

                                      unread: !(alert.isRead),

                                      value: alert.value.toStringAsFixed(1),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },

                    //////////////////////////////////////////////////////////
                    /// LOADING
                    //////////////////////////////////////////////////////////
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        ),
                      );
                    },

                    //////////////////////////////////////////////////////////
                    /// ERROR
                    //////////////////////////////////////////////////////////
                    error: (e, st) {
                      return Center(
                        child: Text(
                          e.toString(),

                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// BACKGROUND
  ////////////////////////////////////////////////////////////

  Widget _background() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -120,

          child: Container(
            width: 320,
            height: 320,

            decoration: const BoxDecoration(
              shape: BoxShape.circle,

              gradient: RadialGradient(
                colors: [Color(0xFF0EA5E9), Colors.transparent],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -160,
          right: -140,

          child: Container(
            width: 360,
            height: 360,

            decoration: const BoxDecoration(
              shape: BoxShape.circle,

              gradient: RadialGradient(
                colors: [Color(0xFF06B6D4), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// HEADER
  ////////////////////////////////////////////////////////////

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              height: 48,
              width: 48,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.white.withOpacity(.06),

                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),

              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 18),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Notifications',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Realtime telemetry alerts',

                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () async {
              await Supabase.instance.client
                  .from('alerts')
                  .delete()
                  .eq('device_id', deviceId);
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),

                color: Colors.redAccent.withOpacity(.12),

                border: Border.all(color: Colors.redAccent.withOpacity(.18)),
              ),

              child: const Icon(
                Icons.delete_sweep_rounded,
                color: Colors.redAccent,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// STATS
  ////////////////////////////////////////////////////////////

  Widget _statsRow(int critical, int unread, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      child: Row(
        children: [
          Expanded(
            child: _statCard('Critical', critical.toString(), Colors.redAccent),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _statCard('Unread', unread.toString(), Colors.cyanAccent),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _statCard('Total', total.toString(), Colors.orangeAccent),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            color: Colors.white.withOpacity(.05),

            border: Border.all(color: Colors.white.withOpacity(.06)),
          ),

          child: Column(
            children: [
              Text(
                value,

                style: TextStyle(
                  color: color,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                label,

                style: TextStyle(
                  color: Colors.white.withOpacity(.55),

                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// EMPTY
  ////////////////////////////////////////////////////////////

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 74,
            color: Colors.white.withOpacity(.28),
          ),

          const SizedBox(height: 18),

          const Text(
            'No alerts yet',

            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Realtime pond alerts appear here',

            style: TextStyle(color: Colors.white.withOpacity(.45)),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// HELPERS
  ////////////////////////////////////////////////////////////

  static String _title(AlertModel alert) {
    if (alert.parameter == 'do') {
      return 'DISSOLVED OXYGEN';
    }

    return alert.parameter.replaceAll('_', ' ').toUpperCase();
  }

  static IconData _icon(AlertModel alert) {
    final p = alert.parameter.toLowerCase();

    if (p.contains('temperature')) {
      return Icons.thermostat_rounded;
    }

    if (p.contains('do') || p.contains('oxygen')) {
      return Icons.water_drop_rounded;
    }

    if (p.contains('water')) {
      return Icons.waves_rounded;
    }

    if (p.contains('ph')) {
      return Icons.science_rounded;
    }

    return Icons.notifications_active_rounded;
  }

  static Color _color(AlertModel alert) {
    final priority = alert.priority.toString().toLowerCase();

    ////////////////////////////////////////////////////////////
    /// CRITICAL
    ////////////////////////////////////////////////////////////

    if (priority.contains('3') || priority.contains('critical')) {
      return const Color(0xFFFF4D6D);
    }

    ////////////////////////////////////////////////////////////
    /// WARNING
    ////////////////////////////////////////////////////////////

    if (priority.contains('2') || priority.contains('warning')) {
      return const Color(0xFFFFB020);
    }

    ////////////////////////////////////////////////////////////
    /// INFO
    ////////////////////////////////////////////////////////////

    return const Color(0xFF22D3EE);
  }
}

////////////////////////////////////////////////////////////
/// CARD
////////////////////////////////////////////////////////////

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String value;

  final IconData icon;

  final Color color;

  final bool critical;
  final bool unread;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.critical,
    required this.unread,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

        child: Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),

            color: Colors.white.withOpacity(.05),

            border: Border.all(
              color: critical
                  ? Colors.redAccent.withOpacity(.35)
                  : color.withOpacity(.22),
            ),

            boxShadow: critical
                ? [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(.14),

                      blurRadius: 24,
                    ),
                  ]
                : [],
          ),

          child: Row(
            children: [
              //////////////////////////////////////////////////////
              /// ICON
              //////////////////////////////////////////////////////
              Container(
                height: 58,
                width: 58,

                decoration: BoxDecoration(
                  color: color.withOpacity(.14),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(icon, color: color),
              ),

              const SizedBox(width: 16),

              //////////////////////////////////////////////////////
              /// CONTENT
              //////////////////////////////////////////////////////
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,

                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        if (unread)
                          Container(
                            height: 10,
                            width: 10,

                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.cyanAccent,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      message,

                      style: TextStyle(
                        color: Colors.white.withOpacity(.68),

                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        //////////////////////////////////////////////////////
                        /// SEVERITY CHIP
                        //////////////////////////////////////////////////////
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),

                            color: critical
                                ? Colors.redAccent.withOpacity(.15)
                                : Colors.orangeAccent.withOpacity(.15),
                          ),

                          child: Text(
                            critical ? 'CRITICAL' : 'WARNING',

                            style: TextStyle(
                              color: critical
                                  ? Colors.redAccent
                                  : Colors.orangeAccent,

                              fontWeight: FontWeight.w700,

                              fontSize: 11,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        //////////////////////////////////////////////////////
                        /// VALUE CHIP
                        //////////////////////////////////////////////////////
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),

                            color: color.withOpacity(.12),
                          ),

                          child: Text(
                            value,

                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,

                              fontSize: 12,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Text(
                          time,

                          style: TextStyle(
                            color: Colors.white.withOpacity(.38),

                            fontSize: 12,
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
}
