import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/step_card_widget.dart';
import 'support_request_controller.dart';
import 'package:dotted_border/dotted_border.dart';

class SupportRequestView extends GetView<SupportRequestController> {
  const SupportRequestView({super.key});




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('request_support_title'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepCard(
                title: 'start_a_request'.tr,
                subtitle: 'start_a_request_hint'.tr,
                badgeText: 'request_support_step'.tr,
              ),

              16.h.verticalSpace,
              _CauseAmountUrgency(),
              16.h.verticalSpace,
              _DescField(),
              16.h.verticalSpace,
              _DocUploadCard(),
              16.h.verticalSpace,
              _NidSection(),
              16.h.verticalSpace,
              _AgreeRow(),
              16.h.verticalSpace,
              Obx(() => SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: controller.submitting.value ? null : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // 🔴 button color
                    foregroundColor: Colors.white, // ⚪ text/icon color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r), // ⬜ rounded corners
                    ),
                  ),
                  child: controller.submitting.value
                      ? const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white, // loader visible on red
                  )
                      : Text(
                    'continue'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),

              8.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}


class _CauseAmountUrgency extends GetView<SupportRequestController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LabeledDropdown(
          label: 'request_cause'.tr,
          hint: 'hint_select_cause'.tr,
          items: controller.causes
              .map((k) => DropdownMenuItem(value: k, child: Text(k.tr)))
              .toList(),
          valueRx: controller.selectedCause,
        ),
        12.h.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _LabeledTextField(
                label: 'amount_needed'.tr,
                hint: 'hint_enter_amount'.tr,
                controller: controller.amountCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            12.w.horizontalSpace,
            Expanded(
              child: _LabeledDropdown(
                label: 'urgency'.tr,
                hint: 'hint_select_urgency'.tr,
                items: controller.urgencies
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                valueRx: controller.selectedUrgency,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescField extends GetView<SupportRequestController> {
  @override
  Widget build(BuildContext context) {
    return _LabeledTextField(
      label: 'describe_situation'.tr,
      hint: 'hint_write_situation'.tr,
      controller: controller.descCtrl,
      maxLines: 5,
    );
  }
}

class _DocUploadCard extends GetView<SupportRequestController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(blurRadius: 8.r, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('doc_upload_title'.tr,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          4.h.verticalSpace,
          Text('doc_upload_sub'.tr,
              style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
          12.h.verticalSpace,
          Obx(() {
            final picked = controller.docFile.value;
            return _DashedUploadBox(
              onTap: controller.pickDoc,
              title: 'doc_upload_drop'.tr,
              subtitle:
              '${'doc_upload_max'.tr}\n${'doc_upload_types'.tr}',
              file: picked,
            );
          }),
        ],
      ),
    );
  }
}

class _NidSection extends GetView<SupportRequestController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => _DashedUploadBox(
          label: 'nid_front_title'.tr,
          onTap: controller.pickNidFront,
          title: 'click_to_upload_front'.tr,
          subtitle: 'max_file_size_25'.tr,
          file: controller.nidFront.value,
          useAddImageIcon: true, // 👈 use custom icon
        )),
        12.h.verticalSpace,
        Obx(() => _DashedUploadBox(
          label: 'nid_back_title'.tr,
          onTap: controller.pickNidBack,
          title: 'click_to_upload_back'.tr,
          subtitle: 'max_file_size_25'.tr,
          file: controller.nidBack.value,
          useAddImageIcon: true, // 👈 use custom icon
        )),
      ],
    );
  }
}


class _AgreeRow extends GetView<SupportRequestController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: controller.agree.value,
            onChanged: (v) => controller.agree.value = v ?? false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        8.w.horizontalSpace,
        Expanded(
          child: Text('agree_verification'.tr,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF1E2430),fontWeight: FontWeight.bold)),
        ),
      ],
    ));
  }
}

/// --- small shared widgets ---

class _LabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;

  const _LabeledTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        8.h.verticalSpace,
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.black45,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F7FB),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final List<DropdownMenuItem<String>> items;
  final RxnString valueRx;

  const _LabeledDropdown({
    required this.label,
    required this.hint,
    required this.items,
    required this.valueRx,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
        8.h.verticalSpace,
        DropdownButtonFormField<String>(
          value: valueRx.value,
          onChanged: (v) => valueRx.value = v,
          isExpanded: true,
          // ✅ Make selected value & menu items NOT bold
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black45,
          ),
          // keep your items but ensure they don't override the style
          items: items
              .map((it) => DropdownMenuItem<String>(
            value: it.value,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1F2937),
              ),
              child: it.child, // your Text(k.tr)
            ),
          ))
              .toList(),

          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black45,
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down, size: 20.w, color: Colors.black45),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F7FB),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        )



      ],
    ));
  }
}



class _DashedUploadBox extends StatelessWidget {
  final String? label;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final File? file;
  final bool useAddImageIcon;

  const _DashedUploadBox({
    this.label,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.file,
    this.useAddImageIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(label!,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ),
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            color: const Color(0xFF4ADE80).withOpacity(0.6),
            strokeWidth: 1,
            dashPattern: const [6, 4], // length of dash & gap
            borderType: BorderType.RRect,
            radius: Radius.circular(12.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 80.w,
                    child: Center(
                      child: file == null
                          ? (useAddImageIcon
                          ? Image.asset(
                        "assets/icon/add_image_icon.png",
                        width: 44.w,
                        height: 44.w,
                      )
                          : Icon(
                        Icons.cloud_upload_outlined,
                        size: 44.w,
                        color: const Color(0xFF1A2035),
                      ))
                          : Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 40.w,
                      ),
                    ),
                  ),
                  8.h.verticalSpace,
                  Text(
                    file == null ? title : file!.path.split('/').last,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  ),
                  4.h.verticalSpace,
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
