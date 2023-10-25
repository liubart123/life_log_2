import 'package:flutter/material.dart';
import 'package:life_log_2/my_widgets/elevation_utils.dart';
import 'package:structures/structures.dart';

import 'my_widgets.dart';

class MyScrollableCardList extends StatefulWidget {
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final Future Function() reloadCallback;
  final Function() bottomScrolledCallback;

  MyScrollableCardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.reloadCallback,
    required this.bottomScrolledCallback,
  });

  @override
  State<MyScrollableCardList> createState() => _MyScrollableCardListState();
}

class _MyScrollableCardListState extends State<MyScrollableCardList> {
  late final ScrollController _scrollController;
  late bool bottomWasScrolled;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(handleScrolling);
    bottomWasScrolled = false;
    super.initState();
  }

  void handleScrolling() {
    if (_scrollController.position.extentAfter < 50) {
      if (!bottomWasScrolled) widget.bottomScrolledCallback();
      bottomWasScrolled = true;
    } else {
      bottomWasScrolled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: widget.reloadCallback,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
        ),
      ),
    );
  }
}

class MyScrollableCardList_Card extends StatelessWidget {
  final Widget child;
  final Function()? onTap;

  final int colorElevationLevel;
  final int shadowElevationLevel;

  const MyScrollableCardList_Card({
    super.key,
    required this.child,
    this.onTap,
    this.colorElevationLevel = 1,
    this.shadowElevationLevel = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [GetElevatedBoxShadow(context, shadowElevationLevel)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color:
            GetTintColorForSurfaceTintOnSurface(context, colorElevationLevel),
        child: InkWell(
          onTap: onTap ?? () {},
          child: child,
        ),
      ),
    );
  }
}

class MyScrollableCardList_Card_InnerContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  final int elevation, shadowElevation;
  final bool useElevation;

  MyScrollableCardList_Card_InnerContainer({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.margin = const EdgeInsets.fromLTRB(4, 0, 4, 0),
    this.useElevation = true,
    this.elevation = 0,
    this.shadowElevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: useElevation
          ? MyElevatedContainer(
              child: child,
              elevation: elevation,
              shadowElevation: shadowElevation,
              borderRadius: 6,
              enableClipping: true,
              padding: padding,
            )
          : Container(padding: padding, child: child),
    );
  }
}

class MyScrollableCardList_Card_Title extends StatelessWidget {
  const MyScrollableCardList_Card_Title({
    super.key,
    required this.titleText,
  });

  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: Row(
        children: [
          Flexible(
            child: MyScrollableCardList_Card_InnerContainer(
              elevation: 2,
              // shadowElevation: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(6, 0, 6, 1),
                child: Text(
                  titleText,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyScrollableCardList_Card_InnerDivider extends StatelessWidget {
  const MyScrollableCardList_Card_InnerDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 8,
      endIndent: 5,
      indent: 5,
    );
  }
}

class MyScrollableCardList_Card_InnerSpacer extends StatelessWidget {
  final double height;
  const MyScrollableCardList_Card_InnerSpacer({super.key}) : height = 8;
  const MyScrollableCardList_Card_InnerSpacer.half({super.key}) : height = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class MyScrollableCardList_Card_InnerContainer_LabelValuePairColumnRenderer
    extends StatelessWidget {
  final List<Pair<String, String>> labelValuePairs;

  const MyScrollableCardList_Card_InnerContainer_LabelValuePairColumnRenderer({
    super.key,
    required this.labelValuePairs,
  });

  @override
  Widget build(BuildContext context) {
    return LabelValuePairsColumnRenderer(
      labelValuePairs: labelValuePairs,
      chessOrderForDarkerRows: false,
      columnCount: 2,
    );
  }
}
