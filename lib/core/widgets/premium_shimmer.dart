import 'package:flutter/material.dart';

class PremiumShimmer extends StatefulWidget {
  final double width;

  final double height;

  final BorderRadius borderRadius;

  const PremiumShimmer({
    super.key,

    required this.width,

    required this.height,

    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  State<PremiumShimmer> createState() => _PremiumShimmerState();
}

class _PremiumShimmerState extends State<PremiumShimmer>
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

      duration: const Duration(milliseconds: 2200),
    )..repeat();
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
    return AnimatedBuilder(
      animation: _controller,

      builder: (_, __) {
        return Container(
          width: widget.width,

          height: widget.height,

          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,

            gradient: LinearGradient(
              begin: Alignment(-1 + (_controller.value * 2), 0),

              end: Alignment(1 + (_controller.value * 2), 0),

              colors: [
                Colors.white.withOpacity(0.015),

                Colors.white.withOpacity(0.045),

                Colors.white.withOpacity(0.015),
              ],
            ),

            border: Border.all(color: Colors.white.withOpacity(0.025)),
          ),
        );
      },
    );
  }
}
