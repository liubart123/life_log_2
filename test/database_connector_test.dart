import 'package:flutter_test/flutter_test.dart';
import 'package:life_log_2/data_access/database_connector.dart';
import 'package:life_log_2/main.dart';

void main() async {
  await initializeEnvVariables();
  test('Basic database connection', () async {
    final connection = await MyDatabseConnector.openDatabaseConnection();
    expect(connection.isOpen, true);
  });
}
