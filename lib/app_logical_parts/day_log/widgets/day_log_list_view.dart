import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/day_log_bloc.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

import '../DayLogModel.dart';

class DayLogListView extends StatelessWidget {
  const DayLogListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DayLogBloc, DayLogBlocState>(
      builder: (context, state) {
        if (state is LoadingPageOfDayLogs && state.dayLogList.isEmpty) {
          return const Center(
            child: Text("Initial loading..."),
          );
        }
        return Container(
          padding: EdgeInsets.all(8),
          // color: Colors.red,
          child: ListView.builder(
              itemCount: state.dayLogList.length + 1,
              itemBuilder: (context, index) {
                if (index < state.dayLogList.length) {
                  DayLog dayLogToBuild = state.dayLogList[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                          //const EdgeInsets.all(0),
                          //const EdgeInsets.all(10),
                          // color: Theme.of(context).colorScheme.secondary,
                          child: Text(
                            formatDate(dayLogToBuild.date),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Divider(
                          endIndent: 5,
                          indent: 5,
                        ),
                        DayLogFieldsRenderer(
                          dayLog: dayLogToBuild,
                        ),
                        Divider(
                          endIndent: 5,
                          indent: 5,
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 40),
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 6),
                          // color: Colors.red,
                          child: Container(
                            // color: Colors.red.shade100,
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              alignment: WrapAlignment.start,
                              children: dayLogToBuild.tags
                                  .map(
                                    (e) => TextWithChip(
                                      text: e,
                                      chipColor: Colors.primaries[Random()
                                          .nextInt(Colors.primaries.length)],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      // Divider(),
                      if (state is LoadingPageOfDayLogs)
                        const Text("Loading..."),
                      if (state is ErrorWithLoadingPageOfDayLogs)
                        Text(
                            "Error: ${(state as ErrorWithLoadingPageOfDayLogs).errorMessage ?? "unknown..."}"),
                      ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<DayLogBloc>()
                                .add(LoadNextPageOfDayLogs());
                          },
                          icon: const Icon(Icons.arrow_circle_down),
                          label: const Text("More")),
                      ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<DayLogBloc>()
                                .add(LoadInitialPageOfDayLogs());
                          },
                          icon: const Icon(Icons.replay_outlined),
                          label: const Text("Reload")),
                    ],
                  );
                }
              }),
        );
      },
    );
  }
}

class DayLogFieldsRenderer extends StatelessWidget {
  final DayLog dayLog;
  const DayLogFieldsRenderer({
    super.key,
    required this.dayLog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          minHeight: 30,
          // maxHeight: 170,
        ),
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        // alignment: Alignment.topLeft,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StrippedColumn(
                rows: [
                  ["Fall asleep", formatTime(dayLog.sleepStartTime)],
                  ["Wake up", formatTime(dayLog.sleepEndTime)],
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              flex: 0,
              child: SizedBox.square(
                dimension: 10,
              ),
            ),
            Expanded(
              child: StrippedColumn(
                darkerEven: false,
                rows: [
                  ["Sleep", formatDuration(dayLog.deepSleepDuration)],
                  ["Deep sleep", formatDuration(dayLog.deepSleepDuration)],
                ],
              ),
            ),
          ],
        ));
  }
}

class StrippedColumn extends StatelessWidget {
  final List<List<String>> rows;
  final Color? lightColor;
  final Color? darkColor;
  final bool? darkerEven;

  const StrippedColumn(
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
                            .withOpacity(0.5),
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
