import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveConstraints extends StatelessWidget {
  final Widget child;

  final double? mobileMaxWidth;

  final double? tabletMaxWidth;

  final double? desktopMaxWidth;

  final Alignment alignment;

  const AdaptiveConstraints({
    super.key,

    required this.child,

    this.mobileMaxWidth,

    this.tabletMaxWidth,

    this.desktopMaxWidth,

    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth;

    //////////////////////////////////////////////////////////
    /// MOBILE
    //////////////////////////////////////////////////////////

    if (ResponsiveHelper.isMobile(context)) {
      maxWidth = mobileMaxWidth ?? MediaQuery.of(context).size.width;
    }
    //////////////////////////////////////////////////////////
    /// TABLET
    //////////////////////////////////////////////////////////
    else if (ResponsiveHelper.isTablet(context)) {
      maxWidth = tabletMaxWidth ?? 900;
    }
    //////////////////////////////////////////////////////////
    /// DESKTOP
    //////////////////////////////////////////////////////////
    else {
      maxWidth = desktopMaxWidth ?? 1400;
    }

    return Align(
      alignment: alignment,

      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),

        child: child,
      ),
    );
  }
}
