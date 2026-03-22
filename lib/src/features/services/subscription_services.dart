import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:isar/isar.dart';
import 'package:improov/src/data/models/app_settings/app_settings.dart';
import 'package:improov/src/data/enums/subscription_type.dart';

class SubscriptionService {
  static const _apiKey = "goog_NdhnvBHKauGLBGISGXnQsHhSNDG";

  static Future<void> init() async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);

    PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
    await Purchases.configure(configuration);

    // Listen for customer info changes
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      debugPrint("Purchases: Customer Info Updated");
    });
  }

  // ENTITLEMENT CHECKER
  static Future<bool> isPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey("Improov Premium");
    } catch (e) {
      debugPrint("Error checking entitlement: $e");
      return false;
    }
  }

  // SYNC REVENUECAT -> ISAR
  static Future<void> syncSubscriptionToIsar(Isar isar) async {
    try {
      CustomerInfo info = await Purchases.getCustomerInfo();
      final hasPremium = info.entitlements.active.containsKey("Improov Premium");

      final settings = await isar.appSettings.get(0) ?? AppSettings();
      
      if (hasPremium) {
        // Check which specific product is active to set the Enum
        final activeEntitlement = info.entitlements.active["Improov Premium"];
        if (activeEntitlement?.productIdentifier.contains('yearly') ?? false) {
          settings.subscriptionType = SubscriptionType.yearly;
        } else {
          settings.subscriptionType = SubscriptionType.monthly;
        }
      } else {
        settings.subscriptionType = SubscriptionType.none;
      }

      await isar.writeTxn(() => isar.appSettings.put(settings));
      debugPrint("✅ Isar Synced with RevenueCat: ${settings.subscriptionType}");
    } catch (e) {
      debugPrint("❌ Failed to sync subscription: $e");
    }
  }
}