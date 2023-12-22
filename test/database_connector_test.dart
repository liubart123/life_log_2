import 'package:flutter_test/flutter_test.dart';
import 'package:life_log_2/utils/data_access/database_connector.dart';

import 'test_utils.dart';

void main() async {
  await initializeTestEnvVariables();
  test('Basic database connection', () async {
    final connection =
        await DatabaseConnector.openDatabaseConnectionUsingEnvConnection();
    expect(connection.isOpen, true);
  });
}
