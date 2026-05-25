import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aquaguard/core/router/app_router.dart';

////////////////////////////////////////////////////////////
/// WEATHER
////////////////////////////////////////////////////////////

import 'package:aquaguard/features/weather/application/providers/weather_provider.dart';
import 'package:aquaguard/features/weather/presentations/widgets/weather_card.dart';

////////////////////////////////////////////////////////////
/// POND
////////////////////////////////////////////////////////////

import 'package:aquaguard/features/pond/application/providers/pond_provider.dart';
import 'package:aquaguard/features/pond/application/providers/pond_state_provider.dart';

import 'package:aquaguard/features/pond/presentation/widgets/add_pond_modal.dart';
import 'package:aquaguard/features/pond/presentation/widgets/network_status_banner.dart';
import 'package:aquaguard/features/pond/presentation/widgets/premium_pond_card.dart';
import 'package:aquaguard/features/pond/presentation/widgets/premium_pond_empty.dart';
import 'package:aquaguard/features/pond/presentation/widgets/premium_pond_error.dart';
import 'package:aquaguard/features/pond/presentation/widgets/pond_shimmer.dart';

////////////////////////////////////////////////////////////
/// HOME
////////////////////////////////////////////////////////////

import 'package:aquaguard/features/home/presentation/widgets/home_header.dart';
import 'package:aquaguard/features/home/presentation/widgets/ponds_section_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;
  ////////////////////////////////////////////////////////////
  /// LIFECYCLE
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      if (mounted) {
        await ref.read(pondProvider.notifier).refreshInBackground();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// APP RESUMED
  ////////////////////////////////////////////////////////////

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.microtask(() {
        if (!mounted) return;

        ref.invalidate(userWeatherProvider);
      });
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(userWeatherProvider);

    final pondsAsync = ref.watch(pondProvider);

    final deletePondState = ref.watch(deletePondStateProvider);

    //////////////////////////////////////////////////////////
    /// NIGHT DETECTION
    //////////////////////////////////////////////////////////

    final isNight = weatherAsync.maybeWhen(
      data: (w) {
        final now = DateTime.now();

        return now.isBefore(w.sunrise) || now.isAfter(w.sunset);
      },

      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          //////////////////////////////////////////////////
          /// PREMIUM RESPONSIVE PADDING
          //////////////////////////////////////////////////

          final padding = min(screenWidth * 0.055, 28.0);

          return Stack(
            children: [
              ////////////////////////////////////////////////
              /// PREMIUM BACKGROUND
              ////////////////////////////////////////////////
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,

                      colors: [Color(0xFF07111F), Color(0xFF0F172A)],
                    ),
                  ),
                ),
              ),
              ////////////////////////////////////////////////
              /// ATMOSPHERIC CYAN ORB
              ////////////////////////////////////////////////
              Positioned(
                top: -120,
                right: -80,

                child: IgnorePointer(
                  child: Container(
                    width: 260,
                    height: 260,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.cyan.withOpacity(0.06),
                    ),
                  ),
                ),
              ),

              ////////////////////////////////////////////////
              /// ATMOSPHERIC BLUE ORB
              ////////////////////////////////////////////////
              Positioned(
                bottom: -100,
                left: -60,

                child: IgnorePointer(
                  child: Container(
                    width: 220,
                    height: 220,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.blue.withOpacity(0.04),
                    ),
                  ),
                ),
              ),

              ////////////////////////////////////////////////
              /// ATMOSPHERIC OVERLAY
              ////////////////////////////////////////////////
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1200),

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,

                        end: Alignment.topCenter,

                        colors: [
                          Colors.black.withOpacity(isNight ? 0.22 : 0.08),

                          Colors.black.withOpacity(isNight ? 0.05 : 0.015),

                          Colors.transparent,
                        ],

                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              ////////////////////////////////////////////////
              /// MAIN CONTENT
              ////////////////////////////////////////////////
              SafeArea(
                child: Column(
                  children: [
                    ////////////////////////////////////////////
                    /// NETWORK STATUS
                    ////////////////////////////////////////////
                    const NetworkStatusBanner(isOnline: true),

                    ////////////////////////////////////////////
                    /// SCROLLABLE CONTENT
                    ////////////////////////////////////////////
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        ),

                        padding: EdgeInsets.symmetric(
                          horizontal: padding,

                          vertical: 18,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            //////////////////////////////////////
                            /// HEADER
                            //////////////////////////////////////
                            const HomeHeader(),

                            const SizedBox(height: 18),

                            //////////////////////////////////////
                            /// WEATHER CARD
                            //////////////////////////////////////
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 700),

                              switchInCurve: Curves.easeOutCubic,

                              switchOutCurve: Curves.easeInOutCubic,

                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,

                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.03),

                                      end: Offset.zero,
                                    ).animate(animation),

                                    child: child,
                                  ),
                                );
                              },

                              child: Align(
                                alignment: Alignment.centerLeft,

                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 450),

                                  curve: Curves.easeOutCubic,

                                  child: weatherAsync.when(
                                    data: (w) {
                                      return WeatherCard(
                                        weather: w,

                                        isNight: isNight,
                                      );
                                    },

                                    loading: () => const _WeatherSkeleton(),

                                    error: (_, __) => const _WeatherError(),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            //////////////////////////////////////
                            /// PONDS HEADER
                            //////////////////////////////////////
                            PondsSectionHeader(
                              onAddPressed: () {
                                _showAddPondModal(context);
                              },
                            ),

                            const SizedBox(height: 24),

                            //////////////////////////////////////
                            /// PONDS LIST
                            //////////////////////////////////////
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 700),

                              switchInCurve: Curves.easeOutCubic,

                              switchOutCurve: Curves.easeInOutCubic,

                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,

                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.03),

                                      end: Offset.zero,
                                    ).animate(animation),

                                    child: child,
                                  ),
                                );
                              },

                              child: pondsAsync.when(
                                //////////////////////////////////
                                /// DATA
                                //////////////////////////////////
                                data: (list) {
                                  final displayList =
                                      deletePondState.undoId != null
                                      ? list
                                            .where(
                                              (p) =>
                                                  p.pondId !=
                                                  deletePondState.undoId,
                                            )
                                            .toList()
                                      : list;

                                  //////////////////////////////////
                                  /// EMPTY
                                  //////////////////////////////////

                                  if (displayList.isEmpty) {
                                    return PremiumPondEmpty(
                                      onAdd: () {
                                        _showAddPondModal(context);
                                      },
                                    );
                                  }

                                  //////////////////////////////////
                                  /// LIST
                                  //////////////////////////////////

                                  return RefreshIndicator(
                                    color: Colors.white.withOpacity(0.85),

                                    backgroundColor: const Color(0xFF0B1220),

                                    onRefresh: () async {
                                      ref.invalidate(pondProvider);

                                      ref.invalidate(userWeatherProvider);
                                    },

                                    child: ListView.separated(
                                      shrinkWrap: true,

                                      physics:
                                          const NeverScrollableScrollPhysics(),

                                      padding: EdgeInsets.zero,

                                      itemCount: displayList.length,

                                      separatorBuilder: (_, __) {
                                        return const SizedBox(height: 22);
                                      },

                                      itemBuilder: (_, i) {
                                        final pond = displayList[i];

                                        final isFeatured = i == 0;

                                        return RepaintBoundary(
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),

                                            curve: Curves.easeOutCubic,

                                            child: PremiumPondCard(
                                              key: ValueKey(pond.pondId),

                                              data: pond,

                                              isFeatured: isFeatured,

                                              onTap: () {
                                                context.push(
                                                  '${AppRoutes.pondDevices}'
                                                  '?pondId=${pond.pondId}'
                                                  '&pondName=${Uri.encodeComponent(pond.pondName)}',
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },

                                //////////////////////////////////
                                /// LOADING
                                //////////////////////////////////
                                loading: () => const PondShimmer(),

                                //////////////////////////////////
                                /// ERROR
                                //////////////////////////////////
                                error: (_, __) {
                                  return PremiumPondError(
                                    onRetry: () {
                                      ref.invalidate(pondProvider);
                                    },

                                    customMessage:
                                        'Couldn\'t load your ponds. Please check your connection.',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 160),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// ADD POND MODAL
  ////////////////////////////////////////////////////////////

  void _showAddPondModal(BuildContext context) {
    showDialog(
      context: context,

      barrierDismissible: true,

      barrierColor: Colors.black.withOpacity(0.3),

      builder: (_) => const AddPondModal(),
    );
  }
}

////////////////////////////////////////////////////////////
/// WEATHER SKELETON
////////////////////////////////////////////////////////////

class _WeatherSkeleton extends StatelessWidget {
  const _WeatherSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),

        borderRadius: BorderRadius.circular(34),

        border: Border.all(color: Colors.white.withOpacity(0.035)),
      ),

      child: const SizedBox(height: 260),
    );
  }
}

////////////////////////////////////////////////////////////
/// WEATHER ERROR
////////////////////////////////////////////////////////////

class _WeatherError extends StatelessWidget {
  const _WeatherError();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),

        borderRadius: BorderRadius.circular(34),

        border: Border.all(color: Colors.white.withOpacity(0.035)),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),

        child: Text(
          'Weather unavailable',

          style: TextStyle(
            color: Colors.white.withOpacity(0.58),

            fontWeight: FontWeight.w500,

            fontSize: 14,

            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
