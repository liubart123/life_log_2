import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_theme.dart';
import 'package:life_log_2/home/home_tabs_screen.dart';
import 'package:life_log_2/utils/log_utils.dart';

void main() async {
  initializeEnvVariables();
  _initializeMainDependencies();
  runApp(const MyApp());
}

Future<void> initializeEnvVariables() async {
  await dotenv.load(fileName: '.env');
}

void _initializeMainDependencies() {
  MyLogger.widget1('RootWidget dependencies initializing...');
  throw UnimplementedError();
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
