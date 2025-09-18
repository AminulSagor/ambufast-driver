// lib/modules/language/language_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/language_card_widget.dart';
import 'language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
                    Text('Back',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Language cards
              Obx(() {
                final code = controller.selectedCode.value;
                return Row(
                  children: [
                    LanguageCard(
                      label: 'English',
                      selected: code == 'en',
                      onTap: () => controller.select('en'),
                    ),
                    SizedBox(width: 16.w),
                    LanguageCard(
                      label: 'Bangla',
                      selected: code == 'bn',
                      onTap: () => controller.select('bn'),
                      highlightColor: const Color(0xFFFDECEC),
                      borderColor: const Color(0xFFF43023),
                    ),
                  ],
                );
              }),

              const Spacer(),

              // Continue button
              // inside LanguageView build()
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: controller.continueNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(fontSize: 16.sp,),
                      ),
                      SizedBox(width: 10.w),
                      // your arrow asset
                      Image.asset(
                        'assets/icon/arrow.png',
                        width: 25.w,
                        height: 25.w,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 18.h),

              // Footer
              Center(
                child: Text(
                  'Powered By SafeCare24/7 Medical Services Limited\nBeta Version 1.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.sp, color: Colors.black54, height: 1.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


