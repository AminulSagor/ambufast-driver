import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EnableLocationDialog extends StatelessWidget {
  final VoidCallback onUseMyLocation;
  final VoidCallback onSkip;

  const EnableLocationDialog({
    super.key,
    required this.onUseMyLocation,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final radius = 18.r;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top illustration
            Padding(
              padding: EdgeInsets.only(top: 6.h, bottom: 16.h),
              child: Image.asset(
                'assets/icon/home_page_icon/big_circular_location_icon.png',
                height: 120.h,
                fit: BoxFit.contain,
              ),
            ),

            // title
            Text(
              'loc_enable_title'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                height: 1.25,
                color: const Color(0xFF111827),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),

            // subtitle
            Text(
              'loc_enable_subtitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.45,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18.h),

            // Use my location button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUseMyLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6322C),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'loc_use_my_location'.tr,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 10.w),
                    Image.asset(
                      'assets/icon/home_page_icon/small_circular_location.png',
                      height: 18.h,
                    ),
                  ],
                ),
              ),
            ),

            // Skip
            TextButton(
              onPressed: onSkip,
              child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  'loc_skip'.tr,
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
