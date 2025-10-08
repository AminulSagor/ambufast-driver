import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'delete_account_controller.dart';

class DeleteAccountView extends GetView<DeleteAccountController> {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'delete_account_title'.tr,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Reasons =====
                Text(
                  'why_leaving'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                10.verticalSpace,
                Obx(() => Column(
                  children: List.generate(controller.reasons.length, (i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: Checkbox(
                              value: controller.selected[i],
                              onChanged: (_) => controller.toggleReason(i),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r)),
                              side: const BorderSide(
                                  color: Color(0xFF94A3B8), width: 1.4),
                              activeColor: const Color(0xFF111827),
                              checkColor: Colors.white,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: Text(
                              controller.reasons[i].tr,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF374151)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                )),
                18.verticalSpace,

                // ===== Security Confirmation =====
                Center(
                  child: Text(
                    'security_confirmation'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                12.verticalSpace,

                // tabs
                Obx(() => Row(
                  children: [
                    _TabButton(
                      label: 'tab_phone'.tr,
                      active:
                      controller.confirmBy.value == ConfirmBy.phone,
                      onTap: () => controller.switchTab(ConfirmBy.phone),
                    ),
                    _TabButton(
                      label: 'tab_email'.tr,
                      active:
                      controller.confirmBy.value == ConfirmBy.email,
                      onTap: () => controller.switchTab(ConfirmBy.email),
                    ),
                  ],
                )),
                16.verticalSpace,

                // ===== inputs by tab =====
                Obx(() {
                  if (controller.confirmBy.value == ConfirmBy.phone) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel(text: 'phone_label'.tr),
                        Row(
                          children: [
                            // flag + code
                            Container(
                              width: 94.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                    color: const Color(0xFFE2E8F0), width: 1),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/icon/bangladesh_flag.png',
                                    width: 24.w,
                                    height: 16.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    '+880',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF111827),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: TextFormField(
                                controller: controller.phoneCtrl,
                                keyboardType: TextInputType.phone,
                                decoration: _inputDecoration(
                                  hint: 'enter_phone'.tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel(text: 'email_label'.tr),
                        TextFormField(
                          controller: controller.emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            hint: 'enter_email'.tr,
                          ),
                        ),
                      ],
                    );
                  }
                }),

                22.verticalSpace,

                // ===== Send OTP =====
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submit, // your controller function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF43023),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isSubmitting.value
                        ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'send_otp'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Image.asset(
                          'assets/icon/arrow.png',
                          width: 20.w,
                          height: 20.w,
                        ),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFF111827), width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.3),
      ),
    );
  }
}

// ===== helpers =====

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),

          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF1F2937),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }
}
