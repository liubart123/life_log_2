import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DatabaseConnector {
  static Future<Connection> openDatabaseConnection() async {
    final conn = Connection.open(
      Endpoint(
        host: dotenv.get('HOST'),
        port: int.parse(dotenv.get('PORT')),
        database: dotenv.get('DATABASE'),
        username: dotenv.get('USERNAME'),
        password: dotenv.get('PASSWORD'),
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
    return conn;
  }
}
