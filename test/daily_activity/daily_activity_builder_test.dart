import 'package:flutter_test/flutter_test.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_builder.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_specific_attributes.dart';

void main() {
  test(
    'Building initial DailyActivity',
    () {
      //setup
      const subCategoryName = 'testSubCategory';
      const categoryName = 'testCategory';
      const enumAttrName = 'enumAttr';
      final enumOptions = [
        EnumDailyActivityAttributeOption('e1', 'e1'),
        EnumDailyActivityAttributeOption('e2', 'e2'),
      ];
      const tagAttrName = 'tagAttr';
      const subCategoryDefualtDuration = Duration(minutes: 2);
      final subCategory = DailyActivitySubCategory(
        subCategoryName,
        [
          EnumDailyActivityAttribute(
            enumAttrName,
            enumAttrName,
            enumOptions,
            enumOptions[0].key,
          ),
          TagDailyActivityAttribute(tagAttrName, tagAttrName, value: true),
        ],
        subCategoryDefualtDuration,
      );
      final category = DailyActivityCategory(
        categoryName,
        [subCategory],
      );

      var buildedDailyActivity =
          DailyActivityBuilder().buildInitialDailyActivity(
        category,
        subCategory,
      );

      // check if common fields where initialized properly
      expect(
        DateTime.now()
                .difference(buildedDailyActivity.dateTime)
                .inMilliseconds <
            1000,
        true,
      );
      expect(
        buildedDailyActivity.duration,
        subCategoryDefualtDuration,
      );
      expect(buildedDailyActivity.category, category);
      expect(buildedDailyActivity.subCategory, subCategory);

      expect(
        buildedDailyActivity.attributes.length,
        2,
      );

      //check initialization of enum attribute
      expect(
        buildedDailyActivity.attributes
            .where((x) => x.name == enumAttrName)
            .length,
        1,
      );
      expect(
        (buildedDailyActivity.attributes
                    .firstWhere((x) => x.name == enumAttrName)
                as EnumDailyActivityAttribute)
            .value
            .key,
        enumOptions[0].key,
      );
      expect(
        (buildedDailyActivity.attributes
                    .firstWhere((x) => x.name == enumAttrName)
                as EnumDailyActivityAttribute)
            .enumValueLabelPairs
            .length,
        2,
      );
      expect(
        (buildedDailyActivity.attributes
                    .firstWhere((x) => x.name == enumAttrName)
                as EnumDailyActivityAttribute)
            .enumValueLabelPairs[1]
            .key,
        enumOptions[1].key,
      );

      //check initialization of tag attribute
      expect(
        buildedDailyActivity.attributes
            .where((x) => x.name == tagAttrName)
            .length,
        1,
      );
      expect(
        (buildedDailyActivity.attributes
                    .firstWhere((x) => x.name == tagAttrName)
                as TagDailyActivityAttribute)
            .value,
        true,
      );

      //check if changing attribute values of builded activity doesn't effect template activity
      (buildedDailyActivity.attributes.firstWhere((x) => x.name == tagAttrName)
              as TagDailyActivityAttribute)
          .value = false;
      expect(
        (subCategory.attributes.firstWhere((x) => x.name == tagAttrName)
                as TagDailyActivityAttribute)
            .value,
        true,
      );

      (buildedDailyActivity.attributes.firstWhere((x) => x.name == enumAttrName)
              as EnumDailyActivityAttribute)
          .setValue(enumOptions[1].key);
      expect(
        (subCategory.attributes.firstWhere((x) => x.name == enumAttrName)
                as EnumDailyActivityAttribute)
            .value
            .key,
        enumOptions[0].key,
      );
    },
  );
}
