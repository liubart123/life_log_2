import 'dart:convert';

import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_specific_attributes.dart';
import 'package:life_log_2/utils/duration/duration_extension.dart';
import 'package:postgres/postgres.dart';

String convertDailyActivityAttributesToJson(
  List<DailyActivityAttribute> attributes,
) {
  return json.encode(
    {
      for (final attribute in attributes)
        attribute.name: _serializeAttributeValue(
          attribute.getValue(),
        )
    },
  );
}

dynamic _serializeAttributeValue(dynamic value) {
  if (value is EnumDailyActivityAttributeOption) {
    return value.key;
  } else if (value is Duration) {
    return _convertDurationToString(value);
  }
  return value;
}

String _convertDurationToString(Duration duration) {
  return duration.toFormattedString(withSeconds: true);
}

DailyActivity convertResultRowToDailyActivity(
  ResultRow row,
  DailyActivityCategoriesConfiguration categoriesConfiguration,
) {
  final (category, subCategory) =
      categoriesConfiguration.getCategoryAndSubCategoryByNames(
    row[1]! as String,
    row[2]! as String,
  );
  final attributes = _convertMapFromJsonToDailyActivityAttributes(
    row[5]! as Map<String, dynamic>,
    subCategory,
  );
  return DailyActivity(
    category,
    subCategory,
    (row[3]! as DateTime).toLocal(),
    Duration(microseconds: (row[4]! as Interval).microseconds),
    attributes,
    id: row[0]! as int,
  );
}

List<DailyActivityAttribute> _convertMapFromJsonToDailyActivityAttributes(
  Map<String, dynamic> attrbiutesMap,
  DailyActivitySubCategory subCategory,
) {
  return attrbiutesMap
      .map(
        (key, value) {
          final attributeTemplate =
              subCategory.attributes.firstWhere((attr) => attr.name == key);
          return MapEntry(
            key,
            _createAttributeByTemplateAndDynamicValue(
              attributeTemplate,
              key,
              value,
            ),
          );
        },
      )
      .values
      .cast<DailyActivityAttribute>()
      .toList();
}

DailyActivityAttribute _createAttributeByTemplateAndDynamicValue(
  DailyActivityAttribute attributeTemplate,
  String attributeName,
  dynamic attributeValue,
) {
  final attribute = attributeTemplate.clone();
  if (attribute is IntDailyActivityAttribute) {
    attribute.value = attributeValue as int;
  } else if (attribute is DoubleDailyActivityAttribute) {
    attribute.value = attributeValue as double;
  } else if (attribute is EnumDailyActivityAttribute) {
    attribute.setValue(attributeValue as String);
  } else if (attribute is TagDailyActivityAttribute) {
    attribute.value = attributeValue as bool;
  } else if (attribute is DurationDailyActivityAttribute) {
    attribute.value = _convertDurationFromString(attributeValue as String);
  } else {
    throw UnimplementedError();
  }
  return attribute;
}

Duration _convertDurationFromString(String inputString) {
  final List<String> timeParts = inputString.split(':');

  return Duration(
    hours: int.parse(timeParts[0]),
    minutes: int.parse(timeParts[1]),
    seconds: timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
  );
}
