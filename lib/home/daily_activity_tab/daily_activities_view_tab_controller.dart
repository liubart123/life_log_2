import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/domain/daily_activity/repository/daily_activity_repository.dart';
import 'package:life_log_2/utils/controller/econtroller_state.dart';
import 'package:life_log_2/utils/log_utils.dart';
import 'package:mutex/mutex.dart';

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
  final _pageLoadingMutex = Mutex();

  Future<void> loadAndSetFirstDailyActivityListPage() async {
    MyLogger.controller2('$runtimeType loadAndSetFirstDailyActivityListPage');

    await _pageLoadingMutex.acquire();
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
      _pageLoadingMutex.release();
    }
  }

  Future<void> loadNextDailyActivityListPage() async {
    MyLogger.controller2('$runtimeType loadAndNextDailyActivityListPage');
    if (_pageLoadingMutex.isLocked) {
      MyLogger.controller2('$runtimeType pageLoadingMutex is locked - end function and don`t start new loading');
      return;
    }
    await _pageLoadingMutex.acquire();
    await Future.delayed(Duration(milliseconds: 1000));

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
      _pageLoadingMutex.release();
    }
  }
}
