import 'package:life_log_2/utils/data_access/database_datatypes_converting.dart';
import 'package:postgres/postgres.dart';

dynamic _convertDynamicObjectToDatabaseObject(dynamic input) {
  if (input is Duration) {
    return convertDurationToPostgresString(input);
  } else if (input is DateTime) {
    return input;
  }
  return input;
}

extension DatabaseConnectionExtension on Connection {
  Future<Result> callProcedure(
    String procedureName,
    Iterable<dynamic> parameters,
  ) async {
    final parametersPlaceholders =
        List.filled(parameters.length, '@').join(',');
    final resultedQuery = 'call $procedureName($parametersPlaceholders);';
    final processedParameters =
        parameters.map(_convertDynamicObjectToDatabaseObject).toList();

    final result = await execute(
      Sql.indexed(resultedQuery),
      parameters: processedParameters,
    );
    return result;
  }

  Future<Result> selectFromFunction(
    String functionName,
    Iterable<dynamic> parameters,
  ) async {
    final parametersPlaceholders =
        List.filled(parameters.length, '@').join(',');
    final resultedQuery =
        'select * from $functionName($parametersPlaceholders);';
    final processedParameters =
        parameters.map(_convertDynamicObjectToDatabaseObject).toList();

    final records = await execute(
      Sql.indexed(resultedQuery),
      parameters: processedParameters,
    );
    return records;
  }
}
