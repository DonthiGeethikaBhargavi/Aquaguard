import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveLoading extends StatefulWidget {
  final String? label;

  final double? size;

  final bool fullScreen;

  final bool compact;

  final bool showBackgroundGlow;

  final EdgeInsetsGeometry? padding;

  const AdaptiveLoading({
    super.key,

    this.label,

    this.size,

    this.fullScreen = false,

    this.compact = false,

    this.showBackgroundGlow = true,

    this.padding,
  });

  @override
  State<AdaptiveLoading> createState() => _AdaptiveLoadingState();
}

class _AdaptiveLoadingState extends State<AdaptiveLoading>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLER
  ////////////////////////////////////////////////////////////

  late AnimationController _controller;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    //////////////////////////////////////////////////////////
    /// SIZING
    //////////////////////////////////////////////////////////

    final loaderSize =
        widget.size ?? (widget.compact ? 28.0 : (isMobile ? 38.0 : 46.0));

    final radius = widget.compact ? 22.0 : 30.0;

    final horizontalPadding = widget.compact ? 18.0 : (isMobile ? 24.0 : 34.0);

    final verticalPadding = widget.compact ? 16.0 : (isMobile ? 22.0 : 30.0);

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    final content = AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {
        final glow = 0.08 + (_controller.value * 0.06);

        return Center(
          child: Stack(
            alignment: Alignment.center,

            children: [
              //////////////////////////////////////////////////////////////
              /// BACKGROUND GLOW
              //////////////////////////////////////////////////////////////
              if (widget.showBackgroundGlow)
                Container(
                  width: loaderSize * 4.2,

                  height: loaderSize * 4.2,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF35E7FF).withOpacity(glow),

                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

              //////////////////////////////////////////////////////////////
              /// CARD
              //////////////////////////////////////////////////////////////
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),

                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                  child: Container(
                    padding:
                        widget.padding ??
                        EdgeInsets.symmetric(
                          horizontal: horizontalPadding,

                          vertical: verticalPadding,
                        ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,

                        end: Alignment.bottomRight,

                        colors: [
                          Colors.white.withOpacity(0.06),

                          Colors.white.withOpacity(0.03),
                        ],
                      ),

                      border: Border.all(color: Colors.white.withOpacity(0.06)),

                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF35E7FF,
                          ).withOpacity(glow * 0.45),

                          blurRadius: 24,

                          spreadRadius: 2,
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        //////////////////////////////////////////////////////
                        /// LOADER
                        //////////////////////////////////////////////////////
                        SizedBox(
                          width: loaderSize,

                          height: loaderSize,

                          child: CircularProgressIndicator(
                            strokeWidth: widget.compact ? 2.8 : 3.4,

                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF35E7FF),
                            ),
                          ),
                        ),

                        //////////////////////////////////////////////////////
                        /// LABEL
                        //////////////////////////////////////////////////////
                        if (widget.label != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: widget.compact ? 14 : 18,
                            ),

                            child: Text(
                              widget.label!,

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: Colors.white.withOpacity(0.76),

                                fontSize: widget.compact
                                    ? 12
                                    : (isMobile ? 13 : 15),

                                fontWeight: FontWeight.w600,

                                height: 1.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    //////////////////////////////////////////////////////////
    /// FULLSCREEN
    //////////////////////////////////////////////////////////

    if (widget.fullScreen) {
      return Scaffold(backgroundColor: const Color(0xFF070B14), body: content);
    }

    return content;
  }
}
