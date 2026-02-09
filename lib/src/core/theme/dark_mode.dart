import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/core/constants/app_colors.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: AppColors.darkSurface,
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    tertiary: AppColors.darkTertiary,
    inversePrimary: AppColors.darkInversePrimary,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: AppColors.darkTertiary,
    selectionHandleColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  ),
);