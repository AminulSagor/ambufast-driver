import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'waiting_approval_controller.dart';

class WaitingApprovalView extends GetView<WaitingApprovalController> {
  const WaitingApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          // subtle top-right gradient like the mock
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFEFF6FB), Colors.white],
              stops: [0.0, 0.6],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
            child: Column(
              children: [
                // === Image + texts as one centered block ===
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Illustration
                      Image.asset(
                        'assets/img.png',
                        width: 220.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 20.h),

                      // Headline
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          'waiting_approval_title'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D3238),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Body
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          'waiting_approval_body'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.5,
                            color: const Color(0xFF6F7985),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // === CTA button near bottom ===
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: controller.onExplore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'waiting_approval_cta'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
