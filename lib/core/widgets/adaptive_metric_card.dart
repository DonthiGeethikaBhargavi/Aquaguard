import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveMetricCard extends StatelessWidget {
  final String title;

  final String value;

  final String? unit;

  final IconData icon;

  final Color color;

  final String? trend;

  final Widget? footer;

  final VoidCallback? onTap;

  const AdaptiveMetricCard({
    super.key,

    required this.title,

    required this.value,

    required this.icon,

    required this.color,

    this.unit,

    this.trend,

    this.footer,

    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final card = ClipRRect(
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
              /// TOP ROW
              //////////////////////////////////////////////////////////////
              Row(
                children: [
                  //////////////////////////////////////////////////////////
                  /// ICON
                  //////////////////////////////////////////////////////////
                  Container(
                    width: isMobile ? 52 : 60,

                    height: isMobile ? 52 : 60,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),

                      color: color.withOpacity(0.14),

                      border: Border.all(color: color.withOpacity(0.22)),
                    ),

                    child: Icon(icon, color: color, size: isMobile ? 24 : 28),
                  ),

                  const Spacer(),

                  //////////////////////////////////////////////////////////
                  /// TREND
                  //////////////////////////////////////////////////////////
                  if (trend != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,

                        vertical: 7,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),

                        color: Colors.white.withOpacity(0.05),
                      ),

                      child: Text(
                        trend!,

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),

                          fontSize: isMobile ? 11 : 12,

                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: isMobile ? 22 : 28),

              //////////////////////////////////////////////////////////////
              /// TITLE
              //////////////////////////////////////////////////////////////
              Text(
                title,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: Colors.white.withOpacity(0.68),

                  fontSize: isMobile ? 13 : 14,

                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: isMobile ? 10 : 14),

              //////////////////////////////////////////////////////////////
              /// VALUE
              //////////////////////////////////////////////////////////////
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,

                spacing: 8,

                runSpacing: 6,

                children: [
                  Text(
                    value,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: isMobile ? 30 : 38,

                      fontWeight: FontWeight.w800,

                      letterSpacing: -1.1,
                    ),
                  ),

                  if (unit != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),

                      child: Text(
                        unit!,

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.62),

                          fontSize: isMobile ? 13 : 15,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
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

    //////////////////////////////////////////////////////////
    /// TAP
    //////////////////////////////////////////////////////////

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(30),

        onTap: onTap,

        child: card,
      ),
    );
  }
}
