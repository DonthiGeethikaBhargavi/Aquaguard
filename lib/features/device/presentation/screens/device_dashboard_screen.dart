import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aquaguard/core/responsive/responsive_helper.dart';

import 'package:aquaguard/core/widgets/adaptive_header.dart';
import 'package:aquaguard/core/widgets/adaptive_realtime_badge.dart';
import 'package:aquaguard/core/widgets/adaptive_tab_bar.dart';

import 'package:aquaguard/core/services/sound_manager.dart';

import 'package:aquaguard/features/device/data/providers/device_status_provider.dart';

import 'package:aquaguard/features/device/presentation/screens/ai_insights_screen.dart';
import 'package:aquaguard/features/device/presentation/widgets/analytics_screen.dart';
import 'package:aquaguard/features/device/presentation/screens/alerts_screen.dart';
import 'package:aquaguard/features/device/presentation/screens/overview_screen.dart';
import 'package:aquaguard/features/notifications/presentation/screens/notification_screen.dart';

class DeviceDashboardScreen extends ConsumerStatefulWidget {
  final String pondId;

  final String deviceId;

  final String? deviceName;

  const DeviceDashboardScreen({
    super.key,
    required this.pondId,
    required this.deviceId,
    this.deviceName,
  });

  @override
  ConsumerState<DeviceDashboardScreen> createState() =>
      _DeviceDashboardScreenState();
}

class _DeviceDashboardScreenState extends ConsumerState<DeviceDashboardScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ////////////////////////////////////////////////////////////
  /// TAB CONTROLLER
  ////////////////////////////////////////////////////////////

  late final TabController _tabController;

  ////////////////////////////////////////////////////////////
  /// ANIMATION
  ////////////////////////////////////////////////////////////

  late AnimationController _pageAnimationController;

  late Animation<double> _fadeAnimation;

  late Animation<Offset> _slideAnimation;

  ////////////////////////////////////////////////////////////
  /// KEEP ALIVE
  ////////////////////////////////////////////////////////////

  @override
  bool get wantKeepAlive => true;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    //////////////////////////////////////////////////////////
    /// TABS
    //////////////////////////////////////////////////////////

    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        SoundManager().playWaterClick();

        _pageAnimationController.forward(from: 0);
      }
    });

    //////////////////////////////////////////////////////////
    /// PAGE MOTION
    //////////////////////////////////////////////////////////

    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _pageAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _pageAnimationController.forward();
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _tabController.dispose();

    _pageAnimationController.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final isMobile = ResponsiveHelper.isMobile(context);

    //////////////////////////////////////////////////////////
    /// STATUS
    //////////////////////////////////////////////////////////

    final lastSeen = ref.watch(
      deviceStatusProviderProvider(widget.deviceId).select(
        (state) => state.maybeWhen(
          data: (status) => status.lastSeen,
          orElse: () => null,
        ),
      ),
    );

    final syncedText = _formatTimeAgo(
      DateTime.now().difference(lastSeen ?? DateTime.now()),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF050B16),

      //////////////////////////////////////////////////////////
      /// PREMIUM BACKGROUND
      //////////////////////////////////////////////////////////
      body: Stack(
        children: [
          //////////////////////////////////////////////////////
          /// BASE GRADIENT
          //////////////////////////////////////////////////////
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF091426),
                  Color(0xFF07101D),
                  Color(0xFF050B16),
                ],
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// AMBIENT GLOW
          //////////////////////////////////////////////////////
          Positioned(
            top: -120,
            right: -80,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyan.withOpacity(0.04),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -180,
            left: -120,
            child: IgnorePointer(
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.03),
                ),
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// CONTENT
          //////////////////////////////////////////////////////
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                //////////////////////////////////////////////////
                /// HEADER
                //////////////////////////////////////////////////
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveHelper.screenPadding(context),
                    14,
                    ResponsiveHelper.screenPadding(context),
                    0,
                  ),
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, 18 * (1 - _fadeAnimation.value)),
                          child: child,
                        ),
                      );
                    },
                    child: _DashboardHeader(
                      syncedText: syncedText,
                      deviceName: widget.deviceName,
                      pondId: widget.pondId,
                      deviceId: widget.deviceId,
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 18 : 28),

                //////////////////////////////////////////////////
                /// TAB BAR
                //////////////////////////////////////////////////
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.screenPadding(context),
                  ),
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, 26 * (1 - _fadeAnimation.value)),
                          child: child,
                        ),
                      );
                    },
                    child: AdaptiveTabBar(
                      controller: _tabController,
                      tabs: const ['Overview', 'Analytics', 'Alerts', 'AI'],
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 22 : 30),

                //////////////////////////////////////////////////
                /// TAB CONTENT
                //////////////////////////////////////////////////
                Expanded(
                  child: AnimatedBuilder(
                    animation: _pageAnimationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        //////////////////////////////////////////////////
                        /// OVERVIEW
                        //////////////////////////////////////////////////
                        RepaintBoundary(
                          child: OverviewScreen(
                            pondId: widget.pondId,
                            deviceId: widget.deviceId,
                            deviceName: widget.deviceName,
                          ),
                        ),

                        //////////////////////////////////////////////////
                        /// ANALYTICS
                        //////////////////////////////////////////////////
                        RepaintBoundary(
                          child: AnalyticsScreen(
                            pondId: widget.pondId,
                            deviceId: widget.deviceId,
                            deviceName: widget.deviceName,
                          ),
                        ),

                        //////////////////////////////////////////////////
                        /// ALERTS
                        //////////////////////////////////////////////////
                        RepaintBoundary(
                          child: AlertsScreen(
                            pondId: widget.pondId,
                            deviceId: widget.deviceId,
                          ),
                        ),

                        //////////////////////////////////////////////////
                        /// AI
                        //////////////////////////////////////////////////
                        RepaintBoundary(
                          child: AIInsightsScreen(
                            pondId: widget.pondId,
                            deviceId: widget.deviceId,
                            deviceName: widget.deviceName,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FORMAT TIME
  ////////////////////////////////////////////////////////////

  String _formatTimeAgo(Duration difference) {
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    }

    return '${difference.inDays} days ago';
  }
}

////////////////////////////////////////////////////////////
/// DASHBOARD HEADER
////////////////////////////////////////////////////////////

class _DashboardHeader extends StatelessWidget {
  final String syncedText;

  final String? deviceName;

  final String pondId;

  final String deviceId;

  const _DashboardHeader({
    required this.syncedText,
    required this.deviceName,
    required this.pondId,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return AdaptiveHeader(
      title: deviceName ?? 'AquaGuard Device',

      subtitle: 'Last synced $syncedText',

      leading: _GlassButton(
        icon: Icons.arrow_back_ios_new,
        onTap: () {
          SoundManager().playWaterClick();

          context.pop();
        },
      ),

      //////////////////////////////////////////////////////////
      /// FIXED TRAILING
      //////////////////////////////////////////////////////////
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NotificationButton(pondId: pondId, deviceId: deviceId),

          SizedBox(width: isMobile ? 8 : 12),

          const AdaptiveRealtimeBadge(),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// GLASS BUTTON
////////////////////////////////////////////////////////////

class _GlassButton extends StatefulWidget {
  final IconData icon;

  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!mounted) return;

        setState(() {
          _hovering = true;
        });
      },

      onExit: (_) {
        if (!mounted) return;

        setState(() {
          _hovering = false;
        });
      },

      //////////////////////////////////////////////////////////
      /// FIXED
      //////////////////////////////////////////////////////////
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),

        curve: Curves.easeOutCubic,

        scale: _hovering ? 1.04 : 1.0,

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius: BorderRadius.circular(24),

            onTap: widget.onTap,

            child: Ink(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.white.withOpacity(_hovering ? 0.08 : 0.05),

                border: Border.all(
                  color: Colors.white.withOpacity(_hovering ? 0.10 : 0.06),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.22),

                    blurRadius: _hovering ? 28 : 18,

                    offset: Offset(0, _hovering ? 12 : 8),
                  ),
                ],
              ),

              child: Icon(
                widget.icon,
                size: 20,
                color: Colors.white.withOpacity(0.88),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// NOTIFICATION BUTTON
////////////////////////////////////////////////////////////

class _NotificationButton extends StatelessWidget {
  final String pondId;
  final String deviceId;

  const _NotificationButton({required this.pondId, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _GlassButton(
          icon: Icons.notifications_none,
          onTap: () {
            SoundManager().playWaterClick();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    NotificationScreen(pondId: pondId, deviceId: deviceId),
              ),
            );
          },
        ),

        Positioned(
          top: 4,
          right: 4,
          child: IgnorePointer(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
