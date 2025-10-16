import 'package:ambufast_driver/model/user_info.dart';
import 'package:ambufast_driver/module/trip_request/models/trip_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/bottom_sheet_helper.dart';
import '../../../utils/colors.dart';
import '../../../widgets/user_details_card.dart';

class BookingDetailsCard extends StatelessWidget {
  final TripRequest requestDetails;
  final String whenText;
  final UserInfo userInfo;
  final bool isExpanded;
  final bool showCallBtn;
  final VoidCallback? onCall;

  const BookingDetailsCard({
    super.key,
    required this.requestDetails,
    required this.whenText,
    required this.userInfo,
    this.isExpanded = true,
    this.showCallBtn = false,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isExpanded) ...[
          _kv('date_time'.tr, whenText),
          divider(),
          _kv('contact'.tr, requestDetails.contactFor),
          divider(),
          _kv('ambulance'.tr, requestDetails.ambulanceType),
          divider(),
          _kv('trip_type'.tr, requestDetails.tripType),
          divider(),
          _kv('category'.tr, requestDetails.category),
          divider(),
        ],

        // From / To
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _fromToCol(
                  'from'.tr,
                  requestDetails.from,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _fromToCol(
                  'to'.tr,
                  requestDetails.to,
                ),
              ),
            ],
          ),
        ),

        // Distance & time
        SizedBox(height: 8.h),
        divider(),
        SizedBox(height: 8.h),
        _distanceRow(requestDetails),
        SizedBox(height: 8.h),
        divider(),

        // More details (expanded-only)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                color: neutral50,
                child: UserDetailsCard(
                  userInfo: userInfo,
                  onCall: onCall,
                  showCallBtn: showCallBtn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _kv(String k, String v) => Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(
                fontSize: 14.sp,
                color: neutral600,
              ),
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

Widget _fromToCol(String label, String value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: neutral600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            color: neutral600,
          ),
        ),
      ],
    );

Widget _distanceRow(TripRequest requestDetials) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'distance_time'.tr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: neutral600,
              ),
            ),
          ),
          Text(
            '${requestDetials.distanceKm.toStringAsFixed(2)}KM',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: neutral600,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: 1,
              height: 16.h,
              color: neutral200,
            ),
          ),
          Text(
            '${requestDetials.etaMins} ${'mins'.tr}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: neutral600,
            ),
          ),
        ],
      ),
    );
