import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/supports_summary_card.dart';
import 'support_payment_controller.dart';

class SupportPaymentView extends GetView<SupportPaymentController> {
  const SupportPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('support_review'.tr,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cause + Amount summary
            SupportSummaryCard(
              causeKey: controller.causeKey,          // or selectedCause.value!
              amount: controller.amount,              // int
              onChange: () {
                Get.back(); // or navigate to edit screen
              },
            ),


            20.h.verticalSpace,
            Text('choose_payment'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),

            12.h.verticalSpace,

            // Payment methods
            Obx(() => Column(
              children: controller.methods.map((m) {
                final isSelected = controller.selectedMethod.value == m['id'];
                return InkWell(
                  onTap: () => controller.selectMethod(m['id']!),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFE5E7EB),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset(m['icon']!, width: 40.w, height: 40.w),
                        12.w.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['title']!.tr,
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                              if (m['subtitle']!.isNotEmpty)
                                Text(m['subtitle']!.tr,
                                    style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Radio<String>(
                          value: m['id']!,
                          groupValue: controller.selectedMethod.value,
                          onChanged: (_) => controller.selectMethod(m['id']!),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),

            24.h.verticalSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                "assets/support_page_image.png",
                height: 90.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(16.w),
        child: SizedBox(
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: controller.onPayNow,
            child: Text('pay_now'.tr,
                style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
