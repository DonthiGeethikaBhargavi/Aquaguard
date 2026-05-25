import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../../core/providers/telemetry_aggregation_provider.dart';

/// Premium timeframe selector with smooth animations
class PremiumTimeframeSelector extends ConsumerWidget {
  final void Function(String)? onTimeframeChanged;
  final bool compact;

  const PremiumTimeframeSelector({
    super.key,
    this.onTimeframeChanged,
    this.compact = false,
  });

  static const List<String> timeframes = ['1H', '24H', '7D', '1M', '1Y'];
  static const List<String> aggregations = [
    'Hour',
    'Day',
    'Week',
    'Month',
    'Year',
  ];
  static const List<String> timeFormatOptions = ['12H', '24H'];

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTimeframe = ref.watch(selectedTimeframeProvider);
    final selectedAggregation = ref.watch(selectedAggregationProvider);
    final timeFormat = ref.watch(timeFormatPreferenceProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Row(
          children: [
            //////////////////////////////////////////////////////
            /// TIMEFRAME SELECTOR
            //////////////////////////////////////////////////////
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < timeframes.length; i++)
                    _buildTimeframeButton(
                      context,
                      ref,
                      timeframes[i],
                      aggregations[i],
                      selectedTimeframe == timeframes[i],
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            //////////////////////////////////////////////////////
            /// TIME FORMAT TOGGLE
            //////////////////////////////////////////////////////
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final format in timeFormatOptions)
                    _buildFormatButton(
                      context,
                      ref,
                      format,
                      timeFormat == format,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// BUILDERS
  ////////////////////////////////////////////////////////////

  Widget _buildTimeframeButton(
    BuildContext context,
    WidgetRef ref,
    String timeframe,
    String aggregation,
    bool isSelected,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(selectedTimeframeProvider.notifier).setTimeframe(timeframe);
          ref
              .read(selectedAggregationProvider.notifier)
              .setAggregation(aggregation);
          onTimeframeChanged?.call(timeframe);
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.cyan.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.cyan.withOpacity(0.4)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeframe,
                style: TextStyle(
                  color: isSelected
                      ? Colors.cyan
                      : Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatButton(
    BuildContext context,
    WidgetRef ref,
    String format,
    bool isSelected,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(timeFormatPreferenceProvider.notifier).setTimeFormat(format);
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.orange.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            format,
            style: TextStyle(
              color: isSelected
                  ? Colors.orange.withOpacity(0.9)
                  : Colors.white.withOpacity(0.5),
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
