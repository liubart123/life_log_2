import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/day_log_edit_screen.dart';
import 'package:life_log_2/app_logical_parts/day_log/list_view/bloc/day_log_bloc.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/StringFormatters.dart';
import 'package:loggy/loggy.dart';
import 'package:structures/structures.dart';

///Displays a readonly list of detailed cards with DayLog information.
///
///Gets data in form of pages from server.
///Refreshes the list on user's gesture.
///Loads new page of data on scrolling to the list bottom.
class DayLogListTab extends StatelessWidget {
  // ignore: public_member_api_docs
  const DayLogListTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DayLogRepositoryProvider(
      child: BlocProvider(
        create: (context) => DayLogListTabBloc(context.read<DayLogRepository>())
          ..add(LoadInitialPageOfDayLogs()),
        child: BlocBuilder<DayLogListTabBloc, DayLogListTabBlocState>(
          builder: (context, state) {
            logDebug('DayLogListTab build: $state');
            if (state is LoadingPageOfDayLogs && state.dayLogList.isEmpty) {
              return const _ProcessIndicatorForInitialLoadingOfDayLogs();
            } else {
              return _DayLogScrollableListBuilder(state);
            }
          },
        ),
      ),
    );
  }
}

class _DayLogScrollableListBuilder extends StatelessWidget {
  const _DayLogScrollableListBuilder(this.state);

  final DayLogListTabBlocState state;

  @override
  Widget build(BuildContext context) {
    return MyScrollableList(
      reloadCallback: () async {
        final bloc = context.read<DayLogListTabBloc>()
          ..add(ResetDayLogListWithRefreshedInitialPage());

        //waiting when initial page is loaded, so state is Idle
        await bloc.stream.firstWhere((state) => state is IdleState);
      },
      bottomScrolledCallback: () {
        context.read<DayLogListTabBloc>().add(LoadNextPageOfDayLogs());
      },
      itemCount: state.dayLogList.length + 1,
      itemBuilder: (context, index) {
        if (index < state.dayLogList.length) {
          return _DayLogCardBuilder(dayLogToBuild: state.dayLogList[index]);
        } else {
          return _BottomUtilElementOfScrollableList(state: state);
        }
      },
      separatorBuilder: (context, index) {
        return Gap(CARD_MARGIN);
      },
    );
  }
}

class _DayLogCardBuilder extends StatelessWidget {
  const _DayLogCardBuilder({
    required this.dayLogToBuild,
  });

  final DayLog dayLogToBuild;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      onTap: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute(builder: (context) {
            return DayLogEditPage(
              dayLogId: dayLogToBuild.id!,
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
          _DayLogFieldsAndTagsRenderer(dayLog: dayLogToBuild),
        ],
      ),
    );
  }
}

class _DayLogFieldsAndTagsRenderer extends StatelessWidget {
  const _DayLogFieldsAndTagsRenderer({
    required this.dayLog,
  });

  final DayLog dayLog;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: MEDIUM_ELEMENT_MARGIN * 2,
            runSpacing: MEDIUM_ELEMENT_MARGIN * 2,
            children: [
              //Primary fields of DayLog
              MyChip(
                'Sleep start: ${formatTime(dayLog.sleepStartTime)}',
                icon: ICON_SLEEP_START,
              ),
              MyChip(
                'Sleep end: ${formatTime(dayLog.sleepEndTime)}',
                icon: ICON_SLEEP_END,
              ),
              MyChip(
                'Sleep: ${formatDuration(dayLog.sleepDuration)}',
                icon: ICON_SLEEP_DURATION,
              ),
              MyChip(
                'Deep sleep: ${formatDuration(dayLog.deepSleepDuration)}',
                icon: ICON_DEEP_SLEEP_DURATION,
              ),

              //Tags from DayLog
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

class _BottomUtilElementOfScrollableList extends StatelessWidget {
  const _BottomUtilElementOfScrollableList({
    required this.state,
  });

  final DayLogListTabBlocState state;

  @override
  Widget build(BuildContext context) {
    final shownErrorMessage = state is ErrorWithLoadingPageOfDayLogs
        ? (state as ErrorWithLoadingPageOfDayLogs).errorMessage ?? 'unknown...'
        : null;
    return Column(
      children: [
        if (state is LoadingPageOfDayLogs)
          Container(
            margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
            child: const MyProcessIndicator(),
          ),
        if (shownErrorMessage != null)
          Text(
            'Error: $shownErrorMessage',
          ),
      ],
    );
  }
}

class _ProcessIndicatorForInitialLoadingOfDayLogs extends StatelessWidget {
  const _ProcessIndicatorForInitialLoadingOfDayLogs();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: const MyProcessIndicator(),
      ),
    );
  }
}
