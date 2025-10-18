import 'package:ambufast_driver/widgets/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import 'update_driving_license_controller.dart';

class UpdateDrivingLicenseView extends GetView<UpdateDrivingLicenseController> {
  const UpdateDrivingLicenseView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UpdateDrivingLicenseController>()) {
      Get.put(UpdateDrivingLicenseController());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _sectionTitle('drivers_license_information'.tr),
                48.h.verticalSpace,
                Text(
                  '${'license_number'.tr} *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: neutral800,
                  ),
                ),
                12.h.verticalSpace,
                TextFormField(
                  controller: controller.licenseNoCtrl,
                  decoration: _dec('enter_full_name'.tr),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: blackBase,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'required_field'.tr
                      : null,
                ),
                18.verticalSpace,
                Text(
                  '${'license_expiry_date'.tr} *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: neutral800,
                  ),
                ),
                8.verticalSpace,
                TextFormField(
                  controller: controller.expiryTextCtrl,
                  readOnly: true,
                  onTap: () => controller.pickExpiryDate(context),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: blackBase,
                  ),
                  decoration: _dec(
                    'select'.tr,
                    suffix: const Icon(Icons.calendar_month_rounded),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'required_field'.tr
                      : null,
                ),
                18.verticalSpace,
                Text(
                  '${'license_category'.tr} *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: neutral800,
                  ),
                ),
                8.verticalSpace,
                Obx(() {
                  final value = controller.selectedCategory.value;
                  return InkWell(
                    onTap: () async {
                      final chosen = await showModalBottomSheet<String>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                        ),
                        builder: (_) => _CategorySheet(
                          options: controller.categories,
                          selected: value,
                        ),
                      );
                      if (chosen != null) {
                        controller.selectedCategory.value = chosen;
                      }
                    },
                    child: InputDecorator(
                      decoration: _dec('select'.tr,
                          suffix: const Icon(Icons.expand_more)),
                      child: Text(
                        value ?? 'Select',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: value == null ? neutralBase : blackBase,
                        ),
                      ),
                    ),
                  );
                }),
                24.h.verticalSpace,
                _sectionTitle('upload_license'.tr),
                16.verticalSpace,
                _UploadTile(
                  title: '${'front_side_of_card'.tr} *',
                  hint: 'upload_front_hint'.tr,
                  onTap: controller.pickFront,
                  preview: controller.frontPreview,
                ),
                16.verticalSpace,
                _UploadTile(
                  title: '${'back_side_of_card'.tr} *',
                  hint: 'upload_back_hint'.tr,
                  onTap: controller.pickBack,
                  preview: controller.backPreview,
                ),
                28.verticalSpace,

                Obx(
                  () => CustomButton(
                    btnTxt: 'update_information'.tr,
                    onTap: controller.isSubmitting.value
                        ? null
                        : controller.submit,
                    trailing: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                          ),
                  ),
                ),
                24.verticalSpace,
                // footer
                Column(
                  children: [
                    Text(
                      'powered_by'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.sp,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      'beta_version'.tr,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        suffixIcon: suffix,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: neutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: primaryBase, width: 1.2),
        ),
      );

  Widget _sectionTitle(String t) => Row(
        children: [
          Expanded(
            child: Divider(
              endIndent: 16.w,
              thickness: 1,
              color: neutral100,
            ),
          ),
          Text(
            t,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: blackBase,
            ),
          ),
          Expanded(
            child: Divider(
              indent: 16.w,
              thickness: 1,
              color: neutral100,
            ),
          ),
        ],
      );
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.title,
    required this.hint,
    required this.onTap,
    required this.preview,
  });

  final String title;
  final String hint;
  final VoidCallback onTap;
  final Rxn<ImageProvider> preview;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final img = preview.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
          8.h.verticalSpace,
          InkWell(
            onTap: onTap,
            child: DottedBorder(
              color: neutral600,
              strokeWidth: 1,
              dashPattern: const [4, 4], // length of dash & gap
              borderType: BorderType.RRect,
              radius: Radius.circular(8.r),
              child: SizedBox(
                height: 190.h,
                child: img == null
                    ? _UploadPlaceholder(hint: hint)
                    : Padding(
                        padding: EdgeInsets.all(8.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image(
                            image: img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder({required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/add_image_icon.png',
              fit: BoxFit.cover,
              width: 50.w,
            ),
            12.verticalSpace,
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: neutralBase,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            6.verticalSpace,
            Text(
              '(max_file_size_25mb)'.tr,
              style: TextStyle(
                color: primaryBase,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySheet extends StatelessWidget {
  const _CategorySheet({required this.options, this.selected});
  final List<String> options;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h, bottom: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            10.verticalSpace,
            ...options.map((e) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.tr),
                  trailing: Radio<String>(
                    value: e,
                    groupValue: selected,
                    onChanged: (v) => Navigator.of(context).pop(v),
                  ),
                  onTap: () => Navigator.of(context).pop(e),
                )),
          ],
        ),
      ),
    );
  }
}
