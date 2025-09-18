// lib/modules/verify/verify_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../combine_service/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/snackbar_helper.dart';

class VerifyController extends GetxController {
  VerifyController({AuthService? auth}) : _auth = auth ?? AuthService();
  final AuthService _auth;

  // true => email verification, false => phone verification
  final isEmail = true.obs;
  final destination = ''.obs;

  // payload carried from previous screen
  String? _ext;
  String? _phone;
  String? _email;
  bool _resetPass = false;

  // OTP inputs
  final List<TextEditingController> otpCtrls =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpNodes = List.generate(6, (_) => FocusNode());

  // timer (mm:ss)
  final _seconds = 2 * 60 + 46; // 02:46 like your UI
  final secondsLeft = 0.obs;
  Timer? _timer;

  final canResend = false.obs;
  final isVerifying = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<dynamic, dynamic>?;

    isEmail.value = (args?['isEmail'] as bool?) ?? true;
    destination.value = (args?['destination'] as String?)?.trim() ?? '';
    _ext = (args?['ext'] as String?)?.trim();
    _phone = (args?['phone'] as String?)?.trim();
    _email = (args?['email'] as String?)?.trim();

    _resetPass = (args?['resetPass'] as bool?) ??
        (args?['forResetPass'] as bool?) ??
        false;

    _startTimer();
  }

  // ----- UI helpers -----
  String get timerText {
    final m = (secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft.value % 60).toString().padLeft(2, '0');
    return 'timer_mm_ss'.trArgs([m, s]);
  }

  String _otpValue() {
    // keep only digits, join to a 6-length string if possible
    final raw = otpCtrls.map((c) => c.text).join();
    return raw.replaceAll(RegExp(r'\D'), '');
  }

  void onOtpChanged(int index, String value) {
    // move forward
    if (value.isNotEmpty && index < otpNodes.length - 1) {
      otpNodes[index + 1].requestFocus();
      return;
    }
    // backspace to previous if empty
    if (value.isEmpty && index > 0) {
      otpNodes[index - 1].requestFocus();
    }
  }

  // ----- Timer / resend -----
  void _startTimer() {
    secondsLeft.value = _seconds;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value <= 1) {
        t.cancel();
        canResend.value = true;
        secondsLeft.value = 0;
      } else {
        secondsLeft.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;
    try {
      if (isEmail.value) {
        if ((_email ?? '').isEmpty) throw Exception('Missing email.');
        if (_resetPass) {
          await _auth.requestRecoverOtpEmail(email: _email!);   // ✅ recover flow
        } else {
          await _auth.requestOtpEmail(email: _email!);          // ✅ signup flow
        }
      } else {
        if ((_ext ?? '').isEmpty || (_phone ?? '').isEmpty) {
          throw Exception('Missing phone payload.');
        }
        if (_resetPass) {
          await _auth.requestRecoverOtpSms(ext: _ext!, phone: _phone!); // ✅ recover flow
        } else {
          await _auth.requestOtpSms(ext: _ext!, phone: _phone!);        // ✅ signup flow
        }
      }
      Get.snackbar('OTP', 'OTP re-sent');
      _startTimer();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }


  // ----- Verify -----
  Future<void> verify() async {
    final otp = _otpValue();
    if (otp.length != 6) {
      showErrorSnackbar('Please enter the 6-digit code.');
      return;
    }

    isVerifying.value = true;
    try {
      Map<String, dynamic> verifyResult;
      if (isEmail.value) {
        if ((_email ?? '').isEmpty) throw Exception('Missing email.');
        verifyResult = await _auth.verifyOtpEmail(email: _email!, otp: otp);
      } else {
        if ((_ext ?? '').isEmpty || (_phone ?? '').isEmpty) {
          throw Exception('Missing phone payload.');
        }
        verifyResult = await _auth.verifyOtpSms(ext: _ext!, phone: _phone!, otp: otp);
      }

      // Common args to pass forward
      final commonArgs = <String, dynamic>{
        'authChannel': isEmail.value ? 'email' : 'phone',
        if (isEmail.value) 'email': _email else ...{'ext': _ext, 'phone': _phone},
        'otp': otp,
        // if your backend returns a one-time reset token, pass it:
        if (verifyResult.containsKey('resetToken')) 'resetToken': verifyResult['resetToken'],
        'verifyResult': verifyResult,
      };

      if (_resetPass) {
        // ✅ go to set password flow
        Get.offNamed(Routes.setPassword, arguments: commonArgs);
      } else {
        // ✅ normal onboarding
        Get.offNamed(Routes.createAccount, arguments: commonArgs);
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      showErrorSnackbar(msg.isEmpty ? 'Something went wrong.' : msg);
    } finally {
      isVerifying.value = false;
    }
  }


  void changeDestination() => Get.back();
  void goBack() => Get.back();

  @override
  void onClose() {
    for (final c in otpCtrls) c.dispose();
    for (final n in otpNodes) n.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
