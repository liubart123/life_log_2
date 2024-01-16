import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/home/daily_activity_edit_bottom_sheet/daily_activity_edit_bottom_sheet.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_scrollable_list_tab_body/daily_activities_view_scrollable_list_tab_body.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_tab_controller.dart';
import 'package:life_log_2/my_flutter_elements/my_modal_bottom_sheet.dart';
import 'package:life_log_2/my_flutter_elements/my_tab.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';
import 'package:life_log_2/utils/controller/econtroller_state.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DailyActivitiesViewTabControlerChild extends MyTabControllerChild {
  @override
  Tab buildTabBarIcon() {
    return const Tab(
      text: 'Daily Activity',
    );
  }

  @override
  Widget buildTabBody() {
    return const DailyActivitiesViewTab();
  }

  @override
  Widget? buildTabFAB(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color.lerp(
        Get.theme.colorScheme.surface,
        Get.theme.colorScheme.primary,
        0.1,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          14,
        ),
      ),
      onPressed: () {
        final controller = Get.find<DailyActivitiesViewTabController>();
        showMyModalBottomSheet(
          context,
          DailyActivityEditBottomSheet(
            controller.dailyActivityList.first,
          ),
        );
      },
      child: const Icon(Icons.add_reaction),
    );
  }
}

class DailyActivitiesViewTab extends StatefulWidget {
  const DailyActivitiesViewTab({super.key});

  @override
  State<DailyActivitiesViewTab> createState() => _DailyActivitiesViewTabState();
}

class _DailyActivitiesViewTabState extends State<DailyActivitiesViewTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DailyActivitiesViewTabController>(
      initState: (builderState) {
        MyLogger.widget1('$runtimeType initState');
        _initializeControllerState();
      },
      dispose: (state) {
        MyLogger.widget1('$runtimeType dispose');
      },
      builder: (controller) {
        MyLogger.widget2('$runtimeType build. Controller state:${controller.controllerState}');
        if (controller.dailyActivityList.isEmpty) {
          if (controller.controllerState == EControllerState.idle) {
            return _emptyActivitiesListTextTabBody();
          } else if (controller.controllerState == EControllerState.processing) {
            return _loadingIndicatorTabBody();
          }
        } else {
          return const DailyActivitiesViewScrollableListTabBody();
        }
        throw UnimplementedError('incorrect controller state');
      },
    );
  }

  void _initializeControllerState() {
    MyLogger.widget1('$runtimeType _InitializeControllerState...');
    final controller = Get.find<DailyActivitiesViewTabController>();
    if (controller.controllerState == EControllerState.idle && controller.dailyActivityList.isEmpty) {
      controller.loadAndSetFirstDailyActivityListPage();
    }
  }

  Widget _loadingIndicatorTabBody() {
    return const Center(
      child: MyProcessIndicator(),
    );
  }

  Widget _emptyActivitiesListTextTabBody() {
    return const Center(
      child: Text('Daily Activities list is empty.'),
    );
  }
}
