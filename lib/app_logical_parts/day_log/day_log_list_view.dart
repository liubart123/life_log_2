import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_log_2/app_logical_parts/day_log/bloc/day_log_bloc.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

import 'DayLogModel.dart';

class DayLogListView extends StatelessWidget {
  const DayLogListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DayLogBloc, DayLogBlocState>(
      builder: (context, state) {
        if (state is LoadingPageOfDayLogs && state.dayLogList.isEmpty) {
          return const Center(
            child: Text("Initial loading..."),
          );
        }
        return Container(
          padding: EdgeInsets.all(8),
          // color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                // fit: FlexFit.tight,
                child: ListView.builder(
                    itemCount: state.dayLogList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.dayLogList.length) {
                        DayLog logToBuild = state.dayLogList[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text("gavno.."),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text("g"),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text(
                                      textAlign: TextAlign.end,
                                      formatDate(logToBuild.date),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            // Divider(),
                            if (state is LoadingPageOfDayLogs)
                              const Text("Loading..."),
                            if (state is ErrorWithLoadingPageOfDayLogs)
                              Text(
                                  "Error: ${(state as ErrorWithLoadingPageOfDayLogs).errorMessage ?? "unknown..."}"),
                            ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<DayLogBloc>()
                                      .add(LoadNextPageOfDayLogs());
                                },
                                icon: const Icon(Icons.arrow_circle_down),
                                label: const Text("More")),
                            ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<DayLogBloc>()
                                      .add(LoadInitialPageOfDayLogs());
                                },
                                icon: const Icon(Icons.replay_outlined),
                                label: const Text("Reload")),
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
