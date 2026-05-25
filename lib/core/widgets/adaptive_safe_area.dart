import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveSafeArea extends StatelessWidget {
  final Widget child;

  final bool top;

  final bool bottom;

  final bool left;

  final bool right;

  final bool maintainBottomViewPadding;

  final bool minimumBottomPadding;

  final bool useResponsivePadding;

  final Color? backgroundColor;

  final EdgeInsetsGeometry? minimum;

  const AdaptiveSafeArea({
    super.key,

    required this.child,

    this.top = true,

    this.bottom = true,

    this.left = true,

    this.right = true,

    this.maintainBottomViewPadding = true,

    this.minimumBottomPadding = true,

    this.useResponsivePadding = false,

    this.backgroundColor,

    this.minimum,
  });

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////
    /// RESPONSIVE
    //////////////////////////////////////////////////////////

    final isDesktop = ResponsiveHelper.isDesktop(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    //////////////////////////////////////////////////////////
    /// MINIMUM PADDING
    //////////////////////////////////////////////////////////

    EdgeInsets resolvedMinimum = EdgeInsets.zero;

    if (useResponsivePadding) {
      resolvedMinimum = EdgeInsets.symmetric(
        horizontal: isDesktop
            ? 18
            : isTablet
            ? 12
            : 8,
      );
    }

    //////////////////////////////////////////////////////////
    /// BOTTOM SPACE
    //////////////////////////////////////////////////////////

    if (minimumBottomPadding && bottom) {
      resolvedMinimum = resolvedMinimum.copyWith(bottom: isDesktop ? 12 : 8);
    }

    //////////////////////////////////////////////////////////
    /// CUSTOM MINIMUM
    //////////////////////////////////////////////////////////

    if (minimum != null && minimum is EdgeInsets) {
      resolvedMinimum = minimum as EdgeInsets;
    }

    //////////////////////////////////////////////////////////
    /// SAFE AREA
    //////////////////////////////////////////////////////////

    return ColoredBox(
      color: backgroundColor ?? const Color(0xFF070B14),

      child: SafeArea(
        top: top,

        bottom: bottom,

        left: left,

        right: right,

        minimum: resolvedMinimum,

        maintainBottomViewPadding: maintainBottomViewPadding,

        child: child,
      ),
    );
  }
}
