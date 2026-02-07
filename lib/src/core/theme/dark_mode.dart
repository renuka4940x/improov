import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF202020),
    primary: Color(0xFF1D1D1D),
    secondary: Color(0xFF2B2B2B),
    tertiary: Color.fromARGB(255, 60, 150, 55),
    inversePrimary: Color(0xFFF5F5F5),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Color.fromARGB(255, 60, 150, 55),
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