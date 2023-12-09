import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_data_provider.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/app_theme.dart';
import 'package:life_log_2/home/home_tabs_screen.dart';
import 'package:life_log_2/utils/log_utils.dart';
import 'package:loggy/loggy.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(),
  );
  // debugRepaintRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MyLogger.testColors();
    MyLogger.widget1('RootWidget build');
    _initializeMainDependencies();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: createAppTheme(context),
      home: const HomeTabsScreen(),
    );
  }

  void _initializeMainDependencies() {
    MyLogger.widget1('RootWidget dependencies initializing...');
    final dayLogDataProvider = Get.put(DayLogDataProvider());
    Get.put(DayLogRepository(dayLogDataProvider));
  }
}
