import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_theme.dart';
import 'package:life_log_2/home/home_tabs_screen.dart';
import 'package:life_log_2/utils/log_utils.dart';

void main() async {
  await _initializeEnvVariables();
  await initializeDatabaseRelatedClassesForDI();
  runApp(const MyApp());
}

Future<void> _initializeEnvVariables() async {
  await dotenv.load(fileName: '.env');
}

Future<void> initializeDatabaseRelatedClassesForDI() async {
  MyLogger.debug('_initializeDatabaseRelatedClassesForDI...');
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
