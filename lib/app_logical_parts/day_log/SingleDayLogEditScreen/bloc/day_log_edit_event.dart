part of 'day_log_edit_bloc.dart';

class DayLogEditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadInitialDayLog extends DayLogEditEvent {}

final class FieldUpdate extends DayLogEditEvent {}

final class UpdateDayLogAfterEditing extends DayLogEditEvent {}

final class LoadDayLogAfterEditing extends DayLogEditEvent {}

final class DeleteDayLog extends DayLogEditEvent {}

final class AddTagToDayLog extends DayLogEditEvent {}
