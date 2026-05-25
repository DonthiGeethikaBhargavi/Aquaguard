import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveChartAspect extends StatelessWidget {
  final Widget child;

  final double? mobileAspectRatio;

  final double? tabletAspectRatio;

  final double? desktopAspectRatio;

  final double? ultraWideAspectRatio;

  final double? minHeight;

  final double? maxHeight;

  final bool useConstrainedHeight;

  final EdgeInsetsGeometry? padding;

  final Alignment alignment;

  const AdaptiveChartAspect({
    super.key,

    required this.child,

    this.mobileAspectRatio,

    this.tabletAspectRatio,

    this.desktopAspectRatio,

    this.ultraWideAspectRatio,

    this.minHeight,

    this.maxHeight,

    this.useConstrainedHeight = true,

    this.padding,

    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////
    /// RESPONSIVE
    //////////////////////////////////////////////////////////

    final width = MediaQuery.of(context).size.width;

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    final isUltraWide = ResponsiveHelper.isUltraWide(context);

    //////////////////////////////////////////////////////////
    /// RATIO
    //////////////////////////////////////////////////////////

    double ratio;

    if (isMobile) {
      if (width < 380) {
        ratio = mobileAspectRatio ?? 0.92;
      } else {
        ratio = mobileAspectRatio ?? 1.02;
      }
    } else if (isTablet) {
      ratio = tabletAspectRatio ?? 1.42;
    } else if (isUltraWide) {
      ratio = ultraWideAspectRatio ?? 2.15;
    } else {
      ratio = desktopAspectRatio ?? 1.92;
    }

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    Widget content = AspectRatio(aspectRatio: ratio, child: child);

    //////////////////////////////////////////////////////////
    /// HEIGHT CONSTRAINTS
    //////////////////////////////////////////////////////////

    if (useConstrainedHeight) {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? (isMobile ? 240 : 320),

          maxHeight: maxHeight ?? (isUltraWide ? 620 : 520),
        ),

        child: content,
      );
    }

    //////////////////////////////////////////////////////////
    /// PADDING
    //////////////////////////////////////////////////////////

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    //////////////////////////////////////////////////////////
    /// ALIGNMENT
    //////////////////////////////////////////////////////////

    return Align(
      alignment: alignment,

      child: RepaintBoundary(child: content),
    );
  }
}
