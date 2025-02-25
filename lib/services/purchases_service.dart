import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesService {
  static const _apiKey = 'appl_RmHLCbIpoROSdqCQzcAGKXdpQWy';
  static const String entitlementId = 'pro';
  static const String productId = 'com.shashankhegde73.glamr.weekly.searches';
  static const String offeringId = 'glamr-pro-unlimited-searches';

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(
      PurchasesConfiguration(_apiKey)
    );
  }

  static Future<bool> checkProAccess() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(entitlementId);
    } catch (e) {
      return false;
    }
  }

  static Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  static Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      print('Debug - Available offerings: ${offerings.all}');
      print('Debug - Current offering: ${offerings.current}');
      return offerings;
    } catch (e) {
      print('Debug - Error fetching offerings: $e');
      return null;
    }
  }

  static Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      return await Purchases.purchasePackage(package);
    } catch (e) {
      print('Debug - Error making purchase: $e');
      return null;
    }
  }
} 