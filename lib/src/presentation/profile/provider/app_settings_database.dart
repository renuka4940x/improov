import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/data/enums/subscription_type.dart';
import 'package:improov/src/data/models/app_settings.dart';
import 'package:isar/isar.dart';

class AppSettingsDatabase {
  final IsarService isarService;

  // Use a getter for cleaner code
  Isar get isar => isarService.db;

  AppSettingsDatabase(this.isarService);

  // Fetch current settings
  Future<AppSettings> getSettings() async {
    return await isar.appSettings.get(0) ?? (AppSettings()..id = 0);
  }

  //update nickname
  Future<void> updateNickname(String? newNickname) async {
    final settings = await getSettings();
    settings.nickname = newNickname;
    
    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });
  }

  //update subscryption type
  Future<void> updateSubscription(SubscriptionType type) async {
    final settings = await getSettings();
    settings.subscriptionType = type;
    
    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });
  }

  //update theme
  Future<void> updateDarkMode(bool isDarkMode) async {
    await isar.writeTxn(() async {
      final settings = await isar.appSettings.get(0) ?? AppSettings()..id = 0;
      settings.isDarkMode = isDarkMode;
      await isar.appSettings.put(settings);
    });
  }
}