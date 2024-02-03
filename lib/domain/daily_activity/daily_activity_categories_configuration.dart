import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';

class DailyActivityCategoriesConfiguration {
  DailyActivityCategoriesConfiguration({
    List<(DailyActivityCategory, List<(DailyActivitySubCategory, List<DailyActivityAttribute>)>)>? configuration,
  }) {
    final defaultConfiguraiton = [
      (
        DailyActivityCategory.key('TestCategory'),
        [
          (
            DailyActivitySubCategory.key('FullSubCategory'),
            [
              NumericDailyActivityAttribute.key('Numeric'),
              StringDailyActivityAttribute.key('String'),
              BoolDailyActivityAttribute.key('Bool'),
              TimeDailyActivityAttribute.key('DateTime'),
              BoolDailyActivityAttribute.key('Bool1'),
              BoolDailyActivityAttribute.key('Bool2'),
              BoolDailyActivityAttribute.key('Bool3 long'),
              BoolDailyActivityAttribute.key('Bool4'),
              BoolDailyActivityAttribute.key('Bool5 super long'),
              BoolDailyActivityAttribute.key('Bool6'),
              BoolDailyActivityAttribute.key('Bool7'),
              DurationDailyActivityAttribute.key('Duration'),
              EnumDailyActivityAttribute.key('Enum', [...List.generate(10, (index) => 'opt$index ${index % 4 == 0 ? 'long opticus' : ''}')]),
            ]
          ),
          (
            DailyActivitySubCategory.key('EmptySubCategory'),
            [
              BoolDailyActivityAttribute.key('LonelyBool'),
            ]
          ),
        ]
      ),
    ];

    for (final categoryConfig in configuration ?? defaultConfiguraiton) {
      _categoryKeyMap[categoryConfig.$1.key] = categoryConfig.$1;
      _categorySubCategoriesMap[categoryConfig.$1] = [];
      for (final subCategoryConfig in categoryConfig.$2) {
        _subCategoryKeyMap[subCategoryConfig.$1.key] = subCategoryConfig.$1;
        _subCategoryAttributesMap[subCategoryConfig.$1] = subCategoryConfig.$2;
        for (final attributeConfig in subCategoryConfig.$2) {
          _attributeKeyMap[attributeConfig.key] = attributeConfig;
        }
      }
    }
  }
  final Map<String, DailyActivityCategory> _categoryKeyMap = {};
  final Map<String, DailyActivitySubCategory> _subCategoryKeyMap = {};
  final Map<String, DailyActivityAttribute> _attributeKeyMap = {};
  final Map<DailyActivityCategory, List<DailyActivitySubCategory>> _categorySubCategoriesMap = {};
  final Map<DailyActivitySubCategory, List<DailyActivityAttribute>> _subCategoryAttributesMap = {};

  List<DailyActivityCategory> getAllCategories() {
    return _categoryKeyMap.values.toList();
  }

  List<DailyActivitySubCategory> getSubCategories(DailyActivityCategory category) {
    if (!_categorySubCategoriesMap.containsKey(category)) {
      throw Exception(
        'Requrested category doesn`t exist in configuration',
      );
    }
    return _categorySubCategoriesMap[category]!;
  }

  List<DailyActivityAttribute> getAttributes(DailyActivitySubCategory subCategory) {
    if (!_subCategoryAttributesMap.containsKey(subCategory)) {
      throw Exception(
        'Requrested subCategory doesn`t exist in configuration',
      );
    }
    return _subCategoryAttributesMap[subCategory]!;
  }

  (DailyActivityCategory, DailyActivitySubCategory) getCategoryAndSubCategoryByNames(
    String categoryKey,
    String subCategoryKey,
  ) {
    if (!_categoryKeyMap.containsKey(categoryKey)) {
      throw Exception(
        'Requrested categoryKey doesn`t exist in configuration',
      );
    }
    if (!_subCategoryKeyMap.containsKey(subCategoryKey)) {
      throw Exception(
        'Requrested subCategoryKey doesn`t exist in configuration',
      );
    }
    return (_categoryKeyMap[categoryKey]!, _subCategoryKeyMap[subCategoryKey]!);
  }

  DailyActivityAttribute getDailyActivityAttribute(String key) {
    if (!_attributeKeyMap.containsKey(key)) {
      throw Exception('Not found attribute with given key');
    }
    return _attributeKeyMap[key]!;
  }
}
