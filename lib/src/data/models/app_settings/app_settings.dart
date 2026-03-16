import 'package:flutter/material.dart';
import 'package:improov/src/data/enums/subscription_type.dart';
import 'package:isar/isar.dart';
import 'package:improov/src/core/theme/dark_mode.dart'; 
import 'package:improov/src/core/theme/light_mode.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = 0;

  DateTime? firstLaunchDate;

  //name
  String? nickname;

  //theme
  bool isDarkMode;

  //haptic & notification toggles
  bool hapticsEnabled;
  bool notifyHabitReminders;
  bool notifyTaskDeadlines;
  bool notifyStreakWarning;

  //subscription type
  @enumerated
  SubscriptionType subscriptionType = SubscriptionType.none;

  //get subscription type
  bool get isPro => subscriptionType != SubscriptionType.none;

  AppSettings({
    this.isDarkMode = false,
    this.hapticsEnabled = true,
    this.notifyHabitReminders = true,
    this.notifyTaskDeadlines = true,
    this.notifyStreakWarning = true,
    DateTime? firstLaunchDate,
  }): firstLaunchDate = firstLaunchDate ?? DateTime.now();

  @ignore
  ThemeData get themeData {
    return isDarkMode ? darkMode : lightMode;
  }
}