import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/bloc/day_log_edit_bloc.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_repository.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_input_widgets.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/InputForm.dart';
import 'package:loggy/loggy.dart';

/// Provides full-screen page for editing DayLog with given [dayLogId]
class DayLogEditPage extends StatelessWidget {
  const DayLogEditPage({
    required this.dayLogId,
    super.key,
  });
  final int dayLogId;

  @override
  Widget build(BuildContext context) {
    logDebug('DayLogEditPage build');
    return DayLogRepositoryProvider(
      child: BlocProvider(
        create: (context) {
          return DayLogEditBloc(
            context.read<DayLogRepository>(),
            dayLogId,
          )..add(
              LoadInitialDayLog(),
            );
        },
        child: BlocListener<DayLogEditBloc, DayLogEditState>(
          listener: (context, state) {
            if (state is ErrorState) {
              if (state.isFatal) Navigator.pop(context);

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
            }
            if (!state.isValid()) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Invalid...')),
                );
            }
          },
          child: BlocBuilder<DayLogEditBloc, DayLogEditState>(
            builder: (
              BuildContext context,
              DayLogEditState state,
            ) {
              logDebug(
                // ignore: lines_longer_than_80_chars
                'Building BlocBuilder for DayLogEdit:${state.formStatus}:${state.formStatus.hashCode}',
              );
              Widget? childForScaffold;
              if (state.formStatus == EInputFormStatus.initialLoading) {
                childForScaffold = const Center(
                  child: MyProcessIndicator(),
                );
              } else if (state.formStatus == EInputFormStatus.idleDirty ||
                  state.formStatus == EInputFormStatus.idleRelevant ||
                  state.formStatus == EInputFormStatus.loading) {
                childForScaffold = DayLogEditWidget(state);
              }
              return Scaffold(
                appBar: myAppBarWithTitle('Day Log'),
                body: childForScaffold,
                floatingActionButton: MyFABCollection(
                  fabs: [
                    if (state.formStatus != EInputFormStatus.loading &&
                        state.formStatus != EInputFormStatus.initialLoading)
                      MyFloatingButton.withIcon(
                        iconData: Icons.save_as_rounded,
                        onPressed: () {
                          logDebug('FAB pressed: ${state.sleepStart.value}');
                          context.read<DayLogEditBloc>().add(SaveDayLog());
                        },
                      )
                    else
                      MyFloatingButton(
                        child: const MyProcessIndicator(),
                        onPressed: () {
                          logDebug('FAB pressed: ${state.sleepStart.value}');
                          context.read<DayLogEditBloc>().add(SaveDayLog());
                        },
                      ),
                    // MyFloatingButton(
                    //   iconData: Icons.abc_outlined,
                    //   onPressed: () {
                    //     logDebug("FAB pressed");
                    //     //context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
                    //   },
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

///Form with fields for editing DayLog
class DayLogEditWidget extends StatelessWidget {
  const DayLogEditWidget(
    this.dayLogState, {
    super.key,
  });

  final DayLogEditState dayLogState;

  @override
  Widget build(BuildContext context) {
    logDebug('DayLogEditWidget build');
    return Container(
      color: Get.theme.colorScheme.surface,
      padding: EdgeInsets.all(CARD_MARGIN + CARD_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyDateTimeInputField(
            label: 'Sleep Start',
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.sleepStart.value,
            validValueHandler:
                _createValidValueHanlder(context, dayLogState.sleepStart),
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyDateTimeInputField(
            label: 'Sleep End',
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.sleepEnd.value,
            validValueHandler:
                _createValidValueHanlder(context, dayLogState.sleepEnd),
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyDurationInputField(
            label: 'Sleep Duration',
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.sleepDuration.value,
            validValueHandler:
                _createValidValueHanlder(context, dayLogState.sleepDuration),
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyDurationInputField(
            label: 'Deep Sleep Duration',
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.deepSleepDuration.value,
            validValueHandler: _createValidValueHanlder(
                context, dayLogState.deepSleepDuration),
          ),
        ],
      ),
    );
  }

  Function(T) _createValidValueHanlder<T>(
    BuildContext context,
    MyInputResult<T> inputField,
  ) {
    return (newValue) {
      context.read<DayLogEditBloc>().add(
            ChangeFieldInDayLogForm<T>(
              inputField,
              newValue,
            ),
          );
    };
  }
}
