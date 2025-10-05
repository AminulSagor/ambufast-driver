import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AmbuFast red
const _kDanger = Color(0xFFFF3B30);

/// Shows the confirm sheet and returns `true` if user taps "Yes, Logout".
Future<bool?> showLogoutConfirmSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    useSafeArea: true,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    barrierColor: Colors.black.withOpacity(.35),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (ctx) => const _LogoutConfirmContent(),
  );
}

class _LogoutConfirmContent extends StatelessWidget {
  const _LogoutConfirmContent();

  @override
  Widget build(BuildContext context) {
    // Assumes ScreenUtilInit is set globally
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Danger octagon icon
          Container(
            width: 48.r,
            height: 48.r,
            decoration: ShapeDecoration(
              color: _kDanger,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10.r), // cut corners → octagon feel
              ),
            ),
            child: Icon(Icons.priority_high_rounded, color: Colors.white, size: 28.r),
          ),
          SizedBox(height: 16.h),

          // Title
          Text(
            'Are you sure?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Text(
            'Are you sure you want to log out? You might\nmiss important trips.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5.sp,
              height: 1.35,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF374151),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kDanger,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Yes, Logout'),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
