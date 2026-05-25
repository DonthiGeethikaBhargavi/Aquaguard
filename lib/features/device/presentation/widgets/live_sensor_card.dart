import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class LiveSensorCard extends StatefulWidget {
  final String title;

  final String value;

  final String unit;

  final IconData icon;

  final Color color;

  final String trend;

  const LiveSensorCard({
    super.key,

    required this.title,

    required this.value,

    required this.unit,

    required this.icon,

    required this.color,

    required this.trend,
  });

  @override
  State<LiveSensorCard> createState() => _LiveSensorCardState();
}

class _LiveSensorCardState extends State<LiveSensorCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  late final List<_ParticleData> _particles;

  @override
  void initState() {
    super.initState();

    //////////////////////////////////////////////////////////
    /// PULSE
    //////////////////////////////////////////////////////////

    _pulseController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    //////////////////////////////////////////////////////////
    /// PARTICLES
    //////////////////////////////////////////////////////////

    final random = Random(widget.title.hashCode);

    _particles = List.generate(
      4,

      (i) => _ParticleData(
        dx: 18 + random.nextDouble() * 40,

        dy: 18 + random.nextDouble() * 40,

        size: 3 + random.nextDouble() * 4,

        opacity: 0.10 + random.nextDouble() * 0.12,

        phase: i.toDouble(),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// TREND COLOR
  ////////////////////////////////////////////////////////////

  Color get trendColor {
    switch (widget.trend) {
      case '↑':
        return Colors.greenAccent;

      case '↓':
        return Colors.redAccent;

      default:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    //////////////////////////////////////////////////////////
    /// RESPONSIVE
    //////////////////////////////////////////////////////////

    final isSmall = width < 380;

    final valueFont = isSmall ? 26.0 : 32.0;

    final titleFont = isSmall ? 12.0 : 14.0;

    final unitFont = isSmall ? 13.0 : 15.0;

    final cardPadding = isSmall ? 16.0 : 20.0;

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),

          child: Material(
            color: Colors.transparent,

            child: InkWell(
              borderRadius: BorderRadius.circular(28),

              splashColor: widget.color.withOpacity(0.06),

              highlightColor: Colors.transparent,

              onTap: () {},

              child: Container(
                ////////////////////////////////////////////////////////////
                /// FIX OVERFLOW
                ////////////////////////////////////////////////////////////
                constraints: const BoxConstraints(minHeight: 170),

                padding: EdgeInsets.all(cardPadding),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,

                    end: Alignment.bottomRight,

                    colors: [
                      Colors.white.withOpacity(0.07),

                      Colors.white.withOpacity(0.025),
                    ],
                  ),

                  border: Border.all(color: widget.color.withOpacity(0.14)),

                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.06),

                      blurRadius: 16,
                    ),
                  ],
                ),

                child: Stack(
                  children: [
                    //////////////////////////////////////////////////////////
                    /// PARTICLES
                    //////////////////////////////////////////////////////////
                    ..._particles.map(
                      (particle) => _ParticleWidget(
                        controller: _pulseController,

                        particle: particle,

                        color: widget.color,
                      ),
                    ),

                    //////////////////////////////////////////////////////////
                    /// CONTENT
                    //////////////////////////////////////////////////////////
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        //////////////////////////////////////////////////////
                        /// TOP ROW
                        //////////////////////////////////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            //////////////////////////////////////////////////
                            /// ICON
                            //////////////////////////////////////////////////
                            Flexible(
                              child: RepaintBoundary(
                                child: Container(
                                  padding: EdgeInsets.all(isSmall ? 8 : 10),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),

                                    gradient: LinearGradient(
                                      colors: [
                                        widget.color.withOpacity(0.22),

                                        widget.color.withOpacity(0.06),
                                      ],
                                    ),

                                    border: Border.all(
                                      color: widget.color.withOpacity(0.16),
                                    ),
                                  ),

                                  child: Icon(
                                    widget.icon,

                                    color: widget.color,

                                    size: isSmall ? 18 : 22,
                                  ),
                                ),
                              ),
                            ),

                            //////////////////////////////////////////////////
                            /// TREND
                            //////////////////////////////////////////////////
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmall ? 8 : 10,

                                vertical: isSmall ? 4 : 6,
                              ),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),

                                color: trendColor.withOpacity(0.12),

                                border: Border.all(
                                  color: trendColor.withOpacity(0.20),
                                ),
                              ),

                              child: Text(
                                widget.trend,

                                style: GoogleFonts.notoSans(
                                  color: trendColor,

                                  fontWeight: FontWeight.w700,

                                  fontSize: isSmall ? 10 : 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        //////////////////////////////////////////////////////
                        /// VALUE
                        //////////////////////////////////////////////////////
                        FittedBox(
                          fit: BoxFit.scaleDown,

                          alignment: Alignment.centerLeft,

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,

                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 240),

                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,

                                    child: child,
                                  );
                                },

                                child: Text(
                                  widget.value,

                                  key: ValueKey(widget.value),

                                  maxLines: 1,

                                  overflow: TextOverflow.ellipsis,

                                  style: GoogleFonts.notoSans(
                                    color: Colors.white,

                                    fontSize: valueFont,

                                    fontWeight: FontWeight.w800,

                                    height: 1,

                                    shadows: [
                                      Shadow(
                                        color: widget.color.withOpacity(0.22),

                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6,
                                  bottom: 4,
                                ),

                                child: Text(
                                  widget.unit,

                                  style: GoogleFonts.notoSans(
                                    color: Colors.white70,

                                    fontSize: unitFont,

                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isSmall ? 8 : 10),

                        //////////////////////////////////////////////////////
                        /// TITLE
                        //////////////////////////////////////////////////////
                        Text(
                          widget.title,

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,

                          style: GoogleFonts.notoSans(
                            color: Colors.white70,

                            fontSize: titleFont,

                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: isSmall ? 10 : 14),

                        //////////////////////////////////////////////////////
                        /// LIVE
                        //////////////////////////////////////////////////////
                        Row(
                          children: [
                            _LivePulseDot(controller: _pulseController),

                            const SizedBox(width: 8),

                            Text(
                              'LIVE',

                              style: GoogleFonts.notoSans(
                                color: Colors.white60,

                                fontSize: isSmall ? 9 : 10,

                                fontWeight: FontWeight.w800,

                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// PARTICLE DATA
////////////////////////////////////////////////////////////

class _ParticleData {
  final double dx;

  final double dy;

  final double size;

  final double opacity;

  final double phase;

  const _ParticleData({
    required this.dx,

    required this.dy,

    required this.size,

    required this.opacity,

    required this.phase,
  });
}

////////////////////////////////////////////////////////////
/// PARTICLE
////////////////////////////////////////////////////////////

class _ParticleWidget extends StatelessWidget {
  final AnimationController controller;

  final _ParticleData particle;

  final Color color;

  const _ParticleWidget({
    required this.controller,

    required this.particle,

    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: particle.dx,

      bottom: particle.dy,

      child: AnimatedBuilder(
        animation: controller,

        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              sin((controller.value * 2 * pi) + particle.phase) * 2,

              cos((controller.value * 2 * pi) + particle.phase) * 2,
            ),

            child: child,
          );
        },

        child: Container(
          width: particle.size,

          height: particle.size,

          decoration: BoxDecoration(
            color: color.withOpacity(particle.opacity),

            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LIVE DOT
////////////////////////////////////////////////////////////

class _LivePulseDot extends StatelessWidget {
  final AnimationController controller;

  const _LivePulseDot({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,

      builder: (context, child) {
        final glow = sin(controller.value * pi) * 3 + 4;

        return Container(
          width: 7,

          height: 7,

          decoration: BoxDecoration(
            color: Colors.greenAccent,

            shape: BoxShape.circle,

            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.55),

                blurRadius: glow,

                spreadRadius: glow * 0.15,
              ),
            ],
          ),
        );
      },
    );
  }
}
