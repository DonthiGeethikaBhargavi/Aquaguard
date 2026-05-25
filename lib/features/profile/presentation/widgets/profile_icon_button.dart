import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user_profile.dart';

class ProfileIconButton extends ConsumerStatefulWidget {
  final VoidCallback onPressed;

  const ProfileIconButton({super.key, required this.onPressed});

  @override
  ConsumerState<ProfileIconButton> createState() => _ProfileIconButtonState();
}

class _ProfileIconButtonState extends ConsumerState<ProfileIconButton>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// ANIMATION
  ////////////////////////////////////////////////////////////

  late AnimationController _controller;

  late Animation<double> _scaleAnimation;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
  /// TAP
  ////////////////////////////////////////////////////////////

  void _onTap() {
    //////////////////////////////////////////////////////////
    /// HAPTIC
    //////////////////////////////////////////////////////////

    HapticFeedback.lightImpact();

    //////////////////////////////////////////////////////////
    /// SCALE
    //////////////////////////////////////////////////////////

    _controller.forward().then((_) {
      _controller.reverse();
    });

    //////////////////////////////////////////////////////////
    /// CALLBACK
    //////////////////////////////////////////////////////////

    widget.onPressed();
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return ScaleTransition(
      scale: _scaleAnimation,

      child: GestureDetector(
        onTap: _onTap,

        child: Container(
          width: 52,
          height: 52,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            ////////////////////////////////////////////////////
            /// GLASS EFFECT
            ////////////////////////////////////////////////////
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                Colors.white.withOpacity(0.18),
                Colors.white.withOpacity(0.06),
              ],
            ),

            border: Border.all(
              color: Colors.white.withOpacity(0.18),

              width: 1.4,
            ),

            ////////////////////////////////////////////////////
            /// SHADOW
            ////////////////////////////////////////////////////
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),

                blurRadius: 18,

                offset: const Offset(0, 8),
              ),

              //////////////////////////////////////////////////
              /// ATMOSPHERIC GLOW
              //////////////////////////////////////////////////
              BoxShadow(
                color: Colors.white.withOpacity(0.05),

                blurRadius: 20,

                spreadRadius: 1,
              ),
            ],
          ),

          child: Center(
            child: userProfileAsync.when(
              //////////////////////////////////////////////////
              /// DATA
              //////////////////////////////////////////////////
              data: (profile) {
                //////////////////////////////////////////////////
                /// NO PROFILE
                //////////////////////////////////////////////////

                if (profile == null) {
                  return Icon(
                    Icons.person_rounded,

                    color: Colors.white.withOpacity(0.92),

                    size: 24,
                  );
                }

                //////////////////////////////////////////////////
                /// INITIALS
                //////////////////////////////////////////////////

                final initials = profile.getInitials().trim();

                //////////////////////////////////////////////////
                /// EMPTY INITIALS
                //////////////////////////////////////////////////

                if (initials.isEmpty) {
                  return Icon(
                    Icons.person_rounded,

                    color: Colors.white.withOpacity(0.92),

                    size: 24,
                  );
                }

                //////////////////////////////////////////////////
                /// INITIAL TEXT
                //////////////////////////////////////////////////

                return Text(
                  initials.toUpperCase(),

                  style: TextStyle(
                    color: Colors.white.withOpacity(0.96),

                    fontSize: 16,

                    fontWeight: FontWeight.w800,

                    letterSpacing: -0.5,
                  ),
                );
              },

              ////////////////////////////////////////////////////
              /// LOADING
              ////////////////////////////////////////////////////
              loading: () => SizedBox(
                width: 18,
                height: 18,

                child: CircularProgressIndicator(
                  strokeWidth: 1.7,

                  valueColor: AlwaysStoppedAnimation(
                    Colors.white.withOpacity(0.65),
                  ),
                ),
              ),

              ////////////////////////////////////////////////////
              /// ERROR
              ////////////////////////////////////////////////////
              error: (_, __) => Icon(
                Icons.person_rounded,

                color: Colors.white.withOpacity(0.85),

                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
