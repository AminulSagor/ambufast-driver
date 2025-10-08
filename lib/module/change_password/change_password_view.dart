import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'change_password'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: const Color(0xFF1E293B),
          ),
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Label(text: 'current_password'.tr),
                Obx(() => _TextField(
                  controller: controller.currentCtrl,
                  obscureText: controller.obscureCurrent.value,
                  hint: 'enter_current_password'.tr,
                  validator: controller.requiredValidator,
                  onToggle: controller.obscureCurrent.toggle,
                )),
                16.verticalSpace,

                _Label(text: 'new_password'.tr),
                Obx(() => _TextField(
                  controller: controller.newCtrl,
                  obscureText: controller.obscureNew.value,
                  hint: 'enter_new_password'.tr,
                  validator: controller.newPasswordValidator,
                  onToggle: controller.obscureNew.toggle,
                )),
                16.verticalSpace,

                _Label(text: 'confirm_password'.tr),
                Obx(() => _TextField(
                  controller: controller.confirmCtrl,
                  obscureText: controller.obscureConfirm.value,
                  hint: 'enter_password'.tr,
                  validator: controller.confirmValidator,
                  onToggle: controller.obscureConfirm.toggle,
                )),
                10.verticalSpace,

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(Routes.recover),
                    child: Text(
                      'recover_password'.tr,
                      style: TextStyle(
                        color: const Color(0xFFEF3D33),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),

                12.verticalSpace,

                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF3D33),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed:
                    controller.isSubmitting.value ? null : controller.submit,
                    child: controller.isSubmitting.value
                        ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      'update'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ))

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

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

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hint;
  final String? Function(String?)? validator;
  final VoidCallback onToggle;

  const _TextField({
    required this.controller,
    required this.obscureText,
    required this.hint,
    required this.validator,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      cursorColor: const Color(0xFFEF3D33),
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFEF3D33), width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.3),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.3),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF9CA3AF),
          ),
          onPressed: onToggle,
        ),
        errorStyle: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFFDC2626),
          height: 1.1,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
