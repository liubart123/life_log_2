import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ThemeData createAppTheme(BuildContext context) {
  return ThemeData(
    colorSchemeSeed: const Color(0xff6750a4),
    useMaterial3: true,
  );
  return FlexThemeData.light(
    scheme: FlexScheme.bahamaBlue,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 3,
    // subThemesData: const FlexSubThemesData(
    //   interactionEffects: false,
    //   tintedDisabledControls: false,
    //   blendOnColors: false,
    //   useTextTheme: true,
    //   // inputDecoratorBorderType: FlexInputBorderType.underline,
    //   // inputDecoratorUnfocusedBorderIsColored: false,
    //   alignedDropdown: true,
    //   tooltipRadius: 4,
    //   tooltipSchemeColor: SchemeColor.inverseSurface,
    //   tooltipOpacity: 0.9,
    //   // useInputDecoratorThemeInDialogs: true,
    //   snackBarElevation: 6,
    //   snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    //   navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    //   navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    //   navigationBarMutedUnselectedLabel: false,
    //   navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    //   navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    //   navigationBarMutedUnselectedIcon: false,
    //   navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
    //   navigationBarIndicatorOpacity: 1.00,
    //   navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    //   navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    //   navigationRailMutedUnselectedLabel: false,
    //   navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    //   navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    //   navigationRailMutedUnselectedIcon: false,
    //   navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
    //   navigationRailIndicatorOpacity: 1.00,
    //   navigationRailBackgroundSchemeColor: SchemeColor.surface,
    //   navigationRailLabelType: NavigationRailLabelType.none,
    // ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the Playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );
}
