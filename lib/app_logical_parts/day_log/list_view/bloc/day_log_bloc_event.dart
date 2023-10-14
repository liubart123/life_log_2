part of 'day_log_bloc.dart';

@immutable
sealed class DayLogViewListBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInitialPageOfDayLogs extends DayLogViewListBlocEvent {}

class LoadNextPageOfDayLogs extends DayLogViewListBlocEvent {}
