part of 'day_log_bloc.dart';

class DayLogBlocState extends Equatable {
  final List<DayLog> dayLogList = [];

  DayLogBlocState copyState(DayLogBlocState stateToCopy) {
    dayLogList.addAll(stateToCopy.dayLogList);
    return this;
  }

  DayLogBlocState copyList(List<DayLog> newList) {
    dayLogList.addAll(newList);
    return this;
  }

  @override
  List<Object?> get props => [dayLogList];
}

class LoadingPageOfDayLogs extends DayLogBlocState {}

class IdleState extends DayLogBlocState {}

class ErrorWithLoadingPageOfDayLogs extends DayLogBlocState {
  final String? errorMessage;

  ErrorWithLoadingPageOfDayLogs(this.errorMessage);
}
