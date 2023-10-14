import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:life_log_2/app_logical_parts/day_log/DayLogModel.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/bloc/day_log_edit_bloc.dart';
import 'package:life_log_2/my_widgets/my_widgets.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

class SingleDayLogEditScreen extends StatelessWidget {
  final int dayLogId;
  const SingleDayLogEditScreen({
    super.key,
    required this.dayLogId,
  });

  @override
  Widget build(BuildContext context) {
    return MyRepositoryProviders(
      child: BlocProvider(
        create: ((context) {
          return DayLogEditBloc(
            context.read<DayLogRepository>(),
            dayLogId,
          )..add(
              LoadInitialDayLog(),
            );
        }),
        child: DayLogEditScaffold(),
      ),
    );
  }
}

class DayLogEditScaffold extends StatelessWidget {
  const DayLogEditScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreateMyAppBar(
        'Day Log Edit',
        context,
      ),
      body: BlocBuilder<DayLogEditBloc, DayLogEditState>(
        builder: (
          BuildContext context,
          DayLogEditState state,
        ) {
          print(state);
          if (state is InitialLoadingOfDayLog) {
            return const Center(
              child: Text("Initial loading..."),
            );
          } else if (state is IdleState) {
            return Center(
              child: DayLogEditWidget(
                dayLog: state.dayLog!,
              ),
            );
          } else if (state is LoadingOfDayLog) {
            return const Center(
              child: Text("Updating..."),
            );
          } else if (state is ErrorReturnedState) {
            return Center(
              child: Text("Error: ${state.errorMessage}"),
            );
          } else
            return Center(child: Text("Unhalded state"));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class DayLogEditWidget extends StatelessWidget {
  final DayLog dayLog;
  const DayLogEditWidget({
    Key? key,
    required this.dayLog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyDatePicker(
                        fieldValueToDisplay: dayLog.sleepStartTime,
                        fieldNameToDisplay: "Fall asleep",
                        actiononDatePick: (newValue) {
                          dayLog.sleepStartTime = newValue;
                          context.read<DayLogEditBloc>().add(FieldUpdate());
                        },
                      ),
                    ),
                    SizedBox.square(
                      dimension: 8,
                    ),
                    Expanded(
                        child: MyDatePicker(
                      fieldValueToDisplay: dayLog.sleepEndTime,
                      fieldNameToDisplay: "Wake up",
                      actiononDatePick: (newValue) {},
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyDatePicker(
                        fieldValueToDisplay: dayLog.sleepStartTime,
                        fieldNameToDisplay: "Fall asleep",
                        actiononDatePick: (newValue) {
                          dayLog.sleepStartTime = newValue;
                          context.read<DayLogEditBloc>().add(FieldUpdate());
                        },
                      ),
                    ),
                    SizedBox.square(
                      dimension: 8,
                    ),
                    Expanded(
                        child: MyDatePicker(
                      fieldValueToDisplay: dayLog.sleepEndTime,
                      fieldNameToDisplay: "Wake up",
                      actiononDatePick: (newValue) {},
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyDatePicker extends StatelessWidget {
  final String fieldNameToDisplay;
  final DateTime fieldValueToDisplay;
  final Function(DateTime newValue) actiononDatePick;

  const MyDatePicker({
    Key? key,
    required this.fieldNameToDisplay,
    required this.fieldValueToDisplay,
    required this.actiononDatePick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$fieldNameToDisplay:",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          SizedBox.square(
            dimension: 4,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
            child: GestureDetector(
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: fieldValueToDisplay,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (newDate != null) actiononDatePick(newDate);
              },
              child: Text(
                formatDate(fieldValueToDisplay),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        ],
      ),
    );
  }
}
