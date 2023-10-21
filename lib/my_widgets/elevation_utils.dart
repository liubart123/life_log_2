import 'package:flutter/material.dart';

final tintColorLevels = const [0.0, 0.1, 0.2];
final tintColorOpacityLevels = const [0.0, 0.1, 0.2];
final shadowOpacityLevels = const [0.0, 0.2, 0.4];

Color GetTintColorForSurfaceTintOnSurface(
  BuildContext context,
  int elevation,
) {
  return GetTintColor(
    elevation,
    Theme.of(context).colorScheme.surface,
    Theme.of(context).colorScheme.surfaceTint,
  );
}

Color GetTintColor(
  int elevation,
  Color backgroundColor,
  Color tintColor,
) {
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
  return GetTransparentTintColor(
      elevation, Theme.of(context).colorScheme.surfaceTint);
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
  double shadowOpacity =
      shadowOpacityLevels[elevation % shadowOpacityLevels.length];
  // shadowOpacity = 1;
  return BoxShadow(
    color: Theme.of(context).colorScheme.shadow.withOpacity(shadowOpacity),
    spreadRadius: 0,
    blurRadius: 1,
    offset: Offset(1, 1),
    // blurStyle: BlurStyle.solid,
  );
}
