import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

import '../providers/health_score_calculator_provider.dart';
import '../providers/ai_insights_aggregation_provider.dart';

class HeroHealthCard extends ConsumerWidget {
  final String pondId;
  final String deviceId;

  const HeroHealthCard({Key? key, required this.pondId, required this.deviceId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthScoreAsync = ref.watch(
      healthScoreCalculatorProvider(pondId, deviceId),
    );
    final aiInsightsAsync = ref.watch(
      aiInsightsAggregationProvider(pondId, deviceId),
    );

    return healthScoreAsync.when(
      data: (healthScore) {
        return aiInsightsAsync.when(
          data: (insights) {
            return _buildCard(context, healthScore, insights);
          },
          loading: () => _buildLoadingState(),
          error: (err, stack) => _buildErrorState(err),
        );
      },
      loading: () => _buildLoadingState(),
      error: (err, stack) => _buildErrorState(err),
    );
  }

  Widget _buildCard(
    BuildContext context,
    HealthScoreResult healthScore,
    List<AiInsight> insights,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = theme.primaryColor;
    final textColor = isDark ? Colors.white : Color(0xFF1A1F2E);
    final subtleColor = isDark ? Color(0xFF8A92A6) : Color(0xFF6B7280);

    final alertCount = insights
        .where((i) => i.severity == AiInsightSeverity.critical)
        .length;
    final predictionCount = insights
        .where((i) => i.type == AiInsightType.prediction)
        .length;

    return Container(
      constraints: BoxConstraints(maxHeight: 240),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image with Overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/analytics_hero_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Dark Cinematic Overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF040A14).withOpacity(0.65),
                      Color(0xFF0D1B2D).withOpacity(0.72),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Glassmorphism Border Glow
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.cyan.withOpacity(0.12),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Top section: Score + Ring
                Expanded(
                  child: Row(
                    children: [
                      // Left: Score + State + Summary
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // "Water Health" Label
                            Row(
                              children: [
                                Icon(
                                  Icons.shield_rounded,
                                  color: Colors.cyan,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Water Health',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Health Score (Large Number - Green)
                            Text(
                              _formatOperationalState(
                                healthScore.operationalState,
                              ),
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: _getScoreColorBright(healthScore.score),
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.2,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Summary Text
                            Text(
                              _buildSummary(healthScore),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.65),
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Right: Animated Health Ring with Score
                      _buildHealthRingPremium(
                        context,
                        healthScore.score,
                        primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Bottom: Operational Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildPremiumChip(
                        context,
                        '● Live',
                        _getChipStatus(healthScore),
                        color: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _buildPremiumChip(
                        context,
                        'Prediction${predictionCount > 0 ? ' Active' : ''}',
                        predictionCount > 0,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      _buildPremiumChip(
                        context,
                        '${alertCount > 0 ? '⚠ $alertCount Alert' : '✓ No Alerts'}',
                        alertCount == 0,
                        color: alertCount > 0 ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _buildPremiumChip(
                        context,
                        '4/4 Sensors Online',
                        true,
                        color: Colors.cyan,
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

  Widget _buildHealthRingPremium(
    BuildContext context,
    int score,
    Color primaryColor,
  ) {
    final ringSize = 110.0;
    final strokeWidth = 7.0;
    final percentage = score / 100;

    return SizedBox(
      width: ringSize + 20,
      height: ringSize + 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow background (animated)
          SizedBox(
            width: ringSize + 10,
            height: ringSize + 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getScoreColorBright(score).withOpacity(0.08),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: 2000.ms,
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.1, 1.1),
                ),
          ),

          // Background ring
          SizedBox(
            width: ringSize,
            height: ringSize,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(
                Colors.white.withOpacity(0.08),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),

          // Progress ring with glow
          SizedBox(
            width: ringSize,
            height: ringSize,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(
                _getScoreColorBright(score),
              ),
              backgroundColor: Colors.transparent,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 3000.ms,
                  color: Colors.white.withOpacity(0.25),
                ),
          ),

          // Center score text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score.toString(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: _getScoreColorBright(score),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                '/100',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumChip(
    BuildContext context,
    String label,
    bool isActive, {
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? color.withOpacity(0.18)
            : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? color.withOpacity(0.35)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isActive ? color : Colors.white.withOpacity(0.6),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildHealthRing(BuildContext context, int score, Color primaryColor) {
    final ringSize = 100.0;
    final strokeWidth = 8.0;
    final percentage = score / 100;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: ringSize,
            height: ringSize,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(
                primaryColor.withOpacity(0.15),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Progress ring
          SizedBox(
            width: ringSize,
            height: ringSize,
            child:
                CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: strokeWidth,
                      valueColor: AlwaysStoppedAnimation(_getScoreColor(score)),
                      backgroundColor: Colors.transparent,
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 3000.ms,
                      color: Colors.white.withOpacity(0.3),
                    ),
          ),
          // Center text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _getScoreColor(score),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Health',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: primaryColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    bool isActive,
    IconData icon, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chipColor = color ?? theme.primaryColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? chipColor.withOpacity(0.15)
            : (isDark ? Color(0xFF3A424D) : Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? chipColor.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isActive ? chipColor : Color(0xFF9CA3AF)),
          SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isActive ? chipColor : Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      constraints: BoxConstraints(maxHeight: 230),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Container(
      constraints: BoxConstraints(maxHeight: 230),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 32),
            SizedBox(height: 12),
            Text('Error loading health data'),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 75) return Color(0xFF10B981); // Green
    if (score >= 50) return Color(0xFFF59E0B); // Amber
    return Color(0xFFEF4444); // Red
  }

  Color _getScoreColorBright(int score) {
    if (score >= 75) return Color(0xFF00FF88); // Bright Green
    if (score >= 50) return Color(0xFFFFAA00); // Bright Orange
    return Color(0xFFFF4466); // Bright Red
  }

  Color _getStateColor(OperationalState state) {
    switch (state) {
      case OperationalState.optimal:
        return Color(0xFF10B981);
      case OperationalState.stable:
        return Color(0xFF3B82F6);
      case OperationalState.warning:
        return Color(0xFFF59E0B);
      case OperationalState.critical:
        return Color(0xFFEF4444);
    }
  }

  String _formatOperationalState(OperationalState state) {
    switch (state) {
      case OperationalState.optimal:
        return 'Optimal';
      case OperationalState.stable:
        return 'Stable';
      case OperationalState.warning:
        return 'Warning';
      case OperationalState.critical:
        return 'Critical';
    }
  }

  bool _getChipStatus(HealthScoreResult healthScore) {
    return healthScore.operationalState == OperationalState.optimal ||
        healthScore.operationalState == OperationalState.stable;
  }

  String _buildSummary(HealthScoreResult healthScore) {
    switch (healthScore.operationalState) {
      case OperationalState.optimal:
        return 'All systems performing optimally. Stability excellent.';
      case OperationalState.stable:
        return 'System stable with minor variations. Continue monitoring.';
      case OperationalState.warning:
        return 'Some parameters trending toward unsafe ranges.';
      case OperationalState.critical:
        return 'Critical conditions detected. Immediate action needed.';
    }
  }
}
