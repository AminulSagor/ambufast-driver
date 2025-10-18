import 'package:ambufast_driver/utils/colors.dart';
import 'package:ambufast_driver/widgets/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'driving_license_controller.dart';
import 'models/driving_license_model.dart';

class DrivingLicenseView extends GetView<DrivingLicenseController> {
  const DrivingLicenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'driving_license'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: neutral700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final DrivingLicenseModel dl = controller.license.value!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: neutral100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image with dashed border
                      DottedBorder(
                        color: neutral800,
                        strokeWidth: 1,
                        dashPattern: const [2, 2], // length of dash & gap
                        borderType: BorderType.RRect,
                        radius: Radius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              dl.frontImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      12.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _kv('license_no'.tr, dl.number),
                              6.verticalSpace,
                              _kv(
                                  'expiry_date'.tr,
                                  _fmtDate(dl.expiryDate,
                                      Get.locale?.toLanguageTag())),
                              6.verticalSpace,
                              Text(
                                dl.category.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: neutral700,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          _statusChip(status: controller.status.value),
                        ],
                      ),
                    ],
                  ),
                ),
                if (controller.status.value == LicenseStatus.rejected) ...[
                  68.h.verticalSpace,
                  _notApprovedCard(),
                ],
                const Spacer(),
                CustomButton(
                  btnTxt: 'update'.tr,
                  onTap: controller.onUpdatePressed,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: const Color(0xFF374151),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: '$k: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: v),
        ],
      ),
    );
  }

  String _fmtDate(DateTime dt, String? locale) {
    // simple manual format to avoid extra packages; you already use intl elsewhere if preferred
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
  }

  Widget _notApprovedCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: negative50, // light pink
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFF8C7D3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: neutral700),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'license_not_approved_title'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: neutral700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'license_not_approved_desc'.tr,
                  style: TextStyle(fontSize: 14.sp, color: neutral700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip({required LicenseStatus status}) {
    late final String label;
    late final Color bg;
    late final Color fg;

    switch (status) {
      case LicenseStatus.verified:
        label = 'Verified';
        bg = posititve100;
        fg = posititveBase;
        break;
      case LicenseStatus.underReview:
        label = 'Under Review';
        bg = orange100;
        fg = orangeBase;
        break;
      case LicenseStatus.rejected:
        label = 'Rejected';
        bg = negative100;
        fg = negativeBase;
        break;
    }

    return AnimatedContainer(
      key: ValueKey(label),
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6.r)),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
