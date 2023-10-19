import 'package:life_log_2/utils/DateTimeUtils.dart';
import 'package:life_log_2/utils/StringFormatters.dart';
import 'package:postgres_pool/postgres_pool.dart';

import 'DayLogDataProvider.dart';
import 'DayLogModel.dart';

class DayLogRepository {
  final DayLogDataProvider dayLogDataProvider;

  DayLogRepository(this.dayLogDataProvider);

  static const String basicSelectQuery = '''
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
  static const String basicSelectQueryEnding = '''
group by d.id
order by day_date desc
limit 5''';
  static const String udpateDayLog = '''
  update day_log set 
    day_date = @day_date::date,
    sleep_start = TO_TIMESTAMP(@sleep_start, 'yyyy-MM-dd HH24:MI'),
    sleep_end = TO_TIMESTAMP(@sleep_end, 'yyyy-MM-dd HH24:MI'),
    deep_sleep = @deep_sleep::interval,
    notes = @notes
  where id = @id;''';

  /// Returns limited amount of days from DB orderd by date. If maxDateFilter is set then returns only days earlier then given date.
  Future<List<DayLog>> GetAllDayLogs({DateTime? maxDateFilter}) async {
    PostgreSQLResult results;
    await Future.delayed(Duration(milliseconds: 500));
    if (maxDateFilter != null) {
      results = await dayLogDataProvider.connectionPool.query(
        "$basicSelectQuery where day_date < @maxDate $basicSelectQueryEnding",
        substitutionValues: {
          'maxDate': stringifyDateTime(maxDateFilter, format: "yyyy-MM-dd"),
        },
      );
    } else {
      results = await dayLogDataProvider.connectionPool
          .query("$basicSelectQuery $basicSelectQueryEnding");
    }

    return results.map((e) => ParseDayLogFromRequest(e)).toList();
  }

  Future<DayLog?> GetDayLog(int id) async {
    await Future.delayed(Duration(milliseconds: 500));
    var result = await dayLogDataProvider.connectionPool.query(
      "$basicSelectQuery where d.id = @id $basicSelectQueryEnding",
      substitutionValues: {
        'id': id,
      },
    );
    if (result.length != 1) return null;
    return ParseDayLogFromRequest(result.first);
  }

  DayLog ParseDayLogFromRequest(PostgreSQLResultRow sqlRow) {
    return DayLog(
        id: sqlRow[0],
        date: sqlRow[1],
        sleepStartTime: parseDateTime(sqlRow[2]),
        sleepEndTime: parseDateTime(sqlRow[3]),
        sleepDuration: parseDuration(sqlRow[4]),
        deepSleepDuration: parseDuration(sqlRow[5]),
        notes: sqlRow[6],
        tags: sqlRow[7] as List<String>);
  }

  Future<void> UpdateDayLog(DayLog dayLogToUpload) async {
    await Future.delayed(Duration(milliseconds: 500));
    var result = await dayLogDataProvider.connectionPool.execute(
      udpateDayLog,
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
