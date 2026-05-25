import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/pond_state_provider.dart';
import '../../domain/models/pond_with_reading.dart';

class PremiumPondCard extends ConsumerStatefulWidget {
  final PondWithReading data;

  final VoidCallback onTap;

  final bool isFeatured;

  const PremiumPondCard({
    super.key,
    required this.data,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  ConsumerState<PremiumPondCard> createState() => _PremiumPondCardState();
}

class _PremiumPondCardState extends ConsumerState<PremiumPondCard>
    with TickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLERS
  ////////////////////////////////////////////////////////////

  late final AnimationController _pulseController;

  late final Animation<double> _pulseAnimation;

  ////////////////////////////////////////////////////////////
  /// STATE
  ////////////////////////////////////////////////////////////

  double _drag = 0;

  bool _pressed = false;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.55, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

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

      barrierDismissible: true,

      barrierColor: Colors.black.withOpacity(0.45),

      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 28),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

              child: Container(
                padding: const EdgeInsets.all(28),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  color: const Color(0xFF111827).withOpacity(0.94),

                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(
                      width: 58,
                      height: 58,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: Colors.red.withOpacity(0.08),
                      ),

                      child: Icon(
                        Icons.delete_outline_rounded,

                        color: Colors.red.shade300,

                        size: 26,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Delete Pond?',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 20,

                        fontWeight: FontWeight.w500,

                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'This pond and its telemetry history will be removed.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),

                        fontSize: 14,

                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context, false);
                            },

                            child: Container(
                              height: 52,

                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),

                                color: Colors.white.withOpacity(0.04),
                              ),

                              child: Text(
                                'Cancel',

                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),

                                  fontSize: 15,

                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context, true);
                            },

                            child: Container(
                              height: 52,

                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),

                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade400,

                                    Colors.red.shade300,
                                  ],
                                ),
                              ),

                              child: const Text(
                                'Delete',

                                style: TextStyle(
                                  color: Colors.white,

                                  fontSize: 15,

                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    //////////////////////////////////////////////////////////
    /// RESET SWIPE POSITION
    //////////////////////////////////////////////////////////

    setState(() {
      _drag = 0;
    });

    await Future.delayed(const Duration(milliseconds: 180));

    //////////////////////////////////////////////////////////
    /// REMOVE FROM UI
    //////////////////////////////////////////////////////////

    ref.read(deletePondStateProvider.notifier).requestDelete(widget.data);

    //////////////////////////////////////////////////////////
    /// SNACKBAR
    //////////////////////////////////////////////////////////

    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger == null) {
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),

          backgroundColor: const Color(0xFF141C2B),

          elevation: 0,

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          content: const Text('Pond deleted successfully'),
        ),
      );
  }

  ////////////////////////////////////////////////////////////
  /// DRAG
  ////////////////////////////////////////////////////////////

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _drag += details.delta.dx;

      _drag = _drag.clamp(-82.0, 0.0);
    });
  }

  ////////////////////////////////////////////////////////////
  /// DRAG END
  ////////////////////////////////////////////////////////////

  void _onDragEnd(DragEndDetails details) {
    if (_drag < -40) {
      setState(() => _drag = -82);
    } else {
      setState(() => _drag = 0);
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final hasData = widget.data.temperature != null;

    return AnimatedSize(
      duration: const Duration(milliseconds: 320),

      curve: Curves.easeOutCubic,

      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: widget.isFeatured ? 210 : 198),

        child: Stack(
          children: [
            //////////////////////////////////////////////////
            /// DELETE LAYER
            //////////////////////////////////////////////////
            Positioned.fill(
              child: Container(
                alignment: Alignment.centerRight,

                padding: const EdgeInsets.only(right: 24),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),

                  gradient: const LinearGradient(
                    colors: [Color(0xFF241114), Color(0xFF120B0D)],
                  ),
                ),

                child: GestureDetector(
                  onTap: _delete,

                  behavior: HitTestBehavior.opaque,

                  child: Container(
                    width: 52,
                    height: 52,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.red.withOpacity(0.08),

                      border: Border.all(color: Colors.red.withOpacity(0.16)),
                    ),

                    child: Icon(
                      Icons.delete_outline_rounded,

                      color: Colors.red.shade300,

                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            //////////////////////////////////////////////////
            /// MAIN CARD
            //////////////////////////////////////////////////
            IgnorePointer(
              ignoring: _drag < -40,

              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _pressed = true;
                  });
                },

                onTapUp: (_) {
                  setState(() {
                    _pressed = false;
                  });
                },

                onTapCancel: () {
                  setState(() {
                    _pressed = false;
                  });
                },

                onTap: widget.onTap,

                onHorizontalDragUpdate: _onDragUpdate,

                onHorizontalDragEnd: _onDragEnd,

                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 1, end: _pressed ? 0.988 : 1),
                  builder: (context, scale, child) {
                    return Transform.translate(
                      offset: Offset(_drag, 0),
                      child: Transform.scale(scale: scale, child: child),
                    );
                  },

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                      child: Container(
                        padding: EdgeInsets.all(widget.isFeatured ? 26 : 22),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),

                          gradient: LinearGradient(
                            begin: Alignment.topLeft,

                            end: Alignment.bottomRight,

                            colors: [
                              const Color(0xFF141C2B).withOpacity(0.88),

                              const Color(0xFF0B1220).withOpacity(0.82),
                            ],
                          ),

                          border: Border.all(
                            color: Colors.white.withOpacity(0.045),
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        widget.data.pondName,

                                        maxLines: 1,

                                        overflow: TextOverflow.ellipsis,

                                        style: TextStyle(
                                          color: Colors.white,

                                          fontSize: widget.isFeatured ? 24 : 21,

                                          fontWeight: FontWeight.w500,

                                          letterSpacing: -1.1,

                                          height: 1,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        _formatTime(widget.data.lastUpdate),

                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.42),

                                          fontSize: 12,

                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),

                                    color: hasData
                                        ? Colors.cyan.withOpacity(0.08)
                                        : Colors.white.withOpacity(0.03),

                                    border: Border.all(
                                      color: hasData
                                          ? Colors.cyan.withOpacity(0.12)
                                          : Colors.white.withOpacity(0.04),
                                    ),
                                  ),

                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      FadeTransition(
                                        opacity: _pulseAnimation,

                                        child: Container(
                                          width: 6,
                                          height: 6,

                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,

                                            color: hasData
                                                ? const Color(0xFF7DD3FC)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 7),

                                      Text(
                                        hasData ? 'LIVE' : 'OFFLINE',

                                        style: TextStyle(
                                          color: hasData
                                              ? Colors.white.withOpacity(0.82)
                                              : Colors.white54,

                                          fontSize: 10,

                                          fontWeight: FontWeight.w500,

                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            Wrap(
                              spacing: 14,

                              runSpacing: 14,

                              children: [
                                _metric(
                                  title: 'Water Temp',

                                  value:
                                      '${widget.data.temperature?.toStringAsFixed(1) ?? '--'}°',
                                ),

                                _metric(
                                  title: 'pH',

                                  value:
                                      widget.data.ph?.toStringAsFixed(1) ??
                                      '--',
                                ),

                                _metric(
                                  title: 'Oxygen',

                                  value:
                                      widget.data.dissolvedOxygen
                                          ?.toStringAsFixed(1) ??
                                      '--',
                                ),

                                _metric(
                                  title: 'Water Level',

                                  value:
                                      '${widget.data.waterLevel?.toStringAsFixed(0) ?? '--'}%',
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
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// METRIC
  ////////////////////////////////////////////////////////////

  Widget _metric({required String title, required String value}) {
    return SizedBox(
      width: 74,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),

            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,

                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15),

                    end: Offset.zero,
                  ).animate(animation),

                  child: child,
                ),
              );
            },

            child: Text(
              value,

              key: ValueKey(value),

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                color: Colors.white.withOpacity(0.94),

                fontSize: 19,

                fontWeight: FontWeight.w500,

                letterSpacing: -0.8,

                height: 1,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              color: Colors.white.withOpacity(0.42),

              fontSize: 11,

              fontWeight: FontWeight.w400,

              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// TIME FORMAT
  ////////////////////////////////////////////////////////////

  String _formatTime(DateTime? date) {
    if (date == null) {
      return 'No telemetry';
    }

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return 'Updated just now';
    }

    if (diff.inHours < 1) {
      return '${diff.inMinutes} min ago';
    }

    if (diff.inDays < 1) {
      return '${diff.inHours} hr ago';
    }

    return '${diff.inDays} days ago';
  }
}
