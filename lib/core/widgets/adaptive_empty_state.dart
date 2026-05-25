import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

enum AdaptiveEmptyVariant { neutral, warning, critical, success }

class AdaptiveEmptyState extends StatelessWidget {
  final String title;

  final String? description;

  final IconData? icon;

  final Widget? action;

  final bool compact;

  final bool fullWidth;

  final AdaptiveEmptyVariant variant;

  final double? maxWidth;

  final EdgeInsetsGeometry? padding;

  const AdaptiveEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.compact = false,
    this.fullWidth = false,
    this.variant = AdaptiveEmptyVariant.neutral,
    this.maxWidth,
    this.padding,
  });

  ////////////////////////////////////////////////////////////
  /// ACCENT COLOR
  ////////////////////////////////////////////////////////////

  Color get _accentColor {
    switch (variant) {
      case AdaptiveEmptyVariant.neutral:
        return const Color(0xFF35E7FF);

      case AdaptiveEmptyVariant.warning:
        return const Color(0xFFF59E0B);

      case AdaptiveEmptyVariant.critical:
        return const Color(0xFFEF4444);

      case AdaptiveEmptyVariant.success:
        return const Color(0xFF22C55E);
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    //////////////////////////////////////////////////////////
    /// RESPONSIVE SIZES
    //////////////////////////////////////////////////////////

    final radius = compact ? 24.0 : 32.0;

    final iconBox = compact
        ? (isMobile ? 66.0 : 74.0)
        : (isMobile ? 78.0 : 92.0);

    final iconSize = compact
        ? (isMobile ? 30.0 : 34.0)
        : (isMobile ? 36.0 : 44.0);

    final titleSize = compact
        ? (isMobile ? 17.0 : 20.0)
        : (isMobile ? 19.0 : 24.0);

    final bodySize = compact ? 12.0 : (isMobile ? 13.0 : 15.0);

    //////////////////////////////////////////////////////////
    /// UI
    //////////////////////////////////////////////////////////

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),

            child: Padding(
              padding: padding ?? EdgeInsets.all(isMobile ? 20 : 28),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? (isMobile ? double.infinity : 560),
                ),

                child: Stack(
                  alignment: Alignment.center,

                  children: [
                    ////////////////////////////////////////////////////////
                    /// BACKGROUND GLOW
                    ////////////////////////////////////////////////////////
                    Container(
                      width: compact ? 180 : 240,

                      height: compact ? 180 : 240,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: RadialGradient(
                          colors: [
                            _accentColor.withOpacity(0.08),

                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    ////////////////////////////////////////////////////////
                    /// GLASS CARD
                    ////////////////////////////////////////////////////////
                    ClipRRect(
                      borderRadius: BorderRadius.circular(radius),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                        child: Container(
                          width: fullWidth
                              ? double.infinity
                              : (maxWidth ??
                                    (isMobile ? double.infinity : 560)),

                          constraints: BoxConstraints(
                            maxWidth: maxWidth ?? 560,
                          ),

                          padding: EdgeInsets.all(
                            compact
                                ? (isMobile ? 22 : 26)
                                : (isMobile ? 26 : 34),
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),

                            gradient: LinearGradient(
                              begin: Alignment.topLeft,

                              end: Alignment.bottomRight,

                              colors: [
                                Colors.white.withOpacity(0.05),

                                Colors.white.withOpacity(0.025),
                              ],
                            ),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: _accentColor.withOpacity(0.06),

                                blurRadius: 28,

                                spreadRadius: 2,
                              ),
                            ],
                          ),

                          ////////////////////////////////////////////////////
                          /// CONTENT
                          ////////////////////////////////////////////////////
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              ////////////////////////////////////////////////
                              /// ICON
                              ////////////////////////////////////////////////
                              Container(
                                width: iconBox,

                                height: iconBox,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  gradient: RadialGradient(
                                    colors: [
                                      _accentColor.withOpacity(0.20),

                                      _accentColor.withOpacity(0.08),
                                    ],
                                  ),

                                  border: Border.all(
                                    color: _accentColor.withOpacity(0.16),
                                  ),
                                ),

                                child: Icon(
                                  icon ?? Icons.inbox_outlined,

                                  color: _accentColor,

                                  size: iconSize,
                                ),
                              ),

                              SizedBox(
                                height: compact ? 18 : (isMobile ? 24 : 30),
                              ),

                              ////////////////////////////////////////////////
                              /// TITLE
                              ////////////////////////////////////////////////
                              Text(
                                title,

                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.white,

                                  fontSize: titleSize,

                                  fontWeight: FontWeight.w800,

                                  letterSpacing: -0.5,

                                  height: 1.1,
                                ),
                              ),

                              ////////////////////////////////////////////////
                              /// DESCRIPTION
                              ////////////////////////////////////////////////
                              if (description != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 14),

                                  child: Text(
                                    description!,

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.68),

                                      fontSize: bodySize,

                                      height: 1.7,

                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                              ////////////////////////////////////////////////
                              /// ACTION
                              ////////////////////////////////////////////////
                              if (action != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: compact ? 22 : (isMobile ? 26 : 32),
                                  ),

                                  child: action!,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
