part of 'day_log_bloc.dart';

@immutable
sealed class DayLogBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInitialPageOfDayLogs extends DayLogBlocEvent {}

class LoadNextPageOfDayLogs extends DayLogBlocEvent {}
