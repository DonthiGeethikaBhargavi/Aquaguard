import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';

import '../../application/providers/device_provider.dart';

import '../providers/device_dashboard_provider.dart';

import 'add_device_screen.dart';

class DeviceListScreen extends ConsumerWidget {
  final String pondId;

  const DeviceListScreen({super.key, required this.pondId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(deviceListProvider(pondId));

    return Scaffold(
      backgroundColor: const Color(0xFF070B14),

      body: Stack(
        children: [
          //////////////////////////////////////////////////////
          /// AMBIENT GLOW
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
            child: Column(
              children: [
                //////////////////////////////////////////////////////////
                /// HEADER
                //////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),

                  child: Row(
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

                      const Spacer(),

                      //////////////////////////////////////////////////////
                      /// SINGLE ADD BUTTON
                      //////////////////////////////////////////////////////
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => AddDeviceScreen(pondId: pondId),
                            ),
                          );
                        },

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),

                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

                            child: Container(
                              width: 54,
                              height: 54,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),

                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.08),

                                    Colors.white.withOpacity(0.03),
                                  ],
                                ),

                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),

                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //////////////////////////////////////////////////////////
                /// TITLE
                //////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 24),

                      const Text(
                        'My AquaGuard Devices',

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 34,

                          fontWeight: FontWeight.w700,

                          letterSpacing: -1.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'telemetry ecosystem',

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),

                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),

                //////////////////////////////////////////////////////////
                /// BODY
                //////////////////////////////////////////////////////////
                Expanded(
                  child: devicesAsync.when(
                    ////////////////////////////////////////////////////
                    /// LOADING
                    ////////////////////////////////////////////////////
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),

                    ////////////////////////////////////////////////////
                    /// ERROR
                    ////////////////////////////////////////////////////
                    error: (e, _) => Center(
                      child: Text(
                        'Failed to load devices',

                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),

                    ////////////////////////////////////////////////////
                    /// DATA
                    ////////////////////////////////////////////////////
                    data: (devices) {
                      //////////////////////////////////////////////////
                      /// EMPTY
                      //////////////////////////////////////////////////

                      if (devices.isEmpty) {
                        return Center(
                          child: Text(
                            'No connected devices',

                            style: TextStyle(
                              color: Colors.white.withOpacity(0.55),

                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      //////////////////////////////////////////////////
                      /// LIST
                      //////////////////////////////////////////////////

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),

                        itemCount: devices.length,

                        itemBuilder: (_, i) {
                          final d = devices[i];

                          final deviceId = d['device_id']?.toString() ?? '';

                          final mac =
                              d['mac_address']?.toString() ?? 'Unknown MAC';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),

                            child: _PremiumDeviceCard(
                              pondId: pondId,

                              deviceId: deviceId,

                              mac: mac,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// PREMIUM DEVICE CARD
////////////////////////////////////////////////////////////

class _PremiumDeviceCard extends ConsumerStatefulWidget {
  final String pondId;

  final String deviceId;

  final String mac;

  const _PremiumDeviceCard({
    required this.pondId,
    required this.deviceId,
    required this.mac,
  });

  @override
  ConsumerState<_PremiumDeviceCard> createState() => _PremiumDeviceCardState();
}

class _PremiumDeviceCardState extends ConsumerState<_PremiumDeviceCard>
    with SingleTickerProviderStateMixin {
  double _drag = 0;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// DELETE
  ////////////////////////////////////////////////////////////

  Future<void> _delete() async {
    HapticFeedback.mediumImpact();

    final confirmed = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141C2B),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Text(
            'Delete Device?',

            style: TextStyle(color: Colors.white),
          ),

          content: Text(
            'This device will be permanently removed from Supabase.',

            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text(
                'Delete',

                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    //////////////////////////////////////////////////////////
    /// DELETE
    //////////////////////////////////////////////////////////

    await ref
        .read(deviceListProvider(widget.pondId).notifier)
        .delete(widget.deviceId);

    //////////////////////////////////////////////////////////
    /// MESSAGE
    //////////////////////////////////////////////////////////

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),

          backgroundColor: const Color(0xFF141C2B),

          content: const Text('Device deleted successfully'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(deviceStatusProvider(widget.deviceId));

    final status = statusAsync.value;

    final isOnline = status?.isOnline ?? false;

    return Stack(
      children: [
        //////////////////////////////////////////////////////////
        /// DELETE LAYER
        //////////////////////////////////////////////////////////
        Positioned.fill(
          child: Container(
            alignment: Alignment.centerRight,

            padding: const EdgeInsets.only(right: 24),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),

              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.18),

                  Colors.red.withOpacity(0.06),
                ],
              ),
            ),

            child: GestureDetector(
              onTap: _delete,

              child: Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.red.withOpacity(0.12),
                ),

                child: const Icon(
                  Icons.delete_outline,

                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ),

        //////////////////////////////////////////////////////////
        /// CARD
        //////////////////////////////////////////////////////////
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _drag += details.delta.dx;

              _drag = _drag.clamp(-90.0, 0.0);
            });
          },

          onHorizontalDragEnd: (_) {
            if (_drag < -45) {
              setState(() {
                _drag = -90;
              });
            } else {
              setState(() {
                _drag = 0;
              });
            }
          },

          onTap: () {
            context.push(
              '${AppRoutes.device}?deviceId=${widget.deviceId}&pondId=${widget.pondId}',
            );
          },

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),

            curve: Curves.easeOutCubic,

            transform: Matrix4.identity()..translate(_drag),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                child: Container(
                  padding: const EdgeInsets.all(22),

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

                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),

                  child: Row(
                    children: [
                      //////////////////////////////////////////////////
                      /// ICON
                      //////////////////////////////////////////////////
                      Container(
                        width: 68,
                        height: 68,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),

                          gradient: LinearGradient(
                            colors: [
                              Colors.cyan.withOpacity(0.18),

                              Colors.blue.withOpacity(0.08),
                            ],
                          ),
                        ),

                        child: const Icon(
                          Icons.memory_rounded,

                          color: Colors.cyanAccent,

                          size: 32,
                        ),
                      ),

                      const SizedBox(width: 18),

                      //////////////////////////////////////////////////
                      /// CONTENT
                      //////////////////////////////////////////////////
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              widget.deviceId,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 20,

                                fontWeight: FontWeight.w700,

                                letterSpacing: -0.8,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              widget.mac,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                color: Colors.white.withOpacity(0.42),

                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseController,

                                  builder: (_, child) {
                                    return Opacity(
                                      opacity: isOnline
                                          ? 0.5 + (_pulseController.value * 0.5)
                                          : 1,

                                      child: child,
                                    );
                                  },

                                  child: Container(
                                    width: 10,

                                    height: 10,

                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,

                                      color: isOnline
                                          ? Colors.cyanAccent
                                          : Colors.redAccent,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  isOnline ? 'Realtime Active' : 'Offline',

                                  style: TextStyle(
                                    color: isOnline
                                        ? Colors.cyanAccent
                                        : Colors.redAccent,

                                    fontWeight: FontWeight.w600,

                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //////////////////////////////////////////////////
                      /// CHEVRON
                      //////////////////////////////////////////////////
                      Icon(
                        Icons.chevron_right_rounded,

                        color: Colors.white.withOpacity(0.22),

                        size: 30,
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
