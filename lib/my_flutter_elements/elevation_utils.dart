import 'package:flutter/material.dart';
import 'package:get/get.dart';

final tintColorLevels = const [0.0, 0.05, 0.2];
final tintColorOpacityLevels = const [0.0, 0.1, 0.2];
final shadowOpacityLevels = const [0.0, 0.2, 0.4];

Color GetTintColorForSurfaceTintOnSurface(
  BuildContext context,
  int elevation,
) {
  return GetTintColor(
    elevation,
    Get.theme.colorScheme.surface,
    Get.theme.colorScheme.surfaceTint,
  );
}

Color GetTintColor(
  int elevation,
  Color backgroundColor,
  Color tintColor,
) {
  var tintColorLevels = const [0.0, 0.05, 0.2];
  double colorLerp = tintColorLevels[elevation % tintColorLevels.length];
  return Color.lerp(
    backgroundColor,
    tintColor,
    colorLerp,
  )!;
}

Color GetTransparentTintColorForSurface(
  BuildContext context,
  int elevation,
) {
  return GetTransparentTintColor(elevation, Get.theme.colorScheme.surfaceTint);
}

Color GetTransparentTintColor(
  int elevation,
  Color tintColor,
) {
  double colorOpacity =
      tintColorOpacityLevels[elevation % tintColorOpacityLevels.length];
  return tintColor.withOpacity(colorOpacity);
}

BoxShadow GetElevatedBoxShadow(BuildContext context, int elevation) {
  final shadowOpacityLevels = const [0.0, 0.1, 0.4];
  double shadowOpacity =
      shadowOpacityLevels[elevation % shadowOpacityLevels.length];
  // shadowOpacity = 1;
  return BoxShadow(
    color: Get.theme.colorScheme.shadow.withOpacity(shadowOpacity),
    spreadRadius: 0,
    blurRadius: 1,
    offset: Offset(1, 1),
    // blurStyle: BlurStyle.solid,
  );
}
