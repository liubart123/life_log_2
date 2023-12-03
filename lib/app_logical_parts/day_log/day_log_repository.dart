import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postgres_pool/postgres_pool.dart';

import 'package:life_log_2/app_logical_parts/day_log/day_log_data_provider.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/utils/DateTimeUtils.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

/// Provides high-level functions to interact with DayLogs from database
class DayLogRepository {
  DayLogRepository(this._dayLogDataProvider);

  final DayLogDataProvider _dayLogDataProvider;

  static const String _basicSelectQuery = '''
select 
	d.id, day_date, 
	TO_CHAR(sleep_start,'yyyy-MM-dd HH24:MI') sleep_start, 
	TO_CHAR(sleep_end,'yyyy-MM-dd HH24:MI') sleep_end, 
	TO_CHAR(sleep_time,'HH24:MI') sleep_time, 
	TO_CHAR(deep_sleep,'HH24:MI') deep_sleep, 
	notes,
    array_agg(t.tag_name) AS day_log_tag_ids
from day_log d left join day_log_tag t
	on d.id = t.day_log_id
''';
  static const String _basicSelectQueryEnding = '''
group by d.id
order by day_date desc
limit 5''';
  static const String _udpateDayLog = '''
  update day_log set 
    day_date = @day_date::date,
    sleep_start = TO_TIMESTAMP(@sleep_start, 'yyyy-MM-dd HH24:MI'),
    sleep_end = TO_TIMESTAMP(@sleep_end, 'yyyy-MM-dd HH24:MI'),
    deep_sleep = @deep_sleep::interval,
    notes = @notes
  where id = @id;''';

  /// Returns limited amount of days from DB orderd by date. If maxDateFilter is
  /// set then returns only days earlier then given date.
  Future<DayLogPageResult> getAllDayLogs({DateTime? maxDateFilter}) async {
    PostgreSQLResult results;
    await Future.delayed(const Duration(milliseconds: 500));
    if (maxDateFilter != null) {
      results = await _dayLogDataProvider.connectionPool.query(
        '$_basicSelectQuery where day_date < @maxDate $_basicSelectQueryEnding',
        substitutionValues: {
          'maxDate': stringifyDateTime(maxDateFilter, format: 'yyyy-MM-dd'),
        },
      );
    } else {
      results = await _dayLogDataProvider.connectionPool
          .query('$_basicSelectQuery $_basicSelectQueryEnding');
    }
    final resultedList = results.map(_parseDayLogFromRequest).toList();
    return DayLogPageResult(
      dayLogList: resultedList,
      noMorePagesToLoad: resultedList.length < 5,
    );
  }

  /// Returns dayLog with given id
  Future<DayLog?> getDayLog(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var result = await _dayLogDataProvider.connectionPool.query(
      '$_basicSelectQuery where d.id = @id $_basicSelectQueryEnding',
      substitutionValues: {
        'id': id,
      },
    );
    if (result.length != 1) return null;
    return _parseDayLogFromRequest(result.first);
  }

  DayLog _parseDayLogFromRequest(PostgreSQLResultRow sqlRow) {
    return DayLog(
        id: sqlRow[0] as int,
        date: sqlRow[1] as DateTime,
        sleepStartTime: parseDateTime(sqlRow[2] as String),
        sleepEndTime: parseDateTime(sqlRow[3] as String),
        sleepDuration: parseDuration(sqlRow[4] as String),
        deepSleepDuration: parseDuration(sqlRow[5] as String),
        notes: sqlRow[6] as String,
        tags: sqlRow[7] as List<String>);
  }

  /// Overrides all fields of DayLog in DB to those from [dayLogToUpload].
  /// [dayLogToUpload]'s ID is used to find appropriate record in DB
  Future<void> updateDayLog(DayLog dayLogToUpload) async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _dayLogDataProvider.connectionPool.execute(
      _udpateDayLog,
      substitutionValues: {
        'day_date': formatDate(dayLogToUpload.date),
        'sleep_start': formatTimestamp(dayLogToUpload.sleepStartTime),
        'sleep_end': formatTimestamp(dayLogToUpload.sleepEndTime),
        'deep_sleep': formatDuration(dayLogToUpload.deepSleepDuration),
        'notes': dayLogToUpload.notes,
        'id': dayLogToUpload.id,
      },
    );
  }
}

///Provides [DayLogRepository] to children widgets
class DayLogRepositoryProvider extends StatelessWidget {
  const DayLogRepositoryProvider({
    required Widget child,
    super.key,
  }) : _child = child;

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DayLogRepository(DayLogDataProvider()),
      child: _child,
    );
  }
}

class DayLogPageResult {
  DayLogPageResult({
    required this.dayLogList,
    required this.noMorePagesToLoad,
  });
  List<DayLog> dayLogList;
  bool noMorePagesToLoad;
}
