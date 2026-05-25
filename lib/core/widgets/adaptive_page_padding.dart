import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptivePagePadding extends StatelessWidget {
  final Widget child;

  final bool removeTopPadding;

  final bool removeBottomPadding;

  final bool removeHorizontalPadding;

  final bool compact;

  final EdgeInsetsGeometry? customPadding;

  final double? topPadding;

  final double? bottomPadding;

  final double? horizontalPadding;

  const AdaptivePagePadding({
    super.key,

    required this.child,

    this.removeTopPadding = false,

    this.removeBottomPadding = false,

    this.removeHorizontalPadding = false,

    this.compact = false,

    this.customPadding,

    this.topPadding,

    this.bottomPadding,

    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////
    /// RESPONSIVE
    //////////////////////////////////////////////////////////

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    //////////////////////////////////////////////////////////
    /// HORIZONTAL
    //////////////////////////////////////////////////////////

    final horizontal = removeHorizontalPadding
        ? 0.0
        : (horizontalPadding ?? ResponsiveHelper.horizontalPadding(context));

    //////////////////////////////////////////////////////////
    /// TOP
    //////////////////////////////////////////////////////////

    final top = removeTopPadding
        ? 0.0
        : (topPadding ??
              (compact
                  ? (isMobile ? 12.0 : 16.0)
                  : (isMobile
                        ? 16.0
                        : isTablet
                        ? 22.0
                        : 28.0)));

    //////////////////////////////////////////////////////////
    /// BOTTOM
    //////////////////////////////////////////////////////////

    final bottom = removeBottomPadding
        ? 0.0
        : (bottomPadding ??
              (compact
                  ? (isMobile ? 14.0 : 18.0)
                  : (isMobile
                        ? 22.0
                        : isTablet
                        ? 30.0
                        : 40.0)));

    //////////////////////////////////////////////////////////
    /// PADDING
    //////////////////////////////////////////////////////////

    final padding =
        customPadding ??
        EdgeInsets.only(
          left: horizontal,

          right: horizontal,

          top: top,

          bottom: bottom,
        );

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    return Padding(padding: padding, child: child);
  }
}
