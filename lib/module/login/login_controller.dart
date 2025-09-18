// lib/modules/login/login_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../combine_service/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../storage/token_storage.dart';
import '../../utils/snackbar_helper.dart';

enum LoginIntent { login, recover, register }

class LoginController extends GetxController {
  LoginController({AuthService? auth}) : _auth = auth ?? AuthService();

  final AuthService _auth;

  final tabIndex = 0.obs; // 0 = phone, 1 = email
  final intent = LoginIntent.login.obs;

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isSubmitting = false.obs;
  // login_controller.dart  (add these fields)


  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }



  LoginIntent _parseIntent(dynamic raw) {
    switch (raw) {
      case 'recover':  return LoginIntent.recover;
      case 'register': return LoginIntent.register;
      case 'login':
      default:         return LoginIntent.login;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final parsed = _parseIntent(args?['intent']);
    intent.value = parsed;

    if (parsed == LoginIntent.recover) {
      Future.microtask(goToRecover);
    }
  }

  // ------------ helpers ------------
  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void changeTab(int index) => tabIndex.value = index;
  void switchTo(LoginIntent target) => intent.value = target;

  String _extractExt() {
    // From translations we show "+880" to user. API expects "880".
    final cc = 'country_code_bd'.tr; // "+880" or "+৮৮০"
    final digits = cc.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? '880' : digits;
  }

  String _sanitizePhone(String input) {
    // keep digits only, drop leading zeros if needed based on backend rules
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String _maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    final visible = phone.substring(phone.length - 4);
    return '••••••$visible';
  }

  // ------------ actions ------------
  Future<void> login({bool rememberMe = false}) async {
    final pwd = passwordController.text.trim();
    if (pwd.isEmpty) {
      showErrorSnackbar('Please enter your password.');
      return;
    }

    isSubmitting.value = true;
    try {
      Map<String, dynamic> data;

      if (tabIndex.value == 0) {
        // Login with phone
        final rawPhone = phoneController.text.trim();
        final phone = _sanitizePhone(rawPhone);
        if (phone.isEmpty || phone.length < 7) {
          showErrorSnackbar('Please enter a valid phone number.');
          return;
        }
        final ext = _extractExt();
        data = await _auth.loginWithPhone(ext: ext, phone: phone, password: pwd);
        // We usually DO NOT remember phone+password; skip credentials.
      } else {
        // Login with email
        final email = emailController.text.trim();
        if (!GetUtils.isEmail(email)) {
          showErrorSnackbar('Please enter a valid email address.');
          return;
        }
        data = await _auth.loginWithEmail(email: email, password: pwd);

        // Remember me (optional)
        if (rememberMe) {
          await TokenStorage.saveCredentials(email, pwd);
        } else {
          await TokenStorage.clearCredentials();
        }
      }

      // Save tokens
      final access = data['accessToken']?.toString();
      final refresh = data['refreshToken']?.toString();
      if (access == null || refresh == null) {
        throw Exception('Malformed login response.');
      }
      await TokenStorage.saveTokens(access, refresh);

      // Navigate to home (adjust route)
      Get.offAllNamed(Routes.home, arguments: {'user': data['user']});
    } catch (e) {
      showErrorSnackbar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isSubmitting.value = false;
    }
  }


  // lib/modules/login/login_controller.dart
  Future<void> sendOtp() async {
    isSubmitting.value = true;

    try {
      if (tabIndex.value == 0) {
        // Phone OTP
        final rawPhone = phoneController.text.trim();
        final phone = _sanitizePhone(rawPhone);

        if (phone.isEmpty || phone.length < 7) {
          Get.snackbar('Invalid', 'Please enter a valid phone number.');
          isSubmitting.value = false;
          return;
        }

        final ext = _extractExt();
        await _auth.requestOtpSms(ext: ext, phone: phone);

        Get.toNamed(
          '/verify',
          arguments: {
            'isEmail': false,
            'destination': '+$ext ${_maskPhone(phone)}',
            'ext': ext,
            'phone': phone,
          },
        );
      } else {
        // Email OTP
        final email = emailController.text.trim();
        if (!GetUtils.isEmail(email)) {
          Get.snackbar('Invalid', 'Please enter a valid email address.');
          isSubmitting.value = false;
          return;
        }

        await _auth.requestOtpEmail(email: email);

        Get.toNamed(
          '/verify',
          arguments: {
            'isEmail': true,
            'destination': email.replaceRange(3, email.indexOf('@'), '••••'),
            'email': email,
          },
        );
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      showErrorSnackbar(msg);
    } finally {
      isSubmitting.value = false;
    }
  }


  void primaryAction() {
    if (intent.value == LoginIntent.register) {
      sendOtp();
    } else {
      login();
    }
  }

  void goToRecover() =>
      Get.toNamed('/recover', arguments: {'resetPass': true});

  void goToRegister() => switchTo(LoginIntent.register);
  void goToLogin() => switchTo(LoginIntent.login);
  void goBack() => Get.back();
}
