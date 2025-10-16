// lib/module/trip_request/trip_request_view.dart
import 'package:ambufast_driver/module/trip_request/widgets/booking_details_card.dart';
import 'package:ambufast_driver/utils/bottom_sheet_helper.dart';
import 'package:ambufast_driver/utils/colors.dart';
import 'package:ambufast_driver/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/custom_back_navigaiton.dart';
import 'trip_request_controller.dart';

class TripRequestView extends GetView<TripRequestController> {
  const TripRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _MapMock(),

          // Close FAB
          Positioned(
            top: 60.h,
            left: 16.w,
            child: CustomBackNavigaiton(
              isClose: true,
              onTap: () => Get.back(),
            ),
          ),

          // Draggable bottom sheet (collapsed ↔ expanded)
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (n) {
              controller.sheetExtent.value = n.extent;
              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: controller.expandedSize,
              minChildSize: controller.collapsedSize,
              maxChildSize: controller.expandedSize,
              snap: true,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18.r)),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 16,
                          offset: Offset(0, -4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Grab handle

                      // Single scrollable owns the sheet controller
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Obx(
                            () => _SheetContent(
                              controller: controller,
                              isExpanded: controller.isExpanded,
                            ),
                          ),
                        ),
                      ),

                      // Bottom CTA
                      GetBuilder<TripRequestController>(
                        id: 'cta',
                        builder: (contoller) {
                          final disabled = contoller.left.value <= 0;
                          return SafeArea(
                            top: false,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 10.h),
                              child: CustomButton(
                                btnTxt: 'accept_trip'.tr,
                                onTap: disabled
                                    ? null
                                    : contoller.openAcceptConfirm,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------- Expanded Content ----------------------- */

class _SheetContent extends StatelessWidget {
  final TripRequestController controller;
  final bool isExpanded;
  const _SheetContent({
    required this.controller,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // key: const ValueKey('expanded_content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
            ),
            color: colorBg,
          ),
          width: double.infinity,
          child: dragHandle(),
        ),

        // Header + timer
        Container(
          color: colorBg,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'respond_title'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: blackFrontS,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'respond_sub'.tr,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              30.w.horizontalSpace,
              Obx(() => _TimerPill(text: controller.timerText)),
            ],
          ),
        ),
        divider(thickness: 2.h),
        BookingDetailsCard(
          requestDetails: controller.request.value,
          whenText: controller.whenText(),
          userInfo: controller.userInfo.value,
          isExpanded: controller.isExpanded,
        ),

        // More details (expanded-only)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isExpanded) ...[
                divider(),
                12.h.verticalSpace,
                Row(
                  children: [
                    Text(
                      'estimated_fare'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: infoBase,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    8.w.horizontalSpace,
                    Expanded(
                      child: Text(
                        '--------------------------------------',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: infoBase,
                        ),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                    8.w.horizontalSpace,
                    Text(
                      controller.money(controller.request.value.fare),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: infoBase,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(
                      Icons.info,
                      size: 18,
                      color: infoBase,
                    ),
                  ],
                ),
                24.h.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: neutral700,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'cash'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: neutral700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                12.h.verticalSpace,
              ],
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}

/* ----------------------- Helpers ----------------------- */

class _TimerPill extends StatelessWidget {
  final String text;
  const _TimerPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: negative50,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: neutral800,
        ),
      ),
    );
  }
}

class _MapMock extends StatelessWidget {
  const _MapMock();

  @override
  Widget build(BuildContext context) {
    // Replace with real Map widget later
    return Positioned.fill(
      child: Image.asset(
        'assets/map_image.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
