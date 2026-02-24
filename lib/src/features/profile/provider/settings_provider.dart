import 'package:flutter/material.dart';
import 'package:improov/src/data/enums/subscription_type.dart';
import 'package:improov/src/data/models/app_settings.dart';
import 'package:improov/src/features/profile/provider/app_settings_database.dart';

class SettingsProvider extends ChangeNotifier {
  final AppSettingsDatabase database;
  // ignore: unused_field
  AppSettings? _settings;

  SettingsProvider(this.database) {
    loadSettings();
  }

  void loadSettings() async {
    _settings = await database.getSettings();
    notifyListeners(); // This is the magic key for UI updates!
  }

  void updateNickname(String newName) async {
    final String nameToSave = newName.trim().isEmpty 
      ? 'mate' 
      : newName.trim();

    await database.updateNickname(nameToSave);
    
    _settings = await database.getSettings();
    loadSettings(); // Reload and notify listeners
  }

  void updateSubscription(SubscriptionType type) async {
    await database.updateSubscription(type);
    loadSettings();
  }

  //getter
  String? get nickname => _settings?.nickname;
  bool get isPro => _settings?.isPro ?? false;
}