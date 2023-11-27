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

import 'day_log_card.dart';

class TabBodyWithDayLogList extends StatelessWidget {
  const TabBodyWithDayLogList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DayLogsViewTabController>(
      builder: (controller) {
        logDebug(
          'List build: ${controller.state}',
        );
        return MyScrollableList(
          reloadCallback: () async {
            // Waiting when initial page is loaded, so state remains Idle
            await controller.resetDayLogListWithInitialPage();
          },
          bottomScrolledCallback: () {
            logDebug('List bottom scrolled');
            controller.loadNextPage();
          },
          itemCount: controller.dayLogList.length + 1,
          itemBuilder: _createItemBuilderForDayLogList(controller),
          separatorBuilder: (context, index) {
            return Gap(CARD_MARGIN);
          },
        );
      },
    );
  }

  Widget? Function(BuildContext, int) _createItemBuilderForDayLogList(
    DayLogsViewTabController controller,
  ) {
    return (context, index) {
      if (index < controller.dayLogList.length) {
        return DayLogCard(
          dayLog: controller.dayLogList[index],
          onTapCallback: () {
            //todo:change to GetX routes
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DayLogEditPage(
                    dayLogId: controller.dayLogList[index].id!,
                  );
                },
              ),
            );
          },
        );
      } else {
        return _createBottomElementForDayLogList(controller);
      }
    };
  }

  Widget? _createBottomElementForDayLogList(
    DayLogsViewTabController controller,
  ) {
    if (controller.state == EControllerState.processing) {
      return Center(
        child: Container(
          margin: EdgeInsets.all(CARD_MARGIN),
          child: const MyProcessIndicator(),
        ),
      );
    } else if (controller.errorMessage.value.isNotEmpty) {
      return MyErrorMessage(
        'Error: ${controller.errorMessage}',
      );
    } else {
      return Container();
    }
  }
}
