import 'package:flutter_test/flutter_test.dart';
import 'package:life_log_2/data_access/database_connector.dart';

void main() async {
  test('Basic database connection', () async {
    final connection = await MyDatabseConnector.openDatabaseConnection();
    expect(connection.isOpen, true);
  });
}
