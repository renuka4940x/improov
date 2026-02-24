import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/data/enums/subscription_type.dart';
import 'package:improov/src/data/models/app_settings.dart';
import 'package:isar/isar.dart';

class AppSettingsDatabase {
  final isar = IsarService.db;

  // Fetch current settings
  Future<AppSettings?> getSettings() async {
    return await isar.appSettings.where().findFirst();
  }

  //update nickname
  Future<void> updateNickname(String? newNickname) async {
    final settings = await getSettings() ?? AppSettings();
    settings.nickname = newNickname;
    
    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });
  }

  //update subscryption type
  Future<void> updateSubscription(SubscriptionType type) async {
    final settings = await getSettings() ?? AppSettings();
    settings.subscriptionType = type;
    
    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });
  }
}