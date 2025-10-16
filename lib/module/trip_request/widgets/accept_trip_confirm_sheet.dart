import 'package:ambufast_driver/utils/bottom_sheet_helper.dart';
import 'package:ambufast_driver/utils/colors.dart';
import 'package:ambufast_driver/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AcceptTripConfirmSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const AcceptTripConfirmSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dragHandle(),
              12.h.verticalSpace,
              // Warning icon
              Image.asset(
                'assets/icon/ambu_error_icon.png',
                height: 40.h,
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                'accept_trip_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: neutral700,
                ),
              ),
              SizedBox(height: 12.h),

              // Bullets
              _bullet('✅ ${'accept_b1'.tr}'),
              _bullet('⛔ ${'accept_b2'.tr}'),
              _bullet('🔒 ${'accept_b3'.tr}'),
              _bullet('🛰️ ${'accept_b4'.tr}'),

              SizedBox(height: 18.h),

              // Primary button
              CustomButton(
                btnTxt: 'accept_trip'.tr,
                onTap: () {
                  Get.back(); // close sheet
                  onConfirm();
                },
              ),
              8.h.verticalSpace,
              CustomButton(
                btnTxt: 'cancel'.tr,
                btnColor: neutral100,
                txtColor: neutral700,
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.4,
                color: neutral700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
