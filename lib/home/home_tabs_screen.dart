import 'package:flutter/material.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_list_tab/day_log_list_tab.dart';
import 'package:life_log_2/utils/log_utils.dart';

/// Is used as home/main page. Displayes main application tabs
// todo: move to 'home' folder widgets that are use on HomeScreen
class HomeTabsScreen extends StatelessWidget {
  const HomeTabsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    MyLogger.widget1('$runtimeType build');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(
          context,
        ),
        //todo: move body widget to widget's helper
        body: TabBarView(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: const DayLogsViewTab(),
            ),
            const Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Theme.of(context).colorScheme.surface,
      title: Text(
        'Day Logs',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      bottom: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.directions_car)),
          Tab(icon: Icon(Icons.directions_transit)),
        ],
      ),
    );
  }
}
