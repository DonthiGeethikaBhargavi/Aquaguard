import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final String? subtitle;

  final Widget? leading;

  final List<Widget>? actions;

  final bool centerTitle;

  const AdaptiveAppBar({
    super.key,

    required this.title,

    this.subtitle,

    this.leading,

    this.actions,

    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

        child: AppBar(
          elevation: 0,

          scrolledUnderElevation: 0,

          automaticallyImplyLeading: false,

          centerTitle: centerTitle,

          backgroundColor: Colors.black.withOpacity(0.22),

          surfaceTintColor: Colors.transparent,

          toolbarHeight: isMobile ? 76 : 84,

          leading: leading != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),

                  child: leading,
                )
              : null,

          titleSpacing: isMobile ? 12 : 18,

          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,

            children: [
              //////////////////////////////////////////////////////////////
              /// TITLE
              //////////////////////////////////////////////////////////////
              Text(
                title,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: Colors.white,

                  fontSize: isMobile ? 22 : 26,

                  fontWeight: FontWeight.w800,

                  letterSpacing: -0.5,
                ),
              ),

              //////////////////////////////////////////////////////////////
              /// SUBTITLE
              //////////////////////////////////////////////////////////////
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),

                  child: Text(
                    subtitle!,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.62),

                      fontSize: isMobile ? 12 : 13,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          //////////////////////////////////////////////////////////////
          /// ACTIONS
          //////////////////////////////////////////////////////////////
          actions: actions != null
              ? [...actions!, const SizedBox(width: 10)]
              : null,
        ),
      ),
    );
  }
}
