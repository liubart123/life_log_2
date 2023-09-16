import 'package:life_log_2/utils/DateTimeUtils.dart';
import 'package:postgres_pool/postgres_pool.dart';

import 'DayLogDataProvider.dart';
import 'DayLogModel.dart';

class DayLogRepository {
  final DayLogDataProvider dayLogDataProvider;

  DayLogRepository(this.dayLogDataProvider);

  static const String basicSelectQuery = '''
select 
	id, day_date, 
	TO_CHAR(sleep_start,'yyyy-MM-dd HH24:MI') sleep_start, 
	TO_CHAR(sleep_end,'yyyy-MM-dd HH24:MI') sleep_end, 
	TO_CHAR(sleep_time,'HH24:MI') sleep_time, 
	TO_CHAR(deep_sleep,'HH24:MI') deep_sleep, 
	notes 
from day_log''';

  /// Returns limited amount of days from DB orderd by date. If maxDateFilter is set then returns only days earlier then given date.
  Future<List<DayLog>> GetAllDayLogs({DateTime? maxDateFilter}) async {
    PostgreSQLResult results;
    await Future.delayed(Duration(milliseconds: 1500));
    if (maxDateFilter != null) {
      results = await dayLogDataProvider.connectionPool.query(
        "$basicSelectQuery where day_date < '@maxDate' order by day_date desc limit 5",
        substitutionValues: {
          'maxDate': stringifyDateTime(maxDateFilter, format: "yyyy-MM-dd"),
        },
      );
    } else {
      results = await dayLogDataProvider.connectionPool
          .query("$basicSelectQuery order by day_date limit 5");
    }

    return results.map((e) => ParseDayLogFromRequest(e)).toList();
  }

  Future<DayLog?> GetDayLog(int id) async {
    var result = await dayLogDataProvider.connectionPool.query(
      "$basicSelectQuery where id = @id",
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
        tags: []);
  }
}
