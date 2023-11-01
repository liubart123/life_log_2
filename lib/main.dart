import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:life_log_2/app_logical_parts/day_log/list_view/bloc/day_log_bloc.dart';

import 'app_logical_parts/day_log/list_view/day_log_list_view.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'my_widgets/my_widgets.dart';
import 'test_of_flutter_possibilities/custom_widgets_test.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
      theme: FlexThemeData.light(
          scheme: FlexScheme.bahamaBlue,
          subThemesData: const FlexSubThemesData(
            interactionEffects: false,
            tintedDisabledControls: false,
            blendOnColors: false,
            useTextTheme: true,
            alignedDropdown: true,
            tooltipRadius: 4,
            tooltipSchemeColor: SchemeColor.inverseSurface,
            tooltipOpacity: 0.9,
            useInputDecoratorThemeInDialogs: true,
            snackBarElevation: 6,
            snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
            navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
            navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
            navigationBarMutedUnselectedLabel: false,
            navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
            navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
            navigationBarMutedUnselectedIcon: false,
            navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
            navigationBarIndicatorOpacity: 1.00,
            navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
            navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
            navigationRailMutedUnselectedLabel: false,
            navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
            navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
            navigationRailMutedUnselectedIcon: false,
            navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
            navigationRailIndicatorOpacity: 1.00,
            navigationRailBackgroundSchemeColor: SchemeColor.surface,
            navigationRailLabelType: NavigationRailLabelType.none,
          ),
          keyColors: const FlexKeyColors(),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          textTheme: TextTheme(
            titleMedium: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),

      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CreateMyAppBar(
              'Day Logs',
              context,
            ),
            body: Container(
              color: Theme.of(context).colorScheme.surface,
              child: const DayLogViewList(),
              // child: const CustomWidgetsTest(),
            ),
            floatingActionButton: MyFABCollection(
              fabs: [
                MyFloatingButton(
                  iconData: Icons.public_sharp,
                  onPressed: () {
                    print("FAB pressed");
                    //context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
                  },
                ),
                MyFloatingButton(
                  iconData: Icons.add_a_photo_outlined,
                  onPressed: () {
                    print("FAB pressed");
                    //context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
                  },
                ),
                MyFloatingButton(
                  iconData: Icons.add,
                  onPressed: () {
                    print("FAB pressed");
                    //context.read<DayLogEditBloc>().add(UpdateDayLogAfterEditing());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
