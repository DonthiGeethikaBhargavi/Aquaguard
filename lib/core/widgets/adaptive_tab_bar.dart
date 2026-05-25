import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveTabBar extends StatelessWidget {
  final TabController controller;

  final List<String> tabs;

  final bool scrollable;

  final double? height;

  final EdgeInsetsGeometry? padding;

  final bool compact;

  final Color? activeColor;

  final Color? inactiveColor;

  const AdaptiveTabBar({
    super.key,

    required this.controller,

    required this.tabs,

    this.scrollable = false,

    this.height,

    this.padding,

    this.compact = false,

    this.activeColor,

    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    //////////////////////////////////////////////////////////
    /// SIZING
    //////////////////////////////////////////////////////////

    final barHeight =
        height ??
        (compact
            ? (isMobile ? 48 : 54)
            : (isMobile
                  ? 56
                  : isTablet
                  ? 60
                  : 66));

    final radius = compact ? 20.0 : 26.0;

    final indicatorRadius = compact ? 16.0 : 20.0;

    final fontSize = compact
        ? (isMobile ? 11.0 : 12.0)
        : (isMobile ? 12.0 : 14.0);

    //////////////////////////////////////////////////////////
    /// COLORS
    //////////////////////////////////////////////////////////

    final selected = activeColor ?? const Color(0xFF35E7FF);

    final unselected = inactiveColor ?? Colors.white.withOpacity(0.58);

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: Container(
          height: barHeight,

          padding: padding ?? const EdgeInsets.all(4),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),

            gradient: LinearGradient(
              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: [
                Colors.white.withOpacity(0.05),

                Colors.white.withOpacity(0.025),
              ],
            ),

            border: Border.all(color: Colors.white.withOpacity(0.06)),

            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.02),

                blurRadius: 18,

                spreadRadius: 1,
              ),
            ],
          ),

          //////////////////////////////////////////////////////
          /// TAB BAR
          //////////////////////////////////////////////////////
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,

              highlightColor: Colors.transparent,
            ),

            child: TabBar(
              controller: controller,

              isScrollable: scrollable,

              dividerColor: Colors.transparent,

              indicatorSize: TabBarIndicatorSize.tab,

              overlayColor: MaterialStateProperty.all(Colors.transparent),

              splashBorderRadius: BorderRadius.circular(indicatorRadius),

              //////////////////////////////////////////////////
              /// INDICATOR
              //////////////////////////////////////////////////
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(indicatorRadius),

                gradient: LinearGradient(
                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                  colors: [
                    const Color(0xFF22D3EE).withOpacity(0.24),

                    const Color(0xFF3B82F6).withOpacity(0.14),
                  ],
                ),

                border: Border.all(
                  color: const Color(0xFF22D3EE).withOpacity(0.30),
                ),

                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22D3EE).withOpacity(0.10),

                    blurRadius: 16,

                    spreadRadius: 1,
                  ),
                ],
              ),

              //////////////////////////////////////////////////
              /// LABELS
              //////////////////////////////////////////////////
              labelColor: selected,

              unselectedLabelColor: unselected,

              labelStyle: TextStyle(
                fontSize: fontSize,

                fontWeight: FontWeight.w700,

                letterSpacing: -0.1,
              ),

              unselectedLabelStyle: TextStyle(
                fontSize: fontSize,

                fontWeight: FontWeight.w600,
              ),

              //////////////////////////////////////////////////
              /// TABS
              //////////////////////////////////////////////////
              tabs: tabs
                  .map(
                    (tab) => Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: scrollable ? 8 : 0,
                        ),

                        child: FittedBox(
                          fit: BoxFit.scaleDown,

                          child: Text(
                            tab,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
