import 'package:postgres_pool/postgres_pool.dart';

class DayLogDataProvider {
  final connectionPool = PgPool(
    PgEndpoint(
      // host: 'ep-shrill-wave-97089462.us-east-2.aws.neon.tech',
      // port: 5432,
      // database: 'neondb',
      // username: 'liubart7',
      // password: 'chZo12zBHnaN',
      // requireSsl: true,

      host: '192.168.0.104',
      port: 5433,
      database: 'mydatabase',
      username: 'myuser',
      password: 'mypassword',
      //requireSsl: true,
    ),
    settings: PgPoolSettings()
      ..maxConnectionAge = const Duration(hours: 1)
      ..concurrency = 4,
  );
}
