import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogDataProvider.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:structures/structures.dart';

import 'elevation_utils.dart';

PreferredSizeWidget CreateMyAppBar(String titleInAppBar, BuildContext context) {
  return AppBar(
    elevation: 1,
    scrolledUnderElevation: 5,
    shadowColor: Theme.of(context).colorScheme.surface,
    title: Text(
      titleInAppBar,
      style: Theme.of(context).textTheme.headlineMedium,
    ),
  );
}

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
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              columnWithPair.hasLeftNeighbour ? 2 : 0),
                          topLeft: Radius.circular(
                              columnWithPair.hasLeftNeighbour ? 2 : 0),
                          bottomRight: Radius.circular(
                              columnWithPair.hasRightNeighbour ? 2 : 0),
                          topRight: Radius.circular(
                              columnWithPair.hasRightNeighbour ? 2 : 0),
                        ),
                      ),
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
