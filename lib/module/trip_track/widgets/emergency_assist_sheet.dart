import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/bottom_sheet_helper.dart';
import '../../../utils/colors.dart';
import '../../../widgets/custom_button.dart';
import '../trip_track_controller.dart';

class EmergencyAssistSheet extends GetView<TripTrackController> {
  final String currentLocation;
  final String vehicleDetails;
  const EmergencyAssistSheet({
    super.key,
    required this.currentLocation,
    required this.vehicleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bottomSheetHeader(
                'emergency_assistance'.tr,
                subTitle: 'emergency_assistance_desc'.tr,
                showGradientDivider: true,
                titleColor: neutral700,
                subTitleColor: neutralBase,
              ),
              SizedBox(height: 8.h),

              // Location
              _infoRow(
                Icons.location_on,
                'your_current_location'.tr,
                currentLocation,
              ),
              SizedBox(height: 8.h),
              // Vehicle
              _infoRow(Icons.location_on, 'vehicle_details'.tr, vehicleDetails),
              SizedBox(height: 16.h),

              // Share trip
              CustomButton(
                btnTxt: 'share_my_trip'.tr,
                onTap: () => controller.shareMyTrip(
                  'Trip SOS\n${'your_current_location'.tr}: $currentLocation\n'
                  '${'vehicle_details'.tr}: $vehicleDetails',
                ),
                btnColor: primaryBase,
                leading: Icon(
                  Icons.share_outlined,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
              16.h.verticalSpace,
              CustomButton(
                btnTxt: 'call_999'.tr,
                onTap: controller.call999,
                btnColor: negative100,
                borderColor: negativeBase,
                txtColor: negativeBase,
                leading: Icon(
                  Icons.phone_in_talk_rounded,
                  size: 20.sp,
                  color: negativeBase,
                ),
              ),
              16.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: blackBase),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: blackFrontS,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(fontSize: 12.sp, color: neutral700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
