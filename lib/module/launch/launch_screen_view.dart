// lib/modules/launch/launch_screen_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routes/app_routes.dart';

class LaunchScreenView extends StatelessWidget {
  const LaunchScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          SizedBox.expand(
            child: Image.asset(
              "assets/launch_screen_background.png",
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),

                  // Logo
                  Image.asset("assets/logo.png", height: 80.h),

                  const Spacer(),

                  // Title
                  Text(
                    'welcome_title'.tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    'welcome_subtitle'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 30.h),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(Routes.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text('login'.tr, style: TextStyle(fontSize: 16.sp)),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Create account button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(
                        Routes.login,
                        arguments: {'intent': 'register'}, // <-- pass flag
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text('create_account'.tr, style: TextStyle(fontSize: 16.sp)),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Footer
                  Text(
                    'powered'.tr,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
