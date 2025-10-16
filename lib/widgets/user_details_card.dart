import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/user_info.dart';
import '../utils/colors.dart';

class UserDetailsCard extends StatelessWidget {
  final bool showTimer;
  final bool showCallBtn;
  final UserInfo userInfo;
  final VoidCallback? onCall;
  const UserDetailsCard({
    super.key,
    this.showTimer = false,
    this.showCallBtn = false,
    required this.userInfo,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Driver Image/Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Container(
            width: 58.w,
            height: 58.h,
            color: Colors.grey[300],
            child: Image.asset(userInfo.avatarUrl),
          ),
        ),
        SizedBox(width: 15.w),

        // Name and Vehicle Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo.name,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    userInfo.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.star, color: Colors.orange, size: 18.w),
                  SizedBox(width: 2.w),
                  Text(
                    '(${userInfo.ratingCount.toStringAsFixed(1)} ratings)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Timer Badge
        if (showTimer)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF04F34).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Text(
              '04:09', // Timer text
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        if (showCallBtn)
          InkWell(
            onTap: onCall,
            child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: onCall == null ? neutralBase : posititveBase,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Image.asset(
                'assets/icon/phone-call.png',
                fit: BoxFit.cover,
                height: 14.w,
              ),
            ),
          ),
      ],
    );
  }
}
