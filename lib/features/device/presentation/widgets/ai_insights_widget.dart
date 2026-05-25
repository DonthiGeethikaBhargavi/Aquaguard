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

    double cardWidth;

    if (isMobile) {
      cardWidth = double.infinity;
    } else if (isTablet) {
      cardWidth = 320;
    } else {
      cardWidth = 360;
    }

    //////////////////////////////////////////////////////////
    /// MOCK DATA
    //////////////////////////////////////////////////////////

    final insights = [
      {
        'title': 'Oxygen Stability Forecast',
        'insight':
            'AI predicts dissolved oxygen stability for the next 6 hours with low probability of critical depletion based on current telemetry trends.',
        'confidence': '96%',
        'icon': Icons.water_drop,
        'color': Colors.cyanAccent,
        'tags': ['Oxygen', 'Forecast', 'Realtime'],
      },
      {
        'title': 'Temperature Pattern Analysis',
        'insight':
            'Temperature variation remains within optimal operational range with minor fluctuation expected during afternoon thermal peaks.',
        'confidence': '92%',
        'icon': Icons.thermostat,
        'color': Colors.orangeAccent,
        'tags': ['Temperature', 'Analysis', 'Telemetry'],
      },
      {
        'title': 'Water Quality Optimization',
        'insight':
            'AI recommends slight aeration adjustment to improve long-term water stability and maintain dissolved oxygen efficiency.',
        'confidence': '94%',
        'icon': Icons.auto_graph,
        'color': Colors.greenAccent,
        'tags': ['Optimization', 'Recommendation', 'AI'],
      },
      {
        'title': 'Anomaly Detection Engine',
        'insight':
            'No abnormal telemetry spikes detected. Sensor behavior aligns with established operational baselines.',
        'confidence': '98%',
        'icon': Icons.crisis_alert,
        'color': Colors.purpleAccent,
        'tags': ['Anomaly', 'Detection', 'Healthy'],
      },
    ];

    //////////////////////////////////////////////////////////
    /// EMPTY STATE
    //////////////////////////////////////////////////////////

    if (insights.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white.withValues(alpha: 0.04),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Colors.white.withValues(alpha: 0.6),
              size: 48,
            ),

            const SizedBox(height: 20),

            const Text(
              'No AI insights available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'AI engine has not generated insights yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.6,
              ),
            ),
          ],
        ),
      );
    }

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: insights.map((item) {
        return _InsightCard(
          width: cardWidth,
          title: item['title'] as String,
          insight: item['insight'] as String,
          confidence: item['confidence'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
          tags: item['tags'] as List<String>,
        );
      }).toList(),
    );
  }
}

//////////////////////////////////////////////////////////////
/// INSIGHT CARD
//////////////////////////////////////////////////////////////

class _InsightCard extends StatelessWidget {
  final double width;
  final String title;
  final String insight;
  final String confidence;
  final IconData icon;
  final Color color;
  final List<String> tags;

  const _InsightCard({
    required this.width,
    required this.title,
    required this.insight,
    required this.confidence,
    required this.icon,
    required this.color,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
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
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              const Spacer(),

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
            ],
          ),

          const SizedBox(height: 22),

          //////////////////////////////////////////////////////
          /// TITLE
          //////////////////////////////////////////////////////
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          //////////////////////////////////////////////////////
          /// INSIGHT
          //////////////////////////////////////////////////////
          Text(
            insight,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.7,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          //////////////////////////////////////////////////////
          /// TAGS
          //////////////////////////////////////////////////////
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags.map((tag) {
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
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
