// lib/modules/edit_profile_details/edit_profile_details_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'edit_profile_details_controller.dart';

const _kDanger = Color(0xFFFF3B30);
const _kFieldBorder = Color(0xFFE5E7EB);
const _kUploadBg = Color(0xFFD4D5D9); // light gray chip-like background
const _kHintText = Color(0xFF8C8F9A);  // off-black for all hints

class EditProfileDetailsView extends GetView<EditProfileDetailsController> {
  const EditProfileDetailsView({super.key});

  // Unified decoration for all inputs
  InputDecoration _dec({Widget? suffix, String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: _kHintText,
        fontSize: 13.sp,
        fontWeight: FontWeight.normal,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: _kFieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: _kFieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: _kFieldBorder),
      ),
      suffixIcon: suffix,
    );
  }

  Future<String?> _showPickerSheet(
      BuildContext context, {
        required String title,
        required List<String> options,
        String? selected,
      }) {
    return showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 6.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6.h),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  itemBuilder: (_, i) {
                    final val = options[i];
                    final isSelected = val == selected;
                    return ListTile(
                      title: Text(
                        val.tr,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.black87)
                          : null,
                      onTap: () => Navigator.pop(ctx, val),
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kDanger,            // 🔴 red background
                      foregroundColor: Colors.white,        // white text/icon
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }


  // Reusable “select field” that looks like a TextFormField but opens a bottom sheet
  Widget _SelectField({
    required BuildContext context,
    required String title,
    required String? value,
    required String hint,
    required List<String> options,
    required void Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return GestureDetector(
      onTap: () async {
        final selected = await _showPickerSheet(
          context,
          title: title,
          options: options,
          selected: value,
        );
        if (selected != null) {
          onChanged(selected);
          controller.validateNow();
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(text: (value ?? '').tr),
          validator: validator,
          decoration: _dec(
            hint: hint,
            suffix: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          ),
          style: TextStyle( // selected text style (not bold)
            fontSize: 14.sp,
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF7FBF8),
        foregroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(                     // 👈 add this
          icon: const Icon(Icons.arrow_back),    // back icon
          onPressed: () => Get.back(),           // uses GetX to go back
        ),
        title: Text(
          'edit_profile_details'.tr,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: Obx(() {
          final url = controller.avatarUrl.value.trim();
          final hasAvatar = url.isNotEmpty &&
              Uri.tryParse(url)?.hasScheme == true &&
              Uri.parse(url).host.isNotEmpty;

          // ⬇️ NEW: prefer local preview if available
          final localPath = controller.localAvatarPath.value;
          ImageProvider? avatarProvider;
          if (localPath != null && localPath.isNotEmpty) {
            avatarProvider = FileImage(File(localPath));
          } else if (hasAvatar) {
            avatarProvider = NetworkImage(url);
          } else {
            avatarProvider = null;
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _SectionHeader(title: 'basic_information'.tr),
                  SizedBox(height: 14.h),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36.r,
                        backgroundColor: Colors.white,
                        backgroundImage: avatarProvider,
                        child: avatarProvider == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                      // Optional: tiny uploading indicator overlay
                      if (controller.isUploadingAvatar.value)
                        Container(
                          width: 72.r,
                          height: 72.r,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Upload profile photo button (asset icon + grey background)
                  TextButton.icon(
                    onPressed: controller.pickPhoto,
                    icon: Image.asset(
                      'assets/icon/upload_icon.png',
                      width: 18.w,
                      height: 18.w,
                    ),
                    label: Text('upload_profile_photo'.tr),
                    style: TextButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      foregroundColor: const Color(0xFF374151),
                      backgroundColor: _kUploadBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: const BorderSide(color: _kFieldBorder),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ----- Fields with OUTSIDE labels -----
                  _FieldLabel(text: '${'full_name'.tr}'),
                  TextFormField(
                    controller: controller.fullNameCtrl,
                    decoration: _dec(hint: 'enter_full_name'.tr),
                    validator: controller.validateName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  _FieldLabel(text: '${'date_of_birth'.tr}*'),
                  TextFormField(
                    controller: controller.dobCtrl,
                    keyboardType: TextInputType.datetime,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    enableSuggestions: false,
                    // allow only digits and hyphens, and cap at 10 chars: yyyy-mm-dd
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: _dec(
                      hint: 'yyyy-mm-dd'.tr, // keep format consistent with picker write-back
                      suffix: IconButton(
                        icon: const Icon(Icons.calendar_today_rounded, size: 18),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: controller.dob.value ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            controller.dob.value = picked;
                            final y = picked.year.toString().padLeft(4, '0');
                            final m = picked.month.toString().padLeft(2, '0');
                            final d = picked.day.toString().padLeft(2, '0');
                            controller.dobCtrl.text = '$y-$m-$d';  // yyyy-mm-dd
                            controller.validateNow();               // re-run validators
                          }
                        },
                      ),
                    ),
                    // ✅ realtime validation while typing
                    onChanged: (_) => controller.validateNow(),
                    onEditingComplete: controller.validateNow,
                    validator: controller.validateDOB,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),


                  SizedBox(height: 12.h),

                  // GENDER (Bottom Sheet)
                  _FieldLabel(text: '${'gender'.tr}*'),
                  _SelectField(
                    context: context,
                    title: 'select_gender'.tr,
                    value: controller.gender.value,
                    hint: 'select_gender'.tr,
                    options: controller.genders,
                    onChanged: (v) => controller.gender.value = v,
                    validator: (_) => controller.validateSelect(controller.gender.value, 'gender'.tr),
                  ),
                  SizedBox(height: 12.h),

                  // BLOOD GROUP (Bottom Sheet)
                  _FieldLabel(text: '${'blood_group'.tr}'),
                  _SelectField(
                    context: context,
                    title: 'select_blood_group'.tr,
                    value: controller.bloodGroup.value,
                    hint: 'select_blood_group'.tr,
                    options: controller.bloodGroups,
                    onChanged: (v) => controller.bloodGroup.value = v,
                  ),
                  SizedBox(height: 18.h),

                  _SectionHeader(title: 'contact_information'.tr),
                  // SizedBox(height: 12.h),
                  //
                  // _FieldLabel(text: '${'phone'.tr}*'),
                  // TextFormField(
                  //   controller: controller.phoneCtrl,
                  //   keyboardType: TextInputType.phone,
                  //   decoration: _dec(hint: 'enter_phone'.tr),
                  //   validator: controller.validatePhone,
                  //   style: TextStyle(
                  //     fontSize: 14.sp,
                  //     color: Colors.black87,
                  //     fontWeight: FontWeight.normal,
                  //   ),
                  // ),
                  SizedBox(height: 12.h),

                  _FieldLabel(text: 'email_address'.tr),
                  TextFormField(
                    controller: controller.emailCtrl,
                    readOnly: true,
                    decoration: _dec(hint: 'email_address'.tr),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  _FieldLabel(text: 'street_address'.tr),
                  TextFormField(
                    controller: controller.streetCtrl,
                    decoration: _dec(hint: 'enter_street_address'.tr),
                    validator: (v) => controller.validateRequired(v, 'street_address'.tr),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  _FieldLabel(text: 'apartment_suite_unit_optional'.tr),
                  TextFormField(
                    controller: controller.aptCtrl,
                    decoration: _dec(hint: 'apt_suite_unit'.tr),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  _FieldLabel(text: 'city'.tr),
                  TextFormField(
                    controller: controller.cityCtrl,
                    decoration: _dec(hint: 'enter_city'.tr),
                    validator: (v) => controller.validateRequired(v, 'city'.tr),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // STATE (Bottom Sheet)
                  _FieldLabel(text: 'state'.tr),
                  _SelectField(
                    context: context,
                    title: 'select_state'.tr,
                    value: controller.state.value,
                    hint: 'select_state'.tr,
                    options: controller.states,
                    onChanged: (v) => controller.state.value = v,
                    validator: (_) => controller.validateSelect(controller.state.value, 'state'.tr),
                  ),
                  SizedBox(height: 12.h),

                  _FieldLabel(text: 'zip_code'.tr),
                  TextFormField(
                    controller: controller.zipCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _dec(hint: 'enter_zip_code'.tr),
                    validator: controller.validateZip,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // COUNTRY (Bottom Sheet)
                  _FieldLabel(text: 'country'.tr),
                  _SelectField(
                    context: context,
                    title: 'select_country'.tr,
                    value: controller.country.value,
                    hint: 'select_country'.tr,
                    options: controller.countries,
                    onChanged: (v) => controller.country.value = v,
                    validator: (_) => controller.validateSelect(controller.country.value, 'country'.tr),
                  ),

                  SizedBox(height: 24.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kDanger,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        textStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text('update'.tr),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _HairLine()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        const Expanded(child: _HairLine()),
      ],
    );
  }
}

class _HairLine extends StatelessWidget {
  const _HairLine();
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFE9EEF0));
  }
}

// small helper for titles outside inputs
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF111111),
          ),
        ),
      ),
    );
  }
}
