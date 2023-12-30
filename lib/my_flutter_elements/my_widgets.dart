// ignore_for_file: unnecessary_import, inference_failure_on_function_return_type

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/my_flutter_elements/my_constants.dart';

/// Creates AppBar that is intended to be used for screens in application
PreferredSizeWidget myAppBarWithTitle(String titleInAppBar) {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 1,
    shadowColor: Get.theme.colorScheme.surface,
    title: Text(
      titleInAppBar,
      style: Get.theme.textTheme.titleLarge,
    ),
  );
}

/// Scrollable list with handlers for scrolling to the bottom
/// and 'reload' gesture.
///
/// Can be used for dispalying large list of large cards
class MyScrollableList extends StatefulWidget  {
  const MyScrollableList({
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.reloadCallback,
    this.bottomScrolledCallback,
    super.key,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final Future<void> Function()? reloadCallback;
  final Function()? bottomScrolledCallback;

  @override
  State<MyScrollableList> createState() => _MyScrollableListState();
}

class _MyScrollableListState extends State<MyScrollableList> with AutomaticKeepAliveClientMixin  {
  late final ScrollController _scrollController;
  late bool bottomWasScrolled;

  @override
  void initState() {
    _scrollController = ScrollController();
    if (widget.bottomScrolledCallback != null) {
      _scrollController.addListener(handleScrolling);
    }
    bottomWasScrolled = false;
    super.initState();
  }

  void handleScrolling() {
    if (_scrollController.position.extentAfter < 10) {
      if (!bottomWasScrolled) widget.bottomScrolledCallback!();
      bottomWasScrolled = true;
    } else if (_scrollController.position.extentAfter > 300) {
      bottomWasScrolled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.surface,
      child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: widget.reloadCallback ?? () async {},
        child: ListView.separated(
          controller: _scrollController,
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
          separatorBuilder: widget.separatorBuilder,
          padding: EdgeInsets.all(SMALL_CARD_MARGIN),
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

/// Card that is ususally used in application
class MySmallCard extends StatelessWidget {
  const MySmallCard({
    required this.child,
    required this.color,
    super.key,
    this.onTap,
  });

  final Widget child;
  final Color color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final hslColor = HSLColor.fromColor(color);
    final splashColor = hslColor.withLightness(hslColor.lightness - 0.2).toColor();
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.shadow.withOpacity(0.1),
            offset: const Offset(1, 2),
            spreadRadius: 0,
            blurRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: color,
        child: InkWell(
          splashColor: splashColor,
          borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
          onTap: onTap ?? () {},
          child: Container(
            padding: const EdgeInsets.all(SMALL_CARD_PADDING),
            child: child,
          ),
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
                style: Get.theme.textTheme.bodyMedium!.copyWith(
                  color: textColor,
                  fontWeight: icon == null ? FontWeight.w500 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicator of processing. Is used to show user that something is in process.
class MyProcessIndicator extends StatelessWidget {
  const MyProcessIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeAlign: BorderSide.strokeAlignInside,
      strokeWidth: 4,
      strokeCap: StrokeCap.square,
      color: Get.theme.colorScheme.primary,
    );
  }
}

/// Displays multiple of FABs. Should be used inside [Scaffold]
class MyFABCollection extends StatelessWidget {
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
  const MyFloatingButton({
    required this.onPressed,
    super.key,
    this.child,
  }) : iconData = null;
  const MyFloatingButton.withIcon({
    required this.iconData,
    required this.onPressed,
    super.key,
  }) : child = null;
  final Function() onPressed;
  final IconData? iconData;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //todo: enable feedback
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Get.theme.colorScheme.surfaceVariant,
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

/// Widget to display error's message.
/// Wrapped in red colored card.
class MyErrorMessage extends StatelessWidget {
  const MyErrorMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        color: Get.theme.colorScheme.errorContainer,
        border: Border.all(
          width: 1,
          color: Get.theme.colorScheme.onErrorContainer.withOpacity(0.4),
        ),
      ),
      padding: EdgeInsets.all(SMALL_CARD_PADDING),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Get.theme.colorScheme.onErrorContainer,
            size: 35,
          ),
          const Gap(2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.labelLarge!.copyWith(
              color: Get.theme.colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }
}
