// lib/module/licence/licence_details_view.dart
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'licence_details_controller.dart';

class LicenceDetailsView extends GetView<LicenceDetailsController> {
  const LicenceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0, // 👈 reduces space
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'back'.tr,
          style: TextStyle(color: Colors.black, fontSize: 14.sp),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 24.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'licence_title'.tr),

              SizedBox(height: 16.h),
              const _LabelText('licence_number'),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.licNoCtrl,
                decoration:
                _inputDecoration(hint: 'licence_number_hint'.tr),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'v_lic_no'.tr : null,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),
              const _LabelText('licence_expiry'),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.expCtrl,
                decoration: _inputDecoration(
                  // shows simple "Select" like your screenshot
                  hint: 'licence_expiry_hint'.tr,
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF8A8F98)),
                    onPressed: () => controller.pickExpiryDate(context),
                    tooltip: 'select'.tr,
                  ),
                ),
                // allow typing as well
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                  LengthLimitingTextInputFormatter(10), // YYYY-MM-DD
                ],
                validator: controller.validateDate,
              ),

              SizedBox(height: 16.h),
              const _LabelText('licence_category'),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.catCtrl,
                readOnly: true,
                decoration: _inputDecoration(
                  hint: 'select'.tr,
                  suffix: const Icon(Icons.arrow_drop_down),
                ),
                onTap: () => controller.pickCategory(context),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'v_lic_cat'.tr : null,
              ),

              SizedBox(height: 20.h),
              _DividerWithTitle(title: 'upload_licence_title'.tr),

              SizedBox(height: 12.h),
              const _LabelText('front_side_title'),
              SizedBox(height: 8.h),
              _UploadBox(
                onTap: controller.pickFront,
                title: 'click_to_upload_front'.tr,
                subtitle: 'max_file_size_25'.tr,
                valueRx: controller.frontPath, // RxnString
              ),

              SizedBox(height: 16.h),
              const _LabelText('back_side_title'),
              SizedBox(height: 8.h),
              _UploadBox(
                onTap: controller.pickBack,
                title: 'click_to_upload_back'.tr,
                subtitle: 'max_file_size_25'.tr,
                valueRx: controller.backPath, // RxnString
              ),

              SizedBox(height: 24.h),
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('next'.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp)),
                        SizedBox(width: 8.w),
                        const Icon(Icons.check,
                            color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              Center(
                child: Text(
                  'powered'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    final radius = BorderRadius.circular(12.r);
    const borderColor = Color(0xFFD5D9E0);      // light gray
    const focusedColor = Color(0xFFB7BEC8);     // a bit darker when focused
    const errorColor = Color(0xFFE53935);       // same red as your button

    OutlineInputBorder outline(Color c) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: c, width: 1),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: const Color(0xFF9AA2AE), fontSize: 14.sp),
      filled: true,
      fillColor: Colors.white, // 👈 white so it stands out from the bg
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),

      // visible borders
      enabledBorder: outline(borderColor),
      border: outline(borderColor),
      focusedBorder: outline(focusedColor),
      errorBorder: outline(errorColor),
      focusedErrorBorder: outline(errorColor),

      suffixIcon: suffix,
    );
  }

}

class _LabelText extends StatelessWidget {
  const _LabelText(this.keyName, {super.key});
  final String keyName;
  @override
  Widget build(BuildContext context) {
    return Text(
      keyName.tr,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
          color: const Color(0xFF2D3238)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3238)),
          ),
        ),
        Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
      ],
    );
  }
}

class _DividerWithTitle extends StatelessWidget {
  const _DividerWithTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
                color: const Color(0xFF2D3238)),
          ),
        ),
        Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
      ],
    );
  }
}

/// Upload box that listens to an RxnString (GetX) instead of ValueListenable.
class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.valueRx, // RxnString
    super.key,
  });

  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final RxnString valueRx;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = valueRx.value;
      final hasFile = value != null && value.isNotEmpty;
      return GestureDetector(
        onTap: onTap,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12.r),
          dashPattern: const [6, 4],
          color: Colors.black26,
          strokeWidth: 1,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  width: 48.w,
                  height: 68.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F7FB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_upload,
                      size: 22, color: Colors.redAccent),
                ),
                SizedBox(height: 10.h),
                Text(
                  hasFile ? value! : title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black87,
                    fontWeight:
                    hasFile ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style:
                  TextStyle(fontSize: 11.sp, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
