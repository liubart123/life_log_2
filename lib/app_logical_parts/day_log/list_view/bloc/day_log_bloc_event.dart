part of 'day_log_bloc.dart';

@immutable
sealed class DayLogListTabBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

//todo:don't use initial loading and use usual loading instead
class LoadInitialPageOfDayLogs extends DayLogListTabBlocEvent {}

class ResetDayLogListWithRefreshedInitialPage extends DayLogListTabBlocEvent {}

class LoadNextPageOfDayLogs extends DayLogListTabBlocEvent {}
