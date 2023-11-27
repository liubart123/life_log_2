import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/day_log_edit_screen.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/StringFormatters.dart';
import 'package:structures/structures.dart';

/// Card for displaying DayLog's data.
/// Is used as element of scrollable list.
class DayLogCard extends StatelessWidget {
  const DayLogCard({
    required this.dayLog,
    this.onTapCallback,
    super.key,
  });

  final DayLog dayLog;
  final Function()? onTapCallback;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      onTap: onTapCallback ?? () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate(dayLog.date),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Gap(INNER_CARD_GAP_MEDIUM),
          _DayLogFieldsAndTagsRenderer(dayLog: dayLog),
        ],
      ),
    );
  }
}

//todo:create file with collection of terms' explanation, like 'Renderer'
class _DayLogFieldsAndTagsRenderer extends StatelessWidget {
  const _DayLogFieldsAndTagsRenderer({
    required this.dayLog,
  });

  final DayLog dayLog;
  //todo:explain in file allowed sizes of widget's code, spicies of widgets
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
