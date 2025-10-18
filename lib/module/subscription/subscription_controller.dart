import 'dart:async';
import 'package:ambufast_driver/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../dialog_box/payment_option_dialogbox.dart';

class SubscriptionController extends GetxController {
  final isLoading = true.obs;
  final isSubscribing = false.obs;
  final isSubscribed = false.obs;

  /// NEW: toggles between the landing page and the plan selection page
  final showPlans = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Mock initial load
    Future.delayed(const Duration(seconds: 1), () => isLoading.value = false);
  }

  void history() {
    Get.toNamed(Routes.paymentHistory);
  }

  void openPlans() => showPlans.value = true;
  void closePlans() => showPlans.value = false;

  /// AppBar back behavior: if on plans, go back to landing; else pop.
  void onBack() {
    if (showPlans.value) {
      closePlans();
    } else {
      Get.back();
    }
  }

  Future<void> subscribe() async {
    // Get.back(); // Close the screen
    Get.dialog(
      PaymentOptionDialogbox(
        onSelect: () {
          Get.toNamed(
            Routes.bkashPayment,
            arguments: {'paymentFor': 'subscription'},
          );
        },
      ),
    );
  }
}
