import 'dart:convert';

import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_builder.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_specific_attributes.dart';
import 'package:life_log_2/utils/data_access/database_connection_enhancements.dart';
import 'package:postgres/postgres.dart';

class DailyActivityRepository {
  DailyActivityRepository(
    this.connection,
    this.dailyActivityBuilder,
  );
  Connection connection;
  DailyActivityBuilder dailyActivityBuilder;

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
        _convertDailyActivityAttributesToJson(source.attributes),
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
    final selectResult =
        await connection.selectFromFunction('select_daily_activity', []);
    final result = selectResult
        .map(
          _convertResultRowToDailyActivity,
        )
        .toList();
    return result;
  }

  Future<List<DailyActivity>> readLatestDailyActivitiesNextPage(
    DailyActivity previousPageEarliestDailyActivity,
  ) async {
    final selectResult =
        await connection.selectFromFunction('select_daily_activity', [
      previousPageEarliestDailyActivity.startTime,
      previousPageEarliestDailyActivity.id,
    ]);
    final result = selectResult
        .map(
          _convertResultRowToDailyActivity,
        )
        .toList();
    return result;
  }

  Future<DailyActivity?> readDailyActivityById(int id) async {
    final selectResult =
        await connection.selectFromFunction('select_daily_activity', [id]);
    if (selectResult.isEmpty) return null;
    return _convertResultRowToDailyActivity(selectResult.first);
  }

  String _convertDailyActivityAttributesToJson(
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
    }
    return value;
  }

  DailyActivity _convertResultRowToDailyActivity(ResultRow row) {
    return dailyActivityBuilder.buildDailyActivity(
      row[0] as int?,
      row[1]! as String,
      row[2]! as String,
      (row[3]! as DateTime).toLocal(),
      Duration(microseconds: (row[4]! as Interval).microseconds),
      row[5]! as Map<String, dynamic>,
    );
  }
}
