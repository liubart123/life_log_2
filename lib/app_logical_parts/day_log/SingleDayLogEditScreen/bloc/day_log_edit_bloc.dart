import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogModel.dart';
import 'package:life_log_2/utils/InputForm.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

import '../../DayLogRepository.dart';

part 'day_log_edit_event.dart';
part 'day_log_edit_state.dart';

class DayLogEditBloc extends Bloc<DayLogEditEvent, DayLogEditState> {
  final DayLogRepository dayLogRepository;
  final int dayLogId;
  DayLog? dayLog;

  DayLogEditBloc(
    this.dayLogRepository,
    this.dayLogId,
  ) : super(
          DayLogEditState(
            dayLogId: dayLogId,
          ),
        ) {
    on<LoadInitialDayLog>((event, emit) async {
      print("event LoadInitialDayLog");
      print("emiting empty DayLogEditState");
      emit(DayLogEditState(
        dayLogId: dayLogId,
        formStatus: EInputFormStatus.initialLoading,
      ));
      // await Future.delayed(Duration(milliseconds: 3000));
      try {
        await LoadModelFromDb(emit);
      } catch (e) {
        print("emiting LoadingError");
        emit(
          ErrorState(
            e.toString(),
            isFatal: true,
          ),
        );
      }
    });
    on<ChangeFieldInDayLogForm>((event, emit) async {
      print("event ChangeFieldInDayLogForm");
      print("emit appropriate ");
      EInputFormStatus status = EInputFormStatus.idleDirty;
      if (event.changedInput == state.sleepStart) {
        emit(state.copyWith(
            sleepStart: MyInputResult(value: event.newValue),
            formStatus: status));
      } else if (event.changedInput == state.sleepEnd) {
        emit(state.copyWith(
            sleepEnd: MyInputResult(value: event.newValue),
            formStatus: status));
      } else if (event.changedInput == state.sleepDuration) {
        emit(state.copyWith(
            sleepDuration: MyInputResult(value: event.newValue),
            formStatus: status));
      } else if (event.changedInput == state.deepSleepDuration) {
        emit(state.copyWith(
            deepSleepDuration: MyInputResult(value: event.newValue),
            formStatus: status));
      }
    });
    on<SaveDayLog>((event, emit) async {
      print("SaveDayLog");
      emit(state.copyWith(formStatus: EInputFormStatus.loading));

      try {
        await dayLogRepository.UpdateDayLog(CreateModelFromState(state));
        await LoadModelFromDb(emit);
      } catch (e) {
        print("emiting LoadingError");
        emit(
          ErrorState(
            e.toString(),
          ),
        );
      }
    });
  }

  Future<void> LoadModelFromDb(Emitter<DayLogEditState> emit) async {
    DayLog? loadedDayLog = await dayLogRepository.GetDayLog(dayLogId);
    // throw new Exception('Day Log not found');
    if (loadedDayLog == null) throw new Exception('Not found');

    dayLog = loadedDayLog;
    print("emiting CreateStateFromModel");
    emit(CreateStateFromModel(loadedDayLog));
  }

  DayLogEditState CreateStateFromModel(DayLog model) {
    return DayLogEditState(
      dayLogId: model.id,
      sleepStart: MyInputResult(value: model.sleepStartTime),
      sleepEnd: MyInputResult(value: model.sleepEndTime),
      sleepDuration: MyInputResult(value: model.sleepDuration),
      deepSleepDuration: MyInputResult(value: model.deepSleepDuration),
      formStatus: EInputFormStatus.idleRelevant,
    );
  }

  DayLog CreateModelFromState(DayLogEditState state) {
    if (dayLog == null) throw Exception("Trying to update null dayLog");
    var result = DayLog(
        id: dayLog!.id,
        date: dayLog!.date,
        sleepStartTime: state.sleepStart.value!,
        sleepEndTime: state.sleepEnd.value,
        sleepDuration: state.sleepDuration.value,
        deepSleepDuration: state.deepSleepDuration.value,
        notes: dayLog!.notes,
        tags: dayLog!.tags);
    return result;
  }
}
