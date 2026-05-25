import 'package:flutter/material.dart';

enum ActionPriority { high, medium, low }

class ActionCenterSection extends StatelessWidget {
  final List<ImmediateAction> actions;

  const ActionCenterSection({Key? key, required this.actions})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? Color(0xFF242B3B) : Colors.white;
    final primaryColor = theme.primaryColor;
    final textColor = isDark ? Colors.white : Color(0xFF1A1F2E);
    final subtleColor = isDark ? Color(0xFF8A92A6) : Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 12,
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
            // Header
            Row(
              children: [
                Icon(Icons.bolt, size: 20, color: Color(0xFFF59E0B)),
                SizedBox(width: 8),
                Text(
                  'Immediate Actions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Content
            if (actions.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFF10B981).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF10B981),
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All systems optimal',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'No immediate actions required',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: subtleColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: List.generate(
                  actions.length,
                  (index) => Column(
                    children: [
                      _buildActionItem(context, actions[index]),
                      if (index < actions.length - 1)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            height: 1,
                            color: primaryColor.withOpacity(0.1),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, ImmediateAction action) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Color(0xFF1A1F2E);
    final subtleColor = isDark ? Color(0xFF8A92A6) : Color(0xFF6B7280);

    final priorityColor = _getPriorityColor(action.priority);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Priority Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: priorityColor.withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            _formatPriority(action.priority),
            style: theme.textTheme.labelSmall?.copyWith(
              color: priorityColor,
              fontWeight: FontWeight.w700,
              fontSize: 9,
            ),
          ),
        ),
        SizedBox(width: 12),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action.title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                action.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: subtleColor,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        // Action Icon
        Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF9CA3AF)),
      ],
    );
  }

  Color _getPriorityColor(ActionPriority priority) {
    switch (priority) {
      case ActionPriority.high:
        return Color(0xFFEF4444); // Red
      case ActionPriority.medium:
        return Color(0xFFF59E0B); // Amber
      case ActionPriority.low:
        return Color(0xFF3B82F6); // Blue
    }
  }

  String _formatPriority(ActionPriority priority) {
    switch (priority) {
      case ActionPriority.high:
        return 'HIGH';
      case ActionPriority.medium:
        return 'MEDIUM';
      case ActionPriority.low:
        return 'LOW';
    }
  }
}

class ImmediateAction {
  final String title;
  final String description;
  final ActionPriority priority;

  ImmediateAction({
    required this.title,
    required this.description,
    required this.priority,
  });
}
