import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';
import 'adaptive_status_indicator.dart';

enum SensorTrendDirection { up, down, stable }

class AdaptiveSensorCard extends StatelessWidget {
  final String title;

  final String value;

  final String unit;

  final IconData icon;

  final Color color;

  final AdaptiveStatus status;

  final String? subtitle;

  final String? trend;

  final SensorTrendDirection trendDirection;

  final VoidCallback? onTap;

  final Widget? footer;

  final Widget? trailing;

  final bool glow;

  final bool compact;

  final bool animateGlow;

  final bool showTrendIcon;

  final bool showStatus;

  final Widget? badge;

  final EdgeInsetsGeometry? padding;

  const AdaptiveSensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.status,
    this.subtitle,
    this.trend,
    this.trendDirection = SensorTrendDirection.stable,
    this.onTap,
    this.footer,
    this.trailing,
    this.glow = true,
    this.compact = true,
    this.animateGlow = true,
    this.showTrendIcon = true,
    this.showStatus = true,
    this.badge,
    this.padding,
  });

  ////////////////////////////////////////////////////////////
  /// TREND ICON
  ////////////////////////////////////////////////////////////

  IconData get trendIcon {
    switch (trendDirection) {
      case SensorTrendDirection.up:
        return Icons.trending_up_rounded;

      case SensorTrendDirection.down:
        return Icons.trending_down_rounded;

      case SensorTrendDirection.stable:
        return Icons.trending_flat_rounded;
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    //////////////////////////////////////////////////////////
    /// SIZING
    //////////////////////////////////////////////////////////

    final radius = compact ? 24.0 : (isMobile ? 28.0 : 34.0);

    final resolvedPadding =
        padding ??
        EdgeInsets.all(
          compact
              ? (isMobile ? 14 : 18)
              : (isMobile
                    ? 18
                    : isTablet
                    ? 22
                    : 26),
        );

    //////////////////////////////////////////////////////////
    /// ICON BOX
    //////////////////////////////////////////////////////////

    final iconBox = compact
        ? (isMobile ? 72.0 : 80.0)
        : (isMobile ? 84.0 : 92.0);

    //////////////////////////////////////////////////////////
    /// VALUE SIZE
    //////////////////////////////////////////////////////////

    final valueSize = compact
        ? (isMobile ? 24.0 : 32.0)
        : (isMobile ? 34.0 : 46.0);

    //////////////////////////////////////////////////////////
    /// CARD
    //////////////////////////////////////////////////////////

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),

          padding: resolvedPadding,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),

            gradient: LinearGradient(
              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: [
                color.withValues(alpha: 0.10),

                Colors.white.withValues(alpha: 0.025),
              ],
            ),

            border: Border.all(color: color.withValues(alpha: 0.16)),

            boxShadow: glow
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: animateGlow ? 0.10 : 0.06),

                      blurRadius: compact ? 18 : 28,

                      spreadRadius: compact ? 1 : 2,
                    ),
                  ]
                : [],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [
              ////////////////////////////////////////////////////////////
              /// HEADER
              ////////////////////////////////////////////////////////////
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  //////////////////////////////////////////////////////////
                  /// ICON
                  //////////////////////////////////////////////////////////
                  Container(
                    width: iconBox,
                    height: iconBox,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(compact ? 18 : 22),

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,

                        end: Alignment.bottomRight,

                        colors: [
                          color.withValues(alpha: 0.22),

                          color.withValues(alpha: 0.08),
                        ],
                      ),

                      border: Border.all(color: color.withValues(alpha: 0.20)),
                    ),

                    child: Icon(
                      icon,

                      color: color,

                      size: compact
                          ? (isMobile ? 22 : 26)
                          : (isMobile ? 24 : 30),
                    ),
                  ),

                  const SizedBox(width: 10),

                  //////////////////////////////////////////////////////////
                  /// RIGHT SIDE
                  //////////////////////////////////////////////////////////
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        //////////////////////////////////////////////////////
                        /// BADGE
                        //////////////////////////////////////////////////////
                        if (badge != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),

                            child: badge!,
                          ),

                        //////////////////////////////////////////////////////
                        /// STATUS
                        //////////////////////////////////////////////////////
                        if (showStatus)
                          FittedBox(
                            fit: BoxFit.scaleDown,

                            child:
                                trailing ??
                                AdaptiveStatusIndicator(
                                  status: status,

                                  expanded: false,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: compact ? 18 : (isMobile ? 22 : 28)),

              ////////////////////////////////////////////////////////////
              /// TITLE
              ////////////////////////////////////////////////////////////
              Text(
                title,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),

                  fontSize: compact ? 12 : (isMobile ? 13 : 14),

                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: compact ? 8 : (isMobile ? 14 : 18)),

              ////////////////////////////////////////////////////////////
              /// VALUE
              ////////////////////////////////////////////////////////////
              FittedBox(
                fit: BoxFit.scaleDown,

                alignment: Alignment.centerLeft,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    ////////////////////////////////////////////////////////
                    /// VALUE
                    ////////////////////////////////////////////////////////
                    Text(
                      value,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: valueSize,

                        fontWeight: FontWeight.w800,

                        height: 0.95,

                        letterSpacing: -1.1,
                      ),
                    ),

                    ////////////////////////////////////////////////////////
                    /// UNIT
                    ////////////////////////////////////////////////////////
                    Padding(
                      padding: EdgeInsets.only(
                        left: 6,

                        bottom: compact ? 3 : 6,
                      ),

                      child: Text(
                        unit,

                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.62),

                          fontSize: compact ? 11 : (isMobile ? 13 : 15),

                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ////////////////////////////////////////////////////////////
              /// SUBTITLE
              ////////////////////////////////////////////////////////////
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 14),

                  child: Text(
                    subtitle!,

                    maxLines: compact ? 2 : (isMobile ? 3 : 4),

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.58),

                      fontSize: compact ? 10 : (isMobile ? 12 : 13),

                      height: 1.5,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              ////////////////////////////////////////////////////////////
              /// TREND
              ////////////////////////////////////////////////////////////
              if (trend != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),

                  child: Row(
                    children: [
                      //////////////////////////////////////////////////////
                      /// ICON
                      //////////////////////////////////////////////////////
                      if (showTrendIcon)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),

                          child: Icon(
                            trendIcon,

                            color: color,

                            size: compact ? 14 : (isMobile ? 18 : 20),
                          ),
                        ),

                      //////////////////////////////////////////////////////
                      /// TEXT
                      //////////////////////////////////////////////////////
                      Expanded(
                        child: Text(
                          trend!,

                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: color,

                            fontSize: compact ? 11 : (isMobile ? 12 : 13),

                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ////////////////////////////////////////////////////////////
              /// FOOTER
              ////////////////////////////////////////////////////////////
              if (footer != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),

                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    );

    //////////////////////////////////////////////////////////
    /// TAP
    //////////////////////////////////////////////////////////

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(radius),

          onTap: onTap,

          child: card,
        ),
      );
    }

    //////////////////////////////////////////////////////////
    /// REPAINT
    //////////////////////////////////////////////////////////

    return RepaintBoundary(child: card);
  }
}
