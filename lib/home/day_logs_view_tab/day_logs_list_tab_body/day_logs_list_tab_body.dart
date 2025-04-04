import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/home/day_logs_view_tab/day_logs_list_tab_body/day_log_card.dart';
import 'package:life_log_2/home/day_logs_view_tab/day_logs_view_tab_controller.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/controller_status.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DayLogsListTabBody extends StatelessWidget {
  const DayLogsListTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DayLogsViewTabController>(
      builder: (controller) {
        MyLogger.widget2('$runtimeType build');
        return MyScrollableList(
          reloadCallback: () async {
            MyLogger.input1('$runtimeType refresh gesture');
            // Waiting when initial page is loaded, so state remains Idle
            await controller.resetDayLogListWithInitialPage();
          },
          bottomScrolledCallback: () {
            MyLogger.input1('$runtimeType bottom scrolled');
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
        final dayLog = controller.dayLogList[index];
        return DayLogCard(
          dayLog: dayLog,
          onTapCallback: () {
            MyLogger.input1('$runtimeType card tapped. Id: ${dayLog.id}');
            Get.to<Scaffold>(
              () => const Scaffold(
                body: Center(
                  child: Icon(Icons.ac_unit_rounded),
                ),
              ),
            );
            // Navigator.push<void>(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return DayLogEditPage(
            //         dayLogId: controller.dayLogList[index].id!,
            //       );
            //     },
            //   ),
            // );
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
    } else if (controller.errorMessage?.isBlank == false) {
      return MyErrorMessage(
        'Error: ${controller.errorMessage}',
      );
    } else {
      return Container();
    }
  }
}
