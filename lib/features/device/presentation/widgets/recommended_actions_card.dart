import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/action_recommendation_provider.dart';

class RecommendedActionsCard extends ConsumerWidget {
  final String pondId;
  final String deviceId;

  const RecommendedActionsCard({
    super.key,
    required this.pondId,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Priority actions derived from current alerts and predictive trends.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 18),
          _buildActionContent(ref),
        ],
      ),
    );
  }

  Widget _buildActionContent(WidgetRef ref) {
    final loadActions = ref.watch(
      actionRecommendationProvider(pondId, deviceId),
    );

    return loadActions.when(
      data: (actions) {
        if (actions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'No critical actions required at this time.',
              style: TextStyle(color: Colors.white.withOpacity(0.65)),
            ),
          );
        }

        return Column(
          children: actions.take(3).map((action) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildActionRow(action),
            );
          }).toList(),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator(color: Colors.cyan)),
      ),
      error: (err, stack) => Text(
        'Unable to fetch recommendations.',
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildActionRow(ActionItem action) {
    final color = _priorityColor(action.priority);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: color.withOpacity(0.18),
            ),
            child: Icon(Icons.check_circle_outline, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  action.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.68),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _priorityLabel(action.priority),
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _priorityLabel(ActionPriority priority) {
    switch (priority) {
      case ActionPriority.high:
        return 'HIGH';
      case ActionPriority.medium:
        return 'MEDIUM';
      case ActionPriority.low:
        return 'LOW';
    }
  }

  Color _priorityColor(ActionPriority priority) {
    switch (priority) {
      case ActionPriority.high:
        return Colors.redAccent;
      case ActionPriority.medium:
        return Colors.orangeAccent;
      case ActionPriority.low:
        return Colors.lightGreenAccent;
    }
  }
}
