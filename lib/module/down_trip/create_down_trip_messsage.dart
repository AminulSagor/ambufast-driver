import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/bottom_sheet_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import 'down_trip_controller.dart';

class CreateDownTripMessage extends GetView<DownTripController> {
  const CreateDownTripMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            // Header image placeholder (no extra asset required)
            Positioned(
              top: -50,
              left: -150,
              child: Container(
                color: Colors.grey[200], // Placeholder for the map widget
                child: Center(
                  child: Image.asset(
                    'assets/trip/change_bg.jpg', // Replace with a real map widget (e.g., google_maps_flutter)
                    fit: BoxFit.cover,
                    width: Get.width + 300,
                  ),
                ),
              ),
            ),

            // Close
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.r,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back<void>(),
                  ),
                ),
              ),
            ),

            // Bottom card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(maxHeight: 0.62.sh),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    14.h,
                    16.w,
                    20.h + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row
                      bottomSheetHeader(
                        'downtrip.title'.tr,
                        showDragHandle: false,
                        showGradientDivider: true,
                      ),
                      SizedBox(height: 24.h),

                      // Intro paragraph
                      Text(
                        'change_destination_intro'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: neutral600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Section: When you can change/add
                      Text(
                        'when_you_can_change'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: neutral600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _rule(true, 'rule_after_trip_started_before_dest'.tr),
                      _rule(false, 'rule_cannot_change_pickup'.tr),
                      _rule(false, 'rule_change_drop_once'.tr),
                      _rule(true, 'rule_add_multiple_stops'.tr),
                      SizedBox(height: 18.h),

                      SizedBox(height: 18.h),
                      CustomButton(
                        btnTxt: 'down_create_title'.tr,
                        onTap: controller.onCreateDownTrip,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rule(bool positive, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            positive ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: positive ? const Color(0xFF22C55E) : const Color(0xFFE11D48),
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12.sp, color: neutral700),
            ),
          ),
        ],
      ),
    );
  }
}
