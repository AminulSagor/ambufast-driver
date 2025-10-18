// lib/donate_payment_selection/bkash_payment_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class BkashPaymentController extends GetxController {
  late final String merchant;
  late final String invoice;
  late final int amount; // minor units not used; show as 2dp
  late final String paymentFor;
  final phoneCtrl = TextEditingController();

  String get amountText =>
      '${amount.toStringAsFixed(0)}.00'; // 10000 -> 10000.00

  @override
  void onInit() {
    final args = (Get.arguments as Map?) ?? const {};
    merchant = (args['merchant'] as String?) ?? 'AmbuFast';
    invoice = (args['invoice'] as String?) ?? '0000000000000';
    amount = (args['amount'] as int?) ?? 0;
    paymentFor = (args['paymentFor'] as String?) ?? 'default';
    super.onInit();
  }

  void onCancel() => Get.back();

  void onConfirm() {
    final v = phoneCtrl.text.trim();
    if (v.length != 11 || !v.startsWith('01')) {
      Get.snackbar('validation_title'.tr, 'Please enter a valid bKash number.');
      return;
    }
    Get.offNamed(
      Routes.paymentSuccessful,
      arguments: {'amount': amount, 'paymentFor': paymentFor}, // int
    );
    Get.snackbar('done'.tr, 'Processing bKash payment for $merchant...');
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    super.onClose();
  }
}
