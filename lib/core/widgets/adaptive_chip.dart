import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveChip
    extends StatelessWidget {
  final String label;

  final IconData? icon;

  final Color color;

  final VoidCallback? onTap;

  final bool selected;

  const AdaptiveChip({
    super.key,

    required this.label,

    required this.color,

    this.icon,

    this.onTap,

    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile =
        ResponsiveHelper.isMobile(
          context,
        );

    final content = Container(
      padding:
          EdgeInsets.symmetric(
        horizontal:
            isMobile ? 14 : 16,

        vertical:
            isMobile ? 10 : 12,
      ),

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          18,
        ),

        color:
            selected
                ? color.withOpacity(
                  0.18,
                )
                : color.withOpacity(
                  0.10,
                ),

        border: Border.all(
          color:
              color.withOpacity(
            selected ? 0.35 : 0.18,
          ),
        ),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          //////////////////////////////////////////////////////
          /// ICON
          //////////////////////////////////////////////////////

          if (icon != null)
            Padding(
              padding:
                  const EdgeInsets.only(
                    right: 8,
                  ),

              child: Icon(
                icon,

                color: color,

                size:
                    isMobile
                    ? 16
                    : 18,
              ),
            ),

          //////////////////////////////////////////////////////
          /// LABEL
          //////////////////////////////////////////////////////

          Flexible(
            child: Text(
              label,

              overflow:
                  TextOverflow
                      .ellipsis,

              maxLines: 1,

              style: TextStyle(
                color: color,

                fontSize:
                    isMobile
                    ? 12
                    : 13,

                fontWeight:
                    selected
                        ? FontWeight
                            .w700
                        : FontWeight
                            .w600,
              ),
            ),
          ),
        ],
      ),
    );

    //////////////////////////////////////////////////////////
    /// TAP
    //////////////////////////////////////////////////////////

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          18,
        ),

        onTap: onTap,

        child: content,
      ),
    );
  }
}