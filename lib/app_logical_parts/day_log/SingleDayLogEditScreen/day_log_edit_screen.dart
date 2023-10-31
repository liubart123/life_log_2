import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:life_log_2/app_logical_parts/day_log/DayLogModel.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:life_log_2/app_logical_parts/day_log/SingleDayLogEditScreen/bloc/day_log_edit_bloc.dart';
import 'package:life_log_2/my_widgets/my_old_widgets.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

class DayLogEditScreen extends StatelessWidget {
  final int dayLogId;
  const DayLogEditScreen({
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
        child: BlocBuilder<DayLogEditBloc, DayLogEditState>(builder: (
          BuildContext context,
          DayLogEditState state,
        ) {
          Widget childForScaffold;
          if (state is InitialLoadingOfDayLog) {
            childForScaffold = const Center(
              child: const MyProgressIndicator(),
            );
          } else if (state is IdleState) {
            childForScaffold = DayLogEditWidget(
              dayLog: state.dayLog!,
            );
          } else if (state is LoadingOfDayLog) {
            childForScaffold = const Center(
              child: const MyProgressIndicator(),
            );
          } else if (state is ErrorReturnedState) {
            childForScaffold = const Center(
              child: const CardWithErrorMessage(
                  erorrMessage:
                      'My Error message:\nAwesome stacktrace for error'),
            );
          } else
            childForScaffold = Center(child: Text("Unhalded state"));

          return Scaffold(
            appBar: CreateMyAppBar(
              'Day Log Edit',
              context,
            ),
            body: childForScaffold,
            floatingActionButton: MyColumnOfFloatingWidgets(
              FABs: [
                MyFloatingButton(
                  iconData: Icons.save_as_rounded,
                  onPressed: () {
                    print("FAB pressed");
                    //context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
                  },
                ),
              ],
            ),
          );
        }),
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyCard(
            margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
            child: Center(
              child: SizedBox.square(
                dimension: 100,
                child: Text(
                  'gavno',
                ),
              ),
            ),
          ),
          MyCard(
            margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
            child: Center(
              child: SizedBox.square(
                dimension: 100,
                child: Text(
                  'gavno',
                ),
              ),
            ),
          ),
          // Card(
          //   child: Container(
          //     padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
          //     child: Column(
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Expanded(
          //               child: Container(
          //                 // child: Text("asd"),
          //                 child: TextField(
          //                   canRequestFocus: false,
          //                   // obscureText: true,
          //                   decoration: InputDecoration(
          //                     border: OutlineInputBorder(),
          //                     labelText: 'Password',
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Expanded(
          //               child: Container(
          //                 // child: Text("asd"),
          //                 child: TextField(
          //                   // obscureText: true,
          //                   decoration: InputDecoration(
          //                     border: OutlineInputBorder(),
          //                     labelText: 'Password',
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Expanded(
          //               child: MyDatePicker(
          //                 fieldValueToDisplay: dayLog.sleepStartTime,
          //                 fieldNameToDisplay: "Fell asleep",
          //                 actiononDatePick: (newValue) {
          //                   dayLog.sleepStartTime = newValue;
          //                   context.read<DayLogEditBloc>().add(FieldUpdate());
          //                 },
          //               ),
          //             ),
          //             SizedBox.square(
          //               dimension: 8,
          //             ),
          //             Expanded(
          //                 child: MyDatePicker(
          //               fieldValueToDisplay: dayLog.sleepEndTime,
          //               fieldNameToDisplay: "Woke up",
          //               actiononDatePick: (newValue) {},
          //             )),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Expanded(
          //               child: MyDatePicker(
          //                 fieldValueToDisplay: dayLog.sleepStartTime,
          //                 fieldNameToDisplay: "Fell asleep",
          //                 actiononDatePick: (newValue) {
          //                   dayLog.sleepStartTime = newValue;
          //                   context.read<DayLogEditBloc>().add(FieldUpdate());
          //                 },
          //               ),
          //             ),
          //             SizedBox.square(
          //               dimension: 8,
          //             ),
          //             Expanded(
          //                 child: MyDatePicker(
          //               fieldValueToDisplay: dayLog.sleepEndTime,
          //               fieldNameToDisplay: "Woke up",
          //               actiononDatePick: (newValue) {},
          //             )),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
