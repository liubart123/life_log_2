import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/my_flutter_elements/my_input_widgets.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DailyActivityEditBottomSheet extends StatelessWidget {
  const DailyActivityEditBottomSheet(
    this.dailyActivity, {
    super.key,
  });

  final DailyActivity dailyActivity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text('empty space'),
          Container(
            color: Colors.amber,
            height: 500,
          ),
          Container(
            color: Colors.red,
            height: 1000,
          ),
          // Gap(500),
          // MyTextInputField(
          //   initialValue: 'initialValue',
          //   onValueChangedCallback: (newValue) {
          //     MyLogger.input1('text inpur field change:$newValue');
          //   },
          //   label: ,
          // ),
          // Gap(MediaQuery.of(context).viewInsets.bottom + 20),
        ],
      ),
    );
  }
}
