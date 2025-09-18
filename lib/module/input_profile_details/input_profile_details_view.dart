import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'input_profile_details_controller.dart';

class InputProfileDetailsView extends GetView<InputProfileDetailsController> {
  const InputProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Local theme override for rounded fields (keeps change scoped to this page)
    final roundedTheme = Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.6),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            Text('back'.tr, style: Get.textTheme.bodyMedium),
          ],
        ),
      ),

      body: Theme(
        data: roundedTheme,
        child: ScreenUtilInit(
          builder: (_, __) => Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'profile_info_title'.tr),

                    12.h.verticalSpace,
                    Center(
                      child: Obx(() {
                        final path = controller.photoPath.value;
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 40.r,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: path.isEmpty ? null : FileImage(File(path)),
                              child: path.isEmpty
                                  ? Icon(Icons.person, size: 40.r, color: Colors.grey)
                                  : null,
                            ),
                            8.h.verticalSpace,
                            OutlinedButton.icon(
                              onPressed: controller.pickPhoto,
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: Text('upload_profile_photo'.tr),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            _ErrorLine(validator: controller.validatePhoto),
                          ],
                        );
                      }),
                    ),

                    16.h.verticalSpace,
                    _LabeledField(
                      label: 'full_name'.tr,
                      child: TextFormField(
                        controller: controller.fullNameCtrl,
                        decoration: InputDecoration(hintText: 'hint_full_name'.tr),
                        validator: controller.validateFullName,
                      ),
                    ),

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'dob'.tr,
                      child: TextFormField(
                        controller: controller.dobTextCtrl,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9/\-]')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'YYYY-MM-DD', // or 'dd-MM-yyyy' to match your controller
                          suffixIcon: IconButton(
                            tooltip: 'select'.tr,
                            icon: const Icon(Icons.calendar_today_outlined),
                            onPressed: () => controller.pickDOB(context),
                          ),
                        ),
                        onChanged: controller.onDobTextChanged,
                        validator: (_) => controller.validateDOB(),
                      ),
                    ),


                    12.h.verticalSpace,
                    Text('gender_q'.tr, style: Theme.of(context).textTheme.bodyMedium),
                    6.h.verticalSpace,
                    Wrap(
                      spacing: 16.w,
                      children: [
                        _genderRadio('male', 'male'.tr),
                        _genderRadio('female', 'female'.tr),
                        _genderRadio('others', 'others'.tr),
                      ],
                    ),
                    _ErrorLine(validator: controller.validateGender), // ✅ plain

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'blood_group'.tr,
                      child: Obx(() {
                        return InkWell(
                          onTap: () => controller.chooseBloodGroup(context),
                          borderRadius: BorderRadius.circular(12.r),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              hintText: 'select'.tr,
                              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                            ),
                            child: Text(
                              controller.bloodGroup.value.isEmpty
                                  ? 'select'.tr
                                  : controller.bloodGroup.value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }),
                    ),
                    _ErrorLine(validator: controller.validateBlood), // ✅ plain

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'password'.tr,
                      child: Obx(() => TextFormField(
                        controller: controller.passwordCtrl,
                        obscureText: controller.hidePassword.value,
                        decoration: InputDecoration(
                          hintText: 'hint_password'.tr,
                          suffixIcon: IconButton(
                            onPressed: () => controller.hidePassword.toggle(),
                            icon: Icon(controller.hidePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        validator: controller.validatePassword,
                      )),
                    ),

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'confirm_password'.tr,
                      child: Obx(() => TextFormField(
                        controller: controller.confirmPasswordCtrl,
                        obscureText: controller.hideConfirm.value,
                        decoration: InputDecoration(
                          hintText: 'hint_confirm_password'.tr,
                          suffixIcon: IconButton(
                            onPressed: () => controller.hideConfirm.toggle(),
                            icon: Icon(controller.hideConfirm.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        validator: controller.validateConfirmPassword,
                      )),
                    ),

                    20.h.verticalSpace,
                    _SectionHeader(title: 'contact_info_title'.tr),

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'country'.tr,
                      child: Obx(() {
                        return InkWell(
                          onTap: () => controller.chooseCountry(context),
                          borderRadius: BorderRadius.circular(12.r),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              hintText: 'hint_country'.tr,
                              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                            ),
                            child: Text(
                              controller.country.value.isEmpty
                                  ? 'select'.tr
                                  : controller.country.value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }),
                    ),
                    _ErrorLine(validator: controller.validateCountry), // ✅ plain

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'zip_code'.tr,
                      child: TextFormField(
                        controller: controller.zipCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'hint_zip'.tr),
                        validator: controller.validateZip,
                      ),
                    ),

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'state'.tr,
                      child: TextFormField(
                        controller: controller.stateCtrl,
                        decoration: InputDecoration(hintText: 'hint_state'.tr),
                        validator: controller.validateState,
                      ),
                    ),

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'city'.tr,
                      child: TextFormField(
                        controller: controller.cityCtrl,
                        decoration: InputDecoration(hintText: 'hint_city'.tr),
                        validator: controller.validateCity,
                      ),
                    ),

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'street_address'.tr,
                      child: TextFormField(
                        controller: controller.streetCtrl,
                        decoration: InputDecoration(hintText: 'hint_street'.tr),
                        validator: controller.validateStreet,
                      ),
                    ),

                    12.h.verticalSpace,
                    _LabeledField(
                      label: 'apartment_optional'.tr,
                      child: TextFormField(
                        controller: controller.apartmentCtrl,
                        decoration: InputDecoration(hintText: 'hint_apartment'.tr),
                      ),
                    ),

                    24.h.verticalSpace,
                    SizedBox(
                      width: double.infinity,
                      height: 45.h,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF43023),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: controller.submit,
                        icon: const Icon(Icons.arrow_right_alt, color: Colors.white),
                        label: Text(
                          'next'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    16.h.verticalSpace,
                    Center(
                      child: Text(
                        'powered'.tr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                )


            ),
          ),
        ),
      ),
    );
  }

  Widget _genderRadio(String value, String label) {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: controller.gender.value,
          onChanged: (v) => controller.gender.value = v ?? '',
        ),
        Text(label),
      ],
    ));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, endIndent: 8.w)),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Expanded(child: Divider(thickness: 1, indent: 8.w)),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        6.h.verticalSpace,
        child,
      ],
    );
  }
}

class _ErrorLine extends StatelessWidget {
  final String? Function()? validator;
  const _ErrorLine({this.validator});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final err = validator?.call();
      if (err == null) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Text(
          err,
          style: TextStyle(color: Colors.red, fontSize: 12.sp),
        ),
      );
    });
  }
}

