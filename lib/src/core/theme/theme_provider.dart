import 'package:flutter/material.dart';
import 'package:improov/src/presentation/profile/provider/app_settings_database.dart';
import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  final AppSettingsDatabase settingsDb; // Inject your DB
  bool _isDark = false;

  ThemeProvider(this.settingsDb) {
    _loadTheme(); // Load initial state on startup
  }

  bool get isDarkMode => _isDark;
  ThemeData get themeData => _isDark ? darkMode : lightMode;

  Future<void> _loadTheme() async {
    final settings = await settingsDb.getSettings();
    _isDark = settings.isDarkMode;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    
    // Save the new state to your persistent database!
    await settingsDb.updateDarkMode(_isDark); 
    notifyListeners();
  }
}