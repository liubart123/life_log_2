import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/utils/log_utils.dart';

abstract class MyTabControllerChild {
  Widget buildTabBody();
  Tab buildTabBarIcon();
  Widget? buildTabFABs();
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
            // floatingActionButton: _ScaffoldWithTabsFABs(tabs:tabs, context: defaultControllerContext),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
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
}

class _ScaffoldWithTabsFABs extends StatelessWidget {
  const _ScaffoldWithTabsFABs({
    super.key,
    required this.tabs,
    required this.context,
  });

  final List<MyTabControllerChild> tabs;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    // tabController.addListener(() {
    //   if (!tabController.indexIsChanging) {
    //     MyLogger.debug('tab index was changed');
    //   }
    // });
    final currentTabFABs = tabs[tabController.index].buildTabFABs() ?? Container();
    return currentTabFABs;
  }
}
