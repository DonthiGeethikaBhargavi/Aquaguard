import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveChartContainer extends StatelessWidget {
  final Widget child;

  final String? title;

  final Widget? trailing;

  final double? mobileAspectRatio;

  final double? tabletAspectRatio;

  final double? desktopAspectRatio;

  const AdaptiveChartContainer({
    super.key,

    required this.child,

    this.title,

    this.trailing,

    this.mobileAspectRatio,

    this.tabletAspectRatio,

    this.desktopAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////
    /// RESPONSIVE
    //////////////////////////////////////////////////////////

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    //////////////////////////////////////////////////////////
    /// ASPECT RATIO
    //////////////////////////////////////////////////////////

    double ratio;

    if (isMobile) {
      ratio = mobileAspectRatio ?? 1.0;
    } else if (isTablet) {
      ratio = tabletAspectRatio ?? 1.45;
    } else {
      ratio = desktopAspectRatio ?? 1.9;
    }

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
                Colors.white.withOpacity(0.05),

                Colors.white.withOpacity(0.025),
              ],
            ),

            border: Border.all(color: Colors.white.withOpacity(0.06)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),

                blurRadius: 24,

                spreadRadius: 2,
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //////////////////////////////////////////////////////////////
              /// HEADER
              //////////////////////////////////////////////////////////////
              if (title != null)
                Padding(
                  padding: EdgeInsets.only(bottom: isMobile ? 18 : 24),

                  child: Row(
                    children: [
                      //////////////////////////////////////////////////////
                      /// TITLE
                      //////////////////////////////////////////////////////
                      Expanded(
                        child: Text(
                          title!,

                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: isMobile ? 18 : 22,

                            fontWeight: FontWeight.w800,

                            letterSpacing: -0.4,
                          ),
                        ),
                      ),

                      //////////////////////////////////////////////////////
                      /// TRAILING
                      //////////////////////////////////////////////////////
                      if (trailing != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12),

                          child: trailing!,
                        ),
                    ],
                  ),
                ),

              //////////////////////////////////////////////////////////////
              /// CHART
              //////////////////////////////////////////////////////////////
              AspectRatio(
                aspectRatio: ratio,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
