import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmDeleteAccountSheet extends StatefulWidget {
  const ConfirmDeleteAccountSheet({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  State<ConfirmDeleteAccountSheet> createState() =>
      _ConfirmDeleteAccountSheetState();
}

class _ConfirmDeleteAccountSheetState extends State<ConfirmDeleteAccountSheet> {
  final checks = <bool>[false, false, false].obs;

  bool get allChecked => checks.every((e) => e);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // drag handle
              Container(
                width: 52.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              12.verticalSpace,

              // Title
              Text(
                'confirm_delete_title'.tr, // Confirm Delete account
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),

              // red hairline
              Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
                child: Container(
                  height: 2,
                  width: 150.w,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x00EF3D33), Color(0xFFEF3D33), Color(0x00EF3D33)],
                    ),
                  ),
                ),
              ),

              // Warning box
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E1), // soft red
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(children: [
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.warning_amber_rounded,
                              size: 18, color: Color(0xFFF59E0B)),
                        ),
                        TextSpan(
                          text: '  ${'warning_title'.tr}\n',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ]),
                    ),
                    Text('warning_intro'.tr,
                        style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151))),
                    8.verticalSpace,
                    _bullet('warning_b1'.tr),
                    _bullet('warning_b2'.tr),
                    _bullet('warning_b3'.tr),
                    _bullet('warning_b4'.tr),
                  ],
                ),
              ),

              16.verticalSpace,

              // Checklist title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'checklist_title'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              10.verticalSpace,

              // Checklist items
              Obx(() => Column(
                children: [
                  _checkRow(
                    value: checks[0],
                    onChanged: (v) => checks[0] = v ?? false,
                    text: 'check_1'.tr,
                  ),
                  _checkRow(
                    value: checks[1],
                    onChanged: (v) => checks[1] = v ?? false,
                    text: 'check_2'.tr,
                  ),
                  _checkRow(
                    value: checks[2],
                    onChanged: (v) => checks[2] = v ?? false,
                    text: 'check_3'.tr,
                  ),
                ],
              )),

              14.verticalSpace,

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: widget.onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E7EB),
                    foregroundColor: const Color(0xFF111827),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text('no'.tr, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                ),
              ),
              10.verticalSpace,
              Obx(() => SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: allChecked ? widget.onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF3D33),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'delete_cta'.tr, // Permanently Delete My Account
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text) => Padding(
    padding: EdgeInsets.only(left: 6.w, bottom: 4.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  ', style: TextStyle(color: Color(0xFF374151))),
        Expanded(
          child: Text(text,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151))),
        ),
      ],
    ),
  );

  Widget _checkRow({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
              side: const BorderSide(color: Color(0xFF94A3B8), width: 1.4),
              activeColor: const Color(0xFF111827),
              checkColor: Colors.white,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF374151))),
          ),
        ],
      ),
    );
  }
}
