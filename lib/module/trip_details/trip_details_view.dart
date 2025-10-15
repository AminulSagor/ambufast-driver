// lib/modules/trip_details/trip_details_view.dart
import 'package:ambufast_driver/module/trip_details/trip_details_pdf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'trip_details_controller.dart';

class TripDetailsView extends GetView<TripDetailsController> {
  const TripDetailsView({super.key});

  Color get neutral50 => const Color(0xFFECEDED); // card bg
  Color get neutral100 => const Color(0xFFE6E6E9); // card border
  Color get amber => const Color(0xFFFFB300);
  Color get green => const Color(0xFF5CB85C);
  Color get red => const Color(0xFFE24636);
  Color get black => const Color(0xFF000000);
  Color get blue => const Color(0xFF4EA0FF);
  Color get greyBadge => const Color(0xFFE9EDF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text('trip.title'.tr,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        leading:
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: Get.back),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() => Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      children: [
                        _infoCard(),
                        SizedBox(height: 12.h),
                        _mapCard(),
                        SizedBox(height: 12.h),
                        _driverCard(),
                        SizedBox(height: 16.h),
                        _tripStatusCard(),
                        SizedBox(height: 12.h),
                        _paymentCard(
                          title: 'trip.section.advancePay'.tr,
                          paid: controller.advancePaid,
                          info: controller.advance.value,
                          showPaidOnKey: 'trip.field.paidOn'.tr,
                        ),
                        SizedBox(height: 12.h),
                        _paymentCard(
                          title: 'trip.section.finalPay'.tr,
                          paid: controller.finalPaid,
                          info: controller.finalPay.value,
                          showPaidOnKey: 'trip.field.paidOn'.tr,
                        ),
                        SizedBox(height: 12.h),
                        _downloadReceiptButton(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
                _bottomBar(),
              ],
            )),
      ),
    );
  }

  // ---- UI Builders ----

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: neutral50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: neutral100, width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10.r, offset: Offset(0, 4.h))
        ],
      ),
      child: child,
    );
  }

  Widget _badge(String text, Color color, {Color? fg}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(text,
          style: TextStyle(
              color: fg ?? color,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp)),
    );
  }

  Widget _row(String k, String v, {bool copyable = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
              child: Text(k,
                  style: TextStyle(color: Colors.black54, fontSize: 14.sp))),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(v, style: TextStyle(fontSize: 14.sp)),
              if (copyable) ...[
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () => controller.copy(v),
                  child: const Icon(Icons.copy_rounded, size: 16),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.formatToday(controller.tripTime.value),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
          SizedBox(height: 10.h),
          Row(children: [
            const Icon(Icons.location_on_outlined, size: 18),
            SizedBox(width: 6.w),
            Expanded(child: Text(controller.pickup.value)),
          ]),
          SizedBox(height: 6.h),
          Row(children: [
            const Icon(Icons.flag_outlined, size: 18),
            SizedBox(width: 6.w),
            Expanded(child: Text(controller.drop.value)),
          ]),
          SizedBox(height: 10.h),
          Divider(height: 20.h),
          Row(
            children: [
              Text('trip.section.distanceTime'.tr,
                  style: TextStyle(color: Colors.black54, fontSize: 13.sp)),
              const Spacer(),
              Text('${controller.distanceKm.value.toStringAsFixed(2)}KM',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(width: 8.w),
              Text('|', style: TextStyle(color: Colors.black26)),
              SizedBox(width: 8.w),
              Text('${controller.etaMins.value} Mins',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mapCard() {
    return _card(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 190.h,
          color: const Color(0xFFDDE7F5),
          alignment: Alignment.center,
          child: Text('Map Preview', style: TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }

  Widget _driverCard() {
    return _card(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: controller.driverAvatar.value.isNotEmpty
                ? NetworkImage(controller.driverAvatar.value)
                : null,
            child: controller.driverAvatar.value.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.driverName.value,
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(controller.driverAvgRating.value.toStringAsFixed(1),
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w600)),
                    SizedBox(width: 4.w),
                    Icon(Icons.star, size: 16, color: amber),
                    SizedBox(width: 6.w),
                    Text(controller.ratingsCountLabel,
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          // (optional) use your asset icon
          GestureDetector(
            onTap: controller.canCallDriver ? controller.callDriver : null,
            child: Image.asset(
              controller.callIconAsset,
              width: 36.w,
              height: 36.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripStatusCard() {
    final s = controller.state.value;
    Color c;
    switch (s) {
      case TripState.upcoming:
        c = blue;
        break;
      case TripState.scheduled:
        c = black;
        break;
      case TripState.completed:
      case TripState.completedNoRating:
        c = green;
        break;
      case TripState.cancelled:
        c = red;
        break;
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('trip.section.tripStatus'.tr,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp)),
              const Spacer(),
              _badge(controller.tripStatusBadge, c),
            ],
          ),
          SizedBox(height: 10.h),

          // Trip ID row
          _row('trip.field.tripId'.tr, controller.tripId.value, copyable: true),

          // Rating row — only if completed or completedNoRating
          if (s == TripState.completed || s == TripState.completedNoRating)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text('trip.field.rating'.tr,
                        style: TextStyle(color: Colors.black54, fontSize: 14.sp)),
                  ),
                  Row(
                    children: [
                      Text(
                        controller.tripRating.value == null
                            ? 'trip.rating.none'.tr
                            : controller.tripRating.value!.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.star, size: 18.sp, color: amber),
                    ],
                  ),
                ],
              ),
            ),


          // Remaining trip details
          _row('trip.field.contact'.tr, controller.contact.value),
          _row('trip.field.ambulance'.tr, controller.ambulance.value),
          _row('trip.field.type'.tr, controller.tripType.value),
          SizedBox(height: 8.h),
        ],
      ),
    );

  }

  Widget _paymentCard({
    required String title,
    required bool paid,
    required PaymentInfo info,
    required String showPaidOnKey,
  }) {
    final badgeColor = paid ? green : black;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp)),
              const Spacer(),
              _badge(paid ? 'trip.badge.paid'.tr : 'trip.badge.unpaid'.tr,
                  badgeColor),
            ],
          ),
          SizedBox(height: 10.h),
          _row('trip.field.txnId'.tr, info.txnId, copyable: info.txnId != 'No'),
          _row('trip.field.amount'.tr, '৳ ${info.amount}'),
          _row('trip.field.method'.tr, info.method),
          _row(
            showPaidOnKey,
            info.paidAt == null ? 'No' : controller.formatTime(info.paidAt!),
          ),
        ],
      ),
    );
  }

  Widget _downloadReceiptButton() {
    final enabled = controller.topActionEnabled &&
        (controller.state.value == TripState.completed ||
            controller.state.value == TripState.completedNoRating ||
            controller.state.value == TripState.upcoming ||
            controller.state.value == TripState.scheduled);

    return Opacity(
      opacity: enabled ? 1 : .5,
      child: IgnorePointer(
        ignoring: !enabled,
        child: _card(
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  // <- remove pill shape
                  borderRadius:
                      BorderRadius.circular(8.r), // use 0.r if you want square
                ),
                side: BorderSide(color: black),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              onPressed: controller.downloadReceipt,
              child: Text('trip.actions.download'.tr),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    final label = controller.topActionLabel;
    final enabled = controller.topActionEnabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
          child: SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled ? red : Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              onPressed: enabled ? controller.onPrimaryAction : null,
              child: Text(label,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        if (controller.showCancelLink)
          Padding(
            padding: EdgeInsets.only(bottom: 14.h,top: 8.h),
            child: GestureDetector(
              onTap: controller.onCancelTrip,
              child: Text('trip.actions.cancel'.tr,
                  style: TextStyle(color: red, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }
}
