import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Adaptive realtime status indicator
class AdaptiveRealtimeStatusIndicator extends ConsumerWidget {
  final bool compact;
  final double? size;

  const AdaptiveRealtimeStatusIndicator({
    super.key,
    this.compact = false,
    this.size,
  });

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = true;

    return _buildStaticStatus();
  }

  ////////////////////////////////////////////////////////////
  /// BUILDERS
  ////////////////////////////////////////////////////////////

  Widget _buildLoading() {
    return Container(
      padding: EdgeInsets.all(compact ? 4 : 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: compact ? 8 : 10,
            height: compact ? 8 : 10,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation(
                Colors.yellow.withOpacity(0.7),
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 6),
            Text(
              'Connecting',
              style: TextStyle(
                color: Colors.yellow.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: EdgeInsets.all(compact ? 4 : 6),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.withOpacity(0.7),
            size: compact ? 10 : 12,
          ),
          if (!compact) ...[
            const SizedBox(width: 6),
            Text(
              'Connection Error',
              style: TextStyle(
                color: Colors.red.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStaticStatus() {
    return Container(
      padding: EdgeInsets.all(compact ? 4 : 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 6),
            Text(
              'LIVE',
              style: TextStyle(
                color: Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
