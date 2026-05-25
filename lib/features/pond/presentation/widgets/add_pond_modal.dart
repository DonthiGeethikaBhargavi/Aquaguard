import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aquaguard/features/pond/application/providers/pond_provider.dart';
import 'package:aquaguard/features/pond/application/providers/pond_state_provider.dart';

class AddPondModal extends ConsumerStatefulWidget {
  const AddPondModal({super.key});

  @override
  ConsumerState<AddPondModal> createState() => _AddPondModalState();
}

class _AddPondModalState extends ConsumerState<AddPondModal>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLERS
  ////////////////////////////////////////////////////////////

  late final AnimationController _animationController;

  late final Animation<double> _fadeAnimation;

  late final Animation<Offset> _slideAnimation;

  ////////////////////////////////////////////////////////////
  /// TEXT
  ////////////////////////////////////////////////////////////

  final _nameController = TextEditingController();

  final _latController = TextEditingController();

  final _lngController = TextEditingController();

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 550),

      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,

            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _animationController.dispose();

    _nameController.dispose();

    _latController.dispose();

    _lngController.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(addPondStateProvider);

    return FadeTransition(
      opacity: _fadeAnimation,

      child: SlideTransition(
        position: _slideAnimation,

        child: Dialog(
          alignment: Alignment.center,

          backgroundColor: Colors.transparent,

          elevation: 0,

          insetPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 24,
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,

                    end: Alignment.bottomRight,

                    colors: [
                      const Color(0xFF141C2B).withOpacity(0.92),

                      const Color(0xFF0A101B).withOpacity(0.88),
                    ],
                  ),

                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),

                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      //////////////////////////////////////////////////////
                      /// TITLE
                      //////////////////////////////////////////////////////
                      Text(
                        'Add Pond',

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 28,

                          fontWeight: FontWeight.w500,

                          letterSpacing: -1.2,

                          height: 1,
                        ),
                      ),

                      const SizedBox(height: 10),

                      //////////////////////////////////////////////////////
                      /// SUBTITLE
                      //////////////////////////////////////////////////////
                      Text(
                        'Create a new telemetry environment.',

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.46),

                          fontSize: 14,

                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 32),

                      //////////////////////////////////////////////////////
                      /// NAME
                      //////////////////////////////////////////////////////
                      _input(controller: _nameController, hint: 'Pond name'),

                      const SizedBox(height: 18),

                      //////////////////////////////////////////////////////
                      /// LOCATION
                      //////////////////////////////////////////////////////
                      Row(
                        children: [
                          Expanded(
                            child: _input(
                              controller: _latController,

                              hint: 'Latitude',
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: _input(
                              controller: _lngController,

                              hint: 'Longitude',
                            ),
                          ),
                        ],
                      ),

                      //////////////////////////////////////////////////////
                      /// ERROR
                      //////////////////////////////////////////////////////
                      if (addState.error != null) ...[
                        const SizedBox(height: 18),

                        Text(
                          addState.error!,

                          style: TextStyle(
                            color: Colors.red.shade200,

                            fontSize: 13,

                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      //////////////////////////////////////////////////////
                      /// ACTIONS
                      //////////////////////////////////////////////////////
                      Row(
                        children: [
                          ////////////////////////////////////////////////////
                          /// CANCEL
                          ////////////////////////////////////////////////////
                          Expanded(
                            child: _secondaryButton(
                              title: 'Cancel',

                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          const SizedBox(width: 14),

                          ////////////////////////////////////////////////////
                          /// ADD
                          ////////////////////////////////////////////////////
                          Expanded(
                            child: _primaryButton(
                              loading: addState.isLoading,

                              title: 'Create',

                              onTap: _handleAddPond,
                            ),
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
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// INPUT
  ////////////////////////////////////////////////////////////

  Widget _input({
    required TextEditingController controller,

    required String hint,
  }) {
    return TextField(
      controller: controller,

      style: const TextStyle(
        color: Colors.white,

        fontSize: 15,

        fontWeight: FontWeight.w400,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.24),

          fontWeight: FontWeight.w400,
        ),

        filled: true,

        fillColor: Colors.white.withOpacity(0.03),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),

          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),

          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),

          borderSide: BorderSide(
            color: Colors.cyan.withOpacity(0.22),

            width: 1,
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// PRIMARY BUTTON
  ////////////////////////////////////////////////////////////

  Widget _primaryButton({
    required String title,

    required VoidCallback onTap,

    required bool loading,
  }) {
    return GestureDetector(
      onTap: loading ? null : onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),

        height: 56,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          gradient: LinearGradient(
            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [
              Colors.white.withOpacity(loading ? 0.08 : 0.14),

              Colors.white.withOpacity(loading ? 0.04 : 0.08),
            ],
          ),

          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),

        child: Center(
          child: loading
              ? SizedBox(
                  width: 18,
                  height: 18,

                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,

                    color: Colors.white.withOpacity(0.8),
                  ),
                )
              : Text(
                  title,

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 15,

                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// SECONDARY BUTTON
  ////////////////////////////////////////////////////////////

  Widget _secondaryButton({
    required String title,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 56,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          color: Colors.white.withOpacity(0.03),

          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),

        child: Center(
          child: Text(
            title,

            style: TextStyle(
              color: Colors.white.withOpacity(0.72),

              fontSize: 15,

              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// ADD POND
  ////////////////////////////////////////////////////////////

  Future<void> _handleAddPond() async {
    final name = _nameController.text.trim();

    final lat = double.tryParse(_latController.text.trim());

    final lng = double.tryParse(_lngController.text.trim());

    if (name.isEmpty) {
      HapticFeedback.lightImpact();
      return;
    }

    //////////////////////////////////////////////////////////
    /// PREMIUM HAPTIC
    //////////////////////////////////////////////////////////

    HapticFeedback.mediumImpact();

    //////////////////////////////////////////////////////////
    /// STORE NOTIFIERS BEFORE DISPOSAL
    //////////////////////////////////////////////////////////

    final addNotifier = ref.read(addPondStateProvider.notifier);

    final pondNotifier = ref.read(pondProvider.notifier);

    //////////////////////////////////////////////////////////
    /// CLOSE MODAL
    //////////////////////////////////////////////////////////

    if (mounted) {
      Navigator.pop(context);
    }

    //////////////////////////////////////////////////////////
    /// BACKEND INSERT
    //////////////////////////////////////////////////////////

    await addNotifier.addPond(name: name, latitude: lat, longitude: lng);

    //////////////////////////////////////////////////////////
    /// REFRESH
    //////////////////////////////////////////////////////////

    await pondNotifier.refreshInBackground();
  }
}
