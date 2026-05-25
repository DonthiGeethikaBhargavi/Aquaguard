import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_helper.dart';

import '../../../../core/widgets/adaptive_realtime_badge.dart';

class AnimatedWaterLevelHeroCard extends StatefulWidget {
  final double waterLevel;

  final double aiRisk;

  final bool isOnline;

  final String deviceName;

  final String? subtitle;

  final bool animate;

  const AnimatedWaterLevelHeroCard({
    super.key,

    required this.waterLevel,

    required this.aiRisk,

    required this.isOnline,

    required this.deviceName,

    this.subtitle,

    this.animate = true,
  });

  @override
  State<AnimatedWaterLevelHeroCard> createState() =>
      _AnimatedWaterLevelHeroCardState();
}

class _AnimatedWaterLevelHeroCardState extends State<AnimatedWaterLevelHeroCard>
    with TickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLERS
  ////////////////////////////////////////////////////////////

  late final AnimationController _waveController;

  late final AnimationController _pulseController;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 2600),
    );

    _pulseController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1800),
    );

    if (widget.animate) {
      _waveController.repeat();

      _pulseController.repeat(reverse: true);
    }
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _waveController.dispose();

    _pulseController.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    //////////////////////////////////////////////////////////
    /// HEIGHT
    //////////////////////////////////////////////////////////

    final cardHeight = isMobile
        ? 300.0
        : isTablet
        ? 340.0
        : 380.0;

    //////////////////////////////////////////////////////////
    /// CONTENT PADDING
    //////////////////////////////////////////////////////////

    final contentPadding = isMobile ? 22.0 : 30.0;

    //////////////////////////////////////////////////////////
    /// HERO
    //////////////////////////////////////////////////////////

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),

          child: Container(
            height: cardHeight,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),

              gradient: LinearGradient(
                begin: Alignment.topLeft,

                end: Alignment.bottomRight,

                colors: [
                  const Color(0xFF0F172A).withOpacity(0.96),

                  const Color(0xFF111827).withOpacity(0.92),

                  const Color(0xFF1E293B).withOpacity(0.90),
                ],
              ),

              border: Border.all(color: Colors.white.withOpacity(0.08)),

              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.08),

                  blurRadius: 34,

                  spreadRadius: 4,
                ),
              ],
            ),

            child: Stack(
              children: [
                ////////////////////////////////////////////////////////////
                /// WATER
                ////////////////////////////////////////////////////////////
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _waveController,

                    builder: (context, child) {
                      return CustomPaint(
                        painter: _WaterPainter(
                          waterLevel: widget.waterLevel / 100,

                          waveOffset: _waveController.value * 2 * pi,
                        ),
                      );
                    },
                  ),
                ),

                ////////////////////////////////////////////////////////////
                /// ATMOSPHERIC GLOW
                ////////////////////////////////////////////////////////////
                Positioned(
                  top: -120,
                  left: -40,

                  child: IgnorePointer(
                    child: Container(
                      width: 280,
                      height: 280,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: RadialGradient(
                          colors: [
                            Colors.cyanAccent.withOpacity(0.08),

                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////////
                /// TOP OVERLAY
                ////////////////////////////////////////////////////////////
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38),

                      gradient: LinearGradient(
                        begin: Alignment.topCenter,

                        end: Alignment.bottomCenter,

                        colors: [
                          Colors.white.withOpacity(0.08),

                          Colors.transparent,

                          Colors.black.withOpacity(0.12),
                        ],
                      ),
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////////
                /// CONTENT
                ////////////////////////////////////////////////////////////
                Padding(
                  padding: EdgeInsets.all(contentPadding),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      ////////////////////////////////////////////////////////
                      /// TOP
                      ////////////////////////////////////////////////////////
                      Row(
                        children: [
                          ////////////////////////////////////////////////////
                          /// REALTIME
                          ////////////////////////////////////////////////////
                          AdaptiveRealtimeBadge(
                            compact: true,

                            state: widget.isOnline
                                ? AdaptiveRealtimeState.live
                                : AdaptiveRealtimeState.offline,
                          ),

                          const Spacer(),

                          ////////////////////////////////////////////////////
                          /// ICON
                          ////////////////////////////////////////////////////
                          Icon(
                            Icons.water_drop_rounded,

                            color: Colors.cyanAccent.withOpacity(0.90),

                            size: isMobile ? 26 : 30,
                          ),
                        ],
                      ),

                      const Spacer(),

                      ////////////////////////////////////////////////////////
                      /// VALUE
                      ////////////////////////////////////////////////////////
                      FittedBox(
                        fit: BoxFit.scaleDown,

                        alignment: Alignment.centerLeft,

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            //////////////////////////////////////////////////
                            /// VALUE
                            //////////////////////////////////////////////////
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,

                                  end: Alignment.bottomCenter,

                                  colors: [
                                    Colors.white,

                                    Colors.cyanAccent.withOpacity(0.92),
                                  ],
                                ).createShader(bounds);
                              },

                              child: Text(
                                widget.waterLevel.toStringAsFixed(1),

                                style: TextStyle(
                                  fontSize: isMobile ? 76 : 96,

                                  fontWeight: FontWeight.w800,

                                  height: 0.95,

                                  color: Colors.white,
                                ),
                              ),
                            ),

                            //////////////////////////////////////////////////
                            /// UNIT
                            //////////////////////////////////////////////////
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,

                                bottom: 12,
                              ),

                              child: Text(
                                '%',

                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),

                                  fontSize: isMobile ? 30 : 40,

                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      ////////////////////////////////////////////////////////
                      /// LABEL
                      ////////////////////////////////////////////////////////
                      Text(
                        'Water Level',

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.74),

                          fontSize: isMobile ? 15 : 17,

                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      ////////////////////////////////////////////////////////
                      /// SUBTITLE
                      ////////////////////////////////////////////////////////
                      if (widget.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),

                          child: Text(
                            widget.subtitle!,

                            style: TextStyle(
                              color: Colors.white.withOpacity(0.56),

                              fontSize: isMobile ? 12 : 13,

                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      SizedBox(height: isMobile ? 22 : 28),

                      ////////////////////////////////////////////////////////
                      /// BOTTOM
                      ////////////////////////////////////////////////////////
                      Wrap(
                        spacing: 14,

                        runSpacing: 14,

                        alignment: WrapAlignment.spaceBetween,

                        crossAxisAlignment: WrapCrossAlignment.center,

                        children: [
                          ////////////////////////////////////////////////////
                          /// AI RISK
                          ////////////////////////////////////////////////////
                          _AiRiskChip(risk: widget.aiRisk),

                          ////////////////////////////////////////////////////
                          /// DEVICE
                          ////////////////////////////////////////////////////
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isMobile ? 180 : 260,
                            ),

                            child: Text(
                              widget.deviceName,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                color: Colors.white.withOpacity(0.62),

                                fontSize: 13,

                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// AI CHIP
////////////////////////////////////////////////////////////

class _AiRiskChip extends StatelessWidget {
  final double risk;

  const _AiRiskChip({required this.risk});

  Color get color {
    if (risk <= 20) {
      return Colors.greenAccent;
    }

    if (risk <= 50) {
      return Colors.yellowAccent;
    }

    if (risk <= 80) {
      return Colors.orangeAccent;
    }

    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        color: Colors.white.withOpacity(0.08),

        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(Icons.auto_awesome, size: 18, color: color),

          const SizedBox(width: 8),

          Text(
            'AI Risk ${risk.toStringAsFixed(0)}%',

            style: const TextStyle(
              color: Colors.white,

              fontSize: 13,

              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// WATER PAINTER
////////////////////////////////////////////////////////////

class _WaterPainter extends CustomPainter {
  final double waterLevel;

  final double waveOffset;

  _WaterPainter({required this.waterLevel, required this.waveOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height * (1 - waterLevel);

    const waveHeight = 12.0;

    //////////////////////////////////////////////////////////
    /// LAYERS
    //////////////////////////////////////////////////////////

    for (int layer = 0; layer < 3; layer++) {
      final path = Path();

      final layerOffset = layer * 3.0;

      final layerWaveHeight = waveHeight * (1 - layer * 0.18);

      final opacity = (0.16 - layer * 0.035).clamp(0.0, 1.0);

      path.moveTo(0, baseY + layerOffset);

      for (double x = 0; x <= size.width; x += 2) {
        final wave =
            sin((x / size.width * 4 * pi) + waveOffset + layer * pi / 3) +
            cos((x / size.width * 2 * pi) + waveOffset * 0.7) * 0.35;

        final y = baseY + layerOffset + wave * layerWaveHeight;

        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);

      path.lineTo(0, size.height);

      path.close();

      final paint = Paint()
        ..color = Colors.cyan.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaterPainter oldDelegate) {
    return oldDelegate.waterLevel != waterLevel ||
        oldDelegate.waveOffset != waveOffset;
  }
}
