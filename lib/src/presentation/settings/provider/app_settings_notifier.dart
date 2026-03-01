import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:improov/src/data/models/app_settings.dart';
import 'package:improov/src/data/enums/subscription_type.dart';
import 'package:improov/src/data/provider/providers.dart';
import 'package:improov/src/core/theme/dark_mode.dart';
import 'package:improov/src/core/theme/light_mode.dart';

part 'app_settings_notifier.g.dart';

@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  FutureOr<AppSettings> build() async {
    final service = await ref.watch(isarDatabaseProvider.future);
    
    //get existing settings
    return await service.db.appSettings.get(0) ?? (AppSettings()..id = 0);
  }

  ThemeData get themeData => state.value?.isDarkMode == true ? darkMode : lightMode;

  // U P D A T E - Nickname
  Future<void> updateNickname(String newName) async {
    final service = await ref.read(isarDatabaseProvider.future);

    final String nameToSave = newName.trim().isEmpty ? 'mate' : newName.trim();

    await service.db.writeTxn(() async {
      final settings = await service.db.appSettings.get(0) ?? (AppSettings()..id = 0);
      settings.nickname = nameToSave;
      await service.db.appSettings.put(settings);
    });
    
    //refreshes UI
    ref.invalidateSelf();
  }

  // U P D A T E - Subscription
  Future<void> updateSubscription(SubscriptionType type) async {
    final service = await ref.read(isarDatabaseProvider.future);

    await service.db.writeTxn(() async {
      final settings = await service.db.appSettings.get(0) ?? (AppSettings()..id = 0);
      settings.subscriptionType = type;
      await service.db.appSettings.put(settings);
    });

    ref.invalidateSelf();
  }

  //U P D A T E - theme
  Future<void> toggleTheme() async {
    final service = await ref.read(isarDatabaseProvider.future);
    final settings = await service.db.appSettings.get(0) ?? (AppSettings()..id = 0);
    
    settings.isDarkMode = !settings.isDarkMode;
    
    await service.db.writeTxn(() async {
      await service.db.appSettings.put(settings);
    });
    
    ref.invalidateSelf();
  }

  //U P D A T E - haptics
  Future<void> toggleHaptics() async {
    final service = await ref.read(isarDatabaseProvider.future);
    final settings = await service.db.appSettings.get(0) ?? (AppSettings()..id = 0);
    
    settings.hapticsEnabled = !settings.hapticsEnabled;
    
    await service.db.writeTxn(() async {
      await service.db.appSettings.put(settings);
    });
    
    ref.invalidateSelf();
  }

  //U P D A T E - notifications 
  Future<void> toggleNotifications() async {
    final service = await ref.read(isarDatabaseProvider.future);
    final settings = await service.db.appSettings.get(0) ?? (AppSettings()..id = 0);
    
    // We flip the main reminder bool
    settings.notifyHabitReminders = !settings.notifyHabitReminders;
    
    settings.notifyTaskDeadlines = settings.notifyHabitReminders;
    settings.notifyStreakWarning = settings.notifyHabitReminders;
    
    await service.db.writeTxn(() async {
      await service.db.appSettings.put(settings);
    });
    
    ref.invalidateSelf();
  }
}