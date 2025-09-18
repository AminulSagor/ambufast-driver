// lib/donate_payment_selection/bkash_payment_view.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'bkash_payment_controller.dart';

class BkashPaymentView extends GetView<BkashPaymentController> {
  const BkashPaymentView({super.key});

  static const _border = Color(0xFFE6E6E9);
  static const _pink = Color(0xFFE2136E); // bKash brand panel
  static const _label = Color(0xFF6B7280);
  static const _text = Color(0xFF1E2430);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('payment'.tr,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: _border, width: 1.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header banner (bkash logo)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
                child: Image.asset(
                  'assets/bkash_banner.png',
                  height: 24.h,
                  fit: BoxFit.contain,
                ),
              ),
              // Thin divider
              Container(height: 1.h, color: _border),
              // Merchant row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Image.asset('assets/icon/shopping_icon.png',
                        width: 28.w, height: 28.w),
                    10.w.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.merchant,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _text)),
                          2.h.verticalSpace,
                          Text(
                            '${'invoice_number'.tr} : ${controller.invoice}',
                            style:
                            TextStyle(fontSize: 12.sp, color: _label),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${controller.amountText} ${'bdt'.tr.toUpperCase()}',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _text),
                    ),
                  ],
                ),
              ),
              // Pink panel
              Container(

                color: _pink,
                padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 50.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'your_bkash_number'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    12.h.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: _border, width: 1.w),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: TextField(
                        controller: controller.phoneCtrl,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.center,                 // ← centers hint & input
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: 'bkash_placeholder'.tr,
                          hintStyle: TextStyle(fontSize: 14.sp, color: _label),
                          border: InputBorder.none,
                        ),
                      )

                    ),
                    12.h.verticalSpace,
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                        children: [
                          TextSpan(text: 'confirm_process_prefix'.tr),
                          TextSpan(
                            text: 'terms_and_conditions'.tr,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,

                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Bottom actions
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _border, width: 1.w),
                          minimumSize: Size(0, 44.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: controller.onCancel,
                        child: Text('cancel'.tr, style: TextStyle(fontSize: 14.sp)),
                      ),
                    ),
                    12.w.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          minimumSize: Size(0, 44.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: controller.onConfirm,
                        child: Text('confirm'.tr,
                            style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              // Footer
              Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Column(
                  children: [
                    Text('16247',
                        style: TextStyle(fontSize: 12.sp, color: Colors.pink)),
                    4.h.verticalSpace,
                    Text('© 2025 bKash, All Rights Reserved',
                        style: TextStyle(fontSize: 12.sp, color: _label)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
