// lib/module/driving_license/edit/update_driving_license_controller.dart
import 'package:ambufast_driver/module/driving_license/driving_license_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'widgets/confirm_change_sheet.dart';

class UpdateDrivingLicenseController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final licenseNoCtrl = TextEditingController();
  final expiryTextCtrl = TextEditingController();

  final categories = const ['Professional', 'Non-professional', 'Learner'];
  final selectedCategory = RxnString();

  final frontPreview = Rxn<ImageProvider>();
  final backPreview = Rxn<ImageProvider>();

  final isSubmitting = false.obs;

  @override
  void onClose() {
    licenseNoCtrl.dispose();
    expiryTextCtrl.dispose();
    super.onClose();
  }

  Future<void> pickExpiryDate(BuildContext ctx) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: ctx,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 20),
      initialDate: now,
    );
    if (picked != null) {
      expiryTextCtrl.text = DateFormat('dd MMM yyyy').format(picked);
    }
  }

  // Mock upload: just drop a placeholder image
  Future<void> pickFront() async {
    frontPreview.value = const AssetImage('assets/mock_license.jpg');
  }

  Future<void> pickBack() async {
    backPreview.value = const AssetImage('assets/mock_license.jpg');
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (frontPreview.value == null || backPreview.value == null) {
      Get.snackbar('error'.tr, 'please_upload_both_sides'.tr);
      return;
    }

    final isConfirm = await Get.bottomSheet<bool>(
      const ConfirmChangeSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.35),
    );
    if (isConfirm ?? false) {
      final mainController = Get.find<DrivingLicenseController>();
      isSubmitting.value = true;
      await Future.delayed(const Duration(seconds: 1)); // mock API
      isSubmitting.value = false;

      Get.back(result: true);
      mainController.startUnderReviewThenMockReject();
    }
  }
}
