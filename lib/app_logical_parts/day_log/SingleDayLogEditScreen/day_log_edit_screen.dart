import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_input_widgets.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/InputForm.dart';

///Form with fields for editing DayLog
class DayLogEditWidget extends StatelessWidget {
  const DayLogEditWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.surface,
      padding: EdgeInsets.all(CARD_MARGIN + CARD_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MyDateTimeInputField(
          //   label: 'Sleep Start',
          //   icon: ICON_SLEEP_START,
          //   initialValue: dayLogState.sleepStart.value,
          // ),
          // Gap(INNER_CARD_GAP_SMALL),
          // MyDateTimeInputField(
          //   label: 'Sleep End',
          //   icon: ICON_SLEEP_START,
          //   initialValue: dayLogState.sleepEnd.value,
          // ),
          // Gap(INNER_CARD_GAP_SMALL),
          // MyDurationInputField(
          //   label: 'Sleep Duration',
          //   icon: ICON_SLEEP_START,
          //   initialValue: dayLogState.sleepDuration.value,
          // ),
          // Gap(INNER_CARD_GAP_SMALL),
          // MyDurationInputField(
          //   label: 'Deep Sleep Duration',
          //   icon: ICON_SLEEP_START,
          //   initialValue: dayLogState.deepSleepDuration.value,
          // ),
        ],
      ),
    );
  }
}
