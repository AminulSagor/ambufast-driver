// lib/widgets/go_online_offline_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../module/home/home_controller.dart';

/// ==========================
/// 🟢 GO ONLINE BOTTOM SHEET
/// ==========================
class GoOnlineBottomSheet extends StatelessWidget {
  const GoOnlineBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SingleChildScrollView(
      // ✅ Handles keyboard inset only (no SafeArea gap)
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // === Header Icon ===
            Image.asset('assets/icon/ambu_error_icon.png', width: 40.w, height: 40.w),
            SizedBox(height: 12.h),

            // === Title ===
            Text(
              "bottomsheet.go_online_title".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),

            // === Description ===
            Text(
              "bottomsheet.go_online_desc".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black54,
                height: 1.45,
              ),
            ),
            SizedBox(height: 16.h),

            // === Search field ===
            Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey, size: 20.w),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center, // ✅ centers vertically
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true, // ✅ remove default padding
                        hintText: "bottomsheet.search_vehicle".tr,
                        hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      onChanged: (val) => controller.searchQuery.value = val,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // === Vehicle list (scrollable) ===
            SizedBox(
              height: 250.h,
              child: Obx(() {
                final vehicles = controller.filteredVehicles;
                if (vehicles.isEmpty) {
                  return Center(
                    child: Text(
                      "No vehicles found",
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final v = vehicles[index];
                    final id = v["id"]!;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40.r),
                            child: Image.asset(
                              v["image"]!,
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v["name"]!.tr,
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  v["number"]!,
                                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => Radio<String>(
                            value: id,
                            groupValue: controller.selectedVehicleId.value,
                            onChanged: (val) => controller.selectedVehicleId.value = val!,
                            activeColor: Colors.red,
                          )),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 16.h),

            // === Go Online Button ===
            Obx(() {
              final selected = controller.selectedVehicleId.value;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  minimumSize: Size(double.infinity, 48.h),
                ),
                onPressed: selected.isEmpty ? null : controller.confirmGoOnline,
                child: Text(
                  "bottomsheet.go_online_btn".tr,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              );
            }),

            SizedBox(height: 10.h),

            // === Cancel Button ===
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF2F2F2),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () => Get.back(),
              child: Text(
                "bottomsheet.cancel_btn".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ==========================
/// 🔴 GO OFFLINE BOTTOM SHEET
/// ==========================
class GoOfflineBottomSheet extends StatelessWidget {
  const GoOfflineBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icon/ambu_error_icon.png', width: 40.w, height: 40.w),
            SizedBox(height: 12.h),
            Text(
              "bottomsheet.go_offline_title".tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            SizedBox(height: 8.h),
            Text(
              "bottomsheet.go_offline_desc".tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: Colors.black54, height: 1.45),
            ),
            SizedBox(height: 20.h),

            // === Confirm Go Offline Button ===
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                minimumSize: Size(double.infinity, 48.h),
              ),
              onPressed: controller.confirmGoOffline,
              child: Text(
                "bottomsheet.go_offline_btn".tr,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 10.h),

            // === Cancel Button ===
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF2F2F2),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () => Get.back(),
              child: Text(
                "bottomsheet.cancel_btn".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
