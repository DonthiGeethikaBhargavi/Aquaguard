import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveButton extends StatelessWidget {
  final String label;

  final VoidCallback? onPressed;

  final IconData? icon;

  final bool loading;

  final bool expanded;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final double? height;

  final BorderRadius? borderRadius;

  const AdaptiveButton({
    super.key,

    required this.label,

    this.onPressed,

    this.icon,

    this.loading = false,

    this.expanded = true,

    this.backgroundColor,

    this.foregroundColor,

    this.height,

    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final button = SizedBox(
      height: height ?? (isMobile ? 52 : 58),

      width: expanded ? double.infinity : null,

      child: ElevatedButton(
        onPressed: loading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: backgroundColor ?? const Color(0xFF22D3EE),

          foregroundColor: foregroundColor ?? Colors.black,

          disabledBackgroundColor: Colors.white.withOpacity(0.08),

          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(18),
          ),

          padding: EdgeInsets.symmetric(horizontal: isMobile ? 18 : 24),
        ),

        child: loading
            ? SizedBox(
                width: 24,
                height: 24,

                child: CircularProgressIndicator(
                  strokeWidth: 2.8,

                  color: foregroundColor ?? Colors.black,
                ),
              )
            : Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,

                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ////////////////////////////////////////////////////////
                  /// ICON
                  ////////////////////////////////////////////////////////
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),

                      child: Icon(icon, size: isMobile ? 18 : 20),
                    ),

                  ////////////////////////////////////////////////////////
                  /// LABEL
                  ////////////////////////////////////////////////////////
                  Flexible(
                    child: Text(
                      label,

                      overflow: TextOverflow.ellipsis,

                      maxLines: 1,

                      style: TextStyle(
                        fontSize: isMobile ? 14 : 15,

                        fontWeight: FontWeight.w700,

                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );

    //////////////////////////////////////////////////////////
    /// NON EXPANDED
    //////////////////////////////////////////////////////////

    if (!expanded) {
      return button;
    }

    return button;
  }
}
