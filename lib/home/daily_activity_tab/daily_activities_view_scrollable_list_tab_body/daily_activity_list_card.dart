import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/my_flutter_elements/my_constants.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';
import 'package:life_log_2/utils/datetime/datetime_extension.dart';
import 'package:life_log_2/utils/duration/duration_extension.dart';
import 'package:life_log_2/utils/random/random_utils.dart';

class DailyActivityListCard extends StatelessWidget {
  const DailyActivityListCard(
    this.dailyActivity, {
    super.key,
    this.highlightStartTime = false,
    this.displayStartDateOnTop = false,
  });

  final DailyActivity dailyActivity;
  final bool highlightStartTime;
  final bool displayStartDateOnTop;

  @override
  Widget build(
    BuildContext context,
  ) {
    final cardColor = _getColorForDailyActivityCard();
    final cardWidthRatio = _calculateCardWidthRatioForDailyActivityCard(dailyActivity);
    final displayDuration = _checkIfDailActivityDurationShouldBeDisplayed();
    return Column(
      children: [
        if (displayStartDateOnTop) _dailyActivityStartDateAboveCard(),
        Row(
          children: [
            _startTimeNearCard(highlight: highlightStartTime),
            Expanded(
              child: FractionallySizedBox(
                alignment: Alignment.topLeft,
                widthFactor: cardWidthRatio,
                child: MySmallCard(
                  color: cardColor,
                  child: Row(
                    children: [
                      const Gap(SMALL_CARD_ADDITIONAL_HORIZONTAL_PADDING),
                      Expanded(child: _cardTitle()),
                      if (displayDuration) _activityDurationNearCard(),
                      const Gap(SMALL_CARD_ADDITIONAL_HORIZONTAL_PADDING),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dailyActivityStartDateAboveCard() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, SMALL_CARD_MARGIN - 2),
        child: Text(
          dailyActivity.startTime.toDateString(),
          style: Get.textTheme.titleSmall!.copyWith(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  bool _checkIfDailActivityDurationShouldBeDisplayed() {
    return dailyActivity.duration.inMinutes > 5;
  }

  Color _getColorForDailyActivityCard() {
    final categoryHue = RandomUtils.getRandomWithStringSeed(dailyActivity.category.key).nextInt(360).toDouble();
    final subcategoryHue = RandomUtils.getRandomWithStringSeed(dailyActivity.subCategory.key).nextInt(50).toDouble();
    final resultedHue = (categoryHue + subcategoryHue) % 360;
    final cardColor = HSLColor.fromAHSL(1, resultedHue, 0.3, 0.8).toColor();
    return cardColor;
  }

  Container _startTimeNearCard({
    bool highlight = true,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(SMALL_CARD_MARGIN, 0, SMALL_CARD_MARGIN, 0),
      child: Text(
        dailyActivity.startTime.toTimeString(),
        style: Get.textTheme.titleMedium!.copyWith(
          color: Get.theme.colorScheme.onSurface.withOpacity(highlight ? 0.7 : 0.2),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Row _cardTitle() {
    return Row(
      children: [
        Text(
          dailyActivity.subCategory.key,
          style: Get.textTheme.titleMedium,
        ),
        Expanded(
          child: Text(
            ' ${dailyActivity.category.key}',
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.titleMedium!.copyWith(
              // color: Get.theme.colorScheme.outline,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _activityDurationNearCard() {
    return Text(
      textAlign: TextAlign.end,
      dailyActivity.duration.toOnlyMinutesString(),
      style: Get.textTheme.bodyMedium!.copyWith(
        color: Get.theme.colorScheme.onSurface.withOpacity(0.2),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  double _calculateCardWidthRatioForDailyActivityCard(DailyActivity dailyActivity) {
    const minRatio = 0.5;
    const maxRatio = 1.0;
    if (dailyActivity.duration < const Duration(minutes: 5))
      return minRatio;
    else if (dailyActivity.duration > const Duration(minutes: 30))
      return maxRatio;
    else
      return lerpDouble(minRatio, maxRatio, ((dailyActivity.duration.inMinutes - 5) / 25).clamp(0, 1))!;
  }
}
