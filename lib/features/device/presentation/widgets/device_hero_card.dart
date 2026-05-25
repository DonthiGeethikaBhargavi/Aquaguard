import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

class DeviceHeroCard extends StatefulWidget {
  final double waterQuality;
  final double aiRisk;
  final bool isOnline;

  const DeviceHeroCard({
    super.key,
    required this.waterQuality,
    required this.aiRisk,
    required this.isOnline,
  });

  @override
  State<DeviceHeroCard> createState() => _DeviceHeroCardState();
}

class _DeviceHeroCardState extends State<DeviceHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;

    // Weather-aware theming
    final gradient = _getTimeBasedGradient(hour);
    final qualityColor = _getQualityColor(widget.waterQuality);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 260,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: gradient,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.3),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated particles for rain effect
                  if (_isRainTime(hour)) ..._buildRainParticles(),

                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status indicator
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: widget.isOnline
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: widget.isOnline
                                      ? [
                                          BoxShadow(
                                            color: Colors.greenAccent
                                                .withOpacity(0.6),
                                            blurRadius:
                                                8 + _pulseController.value * 4,
                                            spreadRadius:
                                                2 + _pulseController.value * 2,
                                          ),
                                        ]
                                      : null,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.isOnline ? 'LIVE' : 'OFFLINE',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Water Quality Score
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            widget.waterQuality.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w800,
                              color: qualityColor,
                              shadows: [
                                Shadow(
                                  color: qualityColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '%',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      Text(
                        'Water Quality Score',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // AI Risk Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.smart_toy_outlined,
                              color: _getRiskColor(widget.aiRisk),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI Risk: ${widget.aiRisk.toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LinearGradient _getTimeBasedGradient(int hour) {
    if (hour >= 6 && hour < 12) {
      // Morning - cyan + sky blue
      return const LinearGradient(
        colors: [Color(0xFF00D4FF), Color(0xFF0099CC), Color(0xFF0066CC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour >= 12 && hour < 17) {
      // Afternoon - aqua + warm blue
      return const LinearGradient(
        colors: [Color(0xFF00FFFF), Color(0xFF0080FF), Color(0xFF004080)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour >= 17 && hour < 21) {
      // Evening - navy + electric blue
      return const LinearGradient(
        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF1E40AF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // Night - navy + electric blue (darker)
      return const LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  bool _isRainTime(int hour) {
    // Simulate rain effect during certain hours
    return hour >= 14 && hour <= 16;
  }

  List<Widget> _buildRainParticles() {
    final random = Random(42);
    return List.generate(8, (i) {
      return Positioned(
        left: 50 + random.nextDouble() * 200,
        top: 50 + random.nextDouble() * 150,
        child: Container(
          width: 2,
          height: 12 + random.nextDouble() * 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    });
  }

  Color _getQualityColor(double quality) {
    if (quality >= 90) return Colors.greenAccent;
    if (quality >= 70) return Colors.yellowAccent;
    if (quality >= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Color _getRiskColor(double risk) {
    if (risk <= 20) return Colors.greenAccent;
    if (risk <= 50) return Colors.yellowAccent;
    if (risk <= 80) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
