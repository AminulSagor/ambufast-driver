import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'colors.dart';

Widget divider({Color? color, double? thickness}) {
  return Divider(
    thickness: thickness ?? 1.h,
    color: color ?? neutral100,
    height: 1.h,
  );
}

Widget dragHandle() {
  return Column(
    children: [
      SizedBox(height: 8.h),
      // drag handle
      Container(
        width: 48.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: neutral100,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
      SizedBox(height: 12.h),
    ],
  );
}

Widget bottomSheetHeader(
  String title, {
  bool showGradientDivider = true,
  bool showDragHandle = true,
  String? subTitle,
  Color? titleColor,
  Color? subTitleColor,
  Widget? trailing,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (showDragHandle) dragHandle(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    title.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? blackBase,
                    ),
                  ),
                  if (subTitle != null)
                    Text(
                      subTitle.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: subTitleColor ?? blackBase,
                      ),
                    ),
                ],
              ),
            ),
            trailing ?? SizedBox(),
          ],
        ),
      ),
      16.h.verticalSpace,
      if (showGradientDivider) gradientDivider(),
    ],
  );
}

Widget gradientDivider() {
  return Container(
    height: 2.h,
    margin: EdgeInsets.symmetric(horizontal: 30.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.white,
          Colors.red.shade600,
          Colors.white,
        ], // Define your gradient colors
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
  );
}
