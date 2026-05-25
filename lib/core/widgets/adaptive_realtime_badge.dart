import 'dart:math';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

enum AdaptiveRealtimeState { live, syncing, warning, offline }

class AdaptiveRealtimeBadge extends StatefulWidget {
  final String? label;

  final AdaptiveRealtimeState state;

  final bool compact;

  final bool animated;

  final bool showIcon;

  final EdgeInsetsGeometry? padding;

  const AdaptiveRealtimeBadge({
    super.key,

    this.label,

    this.state = AdaptiveRealtimeState.live,

    this.compact = false,

    this.animated = true,

    this.showIcon = false,

    this.padding,
  });

  @override
  State<AdaptiveRealtimeBadge> createState() => _AdaptiveRealtimeBadgeState();
}

class _AdaptiveRealtimeBadgeState extends State<AdaptiveRealtimeBadge>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLER
  ////////////////////////////////////////////////////////////

  late final AnimationController _controller;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1800),
    );

    if (widget.animated) {
      _controller.repeat(reverse: true);
    }
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
  /// COLOR
  ////////////////////////////////////////////////////////////

  Color get color {
    switch (widget.state) {
      case AdaptiveRealtimeState.live:
        return const Color(0xFF22C55E);

      case AdaptiveRealtimeState.syncing:
        return const Color(0xFF35E7FF);

      case AdaptiveRealtimeState.warning:
        return const Color(0xFFF59E0B);

      case AdaptiveRealtimeState.offline:
        return const Color(0xFF64748B);
    }
  }

  ////////////////////////////////////////////////////////////
  /// LABEL
  ////////////////////////////////////////////////////////////

  String get resolvedLabel {
    if (widget.label != null) {
      return widget.label!;
    }

    switch (widget.state) {
      case AdaptiveRealtimeState.live:
        return 'LIVE';

      case AdaptiveRealtimeState.syncing:
        return 'SYNCING';

      case AdaptiveRealtimeState.warning:
        return 'UNSTABLE';

      case AdaptiveRealtimeState.offline:
        return 'OFFLINE';
    }
  }

  ////////////////////////////////////////////////////////////
  /// ICON
  ////////////////////////////////////////////////////////////

  IconData get icon {
    switch (widget.state) {
      case AdaptiveRealtimeState.live:
        return Icons.wifi_tethering;

      case AdaptiveRealtimeState.syncing:
        return Icons.sync_rounded;

      case AdaptiveRealtimeState.warning:
        return Icons.warning_amber_rounded;

      case AdaptiveRealtimeState.offline:
        return Icons.wifi_off_rounded;
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    //////////////////////////////////////////////////////////
    /// COMPACT
    //////////////////////////////////////////////////////////

    final compact = widget.compact;

    //////////////////////////////////////////////////////////
    /// SIZING
    //////////////////////////////////////////////////////////

    final horizontal = compact ? 10.0 : (isMobile ? 12.0 : 14.0);

    final vertical = compact ? 7.0 : (isMobile ? 8.0 : 10.0);

    final fontSize = compact ? 10.0 : (isMobile ? 11.0 : 12.0);

    final dotSize = compact ? 7.0 : (isMobile ? 8.0 : 9.0);

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    return AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {
        final pulse = sin(_controller.value * pi) * 4;

        final glow = 4 + pulse;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          padding:
              widget.padding ??
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 16 : 18),

            color: color.withOpacity(0.12),

            border: Border.all(color: color.withOpacity(0.22)),

            boxShadow: widget.animated
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.08),

                      blurRadius: glow * 2,

                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              //////////////////////////////////////////////////////////////
              /// ICON
              //////////////////////////////////////////////////////////////
              if (widget.showIcon)
                Padding(
                  padding: const EdgeInsets.only(right: 6),

                  child: Icon(icon, size: compact ? 14 : 16, color: color),
                ),

              //////////////////////////////////////////////////////////////
              /// DOT
              //////////////////////////////////////////////////////////////
              Container(
                width: dotSize,
                height: dotSize,

                decoration: BoxDecoration(
                  color: color,

                  shape: BoxShape.circle,

                  boxShadow: widget.animated
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.55),

                            blurRadius: glow,

                            spreadRadius: glow * 0.18,
                          ),
                        ]
                      : [],
                ),
              ),

              SizedBox(width: compact ? 6 : 8),

              //////////////////////////////////////////////////////////////
              /// LABEL
              //////////////////////////////////////////////////////////////
              Text(
                resolvedLabel,

                style: TextStyle(
                  color: color,

                  fontSize: fontSize,

                  fontWeight: FontWeight.w800,

                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
