import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../combine_controller/location_controller.dart';
import '../../model/booking_model.dart';
import '../../model/trip_model.dart';
import '../../widgets/ambu_app_bar_widget.dart';
import '../../widgets/upcoming_trip_card_widget.dart';
import '../../widgets/bottom_nav_widget.dart';
import 'activity_controller.dart';

TripCardStatus _flagFor(BookingStatus s) {
  switch (s) {
    case BookingStatus.upcoming:
    case BookingStatus.scheduled:
      return TripCardStatus.upcoming;
    case BookingStatus.completed:
      return TripCardStatus.past;
    case BookingStatus.cancelled:
      return TripCardStatus.cancelled;
  }
}

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    const tabBg = Color(0xFFE9E9EE);
    final loc = Get.find<LocationController>();

    return Scaffold(
      appBar: AmbuAppBar(
        locationBuilder: (ctx) => Obx(() => Text(
          loc.locationText.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,               // <-- was missing
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        )),
        isLocationMissing: () {
          final v = loc.locationText.value.trim();
          return v.isEmpty || v.contains('not available');
        },
        onRequestDeviceLocation: loc.refreshFromDevice,
        showNotificationDot: true,
      ),


      body: Column(
        children: [



          // tabs
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Obx(() {
              return Container(
                height: 46.h,
                decoration: BoxDecoration(
                  color: tabBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    _TabButton(
                      label: 'tk_upcoming'.tr,
                      selected: controller.tab.value == ActivityTab.upcoming,
                      onTap: () => controller.changeTab(ActivityTab.upcoming),
                    ),
                    _TabButton(
                      label: 'tk_past'.tr,
                      selected: controller.tab.value == ActivityTab.past,
                      onTap: () => controller.changeTab(ActivityTab.past),
                    ),
                    _TabButton(
                      label: 'tk_cancelled'.tr,
                      selected: controller.tab.value == ActivityTab.cancelled,
                      onTap: () => controller.changeTab(ActivityTab.cancelled),
                    ),
                  ],
                ),
              );
            }),
          ),

          // search + date
          // search + date (updated to match design)
          // search + date (matches design: one rounded pill, calendar inside)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Container(
              height: 50.h, // smaller
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9EE),
                borderRadius: BorderRadius.circular(28.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [
                  Icon(Icons.search, size: 22.sp, color: const Color(0xFF3B3F4F)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      onChanged: controller.onSearch,
                      style: TextStyle(
                        fontSize: 18.sp, // smaller text
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3B3F4F),
                        height: 1.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'tk_search_booking'.tr,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5F6575),
                          height: 1.2,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // calendar icon INSIDE the pill
                  InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now.subtract(const Duration(days: 365)),
                        lastDate: now.add(const Duration(days: 365)),
                        initialDate: now,
                      );
                      controller.pickDate(picked);
                    },
                    borderRadius: BorderRadius.circular(18.r),
                    child: SizedBox(
                      width: 36.w,
                      height: 36.h,
                      child: Icon(Icons.calendar_today_outlined,
                          size: 20.sp, color: const Color(0xFF3B3F4F)),
                    ),
                  ),
                ],
              ),
            ),
          ),



          // list + pagination
          Expanded(
            child: Obx(() {
              if (controller.isInitialLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = controller.items;
              if (data.isEmpty) {
                return Center(
                  child: Text('No bookings', style: TextStyle(fontSize: 14.sp)),
                );
              }

              // Only add a footer row when more pages are available
              final itemCount =
                  data.length + (controller.hasMore.value ? 1 : 0);

              return RefreshIndicator(
                onRefresh: controller.loadFirstPage,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 160 &&
                        controller.hasMore.value &&
                        !controller.isFetchingMore.value &&
                        !controller.isInitialLoading.value) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 100.h),
                    itemCount: itemCount,
                    itemBuilder: (_, i) {
                      // Data rows
                      if (i < data.length) {
                        final b = data[i];

                        final trip = Trip(
                          dateText: controller.humanTime(b.time),
                          address: 'tk_location'.tr,
                          clinicName: 'tk_destination'.tr,
                          priceText:
                              '${b.fare.toStringAsFixed(2)} ${'tk_bdt'.tr}',
                          mapAsset: 'assets/map.png',
                        );

                        return UpcomingTripCardWidget(
                          trip: trip,
                          status: _flagFor(b.status),
                          // onTap: (_) => Get.toNamed(Routes.activityDetails, arguments: b.id),
                        );
                      }

                      // Footer row — appears only when hasMore == true
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: controller.isFetchingMore.value
                              ? const CircularProgressIndicator()
                              : Text(
                                  'Scroll for more…',
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black45),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

// 2) Make the pill look right: add margin+padding and correct text colors
class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r), // ← CHANGED (was 10.r)
        child: Container(
          // was: alignment: Alignment.center, height: double.infinity,
          // Give the white pill some breathing room inside the grey track:
          margin: EdgeInsets.all(4.w),                  // ← CHANGED
          padding: EdgeInsets.symmetric(horizontal: 8.w), // ← CHANGED
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),  // ← CHANGED (was 10.r)
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,                          // ← CHANGED (clearer size)
              fontWeight: FontWeight.w700,
              color: selected
                  ? const Color(0xFF0B1B2E)             // dark when selected
                  : const Color(0xFF8F95A3),            // grey when not selected
            ),
          ),
        ),
      ),
    );
  }
}

