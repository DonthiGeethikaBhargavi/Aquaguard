import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveGradientBackground extends StatefulWidget {
  final Widget child;

  final bool animated;

  final bool showTopGlow;

  final bool showBottomGlow;

  final bool showMeshGradient;

  final double opacity;

  const AdaptiveGradientBackground({
    super.key,

    required this.child,

    this.animated = true,

    this.showTopGlow = true,

    this.showBottomGlow = true,

    this.showMeshGradient = true,

    this.opacity = 1,
  });

  @override
  State<AdaptiveGradientBackground> createState() =>
      _AdaptiveGradientBackgroundState();
}

class _AdaptiveGradientBackgroundState extends State<AdaptiveGradientBackground>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLER
  ////////////////////////////////////////////////////////////

  late final AnimationController _controller;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(seconds: 18),
    );

    if (widget.animated) {
      _controller.repeat();
    }
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
    final isDesktop = ResponsiveHelper.isDesktop(context);

    final width = MediaQuery.of(context).size.width;

    //////////////////////////////////////////////////////////
    /// GLOW SIZES
    //////////////////////////////////////////////////////////

    final topGlowSize = isDesktop ? 520.0 : 360.0;

    final bottomGlowSize = isDesktop ? 420.0 : 300.0;

    //////////////////////////////////////////////////////////
    /// BACKGROUND
    //////////////////////////////////////////////////////////

    return AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {
        final animation = _controller.value;

        final topOffset = math.sin(animation * math.pi * 2) * 18;

        final bottomOffset = math.cos(animation * math.pi * 2) * 14;

        return RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,

                end: Alignment.bottomCenter,

                colors: [
                  const Color(0xFF020617).withOpacity(widget.opacity),

                  const Color(0xFF071122).withOpacity(widget.opacity),

                  const Color(0xFF020617).withOpacity(widget.opacity),
                ],
              ),
            ),

            child: Stack(
              fit: StackFit.expand,

              children: [
                ////////////////////////////////////////////////////////////
                /// TOP CYAN GLOW
                ////////////////////////////////////////////////////////////
                if (widget.showTopGlow)
                  Positioned(
                    top: -180 + topOffset,

                    right: width > 1400 ? -40 : -80,

                    child: _GlowOrb(
                      size: topGlowSize,

                      color: const Color(0xFF22D3EE).withOpacity(0.10),
                    ),
                  ),

                ////////////////////////////////////////////////////////////
                /// BOTTOM BLUE GLOW
                ////////////////////////////////////////////////////////////
                if (widget.showBottomGlow)
                  Positioned(
                    bottom: -160 + bottomOffset,

                    left: width > 1400 ? -40 : -100,

                    child: _GlowOrb(
                      size: bottomGlowSize,

                      color: const Color(0xFF3B82F6).withOpacity(0.08),
                    ),
                  ),

                ////////////////////////////////////////////////////////////
                /// CENTER MESH
                ////////////////////////////////////////////////////////////
                if (widget.showMeshGradient)
                  Align(
                    alignment: Alignment.center,

                    child: Container(
                      width: width * 0.85,

                      height: width * 0.85,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF0EA5E9).withOpacity(0.04),

                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                ////////////////////////////////////////////////////////////
                /// CONTENT
                ////////////////////////////////////////////////////////////
                widget.child,
              ],
            ),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// GLOW ORB
////////////////////////////////////////////////////////////

class _GlowOrb extends StatelessWidget {
  final double size;

  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          gradient: RadialGradient(
            colors: [color, color.withOpacity(0.35), Colors.transparent],
          ),
        ),
      ),
    );
  }
}
