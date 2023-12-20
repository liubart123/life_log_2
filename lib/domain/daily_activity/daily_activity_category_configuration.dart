import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_specific_attributes.dart';

List<DailyActivityCategory> _categories = [
  DailyActivityCategory(
    'sport',
    [
      DailyActivitySubCategory(
        'fitness',
        [
          TagDailyActivityAttribute(
            'high intensity',
            'high intensity',
            value: false,
          ),
          TagDailyActivityAttribute(
            'to the limit',
            'to the limit',
            value: false,
          ),
        ],
        const Duration(minutes: 20),
      ),
      DailyActivitySubCategory(
        'running',
        [
          DurationDailyActivityAttribute(
            'runDuration',
            'run duration',
            Duration.zero,
          ),
          DoubleDailyActivityAttribute(
            'distance',
            'distance',
            6,
          ),
        ],
        const Duration(minutes: 34),
      ),
    ],
  ),
];

List<DailyActivityCategory> getAllCategories() {
  return _categories;
}
