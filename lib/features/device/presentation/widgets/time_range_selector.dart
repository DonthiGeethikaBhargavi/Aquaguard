import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/responsive_helper.dart';

import '../providers/chart_range.dart';

class TimeRangeSelector extends StatelessWidget {
  final ChartRange selectedRange;

  final ValueChanged<ChartRange> onRangeChanged;

  final bool compact;

  final bool wrap;

  final EdgeInsetsGeometry? padding;

  final double? height;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    this.compact = true,
    this.wrap = false,
    this.padding,
    this.height,
  });

  ////////////////////////////////////////////////////////////
  /// LABEL
  ////////////////////////////////////////////////////////////

  String _getRangeLabel(ChartRange range) {
    switch (range) {
      case ChartRange.hour:
        return '1H';

      case ChartRange.day:
        return '24H';

      case ChartRange.week:
        return '7D';

      case ChartRange.month:
        return '30D';

      case ChartRange.year:
        return '1Y';
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    //////////////////////////////////////////////////////////
    /// SIZING
    //////////////////////////////////////////////////////////

    final selectorHeight =
        height ??
        (compact ? (isMobile ? 46.0 : 50.0) : (isMobile ? 52.0 : 58.0));

    final radius = compact ? 22.0 : 28.0;

    final itemRadius = compact ? 16.0 : 20.0;

    final fontSize = compact
        ? (isMobile ? 11.0 : 12.0)
        : (isMobile ? 12.0 : 13.0);

    //////////////////////////////////////////////////////////
    /// ITEMS
    //////////////////////////////////////////////////////////

    final items = ChartRange.values.map((range) {
      final isSelected = range == selectedRange;

      return Expanded(
        child: _RangeItem(
          label: _getRangeLabel(range),

          selected: isSelected,

          compact: compact,

          radius: itemRadius,

          fontSize: fontSize,

          onTap: () => onRangeChanged(range),
        ),
      );
    }).toList();

    //////////////////////////////////////////////////////////
    /// CONTAINER
    //////////////////////////////////////////////////////////

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),

        child: Container(
          height: selectorHeight,

          padding: padding ?? const EdgeInsets.all(4),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),

            gradient: LinearGradient(
              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: [
                Colors.white.withValues(alpha: 0.05),

                Colors.white.withValues(alpha: 0.02),
              ],
            ),

            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),

                blurRadius: 20,

                spreadRadius: 1,
              ),
            ],
          ),

          child: Row(children: items),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// RANGE ITEM
////////////////////////////////////////////////////////////

class _RangeItem extends StatelessWidget {
  final String label;

  final bool selected;

  final bool compact;

  final double radius;

  final double fontSize;

  final VoidCallback onTap;

  const _RangeItem({
    required this.label,
    required this.selected,
    required this.compact,
    required this.radius,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      behavior: HitTestBehavior.opaque,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),

        curve: Curves.easeOutCubic,

        margin: const EdgeInsets.symmetric(horizontal: 2),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),

          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                  colors: [
                    Colors.cyan.withValues(alpha: 0.22),

                    Colors.blueAccent.withValues(alpha: 0.10),
                  ],
                )
              : null,

          border: Border.all(
            color: selected
                ? Colors.cyan.withValues(alpha: 0.28)
                : Colors.transparent,
          ),

          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.08),

                    blurRadius: 18,

                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),

        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),

            style: GoogleFonts.notoSans(
              color: selected
                  ? Colors.cyanAccent
                  : Colors.white.withValues(alpha: 0.60),

              fontSize: fontSize,

              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,

              letterSpacing: 0.2,
            ),

            child: Text(label),
          ),
        ),
      ),
    );
  }
}
