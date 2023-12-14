import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/app_theme.dart';
import 'package:life_log_2/data_access/database_connector.dart';
import 'package:life_log_2/home/home_tabs_screen.dart';
import 'package:life_log_2/utils/log_utils.dart';

void main() async {
  await initializeEnvVariables();
  await initializeDatabaseRelatedClassesForDI();
  runApp(const MyApp());
}

Future<void> initializeEnvVariables() async {
  await dotenv.load(fileName: '.env');
}

Future<void> initializeDatabaseRelatedClassesForDI() async {
  MyLogger.widget1('_initializeDatabaseRelatedClassesForDI...');

  final connection = await DatabaseConnector.openDatabaseConnection();
  final dayLogRepository = DayLogRepository(connection);

  Get.put(dayLogRepository);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MyLogger.testColors();
    MyLogger.widget1('RootWidget build');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: createAppTheme(context),
      home: const HomeTabsScreen(),
    );
  }
}
