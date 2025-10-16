import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/bottom_sheet_helper.dart';
import '../../../utils/colors.dart';
import '../../../widgets/custom_button.dart';

class CreateConfirmationSheet extends StatelessWidget {
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  const CreateConfirmationSheet({
    super.key,
    this.onYes,
    this.onNo,
  });

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
                'sure_create_down_trip'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: neutral700,
                ),
              ),
              SizedBox(height: 32.h),

              // Primary button
              CustomButton(
                btnTxt: 'yes'.tr,
                onTap: onYes ?? () => Get.back(result: true),
              ),
              8.h.verticalSpace,
              CustomButton(
                btnTxt: 'no'.tr,
                btnColor: neutral100,
                txtColor: neutral700,
                onTap: onNo ?? () => Get.back(result: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
