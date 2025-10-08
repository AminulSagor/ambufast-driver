// lib/account/account_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../legal/legal_policy_controller.dart';
import '../../legal/payment_cancellation_view.dart';
import '../../routes/app_routes.dart';
import '../../storage/token_storage.dart';

class AccountController extends GetxController {
  // Demo values – in your app, inject a repository/service and load these.
  final driverName = 'Kamrul'.obs;
  final rating = 5.0.obs;
  final vehicleTitle = 'Toyota | Dhaka Metro 12 5896'.obs;
  final planExpireDate = '20 Dec, 2025'.obs;
  final trips = 522.obs;
  final years = 2.obs;
  final acceptanceRate = 80.obs;
  final cancellationRate = 20.obs;

  void onTapItem(String key) {
    // Centralized navigation/events
    switch (key) {
      case 'profile':
        Get.toNamed(Routes.profileDetails);
        break;
      case 'subscription':
        Get.snackbar('Open', 'Subscription');
        break;
      case 'reviews':
        Get.toNamed(Routes.allReview);
        break;
      case 'my_earning':
        Get.snackbar('Open', 'My Earning');
        break;
      case 'my_vehicles':
        Get.toNamed(Routes.myVehicles);
        break;
      case 'driving_license':
        Get.snackbar('Open', 'Driving License');
        break;
      case 'vehicle_papers':
        Get.snackbar('Open', 'Vehicle Papers');
        break;
      case 'language':
        Get.snackbar('Open', 'Language');
        break;
      case 'notification':
        Get.snackbar('Open', 'Notification');
        break;
      case 'change_password':
        Get.to(() => const PaymentCancellationInfoView());
        break;
      case 'tap_sos':
        Get.toNamed(Routes.emergencySos);
        break;
      case 'help_center':
        Get.toNamed(Routes.helpCenter);
      case 'contact_support':
        Get.toNamed(Routes.contactSupport);
      case 'terms_conditions':
        _openPolicy(PolicyType.terms);
        break;
      case 'privacy_policy':
        _openPolicy(PolicyType.privacy);
        break;
      case 'cancellation_policy':
        _openPolicy(PolicyType.cancellation);
        break;
      case 'refund_policy': // ✅ newly added
        _openPolicy(PolicyType.refund);
        break;

      default:
        break;

    }
  }

  void _openPolicy(PolicyType type) {
    Get.toNamed(Routes.legalPolicy, arguments: {'type': type.name});
  }

  Future<void> logout() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await TokenStorage.clearTokens();
      // await TokenStorage.clearCredentials(); // if you also want to forget saved login

      // Clear all registered deps but KEEP navigator
      Get.deleteAll(force: true);
    } finally {
      if (Get.isDialogOpen == true) Get.back();
    }

    // Navigate after cleanup
    Get.offAllNamed(Routes.login);
  }
}
