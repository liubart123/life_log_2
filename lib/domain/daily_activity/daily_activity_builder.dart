import 'package:flutter/cupertino.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_specific_attributes.dart';

class DailyActivityBuilder {
  DailyActivityBuilder(this.categoriesConfiguration);
  DailyActivityCategoriesConfiguration categoriesConfiguration;

  DailyActivity buildInitialDailyActivity(
    String categoryName,
    String subCategoryName,
  ) {
    final (category, subCategory) =
        categoriesConfiguration.getCategoryAndSubCategoryByNames(
      categoryName,
      subCategoryName,
    );
    final clonedAttributes =
        subCategory.attributes.map((x) => x.clone()).toList();
    final resultedActivity = DailyActivity(
      category,
      subCategory,
      DateTime.now().toUtc(),
      subCategory.defaultDuration,
      clonedAttributes,
    );

    return resultedActivity;
  }

  DailyActivity buildDailyActivity(
    int? id,
    String categoryName,
    String subCategoryName,
    DateTime startTime,
    Duration duration,
    Map<String, dynamic> attributes,
  ) {
    final (category, subCategory) =
        categoriesConfiguration.getCategoryAndSubCategoryByNames(
      categoryName,
      subCategoryName,
    );
    return DailyActivity(
      category,
      subCategory,
      startTime,
      duration,
      attributes
          .map(
            (key, value) => MapEntry(
              key,
              _createAttributeFromSubCategoryAndAttributeName(
                subCategory,
                key,
                value,
              ),
            ),
          )
          .values
          .cast<DailyActivityAttribute>()
          .toList(),
      id: id,
    );
  }

  DailyActivityAttribute _createAttributeFromSubCategoryAndAttributeName(
    DailyActivitySubCategory subCategory,
    String attributeName,
    dynamic attributeValue,
  ) {
    final attribute = subCategory.attributes
        .firstWhere((attr) => attr.name == attributeName)
        .clone();
    if (attribute is IntDailyActivityAttribute) {
      attribute.value = attributeValue as int;
    } else if (attribute is DoubleDailyActivityAttribute) {
      attribute.value = attributeValue as double;
    } else if (attribute is EnumDailyActivityAttribute) {
      attribute.setValue(attributeValue as String);
    } else if (attribute is TagDailyActivityAttribute) {
      attribute.value = attributeValue as bool;
    } else {
      throw UnimplementedError();
    }
    return attribute;
  }
}
