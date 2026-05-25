import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveHeader extends StatelessWidget {
  final String title;

  final String? subtitle;

  final Widget? leading;

  final Widget? trailing;

  final bool glass;

  const AdaptiveHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.glass = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    ////////////////////////////////////////////////////////////
    /// CONTENT
    ////////////////////////////////////////////////////////////

    final content = Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        gradient: LinearGradient(
          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [
            Colors.white.withValues(alpha: 0.05),

            Colors.white.withValues(alpha: 0.025),
          ],
        ),

        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          //////////////////////////////////////////////////////
          /// LEADING
          //////////////////////////////////////////////////////
          if (leading != null)
            Padding(padding: const EdgeInsets.only(right: 14), child: leading!),

          //////////////////////////////////////////////////////
          /// TITLE AREA
          //////////////////////////////////////////////////////
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //////////////////////////////////////////////////
                /// TITLE
                //////////////////////////////////////////////////
                Text(
                  title,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: isMobile ? 24 : 32,

                    fontWeight: FontWeight.w800,

                    letterSpacing: -0.6,

                    height: 1.0,
                  ),
                ),

                //////////////////////////////////////////////////
                /// SUBTITLE
                //////////////////////////////////////////////////
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),

                    child: Text(
                      subtitle!,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),

                        fontSize: isMobile ? 13 : 15,

                        fontWeight: FontWeight.w500,

                        height: 1.2,

                        letterSpacing: -0.1,
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
            Padding(padding: const EdgeInsets.only(left: 10), child: trailing!),
        ],
      ),
    );

    ////////////////////////////////////////////////////////////
    /// GLASS EFFECT
    ////////////////////////////////////////////////////////////

    if (!glass) {
      return content;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: content,
      ),
    );
  }
}
