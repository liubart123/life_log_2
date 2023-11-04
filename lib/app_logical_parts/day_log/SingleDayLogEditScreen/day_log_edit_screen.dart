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
        child: BlocBuilder<DayLogEditBloc, DayLogEditState>(builder: (
          BuildContext context,
          DayLogEditState state,
        ) {
          Widget childForScaffold;
          if (state is InitialLoadingOfDayLog) {
            childForScaffold = const Center(
              child: const MyLoadingIndicator(),
            );
          } else if (state is IdleState) {
            childForScaffold = DayLogEditWidget(state.dayLog!);
          } else if (state is LoadingOfDayLog) {
            childForScaffold = const Center(
              child: const MyLoadingIndicator(),
            );
          } else if (state is ErrorReturnedState) {
            childForScaffold =
                Center(child: Text("My Error message:${state.errorMessage}"));
          } else
            childForScaffold = Center(child: Text("Unhalded state"));

          return Scaffold(
            appBar: CreateMyAppBar(
              state.dayLog == null ? "Day Log" : formatDate(state.dayLog!.date),
              context,
            ),
            body: childForScaffold,
            floatingActionButton: MyFABCollection(
              fabs: [
                MyFloatingButton(
                  iconData: Icons.save_as_rounded,
                  onPressed: () {
                    print("FAB pressed");
                    //context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
                  },
                ),
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
    );
  }
}

class DayLogEditWidget extends StatefulWidget {
  final DayLog dayLog;
  const DayLogEditWidget(
    this.dayLog, {
    Key? key,
  }) : super(key: key);

  @override
  State<DayLogEditWidget> createState() {
    print('deaulog widget createState');
    return _DayLogEditWidgetState(dayLog);
  }
}

class _DayLogEditWidgetState extends State<DayLogEditWidget> {
  final DayLog dayLog;
  int index = 0;

  _DayLogEditWidgetState(this.dayLog);

  @override
  Widget build(BuildContext context) {
    print('edit widget build');
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.all(CARD_MARGIN + CARD_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextField(
            label: "Sleep Start",
            icon: ICON_SLEEP_START,
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyTextField(
            label: "Sleep End",
            icon: ICON_SLEEP_START,
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyTextField(
            label: "Sleep Duration",
            icon: ICON_SLEEP_START,
          ),
          Gap(INNER_CARD_GAP_SMALL),
          MyTextField(
            label: "Deep Sleep Duration",
            icon: ICON_SLEEP_START,
          ),
        ],
      ),
    );
  }
}
