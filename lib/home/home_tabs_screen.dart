import 'package:flutter/material.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_tab.dart';
import 'package:life_log_2/home/my_sandbox.dart';
import 'package:life_log_2/my_flutter_elements/my_tab.dart';
import 'package:life_log_2/utils/log_utils.dart';

/// Is used as home/main page. Displayes main application tabs
class HomeTabsScreen extends StatelessWidget {
  const HomeTabsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    MyLogger.widget1('$runtimeType build');
    return MyScaffoldWithTabController(
      tabs: [
        DailyActivitiesViewTabControlerChild(),
        MySandboxTabControllerChild(),
      ],
      appBarTitle: 'Guano title',
    );
  }
}
