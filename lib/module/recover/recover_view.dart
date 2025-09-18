// lib/modules/recover/recover_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'recover_controller.dart';

class RecoverView extends GetView<RecoverController> {
  const RecoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      // Footer pinned at the bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(
          'Powered By SafeCare24/7 Medical Services Limited\nBeta Version 1.0',
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
                    Text(
                      'back'.tr,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Logo
              Center(
                child: Image.asset(
                  'assets/logo_with_color.png', // ensure path matches pubspec
                  height: 70.h,
                ),
              ),

              SizedBox(height: 20.h),

              // Title + subtitle
              // Title + subtitle
              Center(
                child: Column(
                  children: [
                    Text(
                      'recover_title'.tr,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3238),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),

                    // ✅ Dynamic subtitle
                    Obx(() {
                      final isPhone = controller.tabIndex.value == 0;
                      return Text(
                        isPhone
                            ? 'recover_subtitle_phone'.tr
                            : 'recover_subtitle_email'.tr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black54,
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ],
                ),
              ),


              SizedBox(height: 20.h),

              // Tabs (joined rectangle)
              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: controller.tabIndex.value == 0
                                ? const Color(0xFF2E3239)
                                : const Color(0xFFEDEDEE),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'tab_phone'.tr,
                            style: TextStyle(
                              color: controller.tabIndex.value == 0
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(1),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: controller.tabIndex.value == 1
                                ? const Color(0xFF2E3239)
                                : const Color(0xFFEDEDEE),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'tab_email'.tr,
                            style: TextStyle(
                              color: controller.tabIndex.value == 1
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 20.h),

              // Phone / Email form
              Obx(() {
                if (controller.tabIndex.value == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('label_phone'.tr),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Container(
                            height: 52.h, // ✅ fixed height
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/bangladesh_flag.png',
                                  width: 20.w,
                                ),
                                SizedBox(width: 6.w),
                                Text('country_code_bd'.tr),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: SizedBox(
                              height: 52.h, // ✅ same height as flag container
                              child: TextField(
                                controller: controller.phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'hint_phone'.tr,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 14.h, // fine-tune text alignment
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('label_email'.tr),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 52.h, // ✅ keep consistent height for email input too
                        child: TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'hint_email'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),


              SizedBox(height: 22.h),

              // Send OTP button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: controller.sendOtp,
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
                        'send_otp'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Image.asset(
                        'assets/icon/arrow.png',
                        width: 20.w,
                        height: 20.w,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 26.h),

              // "Have a account? Login"
              Center(
                child: GestureDetector(
                  onTap: controller.goToLogin,
                  child: RichText(
                    text: TextSpan(
                      text: '${'have_account_q'.tr} ',
                      style: TextStyle(color: Colors.black45, fontSize: 13.sp),
                      children: [
                        TextSpan(
                          text: 'login'.tr,
                          style: const TextStyle(
                            color: Color(0xFFF43023),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // No Spacer() here (we’re inside a scroll view)
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
