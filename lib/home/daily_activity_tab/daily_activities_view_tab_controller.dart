import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/repository/daily_activity_repository.dart';
import 'package:life_log_2/utils/controller/econtroller_state.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DailyActivitiesViewTabController extends GetxController {
  DailyActivitiesViewTabController(
    this.repository, {
    this.controllerState = EControllerState.idle,
  }) {
    MyLogger.controller1('$runtimeType constructor');
  }

  DailyActivityRepository repository;
  EControllerState? controllerState;
  late List<DailyActivity> dailyActivityList = List.empty(growable: true);

  Future<void> loadAndSetFirstDailyActivityListPage() async {
    MyLogger.controller2('$runtimeType loadAndSetFirstDailyActivityListPage');

    controllerState = EControllerState.processing;
    update();

    try {
      final list = await repository.readLatestDailyActivities();
      await Future.delayed(const Duration(milliseconds: 15));
      dailyActivityList = list;
    } catch (e, stacktrace) {
      MyLogger.error('error loadAndSetFirstDailyActivityListPage: $e\n$stacktrace');
    } finally {
      controllerState = EControllerState.idle;
      update();
    }
  }

  Future<void> loadNextDailyActivityListPage() async {
    MyLogger.controller2('$runtimeType loadAndNextDailyActivityListPage');

    controllerState = EControllerState.processing;
    update();

    try {
      final nextPage = await repository.readLatestDailyActivitiesNextPage(
        dailyActivityList.last,
      );
      dailyActivityList.addAll(nextPage);
    } catch (e, stacktrace) {
      MyLogger.error('error loadAndNextDailyActivityListPage: $e\n$stacktrace');
    } finally {
      controllerState = EControllerState.idle;
      update();
    }
  }
}
