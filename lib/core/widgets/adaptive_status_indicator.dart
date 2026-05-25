import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

enum AdaptiveStatus { healthy, warning, critical, offline }

class AdaptiveStatusIndicator extends StatefulWidget {
  final AdaptiveStatus status;

  final String? label;

  final bool expanded;

  final bool compact;

  final bool animated;

  final bool showIcon;

  final EdgeInsetsGeometry? padding;

  final double? borderRadius;

  const AdaptiveStatusIndicator({
    super.key,

    required this.status,

    this.label,

    this.expanded = false,

    this.compact = false,

    this.animated = true,

    this.showIcon = true,

    this.padding,

    this.borderRadius,
  });

  @override
  State<AdaptiveStatusIndicator> createState() =>
      _AdaptiveStatusIndicatorState();
}

class _AdaptiveStatusIndicatorState extends State<AdaptiveStatusIndicator>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  /// CONTROLLER
  ////////////////////////////////////////////////////////////

  late AnimationController _controller;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1600),
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
    switch (widget.status) {
      case AdaptiveStatus.healthy:
        return const Color(0xFF22C55E);

      case AdaptiveStatus.warning:
        return const Color(0xFFF59E0B);

      case AdaptiveStatus.critical:
        return const Color(0xFFEF4444);

      case AdaptiveStatus.offline:
        return const Color(0xFF64748B);
    }
  }

  ////////////////////////////////////////////////////////////
  /// TEXT
  ////////////////////////////////////////////////////////////

  String get text {
    switch (widget.status) {
      case AdaptiveStatus.healthy:
        return 'Healthy';

      case AdaptiveStatus.warning:
        return 'Warning';

      case AdaptiveStatus.critical:
        return 'Critical';

      case AdaptiveStatus.offline:
        return 'Offline';
    }
  }

  ////////////////////////////////////////////////////////////
  /// ICON
  ////////////////////////////////////////////////////////////

  IconData get icon {
    switch (widget.status) {
      case AdaptiveStatus.healthy:
        return Icons.check_circle;

      case AdaptiveStatus.warning:
        return Icons.warning_amber_rounded;

      case AdaptiveStatus.critical:
        return Icons.error_rounded;

      case AdaptiveStatus.offline:
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

    final horizontal = compact ? 10.0 : (isMobile ? 14.0 : 16.0);

    final vertical = compact ? 7.0 : (isMobile ? 10.0 : 12.0);

    final iconSize = compact ? 14.0 : (isMobile ? 18.0 : 20.0);

    final fontSize = compact ? 11.0 : (isMobile ? 12.0 : 13.0);

    //////////////////////////////////////////////////////////
    /// CONTENT
    //////////////////////////////////////////////////////////

    return AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {
        final glow = widget.animated ? 0.12 + (_controller.value * 0.08) : 0.12;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          width: widget.expanded ? double.infinity : null,

          padding:
              widget.padding ??
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? (compact ? 14 : 18),
            ),

            color: color.withOpacity(glow),

            border: Border.all(color: color.withOpacity(0.20)),

            boxShadow: widget.animated
                ? [
                    BoxShadow(
                      color: color.withOpacity(glow * 0.55),

                      blurRadius: compact ? 10 : 16,

                      spreadRadius: compact ? 1 : 2,
                    ),
                  ]
                : [],
          ),

          child: Row(
            mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,

            mainAxisAlignment: widget.expanded
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,

            children: [
              //////////////////////////////////////////////////////////////
              /// ICON
              //////////////////////////////////////////////////////////////
              if (widget.showIcon) Icon(icon, color: color, size: iconSize),

              if (widget.showIcon) SizedBox(width: compact ? 8 : 10),

              //////////////////////////////////////////////////////////////
              /// LABEL
              //////////////////////////////////////////////////////////////
              Flexible(
                child: Text(
                  widget.label ?? text,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: color,

                    fontSize: fontSize,

                    fontWeight: FontWeight.w700,

                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
