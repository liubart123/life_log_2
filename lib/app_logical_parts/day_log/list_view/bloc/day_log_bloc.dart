import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogModel.dart';

import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';

part 'day_log_bloc_event.dart';
part 'day_log_bloc_state.dart';

class DayLogViewListBloc
    extends Bloc<DayLogViewListBlocEvent, DayLogViewListBlocState> {
  final DayLogRepository dayLogRepository;

  DayLogViewListBloc(
    this.dayLogRepository,
  ) : super(DayLogViewListBlocState()) {
    on<LoadInitialPageOfDayLogs>((event, emit) async {
      // state.dayLogList.clear();
      emit(LoadingPageOfDayLogs().copyState(state));
      try {
        var pageOfDayLogs = await dayLogRepository.GetAllDayLogs();
        emit(IdleState().newList(pageOfDayLogs));
      } catch (ex) {
        emit(ErrorWithLoadingPageOfDayLogs(ex.toString()).copyState(state));
      }
    });
    //todo:handle case if new page is already loading, then we don't need to call for new page and need to wait for old request's response
    on<LoadNextPageOfDayLogs>((event, emit) async {
      emit(LoadingPageOfDayLogs().copyState(state));
      try {
        var pageOfDayLogs = await dayLogRepository.GetAllDayLogs(
            maxDateFilter: state.dayLogList.last.date);
        emit(IdleState().copyState(state).copyList(pageOfDayLogs));
      } catch (ex) {
        emit(ErrorWithLoadingPageOfDayLogs(ex.toString()).copyState(state));
      }
    });
    on<RefreshInitialPageOfDayLogs>((event, emit) async {
      var pageOfDayLogs = await dayLogRepository.GetAllDayLogs();
      emit(IdleState().newList(pageOfDayLogs));
    });
  }
}
