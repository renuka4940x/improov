import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:flutter/foundation.dart';

// State is a simple boolean: true if Premium, false if Free
class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    _initStatus();
  }

  // Check status when the app opens
  Future<void> _initStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      // ⚠️ IMPORTANT: Change "premium" to the exact Entitlement ID you set in RevenueCat!
      state = customerInfo.entitlements.all["premium"]?.isActive ?? false;
      debugPrint("👑 Premium Status Initialized: $state");
    } catch (e) {
      debugPrint("RevenueCat Init Error: $e");
      state = false;
    }
  }

  // The Trigger: Call this when they click a locked feature
  Future<bool> showPaywall() async {
    try {
      // Summons the beautiful native UI we fixed yesterday
      final result = await RevenueCatUI.presentPaywallIfNeeded("premium");

      if (result == PaywallResult.purchased || result == PaywallResult.restored) {
        state = true; // UNLOCK THE APP GLOBALLY
        
        // TODO: (Optional) If you have an Isar Settings table, update `isPremium: true` here for offline cache!
        
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