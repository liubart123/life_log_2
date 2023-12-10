import 'package:postgres/postgres.dart';

class MyDatabseConnector {
  static Future<Connection> openDatabaseConnection() async {
    final conn = Connection.open(
      Endpoint(
        host: '192.168.0.102',
        port: 5433,
        database: 'mydatabase',
        username: 'myuser',
        password: 'mypassword',
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
    return conn;
  }
}
