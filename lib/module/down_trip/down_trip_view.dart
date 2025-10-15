import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/ambu_app_bar_widget.dart';
import '../../widgets/bottom_nav_widget.dart';
import 'down_trip_controller.dart';

class DownTripView extends GetView<DownTripController> {
  const DownTripView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 150) {
        controller.fetchTrips();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      /// === TOP APP BAR ===
      appBar: AmbuAppBar(
        locationText: "Gulshan1, Dhaka, Bangladesh",
      ),

      /// === MAIN CONTENT ===
      body: Column(
        children: [
          /// === Search Field ===
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E9),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black, size: 20.w),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: "downtrip.search_hint".tr,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today_outlined,
                      color: Colors.black, size: 20.w),
                ],
              ),
            ),
          ),

          /// === Trip List ===
          Expanded(
            child: Obx(() {
              final trips = controller.trips;

              if (trips.isEmpty && controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                itemCount: trips.length + (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= trips.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final trip = trips[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// === IMAGE ===
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            bottomLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r),

                          ),
                          child: Image.asset(
                            trip["image"],
                            width: 120.w, // ✅ Wider
                            height: 90.h, // ✅ Taller
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// === TEXT SECTION ===
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${trip["from"]} to ${trip["to"]}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "${trip["discount"]} ${'downtrip.discount'.tr}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Text(
                                      trip["date"],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Container(
                                      width: 2.w,
                                      height: 12.h,
                                      color: Colors.grey.shade400,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      trip["timeAfter"],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xFFD32F2F),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// === ACTION ICONS ===
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit,
                                  color: Colors.grey.shade500, size: 18),
                              SizedBox(height: 12.h),
                              const Icon(Icons.delete,
                                  color: Colors.redAccent, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      /// === BOTTOM NAVIGATION ===
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
