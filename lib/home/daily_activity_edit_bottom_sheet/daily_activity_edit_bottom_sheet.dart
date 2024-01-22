import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/home/daily_activity_edit_bottom_sheet/daily_activity_edit_bottom_sheet_controller.dart';
import 'package:life_log_2/my_flutter_elements/my_constants.dart';
import 'package:life_log_2/my_flutter_elements/my_input_widgets.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';
import 'package:life_log_2/utils/datetime/datetime_extension.dart';

class DailyActivityEditBottomSheet extends StatelessWidget {
  const DailyActivityEditBottomSheet(
    this.dailyActivity, {
    super.key,
  });

  final DailyActivity dailyActivity;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyActivityEditBottomSheetController>(
      init: DailyActivityEditBottomSheetController(
        dailyActivity,
        repository: Get.find(),
      ),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(CONTENT_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(CONTENT_PADDING),
              ..._inputFields(context, controller),
              const Gap(CONTENT_PADDING),
              _bottomButtons(),
              //adds padding if keyboard hiding focused node
              Gap(MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _inputFields(
    BuildContext context,
    DailyActivityEditBottomSheetController controller,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Expanded(
          //   flex: 1,
          //   child: MyTimeInputField(
          //     initialValue: controller.dailyActivity.startTime,
          //     label: 'Start time',
          //     onSubmit: (newValue) {
          //       if (newValue != null) {
          //         controller.updateStartTime(newValue);
          //       }
          //     },
          //   ),
          // ),

          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: MyTextButton(
              buttonColor: Get.theme.colorScheme.primaryContainer,
              text: controller.dailyActivity.startTime.toTimeString(),
              callback: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(controller.dailyActivity.startTime),
                );
                if (time != null) {
                  controller.updateStartTime(time);
                }
              },
            ),
          ),
          const Gap(CONTENT_PADDING),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: MyTextButton(
              buttonColor: Get.theme.colorScheme.primaryContainer,
              text: controller.dailyActivity.startTime.toDateString(),
              callback: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2022),
                  lastDate: DateTime.now(),
                  initialDate: controller.dailyActivity.startTime,
                );
                if (date != null) {
                  controller.updateStartDate(date);
                }
              },
            ),
          ),
        ],
      ),
    ];
  }

  Widget _bottomButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 0,
          child: MyIconButton(
            icon: Icons.delete_outline,
            iconColor: Get.theme.colorScheme.error,
            buttonColor: Get.theme.colorScheme.errorContainer,
          ),
        ),
        const Gap(CONTENT_PADDING),
        Expanded(
          child: MyTextButton(
            buttonColor: Get.theme.colorScheme.primaryContainer,
            text: 'Save',
            callback: () {
              Get.find<DailyActivityEditBottomSheetController>().saveDailyActivity();
            },
          ),
        ),
      ],
    );
  }
}
