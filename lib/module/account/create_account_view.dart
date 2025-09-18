// lib/modules/account/create_account_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'create_account_controller.dart';
import 'package:flutter/services.dart';

class CreateAccountView extends GetView<CreateAccountController> {
  const CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Text(
          'powered'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.sp, color: Colors.black54),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16.w,
            12.h,
            16.w,
            MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back + title
                InkWell(
                  onTap: Get.back,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 20.sp, color: Colors.black87),
                      SizedBox(width: 6.w),
                      Text('back'.tr,
                          style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'create_account_title'.tr,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 16.h),

                // Full name
                Text('full_name'.tr),
                SizedBox(height: 6.h),
                TextFormField(
                  controller: controller.fullNameCtrl,
                  decoration: _input('hint_full_name'.tr),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'req_field'.tr : null,
                ),
                SizedBox(height: 14.h),

                // ===== DOB (Text input + Calendar) =====
                Text('dob'.tr),
                SizedBox(height: 6.h),

                // NOTE: removed Obx here to avoid "improper use of Obx"
                TextFormField(
                  controller: controller.dobTextCtrl,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9/\-]')),
                  ],
                  decoration: _input('dd-MM-yyyy').copyWith(
                    suffixIcon: IconButton(
                      tooltip: 'select'.tr,
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: () => controller.pickDob(context),
                    ),
                  ),
                  validator: (v) {
                    // controller.dob is kept in sync by controller.dobTextCtrl listener
                    if (controller.dob.value == null) {
                      return 'invalid_msg'.tr; // or a dedicated 'invalid_dob' key
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14.h),

                // Gender
                Text('gender_q'.tr),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    _radio('male'.tr, 'male'),
                    _radio('female'.tr, 'female'),
                    _radio('others'.tr, 'others'),
                  ],
                ),
                SizedBox(height: 14.h),

                // Blood group
                Text('blood_group'.tr),
                SizedBox(height: 6.h),
                Obx(() {
                  final text = controller.bloodGroup.value.isEmpty
                      ? 'select'.tr
                      : controller.bloodGroup.value;
                  return InkWell(
                    onTap: () => controller.chooseBloodGroup(context),
                    borderRadius: BorderRadius.circular(10.r),
                    child: InputDecorator(
                      decoration: _outlined(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(text, style: TextStyle(fontSize: 14.sp)),
                          const Icon(Icons.expand_more),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 14.h),

                // Password
                Text('password'.tr),
                SizedBox(height: 6.h),
                // lib/modules/account/create_account_view.dart

// Password
                Obx(() => TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction, // optional but recommended
                  controller: controller.passwordCtrl,
                  obscureText: controller.obscurePass.value,
                  decoration: _input('hint_password'.tr).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscurePass.value ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => controller.obscurePass.value = !controller.obscurePass.value,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'req_field'.tr;
                    if (v.length < 6) return 'min_6_chars'.tr;
                    return null;
                  },
                )),
                SizedBox(height: 14.h),
                Text('confirm_password'.tr),
                SizedBox(height: 6.h),
// Confirm password
                Obx(() => TextFormField(
                  key: controller.confirmFieldKey,                     // <-- attach the key
                  autovalidateMode: AutovalidateMode.onUserInteraction, // optional but recommended
                  controller: controller.confirmCtrl,
                  obscureText: controller.obscureConfirm.value,
                  decoration: _input('hint_confirm_password'.tr).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureConfirm.value ? Icons.visibility_off : Icons.visibility),
                      onPressed: () =>
                      controller.obscureConfirm.value = !controller.obscureConfirm.value,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'req_field'.tr;
                    if (v != controller.passwordCtrl.text) return 'password_mismatch'.tr;
                    return null;
                  },
                )),

                SizedBox(height: 22.h),

                // Next
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: Obx(() {
                    final enabled = controller.canSubmit.value;
                    return ElevatedButton(
                      onPressed: enabled ? () => controller.onNext(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF43023),
                        disabledBackgroundColor: const Color(0x33F43023),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'next'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- helpers ----------

  Widget _radio(String label, String value) {
    return Obx(() => Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: controller.gender.value,
          onChanged: (v) => controller.chooseGender(v!),
          visualDensity: VisualDensity.compact,
        ),
        Text(label),
        SizedBox(width: 12.w),
      ],
    ));
  }

  InputDecoration _input(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
  );

  InputDecoration _outlined() => InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
  );
}
