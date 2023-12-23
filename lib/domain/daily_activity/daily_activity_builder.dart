import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';

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
      DateTime.now(),
      subCategory.defaultDuration,
      clonedAttributes,
    );

    return resultedActivity;
  }
}
