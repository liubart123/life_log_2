import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';

class DailyActivityUtils {
  DailyActivityUtils(this.categoriesConfiguration);
  DailyActivityCategoriesConfiguration categoriesConfiguration;
  void initializeAttributesForDailyActivity(DailyActivity dailyActivity) {
    final attributes = categoriesConfiguration.getAttributes(dailyActivity.subCategory);
    dailyActivity.attributeValues = [];
    for (final attr in attributes) {
      dailyActivity.attributeValues.add(_createInitialAttributeValue(attr));
    }
  }

  DailyActivityAttributeValue _createInitialAttributeValue(DailyActivityAttribute attribute) {
    dynamic initialValue;
    if (attribute is StringDailyActivityAttribute) {
      initialValue = '';
    } else if (attribute is NumericDailyActivityAttribute) {
      initialValue = 0;
    } else if (attribute is BoolDailyActivityAttribute) {
      initialValue = false;
    } else if (attribute is TimeDailyActivityAttribute) {
      initialValue = DateTime.now();
    } else if (attribute is DurationDailyActivityAttribute) {
      initialValue = Duration.zero;
    } else if (attribute is EnumDailyActivityAttribute) {
      initialValue = attribute.enumOptions[0];
    } else {
      throw UnimplementedError();
    }

    return DailyActivityAttributeValue(attribute, initialValue);
  }
}
