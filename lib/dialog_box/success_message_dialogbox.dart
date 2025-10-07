import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessMessageDialog extends StatelessWidget {
  const SuccessMessageDialog({
    super.key,
    this.iconAsset = 'assets/icon/update_icon.png', // change if needed
    this.title = 'Your message has been sent!',
    this.subtitle =
    "We've received your inquiry and will get back to you within 24–48 hours",
    this.onClose,
  });

  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 68.w,
              width: 68.w,
              child: Image.asset(iconAsset, fit: BoxFit.contain),
            ),
            SizedBox(height: 16.h),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 10.h),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5.sp,
                height: 1.45,
                color: const Color(0xFF4B5563),
              ),
            ),
            SizedBox(height: 20.h),

            SizedBox(
              width: 0.6.sw,
              height: 42.h,
              child: ElevatedButton(
                onPressed: onClose ?? () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5.sp,
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
