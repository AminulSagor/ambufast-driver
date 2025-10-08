import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/confirm_delete_account_sheet.dart';

enum ConfirmBy { phone, email }

class DeleteAccountController extends GetxController {
  // ===== Reasons =====
  final reasons = <String>[
    'reason_no_need',
    'reason_issue_app',
    'reason_bad_experience',
    'reason_new_account',
    'reason_other',
  ];
  final selected = <bool>[false, false, false, false, false].obs;

  // ===== UI State =====
  final confirmBy = ConfirmBy.phone.obs;
  final isSubmitting = false.obs;

  // ===== Form State =====
  // (We keep a formKey for future use if needed, but we won't call validate())
  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  // ===== Actions =====
  void toggleReason(int i) {
    selected[i] = !selected[i];
    selected.refresh();
  }

  void switchTab(ConfirmBy v) => confirmBy.value = v;

  Future<void> submit() async {
    // Hide keyboard
    FocusScope.of(Get.context!).unfocus();

    // ---- Custom validation (Snackbar only) ----
    if (confirmBy.value == ConfirmBy.phone) {
      final err = _errorForPhone(phoneCtrl.text);
      if (err != null) {
        showWarningSnackbar(err);
        return;
      }
    } else {
      final err = _errorForEmail(emailCtrl.text);
      if (err != null) {
        showWarningSnackbar(err);
        return;
      }
    }

    // ---- Proceed with API ----
    isSubmitting.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1)); // mock API

    } finally {
      Get.bottomSheet(
        ConfirmDeleteAccountSheet(
          onCancel: () => Get.back(), // close sheet
          onConfirm: () {
            Get.back();                 // close sheet
            // navigate or call API
            // Get.toNamed(Routes.deleteAccountFinal) or controller.deleteAccount();
          },
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.35),
      );
      isSubmitting.value = false;
    }
  }

  // ===== Validation Helpers (return null when OK) =====
  String? _errorForPhone(String? v) {
    final t = (v ?? '').replaceAll(RegExp(r'\s+'), '');
    // Bangladesh mobile pattern: (+88)?01[3-9]########
    final bd = RegExp(r'^(?:\+?88)?01[3-9]\d{8}$');
    if (!bd.hasMatch(t)) {
      return 'validation_phone'.trIfExists ?? 'Please enter a valid phone number.';
    }
    return null;
  }

  String? _errorForEmail(String? v) {
    final t = (v ?? '').trim();
    final re = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$');
    if (!re.hasMatch(t)) {
      return 'validation_email'.trIfExists ?? 'Please enter a valid email address.';
    }
    return null;
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}

// Small ext to avoid crashes if a key is missing
extension _TrSafe on String {
  String? get trIfExists {
    final translations = Get.translations[Get.locale?.toString()] ?? {};
    return translations.containsKey(this) ? tr : null;
  }
}
