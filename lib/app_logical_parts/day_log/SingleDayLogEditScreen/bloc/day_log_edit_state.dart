part of 'day_log_edit_bloc.dart';

class DayLogEditState extends Equatable {
  final int dayLogId;
  final DayLog? dayLog;

  DayLogEditState({
    required this.dayLogId,
    this.dayLog,
  });

  @override
  List<Object> get props => [dayLogId, dayLog ?? {}];
}

final class InitialLoadingOfDayLog extends DayLogEditState {
  InitialLoadingOfDayLog({required super.dayLogId});
}

final class LoadingOfDayLog extends DayLogEditState {
  LoadingOfDayLog({required super.dayLogId, super.dayLog});
}

final class IdleState extends DayLogEditState {
  final DateTime lastUpdate;
  IdleState(this.lastUpdate, {required super.dayLogId, required super.dayLog});

  @override
  List<Object> get props => [dayLogId, dayLog ?? {}, lastUpdate];
}

final class ErrorReturnedState extends DayLogEditState {
  final String? errorMessage;

  ErrorReturnedState({
    this.errorMessage,
    required super.dayLogId,
  });
}
