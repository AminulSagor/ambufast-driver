import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class DonateMoneyController extends GetxController {
  // State
  final selectedCause = RxnString();
  final selectedAmount = 0.obs;
  final agreeTerms = false.obs;

  // UI helpers
  final customAmountCtrl = TextEditingController();
  final customAmountFocus = FocusNode();

  // Data
  final causes = const [
    'cause_general_fund',
    'cause_ambulance_trip_help',
    'cause_emergency_medical_help',
    'cause_dead_body_transfer',
  ];


  final amounts = const [500, 1000, 2000, 4000, 5000, 10000];

  void chooseCause(String value) => selectedCause.value = value;

  void chooseAmount(int value) {
    selectedAmount.value = value;
    customAmountCtrl.text = ''; // clear custom if a preset chosen
    customAmountFocus.unfocus();
  }

  void selectOthersAmount() {
    selectedAmount.value = 0;
    customAmountCtrl.text = '';
    customAmountFocus.requestFocus();
  }

  void toggleTerms(bool? v) => agreeTerms.value = v ?? false;

  int get effectiveAmount {
    if (selectedAmount.value > 0) return selectedAmount.value;
    final parsed = int.tryParse(customAmountCtrl.text.trim());
    return parsed ?? 0;
  }

  bool get canReview =>
      (selectedCause.value?.isNotEmpty ?? false) &&
          effectiveAmount > 0 &&
          agreeTerms.value;

  void onTapReview() {
    if (!canReview) {
      Get.snackbar('validation_title'.tr, 'validation_support_msg'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Navigate to Support Payment screen with data
    Get.toNamed(
      Routes.supportPayment,
      arguments: {
        'causeKey': selectedCause.value,  // e.g. 'cause_general_fund'
        'amount': effectiveAmount,        // e.g. 10000
      },
    );
  }

  @override
  void onClose() {
    customAmountCtrl.dispose();
    customAmountFocus.dispose();
    super.onClose();
  }
}
