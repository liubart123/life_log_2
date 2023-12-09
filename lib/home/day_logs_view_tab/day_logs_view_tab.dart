// ignore_for_file: unused_import, prefer_single_quotes

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/day_log_edit_screen.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/home/day_logs_view_tab/day_logs_list_tab_body/day_logs_list_tab_body.dart';
import 'package:life_log_2/home/day_logs_view_tab/day_logs_view_tab_controller.dart';
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
        _initializeControllerIfNeeded();
        _setEventHandlersOnController();
      },
      dispose: (state) {
        _dispouseEventHandlersFromController();
      },
      builder: (controller) {
        //todo:sometimes I see this message 2 times on first loading of the tab with initializing status
        MyLogger.widget1(
          '$runtimeType build. Controller state: ${controller.state}',
        );
        if (controller.state == EControllerState.initializing) {
          return _initialLoadingStateTabBody();
        } else if (controller.state == EControllerState.fatalError) {
          return _fatalErrorStateTabBody();
        } else if (controller.dayLogList.isEmpty) {
          return _emptyDayLogListTabBody();
        } else {
          return const DayLogsListTabBody();
        }
      },
    );
  }

  void _initializeControllerIfNeeded() {
    Get.lazyPut(() {
      MyLogger.widget1('$runtimeType creating controller...');
      final controller = DayLogsViewTabController()..loadInitialPage();
      return controller;
    });
  }

  void _setEventHandlersOnController() {
    final controller = Get.find<DayLogsViewTabController>();
    MyLogger.widget1('$runtimeType setting controller`s event handlers...');
    controller.onErrorCallback.add(_errorMessageHandler);
  }

  void _dispouseEventHandlersFromController() {
    final controller = Get.find<DayLogsViewTabController>();
    MyLogger.widget1('$runtimeType disposing controller`s event handlers...');
    controller.onErrorCallback.remove(_errorMessageHandler);
  }

  void _errorMessageHandler(String errorMessage) {
    if (errorMessage.isNotEmpty) {
      MyLogger.widget2(
          '$runtimeType error handled from controller: $errorMessage');
      showMyErrorSnackbar(errorMessage);
    }
  }

  Widget _emptyDayLogListTabBody() {
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

  Widget _initialLoadingStateTabBody() {
    return const Center(
      child: MyProcessIndicator(),
    );
  }

  Widget _fatalErrorStateTabBody() {
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
