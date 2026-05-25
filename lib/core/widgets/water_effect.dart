import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class WaterEffect extends StatefulWidget {
  final Widget child;
  const WaterEffect({super.key, required this.child});

  @override
  State<WaterEffect> createState() => _WaterEffectState();
}

class _WaterEffectState extends State<WaterEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  ui.FragmentShader? shader;

  Offset touch = Offset.zero;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();

    _loadShader();
  }

  @override
  void dispose() {
    controller.dispose(); // ✅ ADD HERE
    super.dispose();
  }

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset(
      'assets/shaders/water.frag',
    );
    shader = program.fragmentShader();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) return widget.child;

    return GestureDetector(
      onPanUpdate: (d) {
        setState(() {
          touch = d.localPosition;
        });
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          shader!
            ..setFloat(0, MediaQuery.of(context).size.width)
            ..setFloat(1, MediaQuery.of(context).size.height)
            ..setFloat(2, controller.value * 10)
            ..setFloat(3, touch.dx / MediaQuery.of(context).size.width)
            ..setFloat(4, touch.dy / MediaQuery.of(context).size.height)
            ..setFloat(5, 0.3);

          return CustomPaint(
            painter: _WaterPainter(shader!),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _WaterPainter extends CustomPainter {
  final ui.FragmentShader shader;

  _WaterPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
