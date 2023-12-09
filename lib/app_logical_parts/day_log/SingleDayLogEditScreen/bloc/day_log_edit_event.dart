part of 'day_log_edit_bloc.dart';

class DayLogEditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadInitialDayLog extends DayLogEditEvent {}

final class ChangeFieldInDayLogForm<T> extends DayLogEditEvent {
  final MyInputResult<T> changedInput;
  final T newValue;

  ChangeFieldInDayLogForm(this.changedInput, this.newValue) : super();
}

final class SaveDayLog extends DayLogEditEvent {}
