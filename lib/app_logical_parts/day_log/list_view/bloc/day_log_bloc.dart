import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';

import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';

part 'day_log_bloc_event.dart';
part 'day_log_bloc_state.dart';

///Handles logic for tab with list of DayLogs
///
///Interacts with server to get pages of DayLogs.
class DayLogListTabBloc
    extends Bloc<DayLogListTabBlocEvent, DayLogListTabBlocState> {
  final DayLogRepository dayLogRepository;

  DayLogListTabBloc(
    this.dayLogRepository,
  ) : super(DayLogListTabBlocState()) {
    on<LoadInitialPageOfDayLogs>((event, emit) async {
      // state.dayLogList.clear();
      emit(LoadingPageOfDayLogs().copyState(state));
      try {
        var pageOfDayLogs = await dayLogRepository.getAllDayLogs();
        emit(IdleState().newList(pageOfDayLogs));
      } catch (ex) {
        emit(ErrorWithLoadingPageOfDayLogs(ex.toString()).copyState(state));
      }
    });
    //todo:handle case if new page is already loading, then we don't need to call for new page and need to wait for old request's response
    on<LoadNextPageOfDayLogs>((event, emit) async {
      emit(LoadingPageOfDayLogs().copyState(state));
      try {
        var pageOfDayLogs = await dayLogRepository.getAllDayLogs(
            maxDateFilter: state.dayLogList.last.date);
        emit(IdleState().copyState(state).copyList(pageOfDayLogs));
      } catch (ex) {
        emit(ErrorWithLoadingPageOfDayLogs(ex.toString()).copyState(state));
      }
    });
    on<ResetDayLogListWithRefreshedInitialPage>((event, emit) async {
      var pageOfDayLogs = await dayLogRepository.getAllDayLogs();
      emit(IdleState().newList(pageOfDayLogs));
    });
  }
}
