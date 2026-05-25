import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AddDeviceSheet extends ConsumerStatefulWidget {
  final String pondId;

  const AddDeviceSheet({super.key, required this.pondId});

  @override
  ConsumerState<AddDeviceSheet> createState() => _AddDeviceSheetState();
}

class _AddDeviceSheetState extends ConsumerState<AddDeviceSheet> {
  final _deviceIdController = TextEditingController();

  final _deviceNameController = TextEditingController();

  bool _loading = false;

  ////////////////////////////////////////////////////////////
  /// ADD DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> _addDevice() async {
    final deviceId = _deviceIdController.text.trim();

    final deviceName = _deviceNameController.text.trim();

    if (deviceId.isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await Supabase.instance.client.from('devices').insert({
        'device_id': deviceId,

        'pond_id': widget.pondId,

        'device_name': deviceName.isEmpty ? 'AquaGuard Device' : deviceName,

        'is_online': false,

        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add device\n$e')));
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _deviceIdController.dispose();

    _deviceNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),

          decoration: BoxDecoration(
            color: const Color(0xFF09111F).withOpacity(0.94),

            borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),

            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),

          child: SafeArea(
            top: false,

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisSize: MainAxisSize.min,

                children: [
                  ////////////////////////////////////////////////////////////
                  /// HANDLE
                  ////////////////////////////////////////////////////////////
                  Center(
                    child: Container(
                      width: 54,
                      height: 6,

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),

                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  ////////////////////////////////////////////////////////////
                  /// TITLE
                  ////////////////////////////////////////////////////////////
                  const Text(
                    'Add Device',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Connect a realtime AquaGuard IoT device.',

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),

                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 34),

                  ////////////////////////////////////////////////////////////
                  /// DEVICE ID
                  ////////////////////////////////////////////////////////////
                  _GlassTextField(
                    controller: _deviceIdController,

                    hint: 'Device ID',

                    icon: Icons.memory_rounded,
                  ),

                  const SizedBox(height: 20),

                  ////////////////////////////////////////////////////////////
                  /// DEVICE NAME
                  ////////////////////////////////////////////////////////////
                  _GlassTextField(
                    controller: _deviceNameController,

                    hint: 'Device Name (Optional)',

                    icon: Icons.devices_rounded,
                  ),

                  const SizedBox(height: 34),

                  ////////////////////////////////////////////////////////////
                  /// BUTTON
                  ////////////////////////////////////////////////////////////
                  SizedBox(
                    width: double.infinity,

                    height: 60,

                    child: ElevatedButton(
                      onPressed: _loading ? null : _addDevice,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,

                        foregroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),

                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Connect Device',

                              style: TextStyle(
                                fontSize: 16,

                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// GLASS FIELD
////////////////////////////////////////////////////////////

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;

  final String hint;

  final IconData icon;

  const _GlassTextField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: TextField(
        controller: controller,

        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),

          hintText: hint,

          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),

          prefixIcon: Icon(icon, color: Colors.cyanAccent),
        ),
      ),
    );
  }
}
