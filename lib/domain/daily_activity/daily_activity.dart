import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';

class DailyActivity {
  DailyActivity(
    this.category,
    this.subCategory,
    this.startTime,
    this.duration,
    this.attributes, {
    this.notes,
    this.id,
  });
  int? id;
  DailyActivityCategory category;
  DailyActivitySubCategory subCategory;
  DateTime startTime;
  Duration duration;
  List<DailyActivityAttribute> attributes;
  String? notes;
}
