// ignore_for_file: unused_import, prefer_single_quotes

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/day_log_edit_screen.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_list_tab/day_log_list_tab_controller.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_list_tab/tab_body_with_day_log_list.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/StringFormatters.dart';
import 'package:life_log_2/utils/controller_status.dart';
import 'package:life_log_2/utils/log_utils.dart';
import 'package:life_log_2/utils/my_snackbar.dart';
import 'package:loggy/loggy.dart';
import 'package:structures/structures.dart';

/// Pulls pages of DayLogs and displayis them as a scrollable list.
///
/// Autoloads next page on scrolling to the bottom.
/// Refreshes whole list on up-scrolling in top position.
class DayLogsViewTab extends StatelessWidget {
  const DayLogsViewTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DayLogsViewTabController>(
      initState: (builderState) {
        _initializeControllerIfNeed();
        _setEventHandlersOnController();
      },
      dispose: (state) {
        _dispouseEventHandlersFromController();
      },
      builder: (controller) {
        MyLogger.widget1(
          'DayLogsViewTab build. Controller state: ${controller.state}',
        );
        if (controller.state == EControllerState.initializing) {
          return _tabBodyForInitialLoadingState();
        } else if (controller.state == EControllerState.fatalError) {
          return _tabBodyForFatalErrorState();
        } else if (controller.dayLogList.isEmpty) {
          return _tabBodyForEmptyDayLogList();
        } else {
          return const TabBodyWithDayLogList();
        }
      },
    );
  }

  void _initializeControllerIfNeed() {
    Get.lazyPut(() {
      MyLogger.widget1('DayLogsViewTab initializing controller...');
      final controller = DayLogsViewTabController()..loadInitialPage();
      return controller;
    });
  }

  void _setEventHandlersOnController() {
    final controller = Get.find<DayLogsViewTabController>();
    MyLogger.widget1('DayLogsViewTab setting controller`s event handlers...');
    ever(
      controller.errorMessage,
      (newValue) {
        if (newValue.isNotEmpty) {
          MyLogger.widget2('error handled from controller: $newValue');
          showMyErrorSnackbar(newValue);
        }
      },
    );
  }

  void _dispouseEventHandlersFromController() {
    MyLogger.widget1('DayLogsViewTab disposing controller`s event handlers...');
    Get.find<DayLogsViewTabController>().errorMessage.close();
  }

  Widget _tabBodyForEmptyDayLogList() {
    final controller = Get.find<DayLogsViewTabController>();
    return LayoutBuilder(
      builder: (context, constraints) => RefreshIndicator(
        onRefresh: () async {
          await controller.resetDayLogListWithInitialPage();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const Center(
              child: Text("No Day Logs were found"),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabBodyForInitialLoadingState() {
    return const Center(
      child: MyProcessIndicator(),
    );
  }

  Widget _tabBodyForFatalErrorState() {
    final controller = Get.find<DayLogsViewTabController>();
    return LayoutBuilder(
      builder: (context, constraints) => RefreshIndicator(
        onRefresh: () async {
          await controller.resetDayLogListWithInitialPage();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.all(CARD_MARGIN),
              child: const Center(
                child: MyErrorMessage('Fatal error occurred'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
