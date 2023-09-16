import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogDataProvider.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:life_log_2/app_logical_parts/day_log/bloc/day_log_bloc.dart';

import 'app_logical_parts/day_log/day_log_list_view.dart';
import 'test_of_flutter_possibilities/flutter_theme_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // seedColor: Color.fromARGB(255, 117, 26, 94),
          seedColor: Color.fromARGB(255, 63, 193, 233),
          // tertiary: Colors.amber,
          brightness: Brightness.light,
        ),
        // hintColor: Colors.amber,
        //brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DayLogDataProvider>(
            create: (context) => DayLogDataProvider(),
          ),
          RepositoryProvider<DayLogRepository>(
            create: (context) =>
                DayLogRepository(context.read<DayLogDataProvider>()),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: ((context) => DayLogBloc(
                    context.read<DayLogRepository>(),
                  )..add(
                      LoadInitialPageOfDayLogs(),
                    )),
            ),
          ],
          child: AppScreen(),
        ),
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3 Color Scheme Example'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: const DayLogListView(),
    );
  }
}
