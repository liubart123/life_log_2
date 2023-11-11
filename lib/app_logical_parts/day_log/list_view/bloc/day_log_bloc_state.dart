part of 'day_log_bloc.dart';

class DayLogListTabBlocState extends Equatable {
  final List<DayLog> dayLogList = [];

  DayLogListTabBlocState copyState(DayLogListTabBlocState stateToCopy) {
    dayLogList.addAll(stateToCopy.dayLogList);
    return this;
  }

  DayLogListTabBlocState copyList(List<DayLog> newList) {
    dayLogList.addAll(newList);
    return this;
  }

  DayLogListTabBlocState newList(List<DayLog> newList) {
    dayLogList.clear();
    copyList(newList);
    return this;
  }

  @override
  List<Object?> get props => [dayLogList];
}

class LoadingPageOfDayLogs extends DayLogListTabBlocState {}

class IdleState extends DayLogListTabBlocState {}

class ErrorWithLoadingPageOfDayLogs extends DayLogListTabBlocState {
  final String? errorMessage;

  ErrorWithLoadingPageOfDayLogs(this.errorMessage);
}
