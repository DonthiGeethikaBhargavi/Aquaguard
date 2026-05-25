import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aquaguard/core/responsive/responsive_helper.dart';

import '../../data/providers/ai_insights_provider.dart';

class AIInsightsScreen extends ConsumerWidget {
  final String pondId;
  final String deviceId;
  final String? deviceName;

  const AIInsightsScreen({
    super.key,
    required this.pondId,
    required this.deviceId,
    this.deviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final aiAsync = ref.watch(aiInsightsProvider(deviceId));

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          //////////////////////////////////////////////////////////
          /// BACKGROUND
          //////////////////////////////////////////////////////////
          Positioned(
            top: -140,
            right: -120,

            child: Container(
              width: 340,
              height: 340,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.cyanAccent.withValues(alpha: 0.05),
              ),
            ),
          ),

          Positioned(
            bottom: -180,
            left: -100,

            child: Container(
              width: 420,
              height: 420,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.blueAccent.withValues(alpha: 0.04),
              ),
            ),
          ),

          //////////////////////////////////////////////////////////
          /// CONTENT
          //////////////////////////////////////////////////////////
          SafeArea(
            child: aiAsync.when(
              //////////////////////////////////////////////////////
              /// DATA
              //////////////////////////////////////////////////////
              data: (ai) {
                final riskColor = ai.riskScore > 70
                    ? Colors.redAccent
                    : ai.riskScore > 30
                    ? Colors.orangeAccent
                    : Colors.cyanAccent;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  padding: EdgeInsets.only(
                    left: ResponsiveHelper.screenPadding(context),
                    right: ResponsiveHelper.screenPadding(context),
                    top: 18,
                    bottom: isMobile ? 110 : 40,
                  ),

                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1450),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          //////////////////////////////////////////////////
                          /// HERO CARD
                          //////////////////////////////////////////////////
                          ClipRRect(
                            borderRadius: BorderRadius.circular(34),

                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

                              child: Container(
                                width: double.infinity,

                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 18 : 26,
                                  vertical: 16,
                                ),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(34),

                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,

                                    colors: [
                                      riskColor.withValues(alpha: 0.12),

                                      Colors.white.withValues(alpha: 0.04),

                                      Colors.white.withValues(alpha: 0.02),
                                    ],
                                  ),

                                  border: Border.all(
                                    color: riskColor.withValues(alpha: 0.12),
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: riskColor.withValues(alpha: 0.10),

                                      blurRadius: 32,
                                    ),
                                  ],
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    //////////////////////////////////////////////////
                                    /// TOP ROW
                                    //////////////////////////////////////////////////
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),

                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,

                                            color: riskColor.withValues(
                                              alpha: 0.14,
                                            ),
                                          ),

                                          child: Icon(
                                            Icons.auto_awesome_rounded,

                                            color: riskColor,

                                            size: isMobile ? 26 : 32,
                                          ),
                                        ),

                                        const Spacer(),

                                        //////////////////////////////////////////////////
                                        /// STATUS
                                        //////////////////////////////////////////////////
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),

                                            color: riskColor.withValues(
                                              alpha: 0.12,
                                            ),

                                            border: Border.all(
                                              color: riskColor.withValues(
                                                alpha: 0.18,
                                              ),
                                            ),
                                          ),

                                          child: Text(
                                            ai.stability,

                                            style: TextStyle(
                                              color: riskColor,

                                              fontSize: 12,

                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: isMobile ? 20 : 26),

                                    //////////////////////////////////////////////////
                                    /// TITLE
                                    //////////////////////////////////////////////////
                                    Text(
                                      'AI Intelligence Engine',

                                      style: TextStyle(
                                        color: Colors.white,

                                        fontSize: isMobile ? 26 : 38,

                                        fontWeight: FontWeight.w800,

                                        letterSpacing: -1,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    //////////////////////////////////////////////////
                                    /// SUBTITLE
                                    //////////////////////////////////////////////////
                                    Text(
                                      deviceName ??
                                          'Realtime telemetry intelligence and predictive aquaculture optimization.',

                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.64,
                                        ),

                                        fontSize: isMobile ? 13 : 14,

                                        fontWeight: FontWeight.w600,

                                        height: 1.5,
                                      ),
                                    ),

                                    SizedBox(height: isMobile ? 18 : 22),

                                    //////////////////////////////////////////////////
                                    /// RECOMMENDATION
                                    //////////////////////////////////////////////////
                                    Text(
                                      ai.recommendation,

                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.74,
                                        ),

                                        fontSize: isMobile ? 14 : 15,

                                        fontWeight: FontWeight.w500,

                                        height: 1.6,
                                      ),
                                    ),

                                    SizedBox(height: isMobile ? 18 : 24),

                                    //////////////////////////////////////////////////
                                    /// METRICS
                                    //////////////////////////////////////////////////
                                    SizedBox(
                                      height: 170,

                                      child: ListView(
                                        scrollDirection: Axis.horizontal,

                                        children: [
                                          _LiveMetricCard(
                                            title: 'Prediction',

                                            value:
                                                '${ai.predictionAccuracy.toStringAsFixed(0)}%',

                                            color: Colors.cyanAccent,

                                            icon: Icons.analytics_rounded,
                                          ),

                                          const SizedBox(width: 14),

                                          _LiveMetricCard(
                                            title: 'Anomalies',

                                            value: '${ai.anomaliesDetected}',

                                            color: Colors.orangeAccent,

                                            icon: Icons.crisis_alert_rounded,
                                          ),

                                          const SizedBox(width: 14),

                                          _LiveMetricCard(
                                            title: 'Risk Score',

                                            value:
                                                '${ai.riskScore.toStringAsFixed(0)}',

                                            color: riskColor,

                                            icon: Icons.auto_graph_rounded,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isMobile ? 28 : 40),

                          //////////////////////////////////////////////////
                          /// SECTION HEADER
                          //////////////////////////////////////////////////
                          _SectionHeader(
                            title: 'Realtime Intelligence',

                            subtitle:
                                'Dynamic AI telemetry analysis powered by Supabase realtime streams.',

                            isMobile: isMobile,
                          ),

                          SizedBox(height: isMobile ? 18 : 24),

                          //////////////////////////////////////////////////
                          /// CAPABILITY CARDS
                          //////////////////////////////////////////////////
                          Wrap(
                            spacing: 14,
                            runSpacing: 14,

                            children: [
                              _CapabilityCard(
                                title: 'Temperature Engine',

                                description: ai.tempCritical
                                    ? 'Critical thermal instability detected. Immediate monitoring recommended.'
                                    : 'Thermal telemetry operating within optimal aquaculture conditions.',

                                icon: Icons.thermostat_rounded,

                                color: ai.tempCritical
                                    ? Colors.redAccent
                                    : Colors.cyanAccent,
                              ),

                              _CapabilityCard(
                                title: 'Dissolved Oxygen',

                                description: ai.doCritical
                                    ? 'Oxygen levels are outside safe biological range.'
                                    : 'Dissolved oxygen telemetry stable and healthy.',

                                icon: Icons.water_drop_rounded,

                                color: ai.doCritical
                                    ? Colors.orangeAccent
                                    : Colors.cyanAccent,
                              ),

                              _CapabilityCard(
                                title: 'pH Intelligence',

                                description: ai.phCritical
                                    ? 'Water chemistry imbalance detected by AI engine.'
                                    : 'pH balance remains stable across telemetry cycles.',

                                icon: Icons.science_rounded,

                                color: ai.phCritical
                                    ? Colors.purpleAccent
                                    : Colors.cyanAccent,
                              ),
                            ],
                          ),

                          SizedBox(height: isMobile ? 40 : 60),
                        ],
                      ),
                    ),
                  ),
                );
              },

              //////////////////////////////////////////////////////
              /// LOADING
              //////////////////////////////////////////////////////
              loading: () => const Center(child: CircularProgressIndicator()),

              //////////////////////////////////////////////////////
              /// ERROR
              //////////////////////////////////////////////////////
              error: (e, st) => Center(
                child: Text(
                  e.toString(),

                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SECTION HEADER
////////////////////////////////////////////////////////////

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isMobile;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: TextStyle(
            color: Colors.white,

            fontSize: isMobile ? 20 : 28,

            fontWeight: FontWeight.w800,

            letterSpacing: -0.6,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,

          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.66),

            fontSize: isMobile ? 13 : 14,

            fontWeight: FontWeight.w500,

            height: 1.5,
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// LIVE METRIC CARD
////////////////////////////////////////////////////////////

class _LiveMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _LiveMetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: Container(
          width: 150,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),

            color: Colors.white.withValues(alpha: 0.04),

            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: color.withValues(alpha: 0.14),
                ),

                child: Icon(icon, color: color, size: 22),
              ),

              const SizedBox(height: 18),

              Text(
                value,

                style: const TextStyle(
                  color: Colors.white,

                  fontSize: 24,

                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                title,

                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.66),

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
}

////////////////////////////////////////////////////////////
/// CAPABILITY CARD
////////////////////////////////////////////////////////////

class _CapabilityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _CapabilityCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,

      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        color: Colors.white.withValues(alpha: 0.04),

        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(13),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: color.withValues(alpha: 0.14),
            ),

            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(height: 18),

          Text(
            title,

            style: const TextStyle(
              color: Colors.white,

              fontSize: 18,

              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            description,

            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),

              fontSize: 13,

              height: 1.5,

              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
