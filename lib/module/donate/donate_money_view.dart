import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/amount_chip_widget.dart';
import '../../widgets/amount_text_field_widget.dart';
import '../../widgets/radio_tile_chip_widget.dart';
import 'donate_money_controller.dart';

class DonateMoneyView extends GetView<DonateMoneyController> {
  const DonateMoneyView({super.key});



  @override
  Widget build(BuildContext context) {
    final isBn = (Get.locale ?? Get.deviceLocale)?.languageCode == 'bn';
    final btnW = isBn ? 240.w : 200.w;
    return Scaffold(
      appBar: AppBar(
        title: Text('support'.tr, style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('choose_cause'.tr),
            8.h.verticalSpace,
            Obx(() => Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: controller.causes.map((c) {
                return RadioTileChip(
                  label: c.tr,
                  selected: controller.selectedCause.value == c,
                  onTap: () => controller.chooseCause(c),
                );
              }).toList(),
            )),


            20.h.verticalSpace,
            _SectionTitle('choose_amount'.tr),
            10.h.verticalSpace,

            /// Preset amounts
            Obx(() => Wrap(
              spacing: 8.w,
              runSpacing: 12.h,
              children: [
                ...controller.amounts.map(
                      (a) => AmountChip(
                        label: "৳$a",
                        selected: controller.selectedAmount.value == a,
                        onTap: () => controller.chooseAmount(a),
                      ),

                ),
                AmountChip(
                  label: 'others_amount'.tr,
                  selected: controller.selectedAmount.value == 0 &&
                      controller.controllerTextNotEmpty,
                  onTap: controller.selectOthersAmount,
                ),
              ],
            )),

            12.h.verticalSpace,

            /// Custom amount field
            AmountTextField(
              controller: controller.customAmountCtrl,
              focusNode: controller.customAmountFocus,
              onCustomSelected: () => controller.selectedAmount.value = 0,
            ),

            14.h.verticalSpace,

            /// Terms
            Obx(
                  () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Checkbox(
                      value: controller.agreeTerms.value,
                      onChanged: controller.toggleTerms,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  8.w.horizontalSpace,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF1E2430)),
                          children: [
                            TextSpan(text: 'terms_pre_a'.tr),
                            TextSpan(
                              text: 'terms_pre_b'.tr,
                              style: const TextStyle(color: Colors.red),
                              recognizer: TapGestureRecognizer()..onTap = () {/* open terms */},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            16.h.verticalSpace,

            /// Banner image
            ClipRRect(
              child: Image.asset(
                "assets/support_page_image.png",
                height: 90.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            22.h.verticalSpace,

            /// Help block
            Center(
              child: Text(
                'cant_find'.tr,
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
            12.h.verticalSpace,
            Center(
              child: SizedBox(
                width: btnW,
                height: 44.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    // TODO: contact support action
                  },
                  child: Text('contact_support'.tr, style: TextStyle(fontSize: 14.sp,color: Colors.white)),
                ),
              ),
            ),

            24.h.verticalSpace,
          ],
        ),
      ),

      /// Bottom Review button
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h),
        child: Obx(() => SizedBox(
          height: 52.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: controller.canReview ? controller.onTapReview : null,
            child: Text('review'.tr, style: TextStyle(fontSize: 16.sp,color: Colors.white)),
          ),
        )),
      ),
    );
  }
}

extension on DonateMoneyController {
  bool get controllerTextNotEmpty => customAmountCtrl.text.trim().isNotEmpty;
}

/// Section title
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        color: const Color(0xFF1E2430),
      ),
    );
  }
}

/// Radio-like pill

/// Amount chip

/// Custom amount field (with currency prefix)
