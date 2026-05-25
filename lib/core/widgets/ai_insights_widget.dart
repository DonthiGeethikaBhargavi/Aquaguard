import 'package:flutter/material.dart';

import 'package:aquaguard/core/responsive/responsive_helper.dart';

class AIInsightsWidget extends StatelessWidget {
  final String pondId;
  final String deviceId;

  const AIInsightsWidget({
    super.key,
    required this.pondId,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////
    /// RESPONSIVE
    //////////////////////////////////////////////////////////

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    //////////////////////////////////////////////////////////
    /// CARD WIDTH
    //////////////////////////////////////////////////////////

    double metricCardWidth;

    if (isMobile) {
      metricCardWidth = double.infinity;
    } else if (isTablet) {
      metricCardWidth = 220;
    } else {
      metricCardWidth = 240;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.025),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.03),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////////
          /// HEADER
          //////////////////////////////////////////////////////////
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////////////////////////////////////////////////////////
              /// ICON
              ////////////////////////////////////////////////////////
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyanAccent.withValues(alpha: 0.12),
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.cyanAccent,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              ////////////////////////////////////////////////////////
              /// TEXT
              ////////////////////////////////////////////////////////
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Realtime AI Engine',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Telemetry intelligence and predictive forecasting',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 24 : 30),

          //////////////////////////////////////////////////////////
          /// METRICS
          //////////////////////////////////////////////////////////
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _MetricCard(
                width: metricCardWidth,
                title: 'Prediction Accuracy',
                value: '94%',
                icon: Icons.analytics_rounded,
                color: Colors.cyanAccent,
                isMobile: isMobile,
              ),

              _MetricCard(
                width: metricCardWidth,
                title: 'Anomalies Detected',
                value: '12',
                icon: Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                isMobile: isMobile,
              ),

              _MetricCard(
                width: metricCardWidth,
                title: 'System Stability',
                value: 'Optimal',
                icon: Icons.verified_rounded,
                color: Colors.greenAccent,
                isMobile: isMobile,
              ),
            ],
          ),

          SizedBox(height: isMobile ? 24 : 30),

          //////////////////////////////////////////////////////////
          /// AI RECOMMENDATION
          //////////////////////////////////////////////////////////
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ////////////////////////////////////////////////////////
                /// TITLE
                ////////////////////////////////////////////////////////
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.cyanAccent.withValues(alpha: 0.9),
                      size: 20,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      'AI Recommendation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ////////////////////////////////////////////////////////
                /// CONTENT
                ////////////////////////////////////////////////////////
                Text(
                  'Water quality trends indicate stable oxygen levels. AI recommends maintaining the current aeration cycle while monitoring afternoon temperature fluctuations for long-term pond stability.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    height: 1.7,
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// METRIC CARD
//////////////////////////////////////////////////////////////

class _MetricCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isMobile;

  const _MetricCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////////
          /// ICON
          //////////////////////////////////////////////////////////
          Icon(icon, color: color, size: 24),

          const SizedBox(height: 18),

          //////////////////////////////////////////////////////////
          /// VALUE
          //////////////////////////////////////////////////////////
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 6),

          //////////////////////////////////////////////////////////
          /// TITLE
          //////////////////////////////////////////////////////////
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
