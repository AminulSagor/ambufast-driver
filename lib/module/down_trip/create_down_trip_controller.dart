import 'package:ambufast_driver/module/down_trip/down_trip_create_success.dart';
import 'package:ambufast_driver/module/down_trip/widgets/datetime_picker_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'models/down_trip_request.dart';
import 'widgets/create_confirm_sheet.dart';
import 'widgets/district_picker_sheet.dart';

class CreateDownTripController extends GetxController {
  final pickup = RxnString();
  final dropoff = RxnString();
  var selectedDateTime = DateTime.now().add(const Duration(hours: 2)).obs;

  String _locale() {
    final locale = Get.locale;
    return (locale == null)
        ? 'en_US'
        : '${locale.languageCode}_${locale.countryCode ?? 'US'}';
  }

  String formatFull(DateTime dt) =>
      DateFormat('EEE, MMM dd, yy | hh:mm a', _locale()).format(dt);

  String formatDate(DateTime dt) =>
      DateFormat('EEE, MMM dd, yy', _locale()).format(dt);

  String formatTime(DateTime dt) =>
      DateFormat('hh:mm:ss a', _locale()).format(dt);

  Future<void> pickAddress({required bool isPickup}) async {
    final selected = await Get.bottomSheet<String>(
      DistrictPickerSheet(
        initialSelection: isPickup ? pickup.value : dropoff.value,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (selected != null) {
      if (isPickup) {
        pickup.value = selected;
      } else {
        dropoff.value = selected;
      }
    }
  }

  // Future<void> pickTime(BuildContext context) async {
  //   final t = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(pickupDateTime.value),
  //   );
  //   if (t != null) {
  //     final d = pickupDateTime.value;
  //     pickupDateTime.value = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  //   }
  // }

  // Future<void> pickDate(BuildContext context) async {
  //   final d = await showDatePicker(
  //     context: context,
  //     initialDate: pickupDateTime.value,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(const Duration(days: 365)),
  //   );
  //   if (d != null) {
  //     final t = pickupDateTime.value;
  //     pickupDateTime.value = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  //   }
  // }

  // --- Getters for formatted date and time strings ---
  String getFormattedFullDateTime() {
    // The locale needs to be explicitly passed for correct formatting in Bengali
    final format = DateFormat('E, dd MMM y | hh:mm a', _locale());
    return format.format(selectedDateTime.value);
  }

  String getFormattedTime() {
    final format = DateFormat('hh:mm:ss a', _locale());
    return format.format(selectedDateTime.value);
  }

  String getFormattedDate() {
    final format = DateFormat('E, dd MMM y', _locale());
    return format.format(selectedDateTime.value);
  }

  // --- Methods to show pickers ---
  void showDatePicker() {
    // A temporary variable to hold the picker's state
    DateTime tempDate = selectedDateTime.value;

    Get.bottomSheet(
      isScrollControlled: true,
      DatetimePickerSheet(
        title: 'choose_a_date'.tr,
        picker: CupertinoDatePicker(
          initialDateTime: selectedDateTime.value,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (newDate) {
            tempDate = newDate;
          },
        ),
        onDone: () {
          // On "Done" pressed
          final currentDateTime = selectedDateTime.value;
          // Combine the new date with the existing time
          selectedDateTime.value = DateTime(
            tempDate.year,
            tempDate.month,
            tempDate.day,
            currentDateTime.hour,
            currentDateTime.minute,
            currentDateTime.second,
          );
          Get.back();
        },
      ),
    );
  }

  void showTimePicker() {
    DateTime tempTime = selectedDateTime.value;

    Get.bottomSheet(
      DatetimePickerSheet(
        title: 'choose_a_time'.tr,
        picker: CupertinoDatePicker(
          initialDateTime: selectedDateTime.value,
          mode: CupertinoDatePickerMode.time,
          use24hFormat: false,
          onDateTimeChanged: (newTime) {
            tempTime = newTime;
          },
        ),
        onDone: () {
          // On "Done" pressed
          selectedDateTime.value = tempTime;
          Get.back();
        },
      ),
    );
  }

  Future<void> submit() async {
    if (pickup.value == null || dropoff.value == null) {
      Get.snackbar('down_pick_errors_title'.tr, 'down_pick_errors_msg'.tr);
      return;
    }
    final result = await Get.bottomSheet(
      const CreateConfirmationSheet(),
    );
    if (result) {
      Get.dialog(_simplPogressIndicator());
      await Future.delayed(const Duration(seconds: 1));
      final req = DownTripRequest(
        pickupAddress: pickup.value!,
        dropoffAddress: dropoff.value!,
        pickupDateTime: selectedDateTime.value,
      );

      // Mock success
      Get.snackbar(
        'down_created_title'.tr,
        'down_created_msg'.trParams({'when': formatFull(req.pickupDateTime)}),
      );
      Get.to(const DownTripCreateSuccess());
    }
  }
}

Dialog _simplPogressIndicator() {
  return Dialog(
    backgroundColor: Colors.white,
    constraints: BoxConstraints(minHeight: 60.h, minWidth: 60.w),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.r),
    ),
    child: Padding(
      padding: EdgeInsets.all(10.h),
      child: const CircularProgressIndicator(),
    ),
  );
}
