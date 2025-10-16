import 'package:ambufast_driver/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/bottom_sheet_helper.dart';
import '../../widgets/custom_button.dart';
import 'create_down_trip_controller.dart';

class CreateDownTripView extends GetView<CreateDownTripController> {
  const CreateDownTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('down_create_title'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel(text: 'pickup_address'.tr),
              SizedBox(height: 8.h),
              Obx(() => _SelectTile(
                    hint: 'select_pickup'.tr,
                    value: controller.pickup.value,
                    onTap: () => controller.pickAddress(isPickup: true),
                  )),
              SizedBox(height: 14.h),

              _FieldLabel(text: 'dropoff_address'.tr),
              SizedBox(height: 6.h),
              Obx(() => _SelectTile(
                    hint: 'select_dropoff'.tr,
                    value: controller.dropoff.value,
                    onTap: () => controller.pickAddress(isPickup: false),
                  )),
              SizedBox(height: 16.h),

              Obx(
                () => Column(
                  children: [
                    _buildEstimatedTimeCard(
                      controller.getFormattedFullDateTime(),
                    ),
                    SizedBox(height: 16.h),
                    _buildPickerButton(
                      text: controller.getFormattedTime(),
                      onTap: controller.showTimePicker,
                    ),
                    SizedBox(height: 16.h),
                    _buildPickerButton(
                      text: controller.getFormattedDate(),
                      onTap: controller.showDatePicker,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Promo banner (mock)
              Image.asset(
                'assets/slider_image.png',
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              btnTxt: 'create_trip'.tr,
              onTap: controller.submit,
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= small widgets ================= */

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: blackBase,
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final String hint;
  final String? value;
  final VoidCallback onTap;

  const _SelectTile({required this.hint, required this.onTap, this.value});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: neutral200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: value == null ? neutralBase : blackBase,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: neutralBase,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildEstimatedTimeCard(String dateTimeString) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.sp),
    decoration: BoxDecoration(
      color: Color(0xFFE6F0FF),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Column(
      children: [
        Text(
          'estimated_pickup'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: blackBase,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          dateTimeString,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: blackBase,
          ),
        ),
      ],
    ),
  );
}

Widget _buildPickerButton({
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: neutral100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}
