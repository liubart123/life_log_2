import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_specific_attributes.dart';

class DailyActivityCategoriesConfiguration {
  DailyActivityCategoriesConfiguration({
    List<DailyActivityCategory>? overridenCategories,
  }) {
    var categoriesList = [
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
    if (overridenCategories != null) {
      categoriesList = overridenCategories;
    }
    _categories = {
      for (final category in categoriesList) category.name: category
    };
  }
  late Map<String, DailyActivityCategory> _categories;

  List<DailyActivityCategory> getAllCategories() {
    return _categories.values.toList();
  }

  (DailyActivityCategory, DailyActivitySubCategory)
      getCategoryAndSubCategoryByNames(
    String categoryName,
    String subCategoryName,
  ) {
    if (!_categories.containsKey(categoryName)) {
      throw Exception(
        'Requrested categoryName doesn`t exist in used configuration',
      );
    }
    return (
      _categories[categoryName]!,
      _categories[categoryName]!
          .subCategories
          .firstWhere((subCategory) => subCategory.name == subCategoryName)
    );
  }
}
