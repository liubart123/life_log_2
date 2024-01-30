import 'package:flutter_test/flutter_test.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_category.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_utils.dart';
import 'package:life_log_2/domain/daily_activity/repository/daily_activity_repository.dart';
import 'package:life_log_2/utils/data_access/database_connector.dart';

import '../test_utils.dart';

Future<void> main() async {
  await initializeTestEnvVariables();

  final category1 = DailyActivityCategory.key('TestCategory');
  final subCategory1 = DailyActivitySubCategory.key('FullSubCategory');
  final subCategory2 = DailyActivitySubCategory.key('EmptySubCategory');

  final testCategoryConfiguration = [
    (
      category1,
      [
        (
          subCategory1,
          [
            NumericDailyActivityAttribute.key('Numeric'),
            StringDailyActivityAttribute.key('String'),
            BoolDailyActivityAttribute.key('Bool'),
            TimeDailyActivityAttribute.key('DateTime'),
            DurationDailyActivityAttribute.key('Duration'),
            EnumDailyActivityAttribute.key('Enum', ['opt1', 'opt2']),
          ]
        ),
        (
          subCategory2,
          [
            BoolDailyActivityAttribute.key('LonelyBool'),
          ]
        ),
      ]
    ),
  ];
  final connection = await DatabaseConnector.openDatabaseConnectionUsingEnvConfiguration();
  final categoriesConfiguration = DailyActivityCategoriesConfiguration(configuration: testCategoryConfiguration);
  final dailyActivityUtils = DailyActivityUtils(categoriesConfiguration);
  final repository = DailyActivityRepository(
    connection,
    categoriesConfiguration,
  );
  test(
    'repository basic CRUD',
    () async {
      final createdDailyActivity = DailyActivity(category1, subCategory1, DateTime.now(), Duration.zero, []);
      createdDailyActivity.notes = 'test notes';
      dailyActivityUtils.initializeAttributesForDailyActivity(createdDailyActivity);

      final savedId = await repository.saveDailyActivity(createdDailyActivity);

      expect(
        savedId,
        isNotNull,
        reason: 'Created activity should have not null id',
      );

      var latestDailyActivities = await repository.readLatestDailyActivities();
      expect(
        compareDailyActivities(
          latestDailyActivities[0],
          createdDailyActivity,
          compareId: false,
        ),
        isTrue,
        reason: 'last activity should be same as previously created activity',
      );

      var readDailyActivity = await repository.readDailyActivityById(savedId);
      expect(
        readDailyActivity,
        isNotNull,
        reason: 'the read result of created activity should not be null',
      );
      expect(
        compareDailyActivities(
          readDailyActivity!,
          createdDailyActivity,
          compareId: false,
        ),
        isTrue,
        reason: 'the read result of created activity should be same as previously created activity',
      );

      final updatedDailyActivity = readDailyActivity;

      updatedDailyActivity.attributeValues.firstWhere((element) => element.attribute is NumericDailyActivityAttribute).value = 1;
      updatedDailyActivity.attributeValues.firstWhere((element) => element.attribute is StringDailyActivityAttribute).value = 'updated';
      updatedDailyActivity.attributeValues.firstWhere((element) => element.attribute is BoolDailyActivityAttribute).value = true;
      updatedDailyActivity.attributeValues.firstWhere((element) => element.attribute is TimeDailyActivityAttribute).value = DateTime(2001);
      updatedDailyActivity.attributeValues.firstWhere((element) => element.attribute is DurationDailyActivityAttribute).value = Duration(minutes: 12);
      final enumAttribute = updatedDailyActivity.attributeValues.firstWhere((element) => element.attribute is EnumDailyActivityAttribute);
      enumAttribute.value = (enumAttribute.attribute as EnumDailyActivityAttribute).enumOptions.last;

      await repository.saveDailyActivity(updatedDailyActivity);

      readDailyActivity = await repository.readDailyActivityById(savedId);
      expect(
        readDailyActivity,
        isNotNull,
        reason: 'the read result of updated activity should not be null',
      );
      expect(
        compareDailyActivities(
          readDailyActivity!,
          updatedDailyActivity,
          compareId: false,
        ),
        isTrue,
        reason: 'the read result of updated activity should be same as previously updated activity',
      );

      await repository.deleteDailyActivity(savedId);

      latestDailyActivities = await repository.readLatestDailyActivities();
      expect(
        latestDailyActivities.any((element) => element.id == savedId),
        false,
        reason: 'list of last activities shoudn`t contain deleted activity',
      );

      readDailyActivity = await repository.readDailyActivityById(savedId);
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
      act1.category.key == act2.category.key &&
      act1.subCategory.key == act2.subCategory.key &&
      act1.notes == act2.notes &&
      act1.attributeValues.length == act2.attributeValues.length &&
      act1.attributeValues.every(
        (atr1) => act2.attributeValues.any(
          (atr2) => _compareAttributes(atr1, atr2),
        ),
      );
}

bool _compareAttributes(
  DailyActivityAttributeValue atr1,
  DailyActivityAttributeValue atr2,
) {
  if (atr2.attribute.key != atr1.attribute.key) {
    return false;
  }
  if (atr1.value is DateTime && atr2.value is DateTime) {
    return (atr1.value as DateTime).difference(atr2.value as DateTime).inMilliseconds.abs() < 1000;
  } else if (atr1.value is Duration && atr2.value is Duration) {
    return ((atr1.value as Duration).inMilliseconds - (atr2.value as Duration).inMilliseconds).abs() < 1000;
  } else {
    return atr1.value == atr2.value;
  }
}
