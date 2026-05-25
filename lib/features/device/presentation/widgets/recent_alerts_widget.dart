import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentAlertsWidget extends ConsumerWidget {
  const RecentAlertsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_rounded,

                color: Colors.orangeAccent,

                size: 22,
              ),

              const SizedBox(width: 10),

              const Text(
                'Recent Alerts',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 18,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),

              borderRadius: BorderRadius.circular(18),

              border: Border.all(color: Colors.orange.withOpacity(0.18)),
            ),

            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    'Water quality fluctuation detected.',

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.82),

                      fontSize: 14,

                      fontWeight: FontWeight.w500,
                    ),
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
