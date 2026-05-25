import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveListView extends StatelessWidget {
  final int itemCount;

  final Widget Function(BuildContext context, int index) itemBuilder;

  final EdgeInsetsGeometry? padding;

  final ScrollPhysics? physics;

  final bool shrinkWrap;

  final bool separated;

  final Widget? separator;

  const AdaptiveListView({
    super.key,

    required this.itemCount,

    required this.itemBuilder,

    this.padding,

    this.physics,

    this.shrinkWrap = true,

    this.separated = false,

    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.isMobile(context) ? 12.0 : 16.0;

    //////////////////////////////////////////////////////////
    /// SEPARATED LIST
    //////////////////////////////////////////////////////////

    if (separated) {
      return ListView.separated(
        itemCount: itemCount,

        shrinkWrap: shrinkWrap,

        physics: physics ?? const NeverScrollableScrollPhysics(),

        padding: padding,

        separatorBuilder: (_, __) => separator ?? SizedBox(height: spacing),

        itemBuilder: itemBuilder,
      );
    }

    //////////////////////////////////////////////////////////
    /// NORMAL LIST
    //////////////////////////////////////////////////////////

    return ListView.builder(
      itemCount: itemCount,

      shrinkWrap: shrinkWrap,

      physics: physics ?? const NeverScrollableScrollPhysics(),

      padding: padding,

      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == itemCount - 1 ? 0 : spacing,
          ),

          child: itemBuilder(context, index),
        );
      },
    );
  }
}
