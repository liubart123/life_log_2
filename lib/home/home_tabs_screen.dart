import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_tab.dart';
import 'package:life_log_2/home/my_sandbox.dart';
import 'package:life_log_2/utils/log_utils.dart';

/// Is used as home/main page. Displayes main application tabs
class HomeTabsScreen extends StatelessWidget {
  const HomeTabsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    MyLogger.widget1('$runtimeType build');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _appBar(
          context,
        ),
        body: _tabControllerBody(),
      ),
    );
  }

  TabBarView _tabControllerBody() {
    return TabBarView(
      children: [
        Container(
          color: Get.theme.colorScheme.surface,
          child: const Icon(Icons.error_outline_outlined),
        ),
        const DailyActivitiesViewTab(),
        Container(
          color: Get.theme.colorScheme.surface,
          child: const MySandbox(),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Get.theme.colorScheme.surface,
      title: Text(
        'Gavno App',
        style: Get.theme.textTheme.titleLarge,
      ),
      bottom: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.directions_car)),
          Tab(
            text: 'Daily Activity',
          ),
          Tab(
            text: 'Sandbox tab',
          ),
        ],
      ),
    );
  }
}
