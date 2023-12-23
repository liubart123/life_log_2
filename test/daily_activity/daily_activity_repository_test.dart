import 'package:flutter_test/flutter_test.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_builder.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';
import 'package:life_log_2/domain/daily_activity/repository/daily_activity_repository.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_specific_attributes.dart';
import 'package:life_log_2/utils/data_access/database_connector.dart';

import '../test_utils.dart';

Future<void> main() async {
  await initializeTestEnvVariables();

  final subCategory = DailyActivitySubCategory(
    'testSubCategory',
    [
      IntDailyActivityAttribute(
        'intAttr',
        'intAttr',
        123,
      ),
      DoubleDailyActivityAttribute(
        'doubleAttr',
        'doubleAttr',
        1.234,
      ),
      TagDailyActivityAttribute('tagAttr', 'tagAttr', value: true),
      DurationDailyActivityAttribute(
        'durationAttr',
        'durationAttr',
        const Duration(
          minutes: 78,
          seconds: 12,
        ),
      ),
      EnumDailyActivityAttribute(
        'enumAttr',
        'enumAttr',
        [
          EnumDailyActivityAttributeOption('e1', 'e1'),
          EnumDailyActivityAttributeOption('e2', 'e2'),
          EnumDailyActivityAttributeOption('e3', 'e3'),
        ],
        'e2',
      ),
    ],
    const Duration(
      minutes: 123,
    ),
  );
  final category = DailyActivityCategory(
    'testCategory',
    [subCategory],
  );

  final connection =
      await DatabaseConnector.openDatabaseConnectionUsingEnvConfiguration();
  final categoriesConfiguration =
      DailyActivityCategoriesConfiguration(overridenCategories: [category]);
  final dailyActivityBuilder = DailyActivityBuilder(categoriesConfiguration);
  final repository = DailyActivityRepository(
    connection,
    categoriesConfiguration,
  );
  test(
    'repository basic testing',
    () async {
      final createdDailyActivity = dailyActivityBuilder
          .buildInitialDailyActivity(category.name, subCategory.name);

      expect(
        createdDailyActivity.id,
        null,
        reason: 'id of newly created activity should be null',
      );

      await repository.saveDailyActivity(createdDailyActivity);

      expect(
        createdDailyActivity.id,
        isNotNull,
        reason: 'Created activity should have not null id',
      );

      var latestDailyActivities = await repository.readLatestDailyActivities();
      expect(
        compareDailyActivities(
          latestDailyActivities[0],
          createdDailyActivity,
        ),
        isTrue,
        reason: 'last activity should be same as previously created activity',
      );

      var readDailyActivity =
          await repository.readDailyActivityById(createdDailyActivity.id!);
      expect(
        readDailyActivity,
        isNotNull,
        reason: 'the read result of created activity should not be null',
      );
      expect(
        compareDailyActivities(
          readDailyActivity!,
          createdDailyActivity,
        ),
        isTrue,
        reason:
            'the read result of created activity should be same as previously created activity',
      );

      await repository.deleteDailyActivity(createdDailyActivity);

      latestDailyActivities = await repository.readLatestDailyActivities();
      expect(
        latestDailyActivities
            .any((element) => element.id == createdDailyActivity.id),
        false,
        reason: 'list of last activities shoudn`t contain deleted activity',
      );

      readDailyActivity =
          await repository.readDailyActivityById(createdDailyActivity.id!);
      expect(
        readDailyActivity,
        isNull,
        reason: 'the read result of deleted activity should be null',
      );
    },
  );
}

bool compareDailyActivities(
  DailyActivity act1,
  DailyActivity act2, {
  bool compareId = true,
}) {
  return (!compareId || act1.id == act2.id) &&
      act1.startTime == act2.startTime &&
      act1.duration == act2.duration &&
      act1.category.name == act2.category.name &&
      act1.subCategory.name == act2.subCategory.name &&
      act1.attributes.length == act2.attributes.length &&
      act1.attributes.every(
        (atr1) => act2.attributes.any(
          (atr2) => _compareAttributes(atr1, atr2),
        ),
      );
}

bool _compareAttributes(
  DailyActivityAttribute atr1,
  DailyActivityAttribute atr2,
) {
  if (atr2.name != atr1.name || atr2.label != atr1.label) {
    return false;
  } else if (atr1 is DurationDailyActivityAttribute &&
      atr2 is DurationDailyActivityAttribute) {
    return atr1.value == atr2.value;
  }
  return atr2.getValue() == atr1.getValue();
}
