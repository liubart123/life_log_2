import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log//day_log_list_tab/day_log_list_tab.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/utils/controller_status.dart';
import 'package:loggy/loggy.dart';
import 'package:mutex/mutex.dart';

/// Controller for [DayLogListTab] widget.
///
/// Handles data for dayLog list, interaction with repositories.
class DayLogListTabController extends GetxController {
  String? errorMessage;
  List<DayLog> dayLogList = List.empty(growable: true);

  /// Semaphor to prevent multiple simultaneous loading of same pages.
  /// Is used for loading next pages.
  final pageIsLoadingMutex = Mutex();
  EControllerStatus status = EControllerStatus.initializing;
  late DayLogRepository repository;

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  Future<void> _initialize() async {
    repository = Get.find<DayLogRepository>();
    await _loadInitialPage();
  }

  Future<void> _loadInitialPage() async {
    logDebug('$runtimeType started loading of initial page...');
    try {
      resetStatus(EControllerStatus.initializing);
      update();

      await pageIsLoadingMutex.acquire();

      final pageOfDayLogs = await repository.getAllDayLogs();

      logDebug('$runtimeType finished loading of initial page');

      resetStatus(EControllerStatus.idle);
      dayLogList = pageOfDayLogs;
      update();
    } catch (ex) {
      resetStatus(EControllerStatus.majorError);
      errorMessage = ex.toString();
      update();
    } finally {
      pageIsLoadingMutex.release();
    }
  }

  /// Changes status to [EControllerStatus.processing] until new page is loaded.
  /// Then status is returned to [EControllerStatus.idle] and list of daylogs
  /// is updated with new page.
  Future<void> loadNextPage() async {
    logDebug('${runtimeType} started loading of next page...');
    if (pageIsLoadingMutex.isLocked) {
      logDebug(
          '${runtimeType} page loading is already in progress - don`t start new page loading');
      return;
    }
    try {
      resetStatus(EControllerStatus.processing);
      update();

      await pageIsLoadingMutex.acquire();

      final pageOfDayLogs = await repository.getAllDayLogs(
        maxDateFilter: dayLogList.last.date,
      );

      logDebug('$runtimeType finished loading of next page');

      resetStatus(EControllerStatus.idle);
      dayLogList.addAll(pageOfDayLogs);
      update();
    } catch (ex) {
      resetStatus(EControllerStatus.majorError);
      errorMessage = ex.toString();
      update();
    } finally {
      pageIsLoadingMutex.release();
    }
  }

  /// Changes status to [EControllerStatus.processing]
  /// until initial page is loaded.
  /// Then status is returned to [EControllerStatus.idle] and list of daylogs
  /// is reset to only dayLogs from loaded initial page.
  Future<void> resetDayLogListWithInitialPage() async {
    logDebug('${runtimeType} started reseting to initial page...');

    try {
      resetStatus(EControllerStatus.processing);
      update();

      await pageIsLoadingMutex.acquire();

      final pageOfDayLogs = await repository.getAllDayLogs();

      logDebug('$runtimeType finished reseting to initial page');

      resetStatus(EControllerStatus.idle);
      dayLogList = pageOfDayLogs;
      update();
    } catch (ex) {
      resetStatus(EControllerStatus.majorError);
      errorMessage = ex.toString();
      update();
    } finally {
      pageIsLoadingMutex.release();
    }
  }

  void resetStatus(EControllerStatus newStatus) {
    status = newStatus;
    errorMessage = '';
  }
}
