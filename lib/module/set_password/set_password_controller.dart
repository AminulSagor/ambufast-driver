// lib/modules/set_password/set_password_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../combine_service/auth_service.dart';
import '../../routes/app_routes.dart';

class SetPasswordController extends GetxController {
  final pwCtrl = TextEditingController();
  final cpwCtrl = TextEditingController();

  final obscurePw = true.obs;
  final obscureCpw = true.obs;
  final isSubmitting = false.obs;

  // from arguments
  late final bool _isEmail;
  String? _email;
  String? _ext;
  String? _phone;
  String? _resetToken; // if your backend needs it later

  final _auth = AuthService();

  void togglePw()  => obscurePw.value  = !obscurePw.value;
  void toggleCpw() => obscureCpw.value = !obscureCpw.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // these are what VerifyController sent
    _isEmail    = (args['authChannel'] == 'email');
    _email      = args['email'] as String?;
    _ext        = args['ext'] as String?;
    _phone      = args['phone'] as String?;
    _resetToken = args['resetToken'] as String?;

    // (Optional) guard
    if (_isEmail && (_email == null || _email!.isEmpty)) {
      Get.snackbar('Error', 'Missing email for password reset',
          snackPosition: SnackPosition.BOTTOM);
    }
    if (!_isEmail && ((_ext?.isEmpty ?? true) || (_phone?.isEmpty ?? true))) {
      Get.snackbar('Error', 'Missing phone for password reset',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> submit() async {
    final p = pwCtrl.text.trim();
    final c = cpwCtrl.text.trim();

    if (p.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (p != c) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (isSubmitting.value) return;

    isSubmitting.value = true;
    try {
      if (_isEmail) {
        await _auth.resetPasswordEmail(email: _email!, password: p);
      } else {
        await _auth.resetPasswordPhone(ext: _ext!, phone: _phone!, password: p);
      }

      Get.snackbar('Success', 'Password updated successfully',
          snackPosition: SnackPosition.BOTTOM);

      Get.close(2);              // pop last 2 pages
      Get.offNamed(Routes.login); // replace current with login

    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar('Error', msg.isEmpty ? 'Failed to update password' : msg,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  void goBack() => Get.back();

  @override
  void onClose() {
    pwCtrl.dispose();
    cpwCtrl.dispose();
    super.onClose();
  }
}
