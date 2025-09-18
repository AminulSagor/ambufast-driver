import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kSurface = Color(0xFFF7F8F8);

class StepCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;

  const StepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(blurRadius: 8.r, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDE8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFFEA6042),
                  ),
                ),
              ),
            ],
          ),
          6.h.verticalSpace,
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
