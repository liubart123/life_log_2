import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_data_provider.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/utils/StringFormatters.dart';
import 'package:structures/structures.dart';

import 'elevation_utils.dart';

class MyRepositoryProviders extends StatelessWidget {
  final Widget child;
  const MyRepositoryProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DayLogDataProvider>(
          create: (context) => DayLogDataProvider(),
        ),
        RepositoryProvider<DayLogRepository>(
          create: (context) =>
              DayLogRepository(context.read<DayLogDataProvider>()),
        ),
      ],
      child: child,
    );
  }
}

class MyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final Function()? onTap;
  final Color? baseColorForElevation, tintColorForElevation;

  final int colorElevationLevel;
  final int shadowElevationLevel;

  final bool clickable;
  final double borderRadius;

  const MyCard({
    super.key,
    required this.child,
    this.onTap,
    this.colorElevationLevel = 1,
    this.shadowElevationLevel = 1,
    this.baseColorForElevation,
    this.tintColorForElevation,
    this.clickable = false,
    this.borderRadius = 10,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [GetElevatedBoxShadow(context, shadowElevationLevel)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: GetTintColor(
          colorElevationLevel,
          baseColorForElevation ?? Theme.of(context).colorScheme.surface,
          tintColorForElevation ?? Theme.of(context).colorScheme.surfaceTint,
        ),
        child: clickable
            ? InkWell(
                onTap: onTap ?? () {},
                child: child,
              )
            : child,
      ),
    );
  }
}

class TextWithChip extends StatelessWidget {
  final double chipRadius;
  final double chipHorizontalPadding;
  final String text;
  final TextStyle? textStyle;
  final Color? chipColor;

  const TextWithChip({
    Key? key,
    required this.text,
    this.chipColor,
    this.textStyle,
    this.chipRadius = 5,
    this.chipHorizontalPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: chipColor ?? Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(chipRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: chipHorizontalPadding,
        vertical: 0,
      ),
      child: Text(
        text,
        style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class MyElevatedContainer extends StatelessWidget {
  final Widget child;
  final int elevation, shadowElevation;
  final Color? tintColor, backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final bool enableClipping;

  const MyElevatedContainer({
    required this.child,
    super.key,
    required this.elevation,
    required this.shadowElevation,
    required this.borderRadius,
    this.tintColor,
    this.backgroundColor,
    this.enableClipping = false,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: padding,
      decoration: BoxDecoration(
        color: GetTintColor(
          elevation,
          backgroundColor ?? Theme.of(context).colorScheme.surface,
          tintColor ?? Theme.of(context).colorScheme.surfaceTint,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [GetElevatedBoxShadow(context, shadowElevation)],
      ),
      child: enableClipping
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: child,
            )
          : child,
    );
  }
}

class LabelValuePairsColumnRenderer extends StatelessWidget {
  final List<Pair<String, String>> labelValuePairs;
  final Color? colorForDarkerRow;
  final int columnCount;
  final bool chessOrderForDarkerRows;

  const LabelValuePairsColumnRenderer({
    super.key,
    required this.labelValuePairs,
    this.colorForDarkerRow,
    this.columnCount = 2,
    this.chessOrderForDarkerRows = true,
  });

  @override
  Widget build(BuildContext context) {
    var columnsWithPairs = GenerateColumnsWithLabelValuePairs();
    Color usedColorForDarkerRow = colorForDarkerRow ??
        Theme.of(context).colorScheme.shadow.withOpacity(0.1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...columnsWithPairs.map2(
          (columnWithPair, columnIndex) => Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...columnWithPair.pairs.map2(
                  (kvPair, index) {
                    final bool isDarkerRow = index % 2 ==
                        (chessOrderForDarkerRows ? columnIndex % 2 : 0);

                    return Container(
                      decoration: BoxDecoration(
                          color: isDarkerRow ? usedColorForDarkerRow : null,
                          borderRadius: BorderRadius.circular(2)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      margin: EdgeInsets.fromLTRB(
                          columnWithPair.hasLeftNeighbour ? 2 : 0,
                          0,
                          columnWithPair.hasRightNeighbour ? 2 : 0,
                          0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.left,
                              kvPair.first,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                              kvPair.second,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<
      ({
        bool hasLeftNeighbour,
        bool hasRightNeighbour,
        List<Pair<String, String>> pairs,
      })> GenerateColumnsWithLabelValuePairs() {
    List<
        ({
          bool hasLeftNeighbour,
          bool hasRightNeighbour,
          List<Pair<String, String>> pairs,
        })> pairsForColumns = List.generate(
      columnCount,
      (index) => (
        hasLeftNeighbour: index != 0,
        hasRightNeighbour: index != columnCount - 1,
        pairs: List.empty(growable: true),
      ),
    );

    int currentColumnIndex = 0;
    for (var pair in labelValuePairs) {
      pairsForColumns[currentColumnIndex++ % columnCount].pairs.add(pair);
    }

    return pairsForColumns;
  }
}

class CardWithErrorMessage extends StatelessWidget {
  final String erorrMessage;

  const CardWithErrorMessage({
    super.key,
    required this.erorrMessage,
  });

  @override
  Widget build(BuildContext context) {
    return MyElevatedContainer(
      elevation: 0,
      shadowElevation: 1,
      borderRadius: 6,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
          erorrMessage,
        ),
      ),
    );
  }
}

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeAlign: BorderSide.strokeAlignInside,
      strokeWidth: 6,
      strokeCap: StrokeCap.round,
      color: Color.lerp(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        0.8,
      ),
      backgroundColor: Color.lerp(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        0.1,
      ),
    );
  }
}

class MyFloatingButton extends StatelessWidget {
  final Function() onPressed;
  final IconData iconData;
  const MyFloatingButton({
    super.key,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //todo: enable feedback
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // extendedIconLabelSpacing: 0,
      // extendedTextStyle: Theme.of(context).textTheme.labelLarge,
      onPressed: onPressed,
      elevation: 5,
      // label: const Text('Save'),
      // icon: const Icon(Icons.save),
      child: Icon(
        iconData,
        size: 30,
      ),
    );
  }
}

class MyColumnOfFloatingWidgets extends StatelessWidget {
  final List<Widget> FABs;

  const MyColumnOfFloatingWidgets({
    super.key,
    required this.FABs,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> resultedChildren = new List.empty(growable: true);
    for (int i = 0; i < FABs.length; i++) {
      resultedChildren.add(FABs[i]);
      if (i != FABs.length - 1)
        resultedChildren.add(
          const SizedBox.square(
            dimension: 12,
          ),
        );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: resultedChildren,
      ),
    );
  }
}

class MyDatePicker extends StatelessWidget {
  final String fieldNameToDisplay;
  final DateTime fieldValueToDisplay;
  final Function(DateTime newValue) actiononDatePick;

  const MyDatePicker({
    Key? key,
    required this.fieldNameToDisplay,
    required this.fieldValueToDisplay,
    required this.actiononDatePick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$fieldNameToDisplay:",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          SizedBox.square(
            dimension: 4,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
            child: GestureDetector(
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: fieldValueToDisplay,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (newDate != null) actiononDatePick(newDate);
              },
              child: Text(
                formatDate(fieldValueToDisplay),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        ],
      ),
    );
  }
}
