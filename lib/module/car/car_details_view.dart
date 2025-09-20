import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'car_details_controller.dart';

class CarDetailsView extends GetView<CarDetailsController> {
  const CarDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('back'.tr,
            style: TextStyle(color: Colors.black, fontSize: 14.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'car_title'.tr),

              // ---------- Vehicle Photo ----------
              // ---------- Vehicle Photos (multi up to 5) ----------
              _MultiUploadCard(
                title: 'car_vehicle_photo'.tr,
                subtitle: 'car_vehicle_photo_sub'.tr,
                maxNote: 'car_max_10mb'.tr,
                typeNote: 'car_only_types'.tr,
                photosRx: controller.vehiclePhotos,
                onPick: controller.pickVehiclePhotos,
                onRemove: controller.removeVehiclePhotoAt,
              ),



              SizedBox(height: 16.h),
              _Label('car_vehicle_number'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.vehicleNumberCtrl,
                decoration: _dec(hint: 'car_vehicle_number_hint'.tr),
                validator: (v)=> (v==null || v.trim().isEmpty) ? 'car_v_number'.tr : null,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),
              _MultiUploadCard(
                title: 'car_vehicle_reg'.tr,
                subtitle: 'car_vehicle_reg_sub'.tr,
                maxNote: 'car_max_10mb'.tr,
                typeNote: 'car_only_types'.tr,
                photosRx: controller.regStickerPhotos,
                onPick: controller.pickRegStickers,
                onRemove: controller.removeRegStickerAt,
              ),
              SizedBox(height: 16.h),
              _Label('car_vehicle_type'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.vehicleTypeCtrl,
                readOnly: true,
                decoration: _dec(
                  hint: 'car_vehicle_type_hint'.tr,
                  suffix: const Icon(Icons.arrow_drop_down),
                ),
                onTap: () => controller.pickFromList(context, controller.vehicleTypes, controller.vehicleTypeCtrl),
                validator: (v)=> (v==null || v.trim().isEmpty) ? 'car_v_type'.tr : null,
              ),

              SizedBox(height: 16.h),
              _Label('car_brand_model'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.brandModelCtrl,
                decoration: _dec(hint: 'car_brand_model_hint'.tr),
                validator: (v)=> (v==null || v.trim().isEmpty) ? 'car_v_brand'.tr : null,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),
              _Label('car_manufacturing_year'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.yearCtrl,
                decoration: _dec(
                  hint: 'car_manufacturing_year_hint'.tr,
                  suffix: const Icon(Icons.edit_calendar_outlined, size: 18),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                validator: controller.validateYear,
              ),

              SizedBox(height: 20.h),
              _DividerWithTitle(title: 'car_ins_comp_section'.tr),
              SizedBox(height: 20.h),
              _MultiUploadCard(
                title: 'car_ins_upload'.tr,
                subtitle: 'car_vehicle_photo_sub'.tr,
                maxNote: 'car_max_10mb'.tr,
                typeNote: 'car_only_types'.tr,
                photosRx: controller.insurancePhotos,
                onPick: controller.pickInsurancePhotos,
                onRemove: controller.removeInsurancePhotoAt,
              ),

              SizedBox(height: 16.h),
              _Label('car_ins_provider'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.insProviderCtrl,
                readOnly: true,
                decoration: _dec(
                  hint: 'car_ins_provider_hint'.tr,
                  suffix: const Icon(Icons.arrow_drop_down),
                ),
                onTap: () => controller.pickFromList(context, controller.insuranceProviders, controller.insProviderCtrl),
                validator: (v)=> (v==null || v.trim().isEmpty) ? 'car_v_ins_provider'.tr : null,
              ),

              SizedBox(height: 16.h),
              _Label('car_ins_expiry'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.insExpiryCtrl,
                decoration: _dec(
                  hint: 'car_select'.tr,
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF8A8F98)),
                    onPressed: () => controller.chooseDate(controller.insExpiryCtrl, context),
                    tooltip: 'car_select'.tr,
                  ),
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: controller.validateYmd,
              ),

              SizedBox(height: 16.h),
              _Label('car_fit_expiry'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.fitnessExpiryCtrl,
                decoration: _dec(
                  hint: 'car_select'.tr,
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF8A8F98)),
                    onPressed: () => controller.chooseDate(controller.fitnessExpiryCtrl, context),
                    tooltip: 'car_select'.tr,
                  ),
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: controller.validateYmd,
              ),

              SizedBox(height: 16.h),
              _Label('car_road_permit_expiry'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.roadPermitExpiryCtrl,
                decoration: _dec(
                  hint: 'car_select'.tr,
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF8A8F98)),
                    onPressed: () => controller.chooseDate(controller.roadPermitExpiryCtrl, context),
                    tooltip: 'car_select'.tr,
                  ),
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: controller.validateYmd,
              ),

              SizedBox(height: 16.h),
              _Label('car_emission_status'.tr),
              SizedBox(height: 8.h),
              TextFormField(
                controller: controller.emissionStatusCtrl,
                readOnly: true,
                decoration: _dec(
                  hint: 'car_select'.tr,
                  suffix: const Icon(Icons.arrow_drop_down),
                ),
                onTap: () => controller.pickFromList(context, controller.emissionStatuses, controller.emissionStatusCtrl),
                validator: (v)=> (v==null || v.trim().isEmpty) ? 'car_v_type'.tr : null,
              ),

              SizedBox(height: 20.h),
              _DividerWithTitle(title: 'car_additional_services'.tr),
              SizedBox(height: 10.h),
              // simple check-list placeholder (static)
              Obx(() {
                final items = controller.extraServices;
                return Column(
                  children: items.map((label) {
                    final selected = controller.isServiceSelected(label);
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: Checkbox(
                              value: selected,
                              onChanged: (v) => controller.toggleService(label, v ?? false),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp))),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),


              SizedBox(height: 20.h),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value ? null : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('car_submit'.tr, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                      SizedBox(width: 8.w),
                      const Icon(Icons.check, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              )),

              SizedBox(height: 16.h),
              Center(
                child: Text(
                  'powered'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------- UI helpers --------
  InputDecoration _dec({required String hint, Widget? suffix}) {
    final radius = BorderRadius.circular(12.r);
    const borderColor = Color(0xFFD5D9E0);
    const focusedColor = Color(0xFFB7BEC8);
    const errorColor = Color(0xFFE53935);

    OutlineInputBorder outline(Color c) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: c, width: 1),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: const Color(0xFF9AA2AE), fontSize: 14.sp),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      enabledBorder: outline(borderColor),
      border: outline(borderColor),
      focusedBorder: outline(focusedColor),
      errorBorder: outline(errorColor),
      focusedErrorBorder: outline(errorColor),
      suffixIcon: suffix,
    );
  }



}

// ---- small widgets ----
class _Label extends StatelessWidget {
  const _Label(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: const Color(0xFF2D3238)),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2D3238))),
      ),
      Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
    ],
  );
}

class _DividerWithTitle extends StatelessWidget {
  const _DividerWithTitle({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xFF2D3238))),
      ),
      Expanded(child: Divider(color: Colors.black12, thickness: 1.h)),
    ],
  );
}



class _MultiUploadCard extends StatelessWidget {
  const _MultiUploadCard({
    required this.title,
    required this.subtitle,
    required this.maxNote,
    required this.typeNote,
    required this.photosRx,
    required this.onPick,
    required this.onRemove,
    super.key,
  });

  final String title, subtitle, maxNote, typeNote;
  final RxList<String> photosRx;
  final VoidCallback onPick;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = photosRx;

      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16.r, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2D3238))),
            SizedBox(height: 4.h),
            Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 10.h),

            // dotted area (ALWAYS visible)
            GestureDetector(
              onTap: onPick,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12.r),
                dashPattern: const [6, 4],
                color: const Color(0xFF26A69A),
                strokeWidth: 1.2,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 160.h),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_upload_outlined, color: Color(0xFF263238)),
                      SizedBox(height: 8.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF263238)),
                          children: const [
                            TextSpan(text: 'Drag your file(s) or '),
                            TextSpan(text: 'browse', style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(maxNote, style: TextStyle(fontSize: 12.sp, color: Colors.black54, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),
            Text(typeNote, style: TextStyle(fontSize: 11.sp, color: Colors.black54)),

            // picked files list (chips)
            if (items.isNotEmpty) ...[
              SizedBox(height: 12.h),
              for (int i = 0; i < items.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 8.h),
                  child: _FileChip(
                    path: items[i],
                    onRemove: () => onRemove(i),
                  ),
                ),
            ],

            // count
          ],
        ),
      );
    });
  }
}



class _FileChip extends StatelessWidget {
  const _FileChip({required this.path, required this.onRemove, super.key});
  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    final fileName = path.split('/').last;

    // size (best-effort; if it fails, hide the size)
    String? sizeText;
    try {
      final bytes = file.lengthSync();
      sizeText = _formatBytes(bytes);
    } catch (_) {
      sizeText = null;
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD5D9E0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // thumb
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: 40.w,
              height: 40.w,
              color: const Color(0xFFF3F7FB),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, color: Color(0xFF8A8F98)),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // name + size
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2D3238)),
                ),
                if (sizeText != null) ...[
                  SizedBox(height: 2.h),
                  Text(sizeText, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6F7985))),
                ],
              ],
            ),
          ),

          // remove button
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 18, color: Color(0xFF52606D)),
            ),
          ),
        ],
      ),
    );
  }
}


String _formatBytes(int bytes) {
  if (bytes <= 0) return '0 KB';
  const kb = 1024;
  const mb = 1024 * 1024;
  if (bytes >= mb) {
    final v = (bytes / mb);
    return '${v.toStringAsFixed(v >= 10 ? 0 : 1)} MB';
  } else {
    final v = (bytes / kb);
    return '${v.toStringAsFixed(v >= 10 ? 0 : 1)} KB';
  }
}