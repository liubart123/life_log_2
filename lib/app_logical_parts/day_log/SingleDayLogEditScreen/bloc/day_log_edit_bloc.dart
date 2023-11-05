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
        DayLog? loadedDayLog = await dayLogRepository.GetDayLog(dayLogId);
        // throw new Exception('Day Log not found');
        if (loadedDayLog == null) throw new Exception('Not found');

        print("emiting CreateStateFromModel");
        emit(CreateStateFromModel(loadedDayLog));
      } catch (e) {
        print("emiting InitialLoadingError");
        emit(
          InitialLoadingError(
            e.toString(),
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
    // on<UpdateDayLogAfterEditing>((event, emit) async {
    //   print("UpdateDayLogAfterEditing - emiting LoadingOfDayLog");
    //   emit(LoadingOfDayLog(dayLogId: state.dayLogId, dayLog: state.dayLog));

    //   try {
    //     if (state.dayLog == null) {
    //       throw new Exception("State's dayLog is null");
    //     }

    //     await dayLogRepository.UpdateDayLog(state.dayLog!);
    //     DayLog? loadedDayLog = await dayLogRepository.GetDayLog(dayLogId);
    //     if (loadedDayLog == null) throw new Exception('Not found');

    //     print("UpdateDayLogAfterEditing - emiting IdleState");
    //     emit(
    //       IdleState(
    //         DateTime.now(),
    //         dayLogId: dayLogId,
    //         dayLog: loadedDayLog,
    //       ),
    //     );
    //   } catch (e) {
    //     print("UpdateDayLogAfterEditing - emiting ErrorReturnedState");
    //     emit(
    //       ErrorReturnedState(
    //         dayLogId: dayLogId,
    //         errorMessage: e.toString(),
    //       ),
    //     );
    //   }
    // });
  }
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
