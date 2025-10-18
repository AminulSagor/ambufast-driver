import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../widgets/custom_button.dart';

class ConfirmChangeSheet extends StatelessWidget {
  const ConfirmChangeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // grab handle
              Container(
                width: 56.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              SizedBox(height: 16.h),

              // Warning icon
              Image.asset('assets/icon/ambu_error_icon.png', height: 48.h),
              SizedBox(height: 16.h),

              // Title
              Text(
                'confirm_change_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16.h),

              // Intro
              Text(
                'confirm_change_intro'.tr,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14.sp, color: neutral800),
              ),

              // bullets
              _bullet('confirm_point_1'.tr),
              _bullet('confirm_point_2'.tr),
              _bullet('confirm_point_3'.tr),
              SizedBox(height: 12.h),

              // Important notes
              Row(
                children: [
                  Icon(
                    Icons.priority_high_rounded,
                    color: primaryBase,
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'important_notes'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: primaryBase,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              _bullet('note_1'.tr, danger: true),
              _bullet('note_2'.tr, danger: true),
              _bullet('note_3'.tr, danger: true),
              SizedBox(height: 16.h),

              // CTA buttons
              CustomButton(
                btnTxt: 'submit_for_review'.tr,
                onTap: () => Get.back(result: true),
              ),

              SizedBox(height: 16.h),
              CustomButton(
                btnTxt: 'go_back'.tr,
                onTap: () => Get.back(result: false),
                btnColor: neutral100,
                borderColor: neutral100,
                txtColor: neutral800,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text, {bool danger = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: TextStyle(
              color: danger ? primaryBase : neutral800,
              fontSize: 14.sp,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: danger ? 12.sp : 14.sp,
                color: danger ? primaryBase : neutral800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
