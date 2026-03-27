import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:flutter/foundation.dart';

//true if Premium, false if Free
class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    checkSubscriptionStatus();
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      // ⚠️ Fixed the ID to match RevenueCat exactly
      state = customerInfo.entitlements.all["Improov Premium"]?.isActive ?? false;
      debugPrint("👑 Premium Status Initialized: $state");
    } catch (e) {
      debugPrint("RevenueCat Init Error: $e");
      state = false;
    }
  }

  // The Trigger: Call this when they click a locked feature
  Future<bool> showPaywall() async {
    try {
      // Fixed the ID here too
      final result = await RevenueCatUI.presentPaywallIfNeeded("Improov Premium");

      if (result == PaywallResult.purchased || result == PaywallResult.restored) {
        state = true; // UNLOCK THE APP GLOBALLY
        debugPrint("💸 TRANSACTION SUCCESS! Welcome to Premium.");
        return true;
      }
      
      debugPrint("User closed paywall without buying.");
      return false;
    } catch (e) {
      debugPrint("Paywall Launch Error: $e");
      return false;
    }
  }
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});