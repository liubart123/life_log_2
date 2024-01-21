import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/my_flutter_elements/my_constants.dart';
import 'package:life_log_2/my_flutter_elements/my_input_widgets.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DailyActivityEditBottomSheet extends StatelessWidget {
  const DailyActivityEditBottomSheet(
    this.dailyActivity, {
    super.key,
  });

  final DailyActivity dailyActivity;

  @override
  Widget build(BuildContext context) {
    MyLogger.widget3('viewInsets for bottomSHeet`s content:${MediaQuery.of(context).viewInsets.bottom}');
    return Container(
      padding: EdgeInsets.all(CONTENT_PADDING),
      child: Column(
        children: [
          Text('empty space'),
          Container(
            color: Colors.amber,
            height: 500,
            child: Center(child: Text('awesome content')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MyTimeInputField(
              initialValue: DateTime.now(),
              onSubmit: (newValue) {
                MyLogger.debug('Start time newValue:$newValue');
              },
              label: 'Start time',
            ),
          ),
          Container(
            color: Colors.red,
            height: 1000,
            child: Center(child: Text('awesome content')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MyTimeInputField(
              initialValue: DateTime.now(),
              onSubmit: (newValue) {
                MyLogger.debug('Start time newValue:$newValue');
              },
              label: 'Start time',
            ),
          ),
          Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Gap(20),
              Flexible(
                flex: 0,
                fit: FlexFit.loose,
                child: MyIconButton(
                  icon: Icons.delete_outline,
                  iconColor: Get.theme.colorScheme.error,
                  buttonColor: Get.theme.colorScheme.errorContainer,
                ),
              ),
              Gap(CONTENT_PADDING),
              Expanded(
                child: MyTextButton(
                  child: Text('Save'),
                  buttonColor: Get.theme.colorScheme.primaryContainer,
                ),
              ),
              // Gap(20),
            ],
          ),
          //adds padding if keyboard hiding focused node
          Gap(MediaQuery.of(context).viewInsets.bottom + 20),
        ],
      ),
    );
  }
}
