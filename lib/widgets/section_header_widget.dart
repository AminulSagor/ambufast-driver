// lib/widgets/section_header_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  /// If null, the "View All" control is hidden.
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final hasViewAll = onViewAll != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          if (hasViewAll)
            InkWell(
              onTap: onViewAll,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                // generous tap target
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'home_view_all'.tr,
                      style: TextStyle(
                        color: const Color(0xFFF6322C), // #F6322C
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Image.asset(
                      'assets/icon/home_page_icon/filled_arrow_icon.png',
                      height: 14.h,
                      width: 14.w,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
