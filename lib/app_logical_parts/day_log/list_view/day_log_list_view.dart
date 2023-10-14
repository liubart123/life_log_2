import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/my_widgets/scrollable_list.dart';
import 'package:structures/structures.dart';

import '../DayLogRepository.dart';
import '../SingleDayLogEditScreen/SingleDayLogEditScreen.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

import '../DayLogModel.dart';
import 'bloc/day_log_bloc.dart';

class DayLogViewList extends StatelessWidget {
  const DayLogViewList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DayLogViewListBloc(context.read<DayLogRepository>())
        ..add(LoadInitialPageOfDayLogs()),
      child: DayLogViewListBlockBuilder(),
    );
  }

  BlocBuilder<DayLogViewListBloc, DayLogViewListBlocState>
      DayLogViewListBlockBuilder() {
    return BlocBuilder<DayLogViewListBloc, DayLogViewListBlocState>(
      builder: (context, state) {
        if (state is LoadingPageOfDayLogs && state.dayLogList.isEmpty)
          return InitialLoadingDisplayWidget();
        else
          // return MyScrollableList.singleChild(
          //   child: ListView.builder(
          //     itemCount: state.dayLogList.length + 1,
          //     itemBuilder: (context, index) {
          //       if (index < state.dayLogList.length) {
          //         return DayLogCard(dayLogToBuild: state.dayLogList[index]);
          //       } else {
          //         return BottomElementsForDayLogList(state: state);
          //       }
          //     },
          //   ),
          // );
          return MyScrollableList.listView(
            itemCount: state.dayLogList.length + 1,
            itemBuilder: (context, index) {
              if (index < state.dayLogList.length) {
                return DayLogCard(dayLogToBuild: state.dayLogList[index]);
              } else {
                return BottomElementsForDayLogList(state: state);
              }
            },
          );
      },
    );
  }
}

class DayLogCard extends StatelessWidget {
  const DayLogCard({
    super.key,
    required this.dayLogToBuild,
  });

  final DayLog dayLogToBuild;

  @override
  Widget build(BuildContext context) {
    return MyScrollableList_Card(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) {
        //     return SingleDayLogEditScreen(
        //       dayLogId: dayLogToBuild.id,
        //     );
        //   }),
        // );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyScrollableList_Card_Title(
              titleText: formatDate(dayLogToBuild.date)),
          MyScrollableList_Card_InnerDivider(),
          DayLogFieldsRenderer(dayLog: dayLogToBuild),
          MyScrollableList_Card_InnerSpacer(),
          MyScrollableList_Card_InnerContainer(
            child:
                MyScrollableList_Card_InnerContainer_LabelValuePairColumnRenderer(
              labelValuePairs: [
                Pair("Fall asleep", formatTime(dayLogToBuild.sleepStartTime)),
                Pair("Wake up", formatTime(dayLogToBuild.sleepEndTime)),
                Pair("Sleep", formatDuration(dayLogToBuild.deepSleepDuration)),
                Pair(
                  "Deep sleep",
                  formatDuration(dayLogToBuild.deepSleepDuration),
                ),
                ...List.generate(5, (index) => Pair("Guvno$index", "cal")),
              ],
            ),
          ),
          MyScrollableList_Card_InnerDivider(),
          DayLogTagsRenderer(dayLogToBuild: dayLogToBuild),
          MyScrollableList_Card_InnerSpacer.half(),
        ],
      ),
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
    return MyScrollableList_Card_InnerContainer(
      shadowElevation: 1,
      elevation: 1,
      child: MyScrollableList_Card_InnerContainer_LabelValuePairColumnRenderer(
        labelValuePairs: [
          Pair("Fall asleep", formatTime(dayLog.sleepStartTime)),
          Pair("Wake up", formatTime(dayLog.sleepEndTime)),
          Pair("Sleep", formatDuration(dayLog.deepSleepDuration)),
          Pair("Deep sleep", formatDuration(dayLog.deepSleepDuration)),
        ],
      ),
      // child: Row(
      //   mainAxisSize: MainAxisSize.max,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Expanded(
      //       child: ColumnWithStrippedRows(
      //         rows: [
      //           ["Fall asleep", formatTime(dayLog.sleepStartTime)],
      //           ["Wake up", formatTime(dayLog.sleepEndTime)],
      //         ],
      //       ),
      //     ),
      //     SizedBox(width: 10),
      //     Expanded(
      //       child: ColumnWithStrippedRows(
      //         darkerEven: false,
      //         rows: [
      //           ["Sleep", formatDuration(dayLog.deepSleepDuration)],
      //           ["Deep sleep", formatDuration(dayLog.deepSleepDuration)],
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class DayLogTagsRenderer extends StatelessWidget {
  const DayLogTagsRenderer({
    super.key,
    required this.dayLogToBuild,
  });

  final DayLog dayLogToBuild;

  @override
  Widget build(BuildContext context) {
    return MyScrollableList_Card_InnerContainer(
      useElevation: false,
      child: Container(
        // padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.start,
          children: dayLogToBuild.tags
              .map(
                (e) => TextWithChip(
                  text: e,
                  chipColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class BottomElementsForDayLogList extends StatelessWidget {
  const BottomElementsForDayLogList({
    super.key,
    required this.state,
  });

  final DayLogViewListBlocState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state is LoadingPageOfDayLogs) const Text("Loading..."),
        if (state is ErrorWithLoadingPageOfDayLogs)
          Text(
            "Error: ${(state as ErrorWithLoadingPageOfDayLogs).errorMessage ?? "unknown..."}",
          ),
        ElevatedButton.icon(
            onPressed: () {
              context.read<DayLogViewListBloc>().add(LoadNextPageOfDayLogs());
            },
            icon: const Icon(Icons.arrow_circle_down),
            label: const Text("More")),
        ElevatedButton.icon(
            onPressed: () {
              context
                  .read<DayLogViewListBloc>()
                  .add(LoadInitialPageOfDayLogs());
            },
            icon: const Icon(Icons.replay_outlined),
            label: const Text("Reload")),
      ],
    );
  }
}

class InitialLoadingDisplayWidget extends StatelessWidget {
  const InitialLoadingDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Initial loading..."),
    );
  }
}
