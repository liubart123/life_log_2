import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/day_log_edit_screen.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_list_tab/day_log_list_tab_controller.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/StringFormatters.dart';
import 'package:life_log_2/utils/controller_status.dart';
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
    return GetBuilder<DayLogListTabController>(
      init: DayLogListTabController(),
      builder: (controller) {
        logDebug('DayLogListTab.tab controller build: ${controller.status}');
        if (controller.status == EControllerStatus.initializing) {
          return const _ProcessIndicatorForInitialLoadingOfDayLogs();
        }
        if (controller.status == EControllerStatus.majorError) {
          return Padding(
            padding: EdgeInsets.all(CARD_MARGIN),
            child: Center(
              child: MajorErrorMessage(controller.errorMessage!),
            ),
          );
        } else {
          return const _DayLogScrollableListBuilder();
        }
      },
    );
  }
}

class _DayLogScrollableListBuilder extends StatelessWidget {
  const _DayLogScrollableListBuilder();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DayLogListTabController>(
      builder: (controller) {
        logDebug(
          'DayLogListTab.tab.list controller build: ${controller.status}',
        );
        return MyScrollableList(
          reloadCallback: () async {
            //waiting when initial page is loaded, so state is Idle
            await controller.resetDayLogListWithInitialPage();
          },
          bottomScrolledCallback: () {
            logDebug('Bottom scrolled');
            controller.loadNextPage();
          },
          itemCount: controller.dayLogList.length + 1,
          itemBuilder: (context, index) {
            if (index < controller.dayLogList.length) {
              return _DayLogCardBuilder(
                dayLogToBuild: controller.dayLogList[index],
              );
            } else {
              return _BottomUtilElementOfScrollableList(controller);
            }
          },
          separatorBuilder: (context, index) {
            return Gap(CARD_MARGIN);
          },
        );
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
    // logDebug(
    //   'DayLogListTab.tab.list.card build',
    // );
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
  const _BottomUtilElementOfScrollableList(this.controller);
  final DayLogListTabController controller;

  @override
  Widget build(BuildContext context) {
    logDebug(
      'DayLogListTab.tab.list.bottom controller build: ${controller.status}',
    );
    if (controller.status == EControllerStatus.processing) {
      return Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
          child: const MyProcessIndicator(),
        ),
      );
    }
    if (controller.status == EControllerStatus.minorError) {
      return Text(
        'Error: ${controller.errorMessage ?? 'Unknown error :['}',
      );
    }
    return Container();
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
