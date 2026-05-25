import 'package:flutter/material.dart';

class PremiumBackground extends StatefulWidget {
  final Widget child;

  const PremiumBackground({super.key, required this.child});

  @override
  State<PremiumBackground> createState() => _PremiumBackgroundState();
}

class _PremiumBackgroundState extends State<PremiumBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + controller.value, -1),
              end: Alignment(1, 1),
              colors: const [
                Color(0xFF0B0F1A),
                Color(0xFF1A1F3A),
                Color(0xFF0F2027),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
