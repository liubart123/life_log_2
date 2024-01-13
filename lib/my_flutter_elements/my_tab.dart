import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/utils/log_utils.dart';

abstract class MyTabControllerChild {
  Widget buildTabBody();
  Tab buildTabBarIcon();
  Widget? buildTabFAB(BuildContext context);
}

class MyScaffoldWithTabController extends StatelessWidget {
  const MyScaffoldWithTabController({
    required this.tabs,
    required this.appBarTitle,
    super.key,
  });
  final List<MyTabControllerChild> tabs;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    MyLogger.widget1('$runtimeType build');
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (defaultControllerContext) {
          return Scaffold(
            appBar: _appBar(defaultControllerContext),
            body: _tabControllerBody(defaultControllerContext),
            floatingActionButton: _tabControllerFABs(defaultControllerContext),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      scrolledUnderElevation: 1,
      shadowColor: Get.theme.colorScheme.surface,
      title: Text(
        appBarTitle,
        style: Get.theme.textTheme.titleLarge,
      ),
      bottom: TabBar(
        tabs: tabs.map((e) => e.buildTabBarIcon()).toList(),
      ),
    );
  }

  TabBarView _tabControllerBody(BuildContext context) {
    return TabBarView(
      children: tabs.map((e) => e.buildTabBody()).toList(),
    );
  }

  Widget _tabControllerFABs(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [...tabs.map((e) => e.buildTabFAB(context)).nonNulls],
    );
  }
}
