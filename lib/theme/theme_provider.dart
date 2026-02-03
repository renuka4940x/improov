import 'package:flutter/material.dart';
import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //boolean to track the state
  bool _isDark = false; 

  //getters
  bool get isDarkMode => _isDark;
  ThemeData get themeData => _isDark ? darkMode : lightMode;

  //the Toggle
  void toggleTheme() {
    _isDark = !_isDark; // Just flip the switch!
    notifyListeners();
  }
}