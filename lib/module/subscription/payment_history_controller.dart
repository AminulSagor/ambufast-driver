import 'dart:async';
import 'package:get/get.dart';

import 'models/payment_history_item.dart';

class PaymentHistoryController extends GetxController {
  final isLoading = true.obs;
  final items = <PaymentHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _mockLoad();
  }

  Future<void> _mockLoad() async {
    await Future.delayed(const Duration(milliseconds: 900));
    final now = DateTime(2025, 9, 1, 16, 40);
    items.assignAll(List.generate(8, (_) {
      return PaymentHistoryItem(
        planName: 'basic_plan',
        gateway: 'bkash_success',
        paidAt: now,
        amount: 5000,
      );
    }));
    isLoading.value = false;
  }
}
