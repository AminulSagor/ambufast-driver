import 'package:ambufast_driver/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';

class DeleteDownTripConfirmationSheet extends StatelessWidget {
  const DeleteDownTripConfirmationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CancelReasonsController());

    final sheetHeightFactor = 0.7;
    final screenHeight = Get.size.height;
    final sheetHeight = screenHeight * sheetHeightFactor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
      constraints: BoxConstraints(maxHeight: sheetHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icon/ambu_error_icon.png', height: 40.h),
            SizedBox(height: 16.h),

            // Title
            Text(
              'confirm_cancel_title'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),

            // Subheading
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'cancel_reason'.tr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 12.h),

            // Checkbox List
            Obx(
              () => Column(
                spacing: 8.h,
                children: controller.reasonKeys
                    .map((key) => _buildCheckboxTile(controller, key))
                    .toList(),
              ),
            ),
            SizedBox(height: 16.h),

            // Policy Link
            Text(
              'cancel_warning'.tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: primaryBase,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),

            // Buttons
            CustomButton(
              btnTxt: 'delete'.tr,
              onTap: controller.onDel,
            ),
            SizedBox(height: 12.h),
            CustomButton(
              btnTxt: 'go_back'.tr,
              onTap: controller.onBack,
              btnColor: neutral100,
              txtColor: neutral700,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCheckboxTile(CancelReasonsController controller, String key) {
  return InkWell(
    onTap: () => controller.toggleReason(key),
    child: Row(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: Transform.scale(
            scale: 0.7,
            child: Checkbox(
              value: controller.selectedReasons[key],
              onChanged: (value) => controller.toggleReason(key),
              activeColor: Colors.red,
            ),
          ),
        ),
        Text(
          key.tr,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

class CancelReasonsController extends GetxController {
  // cancel trip
  final List<String> reasonKeys = [
    'reason_cannot_reach_pickup',
    'reason_vehicle_issue',
    'reason_emergency_personal',
    'reason_passenger_unreachable',
    'reason_delayed_previous_trip',
    'reason_other',
  ];

  // A reactive map to hold the checked state of each reason
  late final RxMap<String, bool> selectedReasons;

  @override
  void onInit() {
    super.onInit();

    // Initialize all reasons to false (unchecked)
    selectedReasons = {for (var key in reasonKeys) key: false}.obs;
  }

  // Toggles the checked state for a given reason key
  void toggleReason(String key) {
    selectedReasons[key] = !selectedReasons[key]!;
  }

  // Action for the "Yes, Cancel" button
  void onDel() {
    // You can add your cancellation logic here.
    // This example finds the selected reasons and shows a snackbar.
    final reasons = selectedReasons.entries
        .where((entry) => entry.value) // Filter for checked items
        .map((entry) => entry.key.tr) // Get the translated text
        .toList();

    Get.back(result: reasons); // Close the bottom sheet

    if (reasons.isNotEmpty) {
      Get.snackbar(
        'Trip Cancelled',
        'Reason(s): ${reasons.join(', ')}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Trip Cancelled',
        'No reason provided.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onBack() {
    Get.back();
  }
}
