import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/repository/daily_activity_repository.dart';
import 'package:life_log_2/home/daily_activity_tab/daily_activities_view_tab_controller.dart';
import 'package:life_log_2/utils/controller/econtroller_state.dart';
import 'package:life_log_2/utils/datetime/datetime_extension.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DailyActivityEditBottomSheetController extends GetxController {
  DailyActivityEditBottomSheetController(
    this.dailyActivity, {
    required this.repository,
    this.state = EControllerState.idle,
  });
  EControllerState state;
  DailyActivity dailyActivity;
  DailyActivityRepository repository;

  Future<void> saveDailyActivity() async {
    MyLogger.controller2('saving dailyActivity...');
    MyLogger.controller2('startTime to save:${dailyActivity.startTime.toTimeString()}');
    _updateState(EControllerState.processing);
    dailyActivity = await repository.saveAndReadUpdatedDailyActivity(dailyActivity);
    _updateState(EControllerState.idle);
    Get.find<DailyActivitiesViewTabController>().replaceDailyActivityById(dailyActivity);
  }

  void _updateState(EControllerState newState) {
    state = newState;
    update();
  }

  void updateStartDate(DateTime newDate) {
    dailyActivity.startTime = combinationOfDateAndTime(
      newDate,
      TimeOfDay.fromDateTime(dailyActivity.startTime),
    );
    update();
  }

  void updateStartTime(TimeOfDay newTime) {
    dailyActivity.startTime = combinationOfDateAndTime(
      dailyActivity.startTime,
      newTime,
    );
    update();
  }

  void updateDuration(Duration newDuration) {
    dailyActivity.duration = newDuration;
    update();
  }
}
