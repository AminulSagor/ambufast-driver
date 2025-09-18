// lib/modules/set_password/set_password_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'set_password_controller.dart';

class SetPasswordView extends GetView<SetPasswordController> {
  const SetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(
          'powered'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.sp, color: Colors.black54),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 12.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              InkWell(
                onTap: controller.goBack,
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20.sp, color: Colors.black87),
                    SizedBox(width: 6.w),
                    Text('back'.tr,
                        style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Logo
              Center(
                child: Image.asset(
                  'assets/logo_with_color.png',
                  height: 70.h,
                ),
              ),

              SizedBox(height: 20.h),

              // Title + subtitle
              Center(
                child: Column(
                  children: [
                    Text(
                      'setpw_title'.tr,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3238),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'setpw_subtitle'.tr,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black54, height: 1.35),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Password
              Text('pw'.tr),
              SizedBox(height: 8.h),
              Obx(() {
                return TextField(
                  controller: controller.pwCtrl,
                  obscureText: controller.obscurePw.value,
                  decoration: InputDecoration(
                    hintText: 'hint_pw'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscurePw.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: controller.togglePw,
                    ),
                  ),
                );
              }),

              SizedBox(height: 18.h),

              // Confirm Password
              Text('confirm_pw'.tr),
              SizedBox(height: 8.h),
              Obx(() {
                return TextField(
                  controller: controller.cpwCtrl,
                  obscureText: controller.obscureCpw.value,
                  decoration: InputDecoration(
                    hintText: 'hint_confirm_pw'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureCpw.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: controller.toggleCpw,
                    ),
                  ),
                );
              }),

              SizedBox(height: 28.h),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43023),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'submit'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Image.asset(
                        'assets/icon/done_icon.png', // your white check
                        width: 20.w,
                        height: 20.w,
                        // color: Colors.white, // uncomment if needed
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
