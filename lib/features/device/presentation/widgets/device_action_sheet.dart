import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceActionSheet extends StatefulWidget {
  final String deviceId;

  final String deviceName;

  final String pondId;

  const DeviceActionSheet({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.pondId,
  });

  @override
  State<DeviceActionSheet> createState() => _DeviceActionSheetState();
}

class _DeviceActionSheetState extends State<DeviceActionSheet> {
  late final TextEditingController _nameController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.deviceName);
  }

  ////////////////////////////////////////////////////////////
  /// UPDATE DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> _updateDevice() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await Supabase.instance.client
          .from('devices')
          .update({'device_name': name})
          .eq('device_id', widget.deviceId);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showError(e.toString());
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  ////////////////////////////////////////////////////////////
  /// DELETE DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> _deleteDevice() async {
    final confirm = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111827),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Text(
            'Delete Device',
            style: TextStyle(color: Colors.white),
          ),

          content: Text(
            'Remove "${widget.deviceName}" permanently?',

            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      //////////////////////////////////////////////////////////
      /// DELETE DEVICE
      //////////////////////////////////////////////////////////

      await Supabase.instance.client
          .from('devices')
          .delete()
          .eq('device_id', widget.deviceId);

      //////////////////////////////////////////////////////////
      /// DELETE LATEST READING
      //////////////////////////////////////////////////////////

      await Supabase.instance.client
          .from('latest_readings')
          .delete()
          .eq('device_id', widget.deviceId);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showError(e.toString());
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  ////////////////////////////////////////////////////////////
  /// ERROR
  ////////////////////////////////////////////////////////////

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  void dispose() {
    _nameController.dispose();

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
                    'Device Settings',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.deviceId,

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),

                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 34),

                  ////////////////////////////////////////////////////////////
                  /// NAME FIELD
                  ////////////////////////////////////////////////////////////
                  _GlassField(
                    controller: _nameController,

                    hint: 'Device Name',

                    icon: Icons.devices_rounded,
                  ),

                  const SizedBox(height: 30),

                  ////////////////////////////////////////////////////////////
                  /// SAVE
                  ////////////////////////////////////////////////////////////
                  SizedBox(
                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton(
                      onPressed: _loading ? null : _updateDevice,

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
                              'Save Changes',

                              style: TextStyle(
                                fontSize: 16,

                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  ////////////////////////////////////////////////////////////
                  /// DELETE
                  ////////////////////////////////////////////////////////////
                  SizedBox(
                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton(
                      onPressed: _loading ? null : _deleteDevice,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(0.18),

                        foregroundColor: Colors.redAccent,

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),

                      child: const Text(
                        'Delete Device',

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
/// FIELD
////////////////////////////////////////////////////////////

class _GlassField extends StatelessWidget {
  final TextEditingController controller;

  final String hint;

  final IconData icon;

  const _GlassField({
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
