// lib/modules/account/profile_creating_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../combine_service/auth_service.dart';
import '../../storage/token_storage.dart';




class ProfileCreatingView extends StatelessWidget {
  const ProfileCreatingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Read args passed from CreateAccountController
    final args = (Get.arguments as Map<String, dynamic>?) ?? {};
    final authChannel = (args['authChannel'] as String?)?.trim(); // 'email' | 'phone'
    final email = (args['email'] as String?)?.trim();
    final ext = (args['ext'] as String?)?.trim();
    final phone = (args['phone'] as String?)?.trim();
    final password = (args['password'] as String?)?.trim();

    // Fire once after first frame: attempt login + ensure min 2s display
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginThenRoute(
        authChannel: authChannel,
        email: email,
        ext: ext,
        phone: phone,
        password: password,
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // background gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF9FCFF), Color(0xFFF7FAFB)],
                  ),
                ),
              ),
            ),

            // blob behind phone
            Positioned(
              top: 210.h,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 230.w,
                  child: Image.asset(
                    'assets/successful_profile_creation_mobile_back.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // phone
            Positioned(
              top: 220.h,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/mobile.png',
                  height: 220.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // texts
            Column(
              children: [
                SizedBox(height: 480.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'profile_creating'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: const Color(0xFF2F3440),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'profile_customising'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text(
                    'powered'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---- logic ----

  Future<void> _loginThenRoute({
    required String? authChannel,
    required String? email,
    required String? ext,
    required String? phone,
    required String? password,
  }) async {
    final auth = AuthService();
    bool success = false;

    // Ensure the splash stays visible at least 2 seconds
    final minShow = Future.delayed(const Duration(seconds: 3));

    try {
      // Guard: if credentials are missing, skip login
      if ((password == null || password.isEmpty) ||
          (authChannel == 'email' && (email == null || email.isEmpty)) ||
          (authChannel == 'phone' && ((ext == null || ext.isEmpty) || (phone == null || phone.isEmpty)))) {
        success = false;
      } else {
        Map<String, dynamic> data;
        if (authChannel == 'email') {
          data = await auth.loginWithEmail(email: email!, password: password!);
        } else {
          data = await auth.loginWithPhone(ext: ext!, phone: phone!, password: password!);
        }

        // Save tokens if present (supports multiple backend key styles)
        await _persistTokens(data);
        success = true;
      }
    } catch (e) {
      // Optional: show a subtle message; avoid noisy logs here
      // showErrorSnackbar(e.toString().replaceFirst('Exception: ', ''));
      success = false;
    }

    // Wait for minimum display time before routing
    await minShow;

    if (success) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login', arguments: {'intent': 'login'});
    }
  }

  Future<void> _persistTokens(Map<String, dynamic> data) async {
    // Try common token shapes
    final access = (data['access_token'] ??
        data['token'] ??
        data['accessToken'] ??
        data['access']) as String?;
    final refresh = (data['refresh_token'] ??
        data['refreshToken'] ??
        data['refresh']) as String?;

    if (access != null && refresh != null) {
      await TokenStorage.saveTokens(access, refresh);
      return;
    }

    // Fallback: if your backend nests under data['tokens']
    final tokens = data['tokens'];
    if (tokens is Map) {
      final a = tokens['access'] ?? tokens['access_token'];
      final r = tokens['refresh'] ?? tokens['refresh_token'];
      if (a is String && r is String) {
        await TokenStorage.saveTokens(a, r);
        return;
      }
    }

    // If your project uses saveFromResponse() with specific keys, you can also:
    // await TokenStorage.saveFromResponse(data);
  }
}
