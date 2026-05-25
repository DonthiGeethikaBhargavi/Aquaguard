import 'package:flutter/material.dart';

enum InsightSeverity { low, moderate, critical }

class AiInsightCard extends StatelessWidget {
  final String title;
  final String description;
  final InsightSeverity severity;
  final String actionRecommendation;

  const AiInsightCard({
    Key? key,
    required this.title,
    required this.description,
    required this.severity,
    required this.actionRecommendation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? Color(0xFF242B3B) : Colors.white;
    final borderColor = _getSeverityColor(severity);
    final textColor = isDark ? Colors.white : Color(0xFF1A1F2E);
    final subtleColor = isDark ? Color(0xFF8A92A6) : Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
          top: BorderSide(
            color: borderColor.withOpacity(0.2),
            width: 1,
          ),
          right: BorderSide(
            color: borderColor.withOpacity(0.2),
            width: 1,
          ),
          bottom: BorderSide(
            color: borderColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Severity Badge + Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSeverityBadge(context),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Description (Multi-line)
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: subtleColor,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            // Divider
            Container(
              height: 1,
              color: borderColor.withOpacity(0.15),
            ),
            SizedBox(height: 12),
            // Action Recommendation
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: borderColor,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    actionRecommendation,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: borderColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = _getSeverityColor(severity);
    final label = _formatSeverity(severity);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: badgeColor.withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getSeverityColor(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.low:
        return Color(0xFF3B82F6); // Blue
      case InsightSeverity.moderate:
        return Color(0xFFF59E0B); // Amber
      case InsightSeverity.critical:
        return Color(0xFFEF4444); // Red
    }
  }

  String _formatSeverity(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.low:
        return 'Low';
      case InsightSeverity.moderate:
        return 'Moderate';
      case InsightSeverity.critical:
        return 'Critical';
    }
  }
}
