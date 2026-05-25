import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? badge;

  final bool center;
  final bool compact;

  final EdgeInsetsGeometry? padding;

  final int titleMaxLines;
  final int subtitleMaxLines;

  const AdaptiveSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.badge,
    this.center = false,
    this.compact = false,
    this.padding,
    this.titleMaxLines = 2,
    this.subtitleMaxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    ////////////////////////////////////////////////////////////
    /// TYPOGRAPHY
    ////////////////////////////////////////////////////////////

    final double titleSize = compact
        ? (isMobile ? 18 : 22)
        : (isMobile
              ? 22
              : isTablet
              ? 28
              : 32);

    final double subtitleSize = compact ? 12 : (isMobile ? 13 : 15);

    ////////////////////////////////////////////////////////////
    /// SPACING
    ////////////////////////////////////////////////////////////

    final double subtitleSpacing = compact ? 6 : 10;

    ////////////////////////////////////////////////////////////
    /// CONTENT
    ////////////////////////////////////////////////////////////

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////
          /// TEXT CONTENT
          //////////////////////////////////////////////////////
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: center
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                //////////////////////////////////////////////////////////
                /// BADGE
                //////////////////////////////////////////////////////////
                if (badge != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: badge!,
                  ),

                //////////////////////////////////////////////////////////
                /// TITLE
                //////////////////////////////////////////////////////////
                Text(
                  title,
                  maxLines: titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: center ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    height: 1.05,
                  ),
                ),

                //////////////////////////////////////////////////////////
                /// SUBTITLE
                //////////////////////////////////////////////////////////
                if (subtitle != null && subtitle!.trim().isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: subtitleSpacing),
                    child: Text(
                      subtitle!,
                      maxLines: subtitleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      textAlign: center ? TextAlign.center : TextAlign.start,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          //////////////////////////////////////////////////////
          /// TRAILING
          //////////////////////////////////////////////////////
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Align(alignment: Alignment.topRight, child: trailing!),
            ),
        ],
      ),
    );
  }
}
