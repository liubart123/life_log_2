import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_scrollable_list_tab_body/daily_activity_list_card.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_tab_controller.dart';
import 'package:life_log_2/my_flutter_elements/my_constants.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';

class DailyActivitiesViewScrollableListTabBody extends StatelessWidget {
  const DailyActivitiesViewScrollableListTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyActivitiesViewTabController>(
      builder: (controller) {
        final dailActivityList = controller.dailyActivityList;
        return MyScrollableList(
          bottomScrolledCallback: () {
            controller.loadNextDailyActivityListPage();
          },
          reloadCallback: () async {
            await controller.loadAndSetFirstDailyActivityListPage();
          },
          itemCount: dailActivityList.length + 1,
          itemBuilder: _createScrollableListItemBuilder(dailActivityList),
          separatorBuilder: (
            context,
            index,
          ) {
            return const Gap(SMALL_CARD_MARGIN);
          },
        );
      },
    );
  }

  Widget? Function(BuildContext, int) _createScrollableListItemBuilder(List<DailyActivity> list) {
    return (context, index) {
      var displayStartDateOnTop = false;
      var highlightStartTime = false;
      if (index == 0) {
        displayStartDateOnTop = true;
        highlightStartTime = true;
      } else if (index == list.length) {
        return _loadingIndicatorAtBottomOfTheList();
      } else {
        if (index == list.length - 1) {
          highlightStartTime = true;
        } else if (list[index + 1].startTime.hour != list[index].startTime.hour ||
            list[index].startTime.difference(list[index + 1].startTime).inHours >= 1) {
          highlightStartTime = true;
        }

        if (list[index].startTime.difference(list[index - 1].startTime).inDays >= 1 || list[index].startTime.day != list[index - 1].startTime.day) {
          displayStartDateOnTop = true;
        }
      }
      return DailyActivityListCard(
        list[index],
        displayStartDateOnTop: displayStartDateOnTop,
        highlightStartTime: highlightStartTime,
      );
    };
  }

  Widget? _loadingIndicatorAtBottomOfTheList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: const Center(
        child: MyProcessIndicator(),
      ),
    );
  }
}
