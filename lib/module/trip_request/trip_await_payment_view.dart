import 'package:ambufast_driver/module/trip_request/widgets/booking_details_card.dart';
import 'package:ambufast_driver/utils/colors.dart';
import 'package:ambufast_driver/widgets/custom_back_navigaiton.dart';
import 'package:ambufast_driver/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'trip_await_payment_controller.dart';

class TripAwaitPaymentView extends GetView<TripAwaitPaymentController> {
  const TripAwaitPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background (subtle)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // Warning icon
                      28.h.verticalSpace,
                      // Warning icon
                      Image.asset(
                        'assets/icon/ambu_error_icon.png',
                        height: 40.h,
                      ),
                      SizedBox(height: 28.h),

                      // Title + subtitle
                      Text(
                        'await_payment_title'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: neutral700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'await_payment_desc'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            color: neutral700,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Promo banner (mock)
                      Container(
                        height: 120.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12.r),
                          image: const DecorationImage(
                            image: AssetImage('assets/slider_image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _dot(true),
                              SizedBox(width: 4.w),
                              _dot(false),
                              SizedBox(width: 4.w),
                              _dot(false),
                            ],
                          ),
                        ),
                      ),

                      // booking details
                      BookingDetailsCard(
                        requestDetails: controller.request,
                        whenText: controller.whenText(),
                        userInfo: controller.user,
                        showCallBtn: true,
                      ),
                    ],
                  ),
                ),

                // Disabled CTA
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: CustomButton(
                      btnTxt: 'navigate_to_pickup'.tr,
                      onTap: controller.onNavigatePressed,
                      leading: const Icon(
                        Icons.map_outlined,
                        color: baseWhite50,
                      ),
                      btnColor: neutralBase,
                      txtColor: baseWhite50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60.h,
            left: 16.w,
            child: CustomBackNavigaiton(
              isClose: true,
              onTap: controller.onClosePressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(bool active) => Container(
        width: 16.w,
        height: 3.h,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFA5252) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(2.r),
        ),
      );
}
