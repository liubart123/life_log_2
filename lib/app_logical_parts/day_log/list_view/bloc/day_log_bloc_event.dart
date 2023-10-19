part of 'day_log_bloc.dart';

@immutable
sealed class DayLogViewListBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInitialPageOfDayLogs extends DayLogViewListBlocEvent {}

class RefreshInitialPageOfDayLogs extends DayLogViewListBlocEvent {
  final List<DayLog> dayLogList;
  RefreshInitialPageOfDayLogs({
    required this.dayLogList,
  });
  List<Object?> get props => [dayLogList];
}

class LoadNextPageOfDayLogs extends DayLogViewListBlocEvent {}
