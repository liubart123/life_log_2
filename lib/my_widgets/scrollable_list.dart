import 'package:flutter/material.dart';
import 'package:life_log_2/my_widgets/elevation_utils.dart';
import 'package:structures/structures.dart';

import 'my_widgets.dart';

class MyScrollableList extends StatelessWidget {
  final int? itemCount;
  final NullableIndexedWidgetBuilder? itemBuilder;
  final Widget? child;

  const MyScrollableList.listView({
    required itemCount,
    required itemBuilder,
  }) : this._(child: null, itemCount: itemCount, itemBuilder: itemBuilder);

  const MyScrollableList.singleChild({
    required child,
  }) : this._(child: child, itemCount: null, itemBuilder: null);

  const MyScrollableList._({
    super.key,
    this.itemCount,
    this.itemBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (itemBuilder != null && itemCount != null)
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child:
            ListView.builder(itemCount: itemCount, itemBuilder: itemBuilder!),
      );
    else
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: child!,
      );
  }
}

class MyScrollableList_Card extends StatelessWidget {
  final Widget child;
  final Function()? onTap;

  final int colorElevationLevel;
  final int shadowElevationLevel;

  const MyScrollableList_Card({
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
        color: GetTintColorForSurface(context, colorElevationLevel),
        child: InkWell(
          onTap: onTap ?? () {},
          child: child,
        ),
      ),
    );
  }
}

class MyScrollableList_Card_InnerContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  final int elevation, shadowElevation;
  final bool useElevation;

  MyScrollableList_Card_InnerContainer({
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
              borderRadius: 4,
              enableClipping: true,
            )
          : Container(padding: padding, child: child),
    );
  }
}

class MyScrollableList_Card_Title extends StatelessWidget {
  const MyScrollableList_Card_Title({
    super.key,
    required this.titleText,
  });

  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Container(
        // color: Colors.red,
        child: Text(
          titleText,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class MyScrollableList_Card_InnerDivider extends StatelessWidget {
  const MyScrollableList_Card_InnerDivider({
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

class MyScrollableList_Card_InnerSpacer extends StatelessWidget {
  final double height;
  const MyScrollableList_Card_InnerSpacer({super.key}) : height = 8;
  const MyScrollableList_Card_InnerSpacer.half({super.key}) : height = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class MyScrollableList_Card_InnerContainer_LabelValuePairColumnRenderer
    extends StatelessWidget {
  final List<Pair<String, String>> labelValuePairs;

  const MyScrollableList_Card_InnerContainer_LabelValuePairColumnRenderer({
    super.key,
    required this.labelValuePairs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LabelValuePairsColumnRenderer(
        labelValuePairs: labelValuePairs,
      ),
    );
  }
}
