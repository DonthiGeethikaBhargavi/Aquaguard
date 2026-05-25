import 'package:flutter/material.dart';

import 'package:aquaguard/core/responsive/responsive_helper.dart';
import 'package:aquaguard/core/widgets/adaptive_realtime_badge.dart';

enum PredictionRisk { low, medium, high }

class AiPredictionsWidget extends StatelessWidget {
  const AiPredictionsWidget({super.key});

  ////////////////////////////////////////////////////////////
  /// COLOR
  ////////////////////////////////////////////////////////////

  Color _riskColor(PredictionRisk risk) {
    switch (risk) {
      case PredictionRisk.low:
        return Colors.greenAccent;

      case PredictionRisk.medium:
        return Colors.orangeAccent;

      case PredictionRisk.high:
        return Colors.redAccent;
    }
  }

  ////////////////////////////////////////////////////////////
  /// LABEL
  ////////////////////////////////////////////////////////////

  String _riskLabel(PredictionRisk risk) {
    switch (risk) {
      case PredictionRisk.low:
        return 'LOW RISK';

      case PredictionRisk.medium:
        return 'MEDIUM RISK';

      case PredictionRisk.high:
        return 'HIGH RISK';
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    //////////////////////////////////////////////////////////
    /// MOCK DATA
    //////////////////////////////////////////////////////////

    final predictions = [
      {
        'title': 'Oxygen Drop Predicted',
        'insight':
            'Dissolved oxygen levels may fall below optimal range within the next 3 hours based on realtime telemetry pattern forecasting.',
        'confidence': '87%',
        'icon': Icons.air,
        'risk': PredictionRisk.high,
        'tags': ['High Risk', 'Oxygen', 'Forecast'],
        'recommendation':
            'Increase aerator runtime by 20% to stabilize oxygen levels.',
        'timeline': 'Predicted within 3 hours',
      },
      {
        'title': 'pH Instability Detected',
        'insight':
            'Minor pH fluctuations detected from recent sensor trend analysis indicating possible instability during the next feeding cycle.',
        'confidence': '72%',
        'icon': Icons.science_outlined,
        'risk': PredictionRisk.medium,
        'tags': ['Medium', 'pH', 'AI'],
        'recommendation':
            'Monitor water chemistry closely during the next feeding cycle.',
        'timeline': 'Predicted within 6 hours',
      },
    ];

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    return Column(
      children: predictions.asMap().entries.map((entry) {
        final item = entry.value;

        final risk = item['risk'] as PredictionRisk;

        final color = _riskColor(risk);

        return Padding(
          padding: EdgeInsets.only(
            bottom: entry.key == predictions.length - 1 ? 0 : 18,
          ),
          child: _PredictionCard(
            title: item['title'] as String,
            insight: item['insight'] as String,
            confidence: item['confidence'] as String,
            icon: item['icon'] as IconData,
            color: color,
            tags: item['tags'] as List<String>,
            recommendation: item['recommendation'] as String,
            timeline: item['timeline'] as String,
            riskLabel: _riskLabel(risk),
            isHighRisk: risk == PredictionRisk.high,
            isMobile: isMobile,
          ),
        );
      }).toList(),
    );
  }
}

////////////////////////////////////////////////////////////
/// PREDICTION CARD
////////////////////////////////////////////////////////////

class _PredictionCard extends StatelessWidget {
  final String title;
  final String insight;
  final String confidence;
  final IconData icon;
  final Color color;
  final List<String> tags;
  final String recommendation;
  final String timeline;
  final String riskLabel;
  final bool isHighRisk;
  final bool isMobile;

  const _PredictionCard({
    required this.title,
    required this.insight,
    required this.confidence,
    required this.icon,
    required this.color,
    required this.tags,
    required this.recommendation,
    required this.timeline,
    required this.riskLabel,
    required this.isHighRisk,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.025),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////
          /// TOP
          //////////////////////////////////////////////////////
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////////////////////////////////////////////////////
              /// ICON
              ////////////////////////////////////////////////////
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              const SizedBox(width: 16),

              ////////////////////////////////////////////////////
              /// TEXT
              ////////////////////////////////////////////////////
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      insight,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: isMobile ? 13 : 14,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 20 : 24),

          //////////////////////////////////////////////////////
          /// BADGES
          //////////////////////////////////////////////////////
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AdaptiveRealtimeBadge(
                compact: true,
                animated: isHighRisk,
                state: isHighRisk
                    ? AdaptiveRealtimeState.warning
                    : AdaptiveRealtimeState.syncing,
                label: riskLabel,
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: color.withValues(alpha: 0.14),
                ),
                child: Text(
                  confidence,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ),

              ...tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),

          SizedBox(height: isMobile ? 20 : 24),

          //////////////////////////////////////////////////////
          /// FOOTER
          //////////////////////////////////////////////////////
          Container(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //////////////////////////////////////////////////
                /// RECOMMENDATION
                //////////////////////////////////////////////////
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: color,
                      size: isMobile ? 18 : 20,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        recommendation,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.76),
                          fontSize: isMobile ? 12 : 13,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                //////////////////////////////////////////////////
                /// TIMELINE
                //////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.44),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        timeline,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.48),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
