part of 'day_log_bloc.dart';

class DayLogViewListBlocState extends Equatable {
  final List<DayLog> dayLogList = [];

  DayLogViewListBlocState copyState(DayLogViewListBlocState stateToCopy) {
    dayLogList.addAll(stateToCopy.dayLogList);
    return this;
  }

  DayLogViewListBlocState copyList(List<DayLog> newList) {
    dayLogList.addAll(newList);
    return this;
  }

  @override
  List<Object?> get props => [dayLogList];
}

class LoadingPageOfDayLogs extends DayLogViewListBlocState {}

class IdleState extends DayLogViewListBlocState {}

class ErrorWithLoadingPageOfDayLogs extends DayLogViewListBlocState {
  final String? errorMessage;

  ErrorWithLoadingPageOfDayLogs(this.errorMessage);
}
