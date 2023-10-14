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

class ColumnWithStrippedRows extends StatelessWidget {
  final List<List<String>> rows;
  final Color? lightColor;
  final Color? darkColor;
  final bool? darkerEven;

  const ColumnWithStrippedRows(
      {super.key,
      required this.rows,
      this.lightColor,
      this.darkColor,
      this.darkerEven});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...rows.map((stringsInRow) {
          bool isDarker = rows.indexOf(stringsInRow) % 2 == 0;
          isDarker = darkerEven ?? true ? isDarker : !isDarker;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4,
              ),
              decoration: BoxDecoration(
                color: isDarker
                    ? lightColor ?? Colors.transparent
                    : darkColor ??
                        Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ...stringsInRow.map(
                    (stringForColumn) => Expanded(
                      child: Text(
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: false,
                        stringForColumn,
                        textAlign: stringsInRow.indexOf(stringForColumn) ==
                                stringsInRow.length - 1
                            ? TextAlign.end
                            : TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class MyElevatedContainer extends StatelessWidget {
  final Widget child;
  final int elevation, shadowElevation;
  final Color? tintColor, backgroundColor;
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
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
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

  const LabelValuePairsColumnRenderer({
    super.key,
    required this.labelValuePairs,
    this.colorForDarkerRow,
    this.columnCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...labelValuePairs.map2(
                (kvPair, index) {
                  final bool isDarkerRow = index % 2 == 0;

                  return Container(
                    decoration: BoxDecoration(
                      color: isDarkerRow
                          ? (colorForDarkerRow ??
                              Theme.of(context)
                                  .colorScheme
                                  .shadow
                                  .withOpacity(0.1))
                          : null,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    child: Row(
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
      ],
    );
  }
}
