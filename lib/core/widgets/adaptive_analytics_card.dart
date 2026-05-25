import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveAnalyticsCard extends StatelessWidget {
  final String title;

  final String value;

  final String? subtitle;

  final IconData icon;

  final Color color;

  final Widget? chart;

  final Widget? footer;

  const AdaptiveAnalyticsCard({
    super.key,

    required this.title,

    required this.value,

    required this.icon,

    required this.color,

    this.subtitle,

    this.chart,

    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: Container(
          padding: EdgeInsets.all(isMobile ? 18 : 24),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            gradient: LinearGradient(
              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: [
                color.withOpacity(0.10),

                Colors.white.withOpacity(0.025),
              ],
            ),

            border: Border.all(color: color.withOpacity(0.16)),

            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),

                blurRadius: 24,

                spreadRadius: 2,
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //////////////////////////////////////////////////////////////
              /// TOP
              //////////////////////////////////////////////////////////////
              Row(
                children: [
                  //////////////////////////////////////////////////////////
                  /// ICON
                  //////////////////////////////////////////////////////////
                  Container(
                    width: isMobile ? 54 : 62,

                    height: isMobile ? 54 : 62,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),

                      color: color.withOpacity(0.14),

                      border: Border.all(color: color.withOpacity(0.22)),
                    ),

                    child: Icon(icon, color: color, size: isMobile ? 24 : 30),
                  ),

                  const Spacer(),

                  //////////////////////////////////////////////////////////
                  /// VALUE
                  //////////////////////////////////////////////////////////
                  Flexible(
                    child: Text(
                      value,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      textAlign: TextAlign.end,

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: isMobile ? 28 : 38,

                        fontWeight: FontWeight.w800,

                        letterSpacing: -1.1,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 24 : 30),

              //////////////////////////////////////////////////////////////
              /// TITLE
              //////////////////////////////////////////////////////////////
              Text(
                title,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: Colors.white,

                  fontSize: isMobile ? 18 : 22,

                  fontWeight: FontWeight.w800,
                ),
              ),

              //////////////////////////////////////////////////////////////
              /// SUBTITLE
              //////////////////////////////////////////////////////////////
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),

                  child: Text(
                    subtitle!,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.62),

                      fontSize: isMobile ? 13 : 14,

                      height: 1.5,
                    ),
                  ),
                ),

              //////////////////////////////////////////////////////////////
              /// CHART
              //////////////////////////////////////////////////////////////
              if (chart != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22),

                    child: chart!,
                  ),
                ),

              //////////////////////////////////////////////////////////////
              /// FOOTER
              //////////////////////////////////////////////////////////////
              if (footer != null)
                Padding(
                  padding: const EdgeInsets.only(top: 18),

                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
