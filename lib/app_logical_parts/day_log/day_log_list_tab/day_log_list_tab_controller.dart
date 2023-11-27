import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log//day_log_list_tab/day_log_list_tab.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/utils/controller_status.dart';
import 'package:loggy/loggy.dart';
import 'package:mutex/mutex.dart';

/// Controller for [DayLogsViewTab] widget.
///
/// Handles data for dayLog list, interaction with repositories.
class DayLogsViewTabController extends GetxController {
  final errorMessage = RxString('');
  List<DayLog> dayLogList = List.empty(growable: true);
  bool noMorePagesToLoad = false;

  static DayLogsViewTabController get to => Get.find();

  /// Semaphor to prevent multiple simultaneous loading of same pages.
  /// Is used for loading next pages.
  final pageIsLoadingMutex = Mutex();
  EControllerState state = EControllerState.initializing;
  late DayLogRepository repository;

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  void _initialize() {
    repository = Get.find<DayLogRepository>();
    //todo: move it to controller's initialization
    loadInitialPage();
  }

  Future<void> loadInitialPage({
    EControllerState stateDuringLoading = EControllerState.initializing,
  }) async {
    try {
      await pageIsLoadingMutex.acquire();
      logDebug('$runtimeType initial page loading start');
      resetStatusWithUpdate(stateDuringLoading);

      final pageOfDayLogs = await repository.getAllDayLogs();

      resetStatus(EControllerState.idle);
      dayLogList = pageOfDayLogs.dayLogList;
      noMorePagesToLoad = pageOfDayLogs.noMorePagesToLoad;
      update();
    } catch (ex) {
      logDebug('$runtimeType initial page loading error:$ex');
      _setMinorError(ex.toString());
    } finally {
      logDebug('$runtimeType initial page loading end');
      pageIsLoadingMutex.release();
    }
  }

  /// Changes status to [EControllerState.processing] until new page is loaded.
  /// Then status is returned to [EControllerState.idle] and list of daylogs
  /// is updated with new page.
  Future<void> loadNextPage() async {
    if (noMorePagesToLoad) {
      logDebug(
        '$runtimeType no more pages to load - don`t start new page loading',
      );
      return;
    } else if (pageIsLoadingMutex.isLocked) {
      logDebug(
        '$runtimeType page loading is already in progress - don`t start new page loading',
      );
      return;
    } else {
      try {
        await pageIsLoadingMutex.acquire();
        logDebug('$runtimeType page loading start');
        resetStatusWithUpdate(EControllerState.processing);

        final pageOfDayLogs = await repository.getAllDayLogs(
          maxDateFilter: dayLogList.last.date,
        );

        resetStatus(EControllerState.idle);
        dayLogList.addAll(pageOfDayLogs.dayLogList);
        noMorePagesToLoad = pageOfDayLogs.noMorePagesToLoad;
        update();
      } catch (ex) {
        logDebug('$runtimeType page loading error:$ex');
        _setMinorError(ex.toString());
      } finally {
        logDebug('$runtimeType page loading end');
        pageIsLoadingMutex.release();
      }
    }
  }

  /// Changes status to [EControllerState.processing]
  /// until initial page is loaded.
  /// Then status is returned to [EControllerState.idle] and list of daylogs
  /// is reset to contain only dayLogs from loaded initial page.
  Future<void> resetDayLogListWithInitialPage() async {
    logDebug('$runtimeType started reseting to initial page...');
    await loadInitialPage(stateDuringLoading: EControllerState.processing);
  }

  void resetStatus(EControllerState newStatus) {
    state = newStatus;
    errorMessage.value = '';
    noMorePagesToLoad = false;
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
