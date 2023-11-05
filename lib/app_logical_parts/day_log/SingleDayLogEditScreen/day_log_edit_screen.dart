import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:life_log_2/app_logical_parts/day_log/DayLogModel.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/bloc/day_log_edit_bloc.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/my_widgets/my_icons.dart';
import 'package:life_log_2/my_widgets/my_input_widgets.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/InputForm.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

import '../day_log_repository_provider.dart';

class DayLogEditScreen extends StatelessWidget {
  final int dayLogId;
  const DayLogEditScreen({
    super.key,
    required this.dayLogId,
  });

  @override
  Widget build(BuildContext context) {
    print('edit screen build');
    return DayLogRepositoryProvider(
      child: BlocProvider(
        create: ((context) {
          return DayLogEditBloc(
            context.read<DayLogRepository>(),
            dayLogId,
          )..add(
              LoadInitialDayLog(),
            );
        }),
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
            if (!state.isValid())
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Invalid...')),
                );
          },
          child: BlocBuilder<DayLogEditBloc, DayLogEditState>(builder: (
            BuildContext context,
            DayLogEditState state,
          ) {
            print(
                'Building BlocBuilder for DayLogEdit:${state.formStatus}:${state.formStatus.hashCode}');
            Widget? childForScaffold = null;
            if (state.formStatus == EInputFormStatus.initialLoading) {
              childForScaffold = const Center(
                child: const MyLoadingIndicator(),
              );
            } else if (state.formStatus == EInputFormStatus.idleDirty ||
                state.formStatus == EInputFormStatus.idleRelevant ||
                state.formStatus == EInputFormStatus.loading) {
              childForScaffold = DayLogEditWidget(state);
            }
            return Scaffold(
              appBar: CreateMyAppBar(
                "Day Log",
                context,
              ),
              body: childForScaffold,
              floatingActionButton: MyFABCollection(
                fabs: [
                  if (state.formStatus != EInputFormStatus.loading &&
                      state.formStatus != EInputFormStatus.initialLoading)
                    MyFloatingButton.withIcon(
                      iconData: Icons.save_as_rounded,
                      onPressed: () {
                        print("FAB pressed: ${state.sleepStart.value}");
                        context.read<DayLogEditBloc>().add(SaveDayLog());
                      },
                    )
                  else
                    MyFloatingButton(
                      child: MyLoadingIndicator(),
                      onPressed: () {
                        print("FAB pressed: ${state.sleepStart.value}");
                        context.read<DayLogEditBloc>().add(SaveDayLog());
                      },
                    )
                  // MyFloatingButton(
                  //   iconData: Icons.abc_outlined,
                  //   onPressed: () {
                  //     print("FAB pressed");
                  //     //context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
                  //   },
                  // ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DayLogEditWidget extends StatelessWidget {
  final DayLogEditState dayLogState;
  const DayLogEditWidget(
    this.dayLogState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('edit widget build');
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.all(CARD_MARGIN + CARD_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyDateTimeInputField(
            label: "Sleep Start",
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.sleepStart.value,
            validValueHandler:
                CreateValidValueHanlder(context, dayLogState.sleepStart),
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyDateTimeInputField(
            label: "Sleep End",
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.sleepEnd.value,
            validValueHandler:
                CreateValidValueHanlder(context, dayLogState.sleepEnd),
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyDurationInputField(
            label: "Sleep Duration",
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.sleepDuration.value,
            validValueHandler:
                CreateValidValueHanlder(context, dayLogState.sleepDuration),
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyDurationInputField(
            label: "Deep Sleep Duration",
            icon: ICON_SLEEP_START,
            initialValue: dayLogState.deepSleepDuration.value,
            validValueHandler:
                CreateValidValueHanlder(context, dayLogState.deepSleepDuration),
          ),
        ],
      ),
    );
  }

  Function(T) CreateValidValueHanlder<T>(
    BuildContext context,
    MyInputResult<T> inputField,
  ) {
    return (newValue) {
      context.read<DayLogEditBloc>().add(ChangeFieldInDayLogForm<T>(
            inputField,
            newValue,
          ));
    };
  }
}
