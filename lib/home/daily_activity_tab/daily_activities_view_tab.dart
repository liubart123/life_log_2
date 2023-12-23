import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_tab_controller.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DailyActivitiesViewTab extends StatelessWidget {
  const DailyActivitiesViewTab({super.key});

  @override
  Widget build(BuildContext context) {
    MyLogger.widget1('$runtimeType build');
    return GetBuilder<DailyActivitiesViewTabController>(
      initState: (builderState) {
        MyLogger.widget2('$runtimeType initState');
        _initializeTabControllerAndAddInDI();
      },
      dispose: (state) {
        MyLogger.widget2('$runtimeType dispose');
      },
      builder: (controller) {
        return const Center(
          child: Icon(
            Icons.accessibility_rounded,
          ),
        );
      },
    );
  }

  void _initializeTabControllerAndAddInDI() {
    Get.lazyPut(() {
      MyLogger.widget1('$runtimeType creating controller...');
      final controller = DailyActivitiesViewTabController();
      return controller;
    });
  }
}
