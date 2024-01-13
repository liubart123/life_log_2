import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_theme.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_categories_configuration.dart';
import 'package:life_log_2/domain/daily_activity/repository/daily_activity_repository.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_tab_controller.dart';
import 'package:life_log_2/home/home_tabs_screen.dart';
import 'package:life_log_2/utils/data_access/database_connector.dart';
import 'package:life_log_2/utils/log_utils.dart';

void main() async {
  await _initializeEnvVariables();
  await initializeDependencies();
  runApp(const MyApp());
}

Future<void> _initializeEnvVariables() async {
  await dotenv.load(fileName: '.env');
}

Future<void> initializeDependencies() async {
  await initializeDatabaseConnectionDependencies();
  await initializeDependenciesForDailyActivity();
}

Future<void> initializeDatabaseConnectionDependencies() async {
  MyLogger.debug('_initializeDatabaseRelatedClassesForDI...');

  final connection = await DatabaseConnector.openDatabaseConnectionUsingEnvConfiguration();
  Get.put(connection);
}

Future<void> initializeDependenciesForDailyActivity() async {
  final dailyActivityConfiguration = DailyActivityCategoriesConfiguration();
  Get.put(dailyActivityConfiguration);

  final dailyActivityRepository = DailyActivityRepository(
    Get.find(),
    dailyActivityConfiguration,
  );
  Get.put(dailyActivityRepository);
  Get.put(DailyActivitiesViewTabController(dailyActivityRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MyLogger.testColors();
    MyLogger.widget1('MyApp widget build');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: createAppTheme(context),
      home: const HomeTabsScreen(),
    );
  }
}
