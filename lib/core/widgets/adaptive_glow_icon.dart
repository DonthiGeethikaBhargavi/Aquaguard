import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveGlowIcon extends StatelessWidget {
  final IconData icon;

  final Color color;

  final double? size;

  final double glow;

  final EdgeInsetsGeometry? padding;

  final bool background;

  const AdaptiveGlowIcon({
    super.key,

    required this.icon,

    required this.color,

    this.size,

    this.glow = 18,

    this.padding,

    this.background = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final iconSize = size ?? (isMobile ? 24.0 : 30.0);

    final widget = Icon(
      icon,

      color: color,

      size: iconSize,

      shadows: [Shadow(color: color.withOpacity(0.55), blurRadius: glow)],
    );

    //////////////////////////////////////////////////////////
    /// WITHOUT BACKGROUND
    //////////////////////////////////////////////////////////

    if (!background) {
      return widget;
    }

    return Container(
      padding: padding ?? EdgeInsets.all(isMobile ? 14 : 18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        color: color.withOpacity(0.12),

        border: Border.all(color: color.withOpacity(0.18)),

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.10),

            blurRadius: 24,

            spreadRadius: 2,
          ),
        ],
      ),

      child: widget,
    );
  }
}
