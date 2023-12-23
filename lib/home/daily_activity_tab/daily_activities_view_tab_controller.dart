import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity.dart';
import 'package:life_log_2/utils/controller/econtroller_state.dart';
import 'package:life_log_2/utils/log_utils.dart';

class DailyActivitiesViewTabController extends GetxController {
  DailyActivitiesViewTabController({
    this.controllerState = EControllerState.idle,
  }) {
    MyLogger.controller1('$runtimeType constructor');
  }

  EControllerState? controllerState;
  late List<DailyActivity> dailyActivityList = List.empty(growable: true);
}
