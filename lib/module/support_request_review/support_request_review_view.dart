import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/step_card_widget.dart';
import 'support_request_review_controller.dart';

const kSurface = Color(0xFFF7F8F8); // neutral/50
const kBorder  = Color(0xFFE6E6E9); // neutral/100
const kBrand   = Color(0xFF1A2035); // brand for icons/text accents

class SupportRequestReviewView extends GetView<SupportRequestReviewController> {
  const SupportRequestReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('request_review_title'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              StepCard(
                title: 'confirm_request'.tr,
                subtitle: 'confirm_request_hint'.tr,
                badgeText: 'step_2_of_2'.tr,
              ),

              12.h.verticalSpace,
              _SummaryCard(),
              24.h.verticalSpace,
            ],
          ),
        ),
      ),

      // ⬇️ fixed bottom CTA
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Obx(() => SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: controller.submitting.value ? null : controller.submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white, // ensures text/ink is white
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: controller.submitting.value
                ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                : Text(
              'rr_submit_for_review'.tr,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        )),
      ),
    );

  }
}



class _SummaryCard extends GetView<SupportRequestReviewController> {
  @override
  Widget build(BuildContext context) {
    final d = controller.data;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(blurRadius: 8.r, color: Colors.black12)],
      ),
      child: Column(
        children: [
          _RowKV(left: 'rr_cause'.tr, right: d.causeKey.tr),
          10.h.verticalSpace,
          _RowKV(
            left: 'rr_amount_needed'.tr,
            right: '৳${d.amount}',
          ),
          10.h.verticalSpace,
          _RowKV(left: 'rr_urgency'.tr, right: d.urgencyLabel),
          10.h.verticalSpace,
          _RowKV(
            left: 'rr_describe'.tr,
            right: d.description,
            wrapRight: true,
          ),
          14.h.verticalSpace,
          _FilePill(title: d.docFileName ?? 'Clinic Bill - Aug 2025.pdf'),
          8.h.verticalSpace,
          _FilePill(title: d.nidFrontName ?? 'Font ID - Aug 2025.pdf'),
          8.h.verticalSpace,
          _FilePill(title: d.nidBackName ?? 'Back ID - Aug 2025.pdf'),
          12.h.verticalSpace,
          Divider(height: 1, color: kBorder),
          8.h.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text('rr_you_can_edit_below'.tr,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
              ),
              GestureDetector(
                onTap: controller.tapChange,
                child: Text('rr_change'.tr,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFFE53935),
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RowKV extends StatelessWidget {
  final String left;
  final String right;
  final bool wrapRight;

  const _RowKV({required this.left, required this.right, this.wrapRight = false});

  @override
  Widget build(BuildContext context) {
    final rightWidget = Text(
      right,
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF333333)),
    );
    return Row(
      crossAxisAlignment: wrapRight ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(left,
              style: TextStyle(fontSize: 13.sp, color: Colors.black54)),
        ),
        12.w.horizontalSpace,
        Expanded(
          child: wrapRight ? rightWidget : Align(alignment: Alignment.centerRight, child: rightWidget),
        ),
      ],
    );
  }
}

class _FilePill extends StatelessWidget {
  final String title;
  const _FilePill({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, size: 20.w, color: Colors.black54),
          10.w.horizontalSpace,
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF5A5A5A)),
            ),
          ),
          10.w.horizontalSpace,
          Image.asset(
            'assets/icon/download_from_cloud_icon.png',
            width: 20.w,
            height: 20.w,
            color: kBrand,
          ),
        ],
      ),
    );
  }
}
