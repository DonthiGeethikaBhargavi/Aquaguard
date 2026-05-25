import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../application/providers/device_provider.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  final String pondId;

  const AddDeviceScreen({super.key, required this.pondId});

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen> {
  ////////////////////////////////////////////////////////////
  /// CONTROLLERS
  ////////////////////////////////////////////////////////////

  final _deviceIdController = TextEditingController();

  final _macController = TextEditingController();

  ////////////////////////////////////////////////////////////
  /// STATE
  ////////////////////////////////////////////////////////////

  bool _loading = false;

  String? _error;

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _deviceIdController.dispose();

    _macController.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// GENERATE DEVICE ID
  ////////////////////////////////////////////////////////////

  String _generateDeviceId() {
    final millis = DateTime.now().millisecondsSinceEpoch;

    final suffix = millis.toString().substring(millis.toString().length - 6);

    return 'AQG-$suffix';
  }

  ////////////////////////////////////////////////////////////
  /// MAC VALIDATION
  ////////////////////////////////////////////////////////////

  bool _isValidMac(String mac) {
    final regex = RegExp(
      r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$',
      caseSensitive: false,
    );

    return regex.hasMatch(mac);
  }

  ////////////////////////////////////////////////////////////
  /// ADD DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> _addDevice() async {
    //////////////////////////////////////////////////////////
    /// HIDE KEYBOARD
    //////////////////////////////////////////////////////////

    FocusScope.of(context).unfocus();

    //////////////////////////////////////////////////////////
    /// VALIDATION
    //////////////////////////////////////////////////////////

    final deviceId = _deviceIdController.text.trim();

    final mac = _macController.text.trim().toUpperCase();

    if (deviceId.isEmpty) {
      setState(() {
        _error = 'Device ID required';
      });

      HapticFeedback.heavyImpact();

      return;
    }

    if (deviceId.length < 5) {
      setState(() {
        _error = 'Device ID too short';
      });

      HapticFeedback.heavyImpact();

      return;
    }

    if (!_isValidMac(mac)) {
      setState(() {
        _error = 'Invalid MAC address';
      });

      HapticFeedback.heavyImpact();

      return;
    }

    //////////////////////////////////////////////////////////
    /// LOADING
    //////////////////////////////////////////////////////////

    setState(() {
      _loading = true;

      _error = null;
    });

    HapticFeedback.mediumImpact();

    try {
      ////////////////////////////////////////////////////////
      /// USER
      ////////////////////////////////////////////////////////

      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      ////////////////////////////////////////////////////////
      /// PROVIDER
      ////////////////////////////////////////////////////////

      final notifier = ref.read(deviceListProvider(widget.pondId).notifier);

      ////////////////////////////////////////////////////////
      /// ADD DEVICE
      ////////////////////////////////////////////////////////

      await notifier.add(deviceId: deviceId, userId: user.id);

      ////////////////////////////////////////////////////////
      /// UPDATE MAC
      ////////////////////////////////////////////////////////

      await Supabase.instance.client
          .from('devices')
          .update({'mac_address': mac})
          .eq('device_id', deviceId);

      ////////////////////////////////////////////////////////
      /// SUCCESS
      ////////////////////////////////////////////////////////

      if (!mounted) {
        return;
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),

            backgroundColor: const Color(0xFF141C2B),

            content: const Text('Device connected successfully'),
          ),
        );

      HapticFeedback.lightImpact();
    } catch (e) {
      ////////////////////////////////////////////////////////
      /// ERROR
      ////////////////////////////////////////////////////////

      String message = 'Failed to connect device';

      final error = e.toString().toLowerCase();

      if (error.contains('duplicate')) {
        message = 'Device already exists';
      }

      if (error.contains('mac_address_key')) {
        message = 'MAC address already connected';
      }

      if (error.contains('network')) {
        message = 'Network connection failed';
      }

      setState(() {
        _error = message;
      });

      HapticFeedback.heavyImpact();
    } finally {
      ////////////////////////////////////////////////////////
      /// STOP LOADING
      ////////////////////////////////////////////////////////

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),

      body: Stack(
        children: [
          //////////////////////////////////////////////////////
          /// GLOW
          //////////////////////////////////////////////////////
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 260,
              height: 260,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.cyan.withOpacity(0.08),
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// CONTENT
          //////////////////////////////////////////////////////
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  //////////////////////////////////////////////////////
                  /// BACK
                  //////////////////////////////////////////////////////
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

                        child: Container(
                          width: 52,
                          height: 52,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),

                            color: Colors.white.withOpacity(0.04),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),

                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,

                            color: Colors.white,

                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  //////////////////////////////////////////////////////
                  /// TITLE
                  //////////////////////////////////////////////////////
                  const Text(
                    'Connect Device',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 34,

                      fontWeight: FontWeight.w700,

                      letterSpacing: -1.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'onboarding',

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),

                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 40),

                  //////////////////////////////////////////////////////
                  /// GLASS CARD
                  //////////////////////////////////////////////////////
                  ClipRRect(
                    borderRadius: BorderRadius.circular(34),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                      child: Container(
                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),

                          gradient: LinearGradient(
                            begin: Alignment.topLeft,

                            end: Alignment.bottomRight,

                            colors: [
                              const Color(0xFF141C2B).withOpacity(0.9),

                              const Color(0xFF0B1220).withOpacity(0.84),
                            ],
                          ),

                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),

                        child: Column(
                          children: [
                            //////////////////////////////////////////////////
                            /// ICON
                            //////////////////////////////////////////////////
                            Container(
                              width: 82,

                              height: 82,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan.withOpacity(0.25),

                                    Colors.blue.withOpacity(0.08),
                                  ],
                                ),
                              ),

                              child: const Icon(
                                Icons.memory_rounded,

                                color: Colors.cyanAccent,

                                size: 40,
                              ),
                            ),

                            const SizedBox(height: 30),

                            //////////////////////////////////////////////////
                            /// DEVICE ID
                            //////////////////////////////////////////////////
                            _buildField(
                              controller: _deviceIdController,

                              label: 'Device ID',

                              hint: 'AQG-XXXXXX',

                              suffix: IconButton(
                                onPressed: () {
                                  final generated = _generateDeviceId();

                                  _deviceIdController.text = generated;

                                  HapticFeedback.lightImpact();
                                },

                                icon: const Icon(
                                  Icons.auto_awesome_rounded,

                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            //////////////////////////////////////////////////
                            /// MAC
                            //////////////////////////////////////////////////
                            _buildField(
                              controller: _macController,

                              label: 'MAC Address',

                              hint: 'AA:BB:CC:DD:EE:FF',
                            ),

                            const SizedBox(height: 22),

                            //////////////////////////////////////////////////
                            /// ERROR
                            //////////////////////////////////////////////////
                            if (_error != null)
                              Container(
                                width: double.infinity,

                                padding: const EdgeInsets.all(16),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),

                                  color: Colors.red.withOpacity(0.08),

                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.2),
                                  ),
                                ),

                                child: Text(
                                  _error!,

                                  style: const TextStyle(
                                    color: Colors.redAccent,

                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                            if (_error != null) const SizedBox(height: 18),

                            //////////////////////////////////////////////////
                            /// BUTTON
                            //////////////////////////////////////////////////
                            SizedBox(
                              width: double.infinity,

                              height: 58,

                              child: ElevatedButton(
                                onPressed: _loading ? null : _addDevice,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,

                                  foregroundColor: Colors.black,

                                  elevation: 0,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),

                                child: _loading
                                    ? const SizedBox(
                                        width: 24,

                                        height: 24,

                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,

                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        'Connect Device',

                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,

                                          fontSize: 16,
                                        ),
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
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FIELD
  ////////////////////////////////////////////////////////////

  Widget _buildField({
    required TextEditingController controller,

    required String label,

    required String hint,

    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: TextStyle(
            color: Colors.white.withOpacity(0.65),

            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: controller,

          style: const TextStyle(color: Colors.white),

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),

            suffixIcon: suffix,

            filled: true,

            fillColor: Colors.white.withOpacity(0.04),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),

              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),

              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),

              borderSide: BorderSide(
                color: Colors.cyanAccent.withOpacity(0.45),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
