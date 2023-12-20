import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';

class DailyActivityBuilder {
  DailyActivity buildInitialDailyActivity(
    DailyActivityCategory category,
    DailyActivitySubCategory subCategory,
  ) {
    final clonedAttributes =
        subCategory.attributes.map((x) => x.clone()).toList();
    final resultedActivity = DailyActivity(
      category,
      subCategory,
      DateTime.now(),
      subCategory.defaultDuration,
      clonedAttributes,
    );

    return resultedActivity;
  }
}
