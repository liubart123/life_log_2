import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log//day_log_list_tab/day_log_list_tab.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/utils/controller_status.dart';
import 'package:life_log_2/utils/log_utils.dart';
import 'package:mutex/mutex.dart';

/// Controller for [DayLogsViewTab] widget.
///
/// Handles data for dayLog list, interaction with repositories.
class DayLogsViewTabController extends GetxController {
  DayLogsViewTabController() {
    MyLogger.controller1('$runtimeType constructor');
    repository = Get.find<DayLogRepository>();
  }

  List<DayLog> dayLogList = List.empty(growable: true);
  EControllerState state = EControllerState.initializing;
  final errorMessage = RxString('');
  bool noMorePagesToLoad = false;
  late DayLogRepository repository;

  /// Mutex to prevent multiple simultaneous loading of same pages.
  /// Is used for loading next pages.
  final pageLoadingInProcess = Mutex();

  Future<void> loadInitialPage({
    EControllerState stateDuringLoading = EControllerState.initializing,
  }) async {
    try {
      MyLogger.controller2('$runtimeType loading initial page...');
      await pageLoadingInProcess.acquire();
      resetStatusWithUpdate(stateDuringLoading);

      final pageOfDayLogs = await repository.getAllDayLogs();

      dayLogList = pageOfDayLogs.dayLogList;
      noMorePagesToLoad = pageOfDayLogs.noMorePagesToLoad;
      resetStatusWithUpdate(EControllerState.idle);
    } catch (ex) {
      MyLogger.error('$runtimeType initial page loading error:$ex');
      _setMinorError(ex.toString());
    } finally {
      MyLogger.controller2('$runtimeType loading initial page end.');
      pageLoadingInProcess.release();
    }
  }

  /// Changes status to [EControllerState.processing] until new page is loaded.
  /// Then status is returned to [EControllerState.idle] and list of daylogs
  /// is updated with new page.
  Future<void> loadNextPage() async {
    MyLogger.controller2('$runtimeType loading next page...');
    if (!_nextPageLoadingIsNeeded()) {
      return;
    } else {
      try {
        await pageLoadingInProcess.acquire();
        resetStatusWithUpdate(EControllerState.processing);

        final pageOfDayLogs = await repository.getAllDayLogs(
          maxDateFilter: dayLogList.last.date,
        );

        dayLogList.addAll(pageOfDayLogs.dayLogList);
        noMorePagesToLoad = pageOfDayLogs.noMorePagesToLoad;
        resetStatusWithUpdate(EControllerState.idle);
        _setMinorError('test error after loading next page');
      } catch (ex) {
        MyLogger.error('$runtimeType next page loading error:$ex');
        _setMinorError(ex.toString());
      } finally {
        MyLogger.controller2('$runtimeType loading next page end.');
        pageLoadingInProcess.release();
      }
    }
  }

  bool _nextPageLoadingIsNeeded() {
    if (noMorePagesToLoad) {
      MyLogger.controller2(
        '$runtimeType no more pages to load - don`t start new page loading',
      );
      return false;
    } else if (pageLoadingInProcess.isLocked) {
      MyLogger.controller2(
        '$runtimeType page loading is already in progress - don`t start new page loading',
      );
      return false;
    } else {
      return true;
    }
  }

  /// Changes status to [EControllerState.processing]
  /// until initial page is loaded.
  /// Then status is returned to [EControllerState.idle] and list of daylogs
  /// is reset to contain only dayLogs from loaded initial page.
  Future<void> resetDayLogListWithInitialPage() async {
    MyLogger.controller2(
      '$runtimeType reseting DayLogList with initial page...',
    );
    await loadInitialPage(stateDuringLoading: EControllerState.processing);
  }

  void resetStatus(EControllerState newStatus) {
    state = newStatus;
    errorMessage.value = '';
  }

  void resetStatusWithUpdate(EControllerState newStatus) {
    resetStatus(newStatus);
    update();
  }

  void _setMinorError(String message) {
    state = EControllerState.idle;
    errorMessage.value = message;
    update();
  }
}
