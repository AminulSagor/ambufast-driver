// lib/modules/verify/verify_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'verify_controller.dart';

class VerifyView extends GetView<VerifyController> {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

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

              // Title & dynamic subtitle
              Obx(() {
                final subtitle = controller.isEmail.value
                    ? 'verify_subtitle_email'.tr
                    : 'verify_subtitle_phone'.tr;

                return Column(
                  children: [
                    Text(
                      'verify_title'.tr,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3238),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black54, height: 1.35),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),

              SizedBox(height: 20.h),

              // OTP boxes
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: TextField(
                      controller: controller.otpCtrls[i],
                      focusNode: controller.otpNodes[i],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onChanged: (v) => controller.onOtpChanged(i, v),
                    ),
                  );
                }),
              ),

              SizedBox(height: 16.h),

              // Timer + Resend
              Obx(() {
                return Row(
                  children: [
                    Text(
                      controller.timerText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const Spacer(),
                    AbsorbPointer(
                      absorbing: !controller.canResend.value,
                      child: Opacity(
                        opacity: controller.canResend.value ? 1 : 0.45,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F4),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: GestureDetector(
                            onTap: controller.resendOtp,
                            child: Text(
                              'resend_otp'.tr, // (en) Resent OTP / (bn) পুনরায় OTP পাঠান
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 16.h),

              // Change destination (dynamic)
              Center(
                child: Obx(() {
                  return GestureDetector(
                    onTap: controller.changeDestination,
                    child: Text(
                      controller.isEmail.value ? 'change_email'.tr : 'change_phone'.tr,
                      style: TextStyle(
                        color: const Color(0xFF2E5BFF),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 22.h),

              // Verify button
              // Verify button
              // lib/modules/verify/verify_view.dart  (inside the button)
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: Obx(() {
                  final loading = controller.isVerifying.value;
                  return ElevatedButton(
                    onPressed: loading ? null : controller.verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF43023),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (loading) ...[
                          SizedBox(
                            width: 18.w, height: 18.w,
                            child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          SizedBox(width: 10.w),
                        ],
                        Text(
                          'verify_btn'.tr,
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        if (!loading) ...[
                          SizedBox(width: 10.w),
                          Image.asset('assets/icon/justify.png', width: 20.w, height: 20.w),
                        ],
                      ],
                    ),
                  );
                }),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
