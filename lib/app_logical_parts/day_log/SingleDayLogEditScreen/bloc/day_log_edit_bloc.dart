import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogModel.dart';

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
          InitialLoadingOfDayLog(
            dayLogId: dayLogId,
          ),
        ) {
    on<LoadInitialDayLog>((event, emit) async {
      print("LoadInitialDayLog - emiting InitialLoadingOfDayLog");
      emit(InitialLoadingOfDayLog(dayLogId: dayLogId));
      try {
        DayLog? loadedDayLog = await dayLogRepository.GetDayLog(dayLogId);
        if (loadedDayLog == null) throw new Exception('Not found');

        print("LoadInitialDayLog - emiting IdleState");
        emit(
          IdleState(DateTime.now(), dayLogId: dayLogId, dayLog: loadedDayLog),
        );
      } catch (e) {
        print("LoadInitialDayLog - emiting ErrorReturnedState");
        emit(
          ErrorReturnedState(
            dayLogId: dayLogId,
            errorMessage: e.toString(),
          ),
        );
      }
    });
    on<FieldUpdate>((event, emit) async {
      print("FieldUpdate - emiting IdleState");
      if (state is IdleState) {
        emit(
          IdleState(
            DateTime.now(),
            dayLogId: dayLogId,
            dayLog: state.dayLog,
          ),
        );
      }
    });
    on<UpdateDayLogAfterEditing>((event, emit) async {
      print("UpdateDayLogAfterEditing - emiting LoadingOfDayLog");
      emit(LoadingOfDayLog(dayLogId: state.dayLogId, dayLog: state.dayLog));

      try {
        if (state.dayLog == null) {
          throw new Exception("State's dayLog is null");
        }

        await dayLogRepository.UpdateDayLog(state.dayLog!);
        DayLog? loadedDayLog = await dayLogRepository.GetDayLog(dayLogId);
        if (loadedDayLog == null) throw new Exception('Not found');

        print("UpdateDayLogAfterEditing - emiting IdleState");
        emit(
          IdleState(
            DateTime.now(),
            dayLogId: dayLogId,
            dayLog: loadedDayLog,
          ),
        );
      } catch (e) {
        print("UpdateDayLogAfterEditing - emiting ErrorReturnedState");
        emit(
          ErrorReturnedState(
            dayLogId: dayLogId,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
