import 'package:ambufast_driver/utils/colors.dart';
import 'package:ambufast_driver/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'subscription_controller.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: colorBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            controller.showPlans.value
                ? 'choose_plan_title'.tr
                : 'subscription_title'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: neutral700,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.onBack,
          ),
          actions: [
            IconButton(
              onPressed: controller.history,
              icon: const Icon(Icons.history_rounded),
              tooltip: 'Payment History',
            ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: controller.showPlans.value
                    ? const _PlanSelection()
                    : const _Landing(),
              ),
      ),
    );
  }
}

/* ================= Landing (existing) ================= */

class _Landing extends GetView<SubscriptionController> {
  const _Landing();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Pill(label: 'priority_label'.tr),
          8.h.verticalSpace,
          Text(
            'subscription_hero_title'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: primaryBase,
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'subscription_hero_subtitle'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: neutral600,
            ),
          ),
          SizedBox(height: 40.h),
          Image.asset('assets/subscription.png'),
          SizedBox(height: 20.h),
          _BenefitTile(text: 'benefit_priority'.tr),
          _BenefitTile(text: 'benefit_earning'.tr),
          _BenefitTile(text: 'benefit_insights'.tr),
          _BenefitTile(text: 'benefit_discount'.tr),
          SizedBox(height: 18.h),
          CustomButton(
            btnTxt: 'subscribe_now'.tr,
            onTap: controller.openPlans,
          ),
          SizedBox(height: 12.h),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: 'terms_prefix'.tr),
              TextSpan(
                text: 'terms_tos'.tr,
                style: TextStyle(
                  color: neutral700,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      Get.snackbar('terms_tos'.tr, 'open_link_placeholder'.tr),
              ),
              TextSpan(text: 'terms_and'.tr),
              TextSpan(
                text: 'terms_privacy'.tr,
                style: TextStyle(
                  color: neutral700,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.snackbar(
                      'terms_privacy'.tr, 'open_link_placeholder'.tr),
              ),
              TextSpan(text: 'terms_suffix'.tr),
            ]),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: neutral700,
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= Plan Selection (new) ================= */

class _PlanSelection extends GetView<SubscriptionController> {
  const _PlanSelection();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        children: [
          _PlanCard(
            title: 'basic_plan'.tr,
            priceTag: 'price_per_month'.trParams({'price': '299'}),
            features: [
              'feat_one_request'.tr,
              'feat_two_weeks'.tr,
              'feat_unlimited_requests'.tr,
              'feat_one_meeting'.tr,
              'feat_dev_ready_figma'.tr,
              'feat_unlimited_stock'.tr,
            ],
            onTap: controller.subscribe,
          ),
          SizedBox(height: 16.h),
          _PlanCard(
            title: 'basic_plan'.tr,
            priceTag: 'price_per_month'.trParams({'price': '299'}),
            features: [
              'feat_one_request'.tr,
              'feat_two_weeks'.tr,
              'feat_unlimited_requests'.tr,
              'feat_one_meeting'.tr,
              'feat_dev_ready_figma'.tr,
              'feat_unlimited_stock'.tr,
            ],
            onTap: controller.subscribe,
          ),
          SizedBox(height: 24.h),
          Text(
            '${'powered_by'.tr}\n${'beta_version'.trParams({'v': '1.0'})}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: blackFrontS,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

/* ================= widgets ================= */

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: neutral50,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icon/stars.png'),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  final String text;
  const _BenefitTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: neutral50,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          Image.asset('assets/icon/stars.png'),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: neutral700,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String priceTag;
  final List<String> features;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.priceTag,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: neutral50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + price pill
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: blackBase,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: primaryBase,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  priceTag,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Features
          for (final f in features) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h, right: 8.w, bottom: 8.h),
                  child: Icon(
                    Icons.check_rounded,
                    size: 20.sp,
                    color: primaryBase,
                  ),
                ),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: neutral600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 10.h),

          SizedBox(
            width: 132.w,
            child: CustomButton(
              btnTxt: 'get_started'.tr,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
