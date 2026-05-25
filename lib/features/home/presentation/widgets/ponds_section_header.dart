import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PondsSectionHeader extends StatefulWidget {
  final VoidCallback onAddPressed;

  const PondsSectionHeader({super.key, required this.onAddPressed});

  @override
  State<PondsSectionHeader> createState() => _PondsSectionHeaderState();
}

class _PondsSectionHeaderState extends State<PondsSectionHeader>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLER
  ////////////////////////////////////////////////////////////

  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 180),

      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.985,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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
  /// ACTION
  ////////////////////////////////////////////////////////////

  Future<void> _onPressed() async {
    HapticFeedback.lightImpact();

    await _controller.forward();

    await _controller.reverse();

    widget.onAddPressed();
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        //////////////////////////////////////////////////////
        /// LEFT
        //////////////////////////////////////////////////////
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //////////////////////////////////////////////////
              /// TITLE
              //////////////////////////////////////////////////
              Text(
                'Pond Systems',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 23,

                  fontWeight: FontWeight.w500,

                  letterSpacing: -1,

                  height: 1,
                ),
              ),

              const SizedBox(height: 8),

              //////////////////////////////////////////////////
              /// SUBTITLE
              //////////////////////////////////////////////////
              Text(
                'Aquatic monitoring environments',

                style: TextStyle(
                  color: Colors.white.withOpacity(0.42),

                  fontSize: 13,

                  fontWeight: FontWeight.w400,

                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        //////////////////////////////////////////////////////
        /// ADD BUTTON
        //////////////////////////////////////////////////////
        ScaleTransition(
          scale: _scaleAnimation,

          child: GestureDetector(
            onTap: _onPressed,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                child: Container(
                  height: 44,

                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,

                      colors: [
                        Colors.white.withOpacity(0.04),

                        Colors.white.withOpacity(0.015),
                      ],
                    ),

                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      ////////////////////////////////////////////
                      /// ICON
                      ////////////////////////////////////////////
                      Icon(
                        Icons.add_rounded,

                        size: 16,

                        color: Colors.white.withOpacity(0.82),
                      ),

                      const SizedBox(width: 8),

                      ////////////////////////////////////////////
                      /// LABEL
                      ////////////////////////////////////////////
                      Text(
                        'Add',

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),

                          fontSize: 13,

                          fontWeight: FontWeight.w500,

                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
