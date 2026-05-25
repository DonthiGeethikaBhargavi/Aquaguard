import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

import 'adaptive_page_padding.dart';

class AdaptiveScrollView extends StatelessWidget {
  final List<Widget> children;

  final bool useSafeArea;

  final bool useContainer;

  final bool bounce;

  final bool primary;

  final bool shrinkWrap;

  final ScrollController? controller;

  final EdgeInsetsGeometry? padding;

  final ScrollPhysics? physics;

  final Widget? separator;

  final double? maxWidth;

  const AdaptiveScrollView({
    super.key,
    required this.children,
    this.useSafeArea = true,
    this.useContainer = true,
    this.bounce = true,
    this.primary = true,
    this.shrinkWrap = false,
    this.controller,
    this.padding,
    this.physics,
    this.separator,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////
    /// RESPONSIVE
    //////////////////////////////////////////////////////////

    final isDesktop = ResponsiveHelper.isDesktop(context);

    //////////////////////////////////////////////////////////
    /// PHYSICS
    //////////////////////////////////////////////////////////

    final scrollPhysics =
        physics ??
        (bounce
            ? const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              )
            : const ClampingScrollPhysics());

    //////////////////////////////////////////////////////////
    /// CONTENT COLUMN
    //////////////////////////////////////////////////////////

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: separator == null ? children : _withSeparators(),
    );

    //////////////////////////////////////////////////////////
    /// SCROLL VIEW
    //////////////////////////////////////////////////////////

    Widget content = CustomScrollView(
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      physics: scrollPhysics,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        //////////////////////////////////////////////////////
        /// BODY
        //////////////////////////////////////////////////////
        SliverToBoxAdapter(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: AdaptivePagePadding(child: column),
          ),
        ),

        //////////////////////////////////////////////////////
        /// BOTTOM SPACE
        //////////////////////////////////////////////////////
        SliverToBoxAdapter(child: SizedBox(height: isDesktop ? 40 : 28)),
      ],
    );

    //////////////////////////////////////////////////////////
    /// MAX WIDTH CONTAINER
    //////////////////////////////////////////////////////////

    if (useContainer) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? 1400),
          child: content,
        ),
      );
    }

    //////////////////////////////////////////////////////////
    /// SAFE AREA
    //////////////////////////////////////////////////////////

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    //////////////////////////////////////////////////////////
    /// REPAINT
    //////////////////////////////////////////////////////////

    return RepaintBoundary(child: content);
  }

  ////////////////////////////////////////////////////////////
  /// SEPARATORS
  ////////////////////////////////////////////////////////////

  List<Widget> _withSeparators() {
    final items = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);

      if (i != children.length - 1) {
        items.add(separator!);
      }
    }

    return items;
  }
}
