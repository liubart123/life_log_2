import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/day_log_edit_screen.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository_provider.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/my_widgets/scrollable_card_list.dart';
import 'package:structures/structures.dart';

import '../DayLogRepository.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

import '../DayLogModel.dart';
import 'bloc/day_log_bloc.dart';

class DayLogViewList extends StatelessWidget {
  const DayLogViewList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DayLogRepositoryProvider(
      child: BlocProvider(
        create: (context) =>
            DayLogViewListBloc(context.read<DayLogRepository>())
              ..add(LoadInitialPageOfDayLogs()),
        child: BlocBuilder<DayLogViewListBloc, DayLogViewListBlocState>(
          builder: (context, state) {
            if (state is LoadingPageOfDayLogs && state.dayLogList.isEmpty)
              return InitialLoadingDisplayWidget();
            else
              return MyScrollableList(
                reloadCallback: () async {
                  var bloc = context.read<DayLogViewListBloc>();
                  bloc.add(RefreshInitialPageOfDayLogs());
                  await bloc.stream.firstWhere((state) => state is IdleState);
                },
                bottomScrolledCallback: () {
                  context
                      .read<DayLogViewListBloc>()
                      .add(LoadNextPageOfDayLogs());
                },
                itemCount: state.dayLogList.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.dayLogList.length) {
                    return DayLogCard(dayLogToBuild: state.dayLogList[index]);
                  } else {
                    return BottomElementsForDayLogList(state: state);
                  }
                },
                separatorBuilder: (context, index) {
                  return Gap(CARD_MARGIN);
                },
              );
          },
        ),
      ),
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
    return MyCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return DayLogEditScreen(
              dayLogId: dayLogToBuild.id,
            );
          }),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate(dayLogToBuild.date),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Gap(INNER_CARD_GAP_MEDIUM),
          DayLogFieldsAndTagsRenderer(dayLog: dayLogToBuild),
        ],
      ),
    );
  }
}

class DayLogFieldsAndTagsRenderer extends StatelessWidget {
  final DayLog dayLog;
  const DayLogFieldsAndTagsRenderer({
    super.key,
    required this.dayLog,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: ELEMENT_DISTANCE,
            runSpacing: ELEMENT_DISTANCE,
            children: [
              MyChip(
                "Sleep start: ${formatTime(dayLog.sleepStartTime)}",
                icon: SLEEP_START,
              ),
              MyChip(
                "Sleep end: ${formatTime(dayLog.sleepEndTime)}",
                icon: SLEEP_END,
              ),
              MyChip(
                "Sleep: ${formatDuration(dayLog.sleepDuration)}",
                icon: SLEEP_DURATION,
              ),
              MyChip(
                "Deep sleep: ${formatDuration(dayLog.deepSleepDuration)}",
                icon: DEEP_SLEEP_DURATION,
              ),
              ...dayLog.tags.map2(
                (value, index) {
                  return MyChip(value);
                },
              ),
            ],
          ),
        ),
      ],
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
        // const MyProgressIndicator(),
        if (state is LoadingPageOfDayLogs)
          Container(
              margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
              child: const MyLoadingIndicator()),
        if (state is ErrorWithLoadingPageOfDayLogs)
          Text(
            "Error: ${(state as ErrorWithLoadingPageOfDayLogs).errorMessage ?? "unknown..."}",
          ),
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
    return Center(
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
          child: const MyLoadingIndicator()),
    );
  }
}
