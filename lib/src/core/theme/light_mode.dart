import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/core/constants/app_colors.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: AppColors.lightSurface,
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightSecondary,
    tertiary: AppColors.lightTertiary,
    inversePrimary: AppColors.lightInversePrimary,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
    selectionColor: AppColors.lightTertiary,
    selectionHandleColor: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);