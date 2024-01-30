import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';
import 'package:life_log_2/utils/duration/duration_extension.dart';
import 'package:postgres/postgres.dart';

class DailyActivityRepositoryConverter {
  DailyActivityRepositoryConverter({required this.categoriesConfiguration});
  DailyActivityCategoriesConfiguration categoriesConfiguration;
  String convertDailyActivityAttributeValuesToJson(
    List<DailyActivityAttributeValue> attributeValues,
  ) {
    return json.encode(
      {
        for (final attributeValue in attributeValues)
          attributeValue.attribute.key: _serializeAttributeValue(
            attributeValue.value,
          )
      },
    );
  }

  dynamic _serializeAttributeValue(dynamic value) {
    if (value is Duration) {
      return _convertDurationToString(value);
    } else if (value is DateTime) {
      return _convertDateTimeToString(value);
    }
    return value;
  }

  String _convertDurationToString(Duration duration) {
    return duration.toFormattedString(withSeconds: true);
  }

  String _convertDateTimeToString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Duration _convertStringToDuration(String str) {
    return convertStringToDuration(str);
  }

  DateTime _convertStringToDateTime(String str) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(str);
  }

  DailyActivity convertResultRowToDailyActivity(
    ResultRow row,
    DailyActivityCategoriesConfiguration categoriesConfiguration,
  ) {
    final (category, subCategory) = categoriesConfiguration.getCategoryAndSubCategoryByNames(
      row[1]! as String,
      row[2]! as String,
    );
    final resultedDailyActivity = DailyActivity(
      category,
      subCategory,
      (row[3]! as DateTime).toLocal(),
      Duration(microseconds: (row[4]! as Interval).microseconds),
      _convertMapFromJsonToDailyActivityAttributeValues(
        row[5]! as Map<String, dynamic>,
      ),
      id: row[0]! as int,
      notes: row[6] as String?,
    );
    return resultedDailyActivity;
  }

  List<DailyActivityAttributeValue> _convertMapFromJsonToDailyActivityAttributeValues(
    Map<String, dynamic> attrbiutesMap,
  ) {
    return attrbiutesMap
        .map(
          (key, value) {
            final attribute = categoriesConfiguration.getDailyActivityAttribute(key);
            return MapEntry(
              key,
              _createAttributeValueFromDynamicValue(
                attribute,
                value,
              ),
            );
          },
        )
        .values
        .cast<DailyActivityAttributeValue>()
        .toList();
  }

  DailyActivityAttributeValue _createAttributeValueFromDynamicValue(
    DailyActivityAttribute attribute,
    dynamic attributeValue,
  ) {
    dynamic resultValue;
    if (attribute is StringDailyActivityAttribute) {
      resultValue = attributeValue as String;
    } else if (attribute is NumericDailyActivityAttribute) {
      resultValue = attributeValue as int;
    } else if (attribute is BoolDailyActivityAttribute) {
      resultValue = attributeValue as bool;
    } else if (attribute is TimeDailyActivityAttribute) {
      resultValue = _convertStringToDateTime(attributeValue as String);
    } else if (attribute is DurationDailyActivityAttribute) {
      resultValue = _convertStringToDuration(attributeValue as String);
    } else if (attribute is EnumDailyActivityAttribute) {
      resultValue = attributeValue as String;
    } else {
      throw UnimplementedError();
    }
    final result = DailyActivityAttributeValue(attribute, resultValue);
    return result;
  }

  Duration _convertDurationFromString(String inputString) {
    final List<String> timeParts = inputString.split(':');

    return Duration(
      hours: int.parse(timeParts[0]),
      minutes: int.parse(timeParts[1]),
      seconds: timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
    );
  }
}
