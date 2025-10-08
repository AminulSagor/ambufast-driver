import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dialog_box/change_password_success.dart';

class ChangePasswordController extends GetxController {
  // Form state
  final formKey = GlobalKey<FormState>();

  final currentCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  // UI state
  final obscureCurrent = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;
  final isSubmitting = false.obs;

  String? requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'required'.tr : null;

  String? newPasswordValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'required'.tr;
    if (v.trim().length < 6) return 'pwd_min'.tr;
    return null;
  }

  String? confirmValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'required'.tr;
    if (v.trim() != newCtrl.text.trim()) return 'pwd_mismatch'.tr;
    return null;
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSubmitting.value = true;

    // Mock API call
    await Future.delayed(const Duration(seconds: 1));

    isSubmitting.value = false;

    // Clear sensitive fields
    currentCtrl.clear();
    newCtrl.clear();
    confirmCtrl.clear();

    // Show success dialog
    showSuccessPopup();
  }

  void showSuccessPopup() {
    Get.dialog(
      barrierDismissible: true,
      useSafeArea: true,
      const ChangePasswordSuccess(),
    );
  }

  @override
  void onClose() {
    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }
}


