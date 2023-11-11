// ignore_for_file: unnecessary_import, inference_failure_on_function_return_type

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';

/// Creates AppBar that is intended to be used for screens in application
PreferredSizeWidget createMyAppBar(String titleInAppBar, BuildContext context) {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 1,
    shadowColor: Theme.of(context).colorScheme.surface,
    title: Text(
      titleInAppBar,
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}

/// Scrollable list with handlers for scrolling to the bottom
/// and 'reload' gesture.
///
/// Can be used for dispalying large list of large cards
class MyScrollableList extends StatefulWidget {
  // ignore: public_member_api_docs
  const MyScrollableList({
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.reloadCallback,
    required this.bottomScrolledCallback,
    super.key,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final Future<void> Function() reloadCallback;
  final Function() bottomScrolledCallback;

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

/// Card that is ususally used in application
class MyCard extends StatelessWidget {
  // ignore: public_member_api_docs
  const MyCard({
    required this.child,
    super.key,
    this.onTap,
  });

  final Widget child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () {},
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              // ignore: avoid_redundant_argument_values
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

/// Text enclosed into small colored container.
///
/// Can be used as tag, filter indicator.
/// Can have icon before text.
class MyChip extends StatelessWidget {
  // ignore: public_member_api_docs
  const MyChip(
    this.text, {
    super.key,
    this.icon,
  });
  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final hue = Random().nextInt(360).toDouble();
    final chipColor = HSLColor.fromAHSL(1, hue, 0.3, 0.9).toColor();
    final textColor = HSLColor.fromAHSL(1, hue, 1, 0.15).toColor();
    return Ink(
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(icon == null ? 6 : 4, 3, 8, 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20,
              ),
            Container(
              margin: const EdgeInsets.only(left: 2),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: textColor,
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

/// Indicator of processing
class MyProcessIndicator extends StatelessWidget {
  // ignore: public_member_api_docs
  const MyProcessIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeAlign: BorderSide.strokeAlignInside,
      // ignore: avoid_redundant_argument_values
      strokeWidth: 4,
      strokeCap: StrokeCap.square,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

/// Displays multiple of FABs. Should be used inside [Scaffold]
class MyFABCollection extends StatelessWidget {
  // ignore: public_member_api_docs
  const MyFABCollection({
    required this.fabs,
    super.key,
  });
  final List<Widget> fabs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...fabs
            .expand(
              (e) => [
                const Gap(16),
                Container(
                  child: e,
                ),
              ],
            )
            .skip(1),
      ],
    );
  }
}

/// Floating button, ususally used in application.
///
/// Additionaly can have an icon.
class MyFloatingButton extends StatelessWidget {
  // ignore: public_member_api_docs
  const MyFloatingButton.withIcon({
    required this.iconData,
    required this.onPressed,
    super.key,
  }) : child = null;
  // ignore: public_member_api_docs
  const MyFloatingButton({
    required this.onPressed,
    super.key,
    this.child,
  }) : iconData = null;
  final Function() onPressed;
  final IconData? iconData;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //todo: enable feedback
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      onPressed: onPressed,
      elevation: 2,
      child: child ??
          Icon(
            iconData,
            size: 30,
          ),
    );
  }
}
