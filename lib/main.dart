import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogDataProvider.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:life_log_2/app_logical_parts/day_log/bloc/day_log_bloc.dart';

import 'app_logical_parts/day_log/widgets/day_log_list_view.dart';
import 'test_of_flutter_possibilities/flutter_theme_test.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.sanJuanBlue;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xff004881),
          primaryContainer: Color(0xffd0e4ff),
          secondary: Color(0xffac3306),
          secondaryContainer: Color(0xffffdbcf),
          tertiary: Color(0xff006875),
          tertiaryContainer: Color(0xff95f0ff),
          appBarColor: Color(0xffffdbcf),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 8,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),

      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     // seedColor: Color.fromARGB(255, 117, 26, 94),
      //     seedColor: Color.fromARGB(255, 63, 193, 233),
      //     // tertiary: Colors.amber,
      //     brightness: Brightness.light,
      //   ),
      //   // hintColor: Colors.amber,
      //   //brightness: Brightness.dark,
      //   useMaterial3: true,
      // ),
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
        elevation: 1,
        scrolledUnderElevation: 5,
        shadowColor: Theme.of(context).colorScheme.surface,
        // bottomOpacity: 0.0,
        title: const Text('M3 Color Scheme Example'),
        // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: const DayLogListView(),
    );
  }
}
