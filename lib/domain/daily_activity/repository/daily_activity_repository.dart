import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';
import 'package:life_log_2/domain/daily_activity/repository/daily_activity_repository_converter.dart';
import 'package:life_log_2/utils/data_access/database_connection_enhancements.dart';
import 'package:postgres/postgres.dart';

class DailyActivityRepository {
  DailyActivityRepository(
    this.connection,
    this.categoriesConfiguration,
  );
  Connection connection;
  DailyActivityCategoriesConfiguration categoriesConfiguration;

  /// Creates or updates activity in datasource.
  Future<void> saveDailyActivity(DailyActivity source) async {
    final result = await connection.callProcedure(
      'upsert_daily_activity',
      [
        source.id,
        source.category.name,
        source.subCategory.name,
        source.startTime,
        source.duration,
        convertDailyActivityAttributesToJson(source.attributes),
        source.notes,
      ],
    );
    source.id ??= result.first.first! as int;
  }

  Future<void> deleteDailyActivity(DailyActivity source) async {
    await connection.callProcedure(
      'delete_daily_activity',
      [source.id],
    );
  }

  Future<List<DailyActivity>> readLatestDailyActivities() async {
    final selectResult = await connection.selectFromFunction('select_daily_activity', []);
    final result = selectResult
        .map(
          (x) => convertResultRowToDailyActivity(x, categoriesConfiguration),
        )
        .toList();
    return result;
  }

  Future<List<DailyActivity>> readLatestDailyActivitiesNextPage(
    DailyActivity previousPageEarliestDailyActivity,
  ) async {
    final selectResult = await connection.selectFromFunction('select_daily_activity', [
      previousPageEarliestDailyActivity.startTime,
      previousPageEarliestDailyActivity.id,
    ]);
    final result = selectResult
        .map(
          (x) => convertResultRowToDailyActivity(x, categoriesConfiguration),
        )
        .toList();
    return result;
  }

  Future<DailyActivity?> readDailyActivityById(int id) async {
    final selectResult = await connection.selectFromFunction('select_daily_activity', [id]);
    if (selectResult.isEmpty) return null;
    return convertResultRowToDailyActivity(
      selectResult.first,
      categoriesConfiguration,
    );
  }
}
