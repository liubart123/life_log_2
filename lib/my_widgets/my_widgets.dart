import 'dart:math';

import 'package:flutter/material.dart';
import 'package:life_log_2/my_widgets/elevation_utils.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:structures/structures.dart';

import 'my_old_widgets.dart';

class MyScrollableList extends StatefulWidget {
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final Future Function() reloadCallback;
  final Function() bottomScrolledCallback;

  MyScrollableList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.reloadCallback,
    required this.bottomScrolledCallback,
  });

  @override
  State<MyScrollableList> createState() => _MyScrollableListState();
}

class _MyScrollableListState extends State<MyScrollableList> {
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
    if (_scrollController.position.extentAfter < 10) {
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
        child: ListView.separated(
          controller: _scrollController,
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
          separatorBuilder: widget.separatorBuilder,
          padding: EdgeInsets.all(CARD_MARGIN),
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final Widget child;
  final Function()? onTap;

  const MyCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // splashColor: Theme.of(context).colorScheme.primary,
        onTap: onTap ?? () {},
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.primaryContainer,
            // color: GetTintColor(
            //   1,
            //   Theme.of(context).colorScheme.surface,
            //   Theme.of(context).colorScheme.surfaceTint,
            // ),
            // boxShadow: [GetElevatedBoxShadow(context, 1)],
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(CARD_PADDING),
          child: child,
        ),
      ),
    );
  }
}

class MyChip extends StatelessWidget {
  final IconData? icon;
  final String text;
  const MyChip(
    this.text, {
    super.key,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double hue = Random().nextInt(360).toDouble();
    Color chipColor = HSLColor.fromAHSL(1, hue, 0.3, 0.9).toColor();
    Color textColor = HSLColor.fromAHSL(1, hue, 1, 0.15).toColor();
    return Ink(
      decoration: BoxDecoration(
        color: chipColor,
        // color: GetTintColor(2, Theme.of(context).colorScheme.surface,
        //     Theme.of(context).colorScheme.surfaceTint),
        borderRadius: BorderRadius.circular(6),
        // border: Border.all(
        //   width: 1,
        //   color: Theme.of(context).colorScheme.outline,
        // ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(icon == null ? 6 : 4, 3, 8, 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Container(
                child: Icon(
                  icon,
                  size: 20,
                ),
              ),
            Container(
              margin: EdgeInsets.only(left: 2),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: textColor,
                      // color: Theme.of(context).colorScheme.surfaceTint,
                      // fontSize: 14,
                      fontWeight:
                          icon == null ? FontWeight.w500 : FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyLoadingIndicator extends StatelessWidget {
  const MyLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeAlign: BorderSide.strokeAlignInside,
      strokeWidth: 4,
      strokeCap: StrokeCap.square,
      color: Theme.of(context).colorScheme.primary,
      // color: Color.lerp(
      //   Theme.of(context).colorScheme.surface,
      //   Theme.of(context).colorScheme.surfaceTint,
      //   0.8,
      // ),
      // backgroundColor: Color.lerp(
      //   Theme.of(context).colorScheme.surface,
      //   Theme.of(context).colorScheme.surfaceTint,
      //   0.1,
      // ),
    );
  }
}
