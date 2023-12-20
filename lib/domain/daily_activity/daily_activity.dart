import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';

class DailyActivity {
  DailyActivity(
    this.category,
    this.subCategory,
    this.dateTime,
    this.duration,
    this.attributes,
  );

  DailyActivityCategory category;
  DailyActivitySubCategory subCategory;
  DateTime dateTime;
  Duration duration;
  List<DailyActivityAttribute> attributes;
}
