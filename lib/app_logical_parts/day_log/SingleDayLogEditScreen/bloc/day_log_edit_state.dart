part of 'day_log_edit_bloc.dart';

class DayLogEditState extends Equatable {
  final int? dayLogId;
  final MyInputResult<String> sleepStart;
  final MyInputResult<String> sleepEnd;
  final MyInputResult<String> sleepDuration;
  final MyInputResult<String> deepSleepDuration;
  final EInputFormStatus formStatus;

  const DayLogEditState({
    this.dayLogId,
    this.sleepStart = const MyInputResult(),
    this.sleepEnd = const MyInputResult(),
    this.sleepDuration = const MyInputResult(),
    this.deepSleepDuration = const MyInputResult(),
    this.formStatus = EInputFormStatus.initialLoading,
  });

  DayLogEditState copyWith({
    MyInputResult<String>? sleepStart,
    MyInputResult<String>? sleepEnd,
    MyInputResult<String>? sleepDuration,
    MyInputResult<String>? deepSleepDuration,
    EInputFormStatus? formStatus,
  }) {
    return DayLogEditState(
      dayLogId: 2,
      sleepStart: sleepStart ?? this.sleepStart,
      sleepEnd: sleepEnd ?? this.sleepEnd,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      deepSleepDuration: deepSleepDuration ?? this.deepSleepDuration,
    );
  }

  List<MyInputResult> GetInputsCollection() {
    return [sleepStart, sleepEnd, sleepDuration, deepSleepDuration];
  }

  @override
  List<Object> get props => [...GetInputsCollection(), formStatus];

  bool isValid() {
    return !GetInputsCollection().any((element) => !element.IsValid());
  }
}

class InitialLoadingError extends DayLogEditState {
  final String errorMessage;
  const InitialLoadingError(this.errorMessage);
}
