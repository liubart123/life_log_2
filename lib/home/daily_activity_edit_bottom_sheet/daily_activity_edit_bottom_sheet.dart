import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
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
      padding: EdgeInsets.all(8),
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
              MyIconButton(icon: Icons.delete_outline),
            ],
          ),
          //adds padding if keyboard hiding focused node
          Gap(MediaQuery.of(context).viewInsets.bottom + 20),
        ],
      ),
    );
  }
}
