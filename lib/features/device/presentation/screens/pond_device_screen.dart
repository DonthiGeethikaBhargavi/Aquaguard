import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';

import '../../application/providers/pond_devices_provider.dart';

import '../widgets/add_device_sheet.dart';

import '../widgets/device_action_sheet.dart';

class PondDeviceScreen extends ConsumerStatefulWidget {
  final String pondId;

  final String? pondName;

  const PondDeviceScreen({super.key, required this.pondId, this.pondName});

  @override
  ConsumerState<PondDeviceScreen> createState() => _PondDeviceScreenState();
}

class _PondDeviceScreenState extends ConsumerState<PondDeviceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// FORMAT LAST SEEN
  ////////////////////////////////////////////////////////////

  String _formatLastSeen(DateTime? time) {
    if (time == null) {
      return 'Never';
    }

    final diff = DateTime.now().difference(time);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }

    return '${diff.inDays}d ago';
  }

  ////////////////////////////////////////////////////////////
  /// SHOW ADD DEVICE
  ////////////////////////////////////////////////////////////

  void _showAddDeviceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AddDeviceSheet(pondId: widget.pondId);
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// SHOW DEVICE ACTIONS
  ////////////////////////////////////////////////////////////

  void _showDeviceActions({
    required String deviceId,
    required String deviceName,
    required String pondId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DeviceActionSheet(
          deviceId: deviceId,
          deviceName: deviceName,
          pondId: pondId,
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH
  ////////////////////////////////////////////////////////////

  Future<void> _refreshDevices() {
    return ref.refresh(pondDevicesProvider(widget.pondId).future);
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(pondDevicesProvider(widget.pondId));

    return Scaffold(
      backgroundColor: const Color(0xFF050B16),

      //////////////////////////////////////////////////////////
      /// BODY
      //////////////////////////////////////////////////////////
      body: Stack(
        children: [
          //////////////////////////////////////////////////////
          /// BACKGROUND
          //////////////////////////////////////////////////////
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF081120),
                    Color(0xFF07101C),
                    Color(0xFF050B16),
                  ],
                ),
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// CYAN GLOW
          //////////////////////////////////////////////////////
          Positioned(
            top: -120,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withOpacity(0.08),
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// CONTENT
          //////////////////////////////////////////////////////
          SafeArea(
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut,
              ),

              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOutCubic,
                      ),
                    ),

                child: devicesAsync.when(
                  ////////////////////////////////////////////////////////////
                  /// LOADING
                  ////////////////////////////////////////////////////////////
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      ),
                    );
                  },

                  ////////////////////////////////////////////////////////////
                  /// ERROR
                  ////////////////////////////////////////////////////////////
                  error: (e, st) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Failed to load devices\n\n$e',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },

                  ////////////////////////////////////////////////////////////
                  /// DATA
                  ////////////////////////////////////////////////////////////
                  data: (devices) {
                    return RefreshIndicator(
                      color: Colors.cyanAccent,

                      backgroundColor: const Color(0xFF09111F),

                      onRefresh: _refreshDevices,

                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),

                        slivers: [
                          ////////////////////////////////////////////////////
                          /// HEADER
                          ////////////////////////////////////////////////////
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),

                              child: Row(
                                children: [
                                  _GlassButton(
                                    icon: Icons.arrow_back_ios_new,

                                    onTap: () {
                                      context.pop();
                                    },
                                  ),

                                  const Spacer(),

                                  _GlassButton(
                                    icon: Icons.add,

                                    onTap: _showAddDeviceSheet,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ////////////////////////////////////////////////////
                          /// TITLE
                          ////////////////////////////////////////////////////
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    widget.pondName ?? 'Pond Devices',

                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -1.2,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    '${devices.length} Devices Connected',

                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ////////////////////////////////////////////////////
                          /// HERO
                          ////////////////////////////////////////////////////
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(24),

                              child: _HeroCard(),
                            ),
                          ),

                          ////////////////////////////////////////////////////
                          /// EMPTY
                          ////////////////////////////////////////////////////
                          if (devices.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,

                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.cyanAccent.withOpacity(0.18),
                                            Colors.cyanAccent.withOpacity(0.04),
                                          ],
                                        ),
                                      ),

                                      child: Icon(
                                        Icons.sensors_off_rounded,

                                        color: Colors.white.withOpacity(0.8),

                                        size: 56,
                                      ),
                                    ),

                                    const SizedBox(height: 28),

                                    const Text(
                                      'No Devices Found',

                                      style: TextStyle(
                                        color: Colors.white,

                                        fontSize: 24,

                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),

                                      child: Text(
                                        'Connect your first AquaGuard IoT device to start realtime monitoring.',

                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.62),

                                          fontSize: 14,

                                          height: 1.5,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 34),

                                    SizedBox(
                                      height: 58,

                                      child: ElevatedButton.icon(
                                        onPressed: _showAddDeviceSheet,

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.cyanAccent,

                                          foregroundColor: Colors.black,

                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 28,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                        ),

                                        icon: const Icon(Icons.add),

                                        label: const Text(
                                          'Add Device',

                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ////////////////////////////////////////////////////
                          /// DEVICES
                          ////////////////////////////////////////////////////
                          if (devices.isNotEmpty)
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                0,
                                20,
                                120,
                              ),

                              sliver: SliverList.separated(
                                itemCount: devices.length,

                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 18),

                                itemBuilder: (_, index) {
                                  final device = devices[index];

                                  return _PremiumDeviceCard(
                                    deviceName: device.deviceName,

                                    deviceId: device.deviceId,

                                    status: device.isOnline
                                        ? 'Online'
                                        : 'Offline',

                                    lastSeen: _formatLastSeen(device.lastSeen),

                                    onTap: () {
                                      context.push(
                                        '${AppRoutes.device}'
                                        '?deviceId=${device.deviceId}'
                                        '&pondId=${device.pondId}'
                                        '&deviceName=${Uri.encodeComponent(device.deviceName)}',
                                      );
                                    },

                                    onLongPress: () {
                                      _showDeviceActions(
                                        deviceId: device.deviceId,

                                        deviceName: device.deviceName,

                                        pondId: device.pondId,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      //////////////////////////////////////////////////////////
      /// FAB
      //////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,

        elevation: 18,

        onPressed: _showAddDeviceSheet,

        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HERO CARD
////////////////////////////////////////////////////////////

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

        child: Container(
          height: 220,

          padding: const EdgeInsets.all(28),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),

            color: Colors.white.withOpacity(0.06),

            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.cyanAccent.withOpacity(0.16),
                ),

                child: const Icon(
                  Icons.water_drop,
                  color: Colors.cyanAccent,
                  size: 30,
                ),
              ),

              const Spacer(),

              const Text(
                'Aquatic Ecosystem',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Realtime device monitoring and telemetry intelligence.',

                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// DEVICE CARD
////////////////////////////////////////////////////////////

class _PremiumDeviceCard extends StatelessWidget {
  final String deviceName;

  final String deviceId;

  final String status;

  final String lastSeen;

  final VoidCallback onTap;

  final VoidCallback onLongPress;

  const _PremiumDeviceCard({
    required this.deviceName,
    required this.deviceId,
    required this.status,
    required this.lastSeen,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = status == 'Online';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

          child: Container(
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),

              color: Colors.white.withOpacity(0.05),

              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),

            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    color: Colors.cyanAccent.withOpacity(0.12),
                  ),

                  child: const Icon(
                    Icons.memory_rounded,
                    color: Colors.cyanAccent,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        deviceName,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        deviceId,

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _AnimatedStatusDot(isOnline: isOnline),

                          const SizedBox(width: 8),

                          Text(
                            '$status • $lastSeen',

                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.4),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} ////////////////////////////////////////////////////////////
/// ANIMATED STATUS DOT
////////////////////////////////////////////////////////////

class _AnimatedStatusDot extends StatefulWidget {
  final bool isOnline;

  const _AnimatedStatusDot({required this.isOnline});

  @override
  State<_AnimatedStatusDot> createState() => _AnimatedStatusDotState();
}

class _AnimatedStatusDotState extends State<_AnimatedStatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (widget.isOnline) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedStatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOnline) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isOnline ? Colors.greenAccent : Colors.redAccent;

    return SizedBox(
      width: 16,
      height: 16,

      child: Stack(
        alignment: Alignment.center,

        children: [
          //////////////////////////////////////////////////////
          /// PULSE
          //////////////////////////////////////////////////////
          if (widget.isOnline)
            AnimatedBuilder(
              animation: _controller,

              builder: (_, __) {
                final scale = 1 + (_controller.value * 1.8);

                final opacity = 1 - _controller.value;

                return Container(
                  width: 10 * scale,
                  height: 10 * scale,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: color.withOpacity(opacity * 0.35),
                  ),
                );
              },
            ),

          //////////////////////////////////////////////////////
          /// DOT
          //////////////////////////////////////////////////////
          Container(
            width: 10,
            height: 10,

            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// GLASS BUTTON
////////////////////////////////////////////////////////////

class _GlassButton extends StatelessWidget {
  final IconData icon;

  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

          child: Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              color: Colors.white.withOpacity(0.05),

              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),

            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
