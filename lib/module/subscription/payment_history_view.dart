import 'package:ambufast_driver/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'payment_history_controller.dart';

class PaymentHistoryView extends GetView<PaymentHistoryController> {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final localeName = Get.locale?.toLanguageTag() ?? Intl.getCurrentLocale();
    return Scaffold(
      backgroundColor: colorBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'payment_history_title'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: neutral700,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, i) {
            final it = controller.items[i];
            final dt = DateFormat('dd MMMM yyyy, hh:mm a', localeName)
                .format(it.paidAt);
            final currency = NumberFormat.currency(
              locale: localeName,
              symbol: 'BDT ',
              decimalDigits: 2,
            ).format(it.amount);

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: neutral100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left block
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'basic_plan'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: blackBase,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'bkash_success'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: neutralBase,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          dt,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackBase,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Amount
                  Text(
                    currency,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: blackBase,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
