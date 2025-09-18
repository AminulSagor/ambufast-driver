// lib/modules/recover/recover_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../combine_service/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/snackbar_helper.dart';

class RecoverController extends GetxController {
  RecoverController({AuthService? auth}) : _auth = auth ?? AuthService();
  final AuthService _auth;

  final tabIndex = 0.obs; // 0 = phone, 1 = email
  final isSubmitting = false.obs;

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool _resetPass = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _resetPass = (args['resetPass'] as bool?) ?? false;
  }

  void changeTab(int i) => tabIndex.value = i;

  // from your login controller: keep country code digits only
  String _extractExt() {
    final cc = 'country_code_bd'.tr;      // "+880" / "+৮৮০"
    final digits = cc.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? '880' : digits;
  }
  String _digitsOnly(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  Future<void> sendOtp() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    try {
      if (tabIndex.value == 0) {
        // ----- phone flow -----
        final raw = phoneController.text.trim();
        final phone = _digitsOnly(raw);
        if (phone.isEmpty) throw Exception('Please enter phone number');

        final ext = _extractExt(); // e.g., "880"
        await _auth.requestRecoverOtpSms(ext: ext, phone: phone);

        // ✅ forward the flag to /verify
        Get.toNamed(
          Routes.verify,
          arguments: {
            'isEmail'    : false,
            'destination': '+$ext ${phone.substring(phone.length - 4).padLeft(phone.length, '•')}',
            'ext'        : ext,
            'phone'      : phone,
            'resetPass'  : _resetPass, // ✅
          },
        );
      } else {
        // ----- email flow -----
        final email = emailController.text.trim();
        if (!GetUtils.isEmail(email)) throw Exception('Please enter a valid email address');

        await _auth.requestRecoverOtpEmail(email: email);

        // ✅ forward the flag to /verify
        Get.toNamed(
          Routes.verify,
          arguments: {
            'isEmail'    : true,
            'destination': email.replaceRange(3, email.indexOf('@'), '••••'),
            'email'      : email,
            'resetPass'  : _resetPass, // ✅
          },
        );
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      showErrorSnackbar(msg.isEmpty ? 'Something went wrong.' : msg);
    } finally {
      isSubmitting.value = false;
    }
  }
  void goBack() => Get.back();
  void goToLogin() => Get.back();

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
