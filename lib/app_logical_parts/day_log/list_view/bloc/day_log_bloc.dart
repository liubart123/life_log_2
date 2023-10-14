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
      state.dayLogList.clear();
      emit(LoadingPageOfDayLogs());
      try {
        var pageOfDayLogs = await dayLogRepository.GetAllDayLogs();
        emit(IdleState().copyList(pageOfDayLogs));
      } catch (ex) {
        emit(ErrorWithLoadingPageOfDayLogs(ex.toString()).copyState(state));
      }
    });
    on<LoadNextPageOfDayLogs>((event, emit) async {
      emit(LoadingPageOfDayLogs().copyState(state));
      try {
        var pageOfDayLogs = await dayLogRepository.GetAllDayLogs();
        emit(IdleState().copyState(state).copyList(pageOfDayLogs));
      } catch (ex) {
        emit(ErrorWithLoadingPageOfDayLogs(ex.toString()).copyState(state));
      }
    });
  }
}
