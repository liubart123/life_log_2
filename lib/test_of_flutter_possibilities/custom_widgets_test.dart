import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/day_log_edit_screen.dart';
import 'package:life_log_2/my_widgets/elevation_utils.dart';
import 'package:life_log_2/my_widgets/scrollable_card_list.dart';
import 'package:structures/structures.dart';

class CustomWidgetsTest extends StatelessWidget {
  const CustomWidgetsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...List.generate(
          2,
          (index) => MyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTitlePrimaryText("23.05.2023"),
                // Gap(12),
                // MyDivider(),
                Gap(16),
                // MyDivider(),
                // SizedBox.square(dimension: 6),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     MyLabelValuePairInColumn(
                //       "Fell Sleep",
                //       "23:12",
                //       textAlign: TextAlign.left,
                //     ),
                //     MyLabelValuePairInColumn(
                //       "Woke Up",
                //       "08:12",
                //       textAlign: TextAlign.center,
                //     ),
                //     MyLabelValuePairInColumn(
                //       "Sleep",
                //       "8:12",
                //       textAlign: TextAlign.right,
                //     ),
                //   ],
                // ),
                // SizedBox.square(dimension: 6),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     MyLabelValuePairInColumn(
                //       "Deep Sleep",
                //       "2:48",
                //       textAlign: TextAlign.left,
                //     ),
                //     MyLabelValuePairInColumn(
                //       "Other Field",
                //       "Maybe long value",
                //       textAlign: TextAlign.center,
                //     ),
                //     MyLabelValuePairInColumn(
                //       "Sleep Score",
                //       "78",
                //       textAlign: TextAlign.right,
                //     ),
                //   ],
                // ),
                // SizedBox.square(dimension: 6),
                // // MyDivider(),
                // SizedBox.square(dimension: 10),
                TagCollection(List.generate(
                    13,
                    (index) => [
                          "Fell asleep: 23:49",
                          "Woke up: 07:42",
                          "Sleep: 8:32",
                          "Deep sleep: 3:48",
                          "Foodie",
                          "Adventure",
                          "Photography",
                          "Wanderlust",
                          "Cats",
                          "Mountains",
                          "BeachLife",
                          "Sustainability",
                          "Exploration",
                        ][index]))
              ],
            ),
          ),
        ),
        ...List.generate(
          2,
          (index) => MyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTitlePrimaryText("23.05.2023"),
                Gap(16),
                RoundTagCollection(List.generate(
                    13,
                    (index) => [
                          "Fell asleep: 23:49",
                          "Woke up: 07:42",
                          "Sleep: 8:32",
                          "Deep sleep: 3:48",
                          "Foodie",
                          "Adventure",
                          "Photography",
                          "Wanderlust",
                          "Cats",
                          "Mountains",
                          "BeachLife",
                          "Sustainability",
                          "Exploration",
                        ][index]))
              ],
            ),
          ),
        ),
        MyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTitlePrimaryText("Title 2"),
              MyDivider(),
              MyBodyPrimaryText(
                "Awesome preety long text for description purposes. Even new sentence is provided to emulate long text description.",
              ),
              MyBodyPrimaryText(
                "Awesome preety long text for description purposes. Even new sentence is provided to emulate long text description.",
              ),
              MyDivider(),
              MyBodyPrimaryText(
                "Awesome preety long text for description purposes. Even new sentence is provided to emulate long text description.",
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              MyDivider(),
              MyBodyPrimaryText(
                "Awesome preety long text for description purposes. Even new sentence is provided to emulate long text description.",
              ),
              MyDivider(),
              MyLabelValuePairInRow("Field1", "Gavno"),
              MyDivider(),
              MyLabelValuePairInRow("Date Field", "23.05.2023"),
              MyDivider(),
              MyLabelValuePairInRow("DateTime Field", "23:12"),
            ],
          ),
        ),
        MyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTitlePrimaryText("23.05.2023"),
              MyDivider(),
              MyLabelValuePairInRow("Field1", "Gavno"),
              MyDivider(),
              MyLabelValuePairInRow("Date Field", "23.05.2023"),
              MyDivider(),
              MyLabelValuePairInRow("DateTime Field", "23:12"),
              // MyDivider(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        MyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTitlePrimaryText("23.05.2023"),
              MyDivider(),
              MyLabelValuePairInRowTight("Field1", "Gavno"),
              MyDivider(),
              MyLabelValuePairInRowTight("Date Field", "23.05.2023"),
              MyDivider(),
              MyLabelValuePairInRowTight("DateTime Field", "23:12"),
              // MyDivider(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyCard extends StatelessWidget {
  final Widget child;

  const MyCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: child,
    );
  }
}

class MyTitlePrimaryText extends StatelessWidget {
  final String title;
  const MyTitlePrimaryText(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class MyBodyPrimaryText extends StatelessWidget {
  final String text;
  const MyBodyPrimaryText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Divider(
        indent: 0,
        height: 4,
      ),
    );
  }
}

class MyLabelValuePairInRow extends StatelessWidget {
  final String label, value;

  const MyLabelValuePairInRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class MyLabelValuePairInRowTight extends StatelessWidget {
  final String label, value;

  const MyLabelValuePairInRowTight(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              label + ": ",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class MyLabelValuePairInColumn extends StatelessWidget {
  final String label, value;
  final TextAlign textAlign;

  const MyLabelValuePairInColumn(
    this.label,
    this.value, {
    super.key,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: textAlign,
              ),
            ),
            Container(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: textAlign,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagCollection extends StatelessWidget {
  final List<String> tagNames;
  const TagCollection(this.tagNames, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 6,
            runSpacing: 6,
            children: [
              ...tagNames.map2(
                (value, index) {
                  IconData? icon = null;
                  if (index == 0)
                    icon = Icons.access_time_outlined;
                  else if (index == 1)
                    icon = Icons.timer_off_outlined;
                  else if (index == 2)
                    icon = Icons.alarm_outlined;
                  else if (index == 3) icon = Icons.alarm_on_outlined;
                  return TextTag(value, icon);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TextTag extends StatelessWidget {
  final IconData? icon;
  final String text;
  const TextTag(this.text, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    double hue = Random().nextInt(360).toDouble();
    Color chipColor = HSLColor.fromAHSL(1, hue, 0.1, 0.90).toColor();
    Color textColor = HSLColor.fromAHSL(1, hue, 0.99, 0.1).toColor();
    return Container(
      padding: EdgeInsets.fromLTRB(icon == null ? 6 : 4, 3, 8, 3),
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
    );
  }
}

class RoundTagCollection extends StatelessWidget {
  final List<String> tagNames;
  const RoundTagCollection(this.tagNames, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 6,
            runSpacing: 6,
            children: [
              ...tagNames.map2(
                (value, index) {
                  IconData? icon = null;
                  if (index == 0)
                    icon = Icons.access_time_outlined;
                  else if (index == 1)
                    icon = Icons.timer_off_outlined;
                  else if (index == 2)
                    icon = Icons.alarm_outlined;
                  else if (index == 3) icon = Icons.alarm_on_outlined;
                  return RoundTextTag(value, icon);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RoundTextTag extends StatelessWidget {
  final IconData? icon;
  final String text;
  const RoundTextTag(this.text, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    double hue = Random().nextInt(360).toDouble();
    Color chipColor = HSLColor.fromAHSL(1, hue, 0.1, 0.90).toColor();
    Color textColor = HSLColor.fromAHSL(1, hue, 0.99, 0.1).toColor();
    return Container(
      padding: EdgeInsets.fromLTRB(icon == null ? 10 : 4, 3, 12, 3),
      decoration: BoxDecoration(
        color: chipColor,
        // color: GetTintColor(2, Theme.of(context).colorScheme.surface,
        //     Theme.of(context).colorScheme.surfaceTint),
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(
        //   width: 1,
        //   color: Theme.of(context).colorScheme.outline,
        // ),
      ),
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
                    // fontSize: 18,
                    fontWeight:
                        icon == null ? FontWeight.w500 : FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
