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

  //subscription type
  @enumerated
  SubscriptionType subscriptionType = SubscriptionType.none;

  //get subscription type
  bool get isPro => subscriptionType != SubscriptionType.none;

  AppSettings({this.isDarkMode = false});

  @ignore
  ThemeData get themeData {
    return isDarkMode ? darkMode : lightMode;
  }
}