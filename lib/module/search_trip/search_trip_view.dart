import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'search_trip_controller.dart';

class SearchTripView extends GetView<SearchTripController> {
  const SearchTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
            final position = controller.currentPosition.value;
            if (position == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return MaplibreMap(
              styleString: SearchTripController.mapUrl,
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 16,
              ),
              myLocationEnabled: false,
              myLocationTrackingMode: MyLocationTrackingMode.tracking,
              onMapCreated: controller.onMapCreated,
            );
          }),

          Positioned(
            top: 60.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Image.asset(
                      'assets/launch_screen_background.png',
                      width: 52.w,
                      height: 52.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Md Kamrul Hasan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '৳520.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5.00',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.star, color: Colors.amber, size: 18.w),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final isOnline = controller.isOnline.value;
        return Container(
          height: 80.h,
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1B2E),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Get.offAllNamed('/home'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/bottom_navigation/not_selected_home.png',
                      width: 26.w,
                      height: 26.w,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: controller.toggleOnlineOffline,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isOnline
                          ? const Color(0xFF4CAF50)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: isOnline
                          ? Row(
                        key: const ValueKey('online'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Text(
                              'home.status_online'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Image.asset(
                            'assets/icon/home_page_icon/toggle_icon/online.png',
                            width: 28.w,
                            height: 28.w,
                          ),
                        ],
                      )
                          : Row(
                        key: const ValueKey('offline'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icon/home_page_icon/toggle_icon/offline.png',
                            width: 28.w,
                            height: 28.w,
                          ),
                          SizedBox(width: 12.w),
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Text(
                              'home.status_offline'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.offAllNamed('/account'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/bottom_navigation/not_selected_account.png',
                      width: 26.w,
                      height: 26.w,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Account',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
