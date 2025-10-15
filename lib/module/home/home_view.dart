import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/ambu_app_bar_widget.dart';
import '../../widgets/bottom_nav_widget.dart';
import '../../widgets/center_title_divider_widget.dart';
import '../../widgets/promo_image_slider_widget.dart';
import '../../widgets/section_header_widget.dart';
import '../../widgets/upcoming_trip_card_widget.dart';
import 'home_controller.dart';
import '../../combine_controller/location_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Get.find<LocationController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AmbuAppBar(
        locationBuilder: (ctx) => Obx(() => Text(
              loc.locationText.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
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
      body: SafeArea(
        child: Obx(
          () => CustomScrollView(
            slivers: [
              if (controller.isAccountNotApproved.value) ...[
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(12.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDEAEA),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 20.w,
                                color: Colors.black.withOpacity(0.7)),
                            SizedBox(width: 8.w),
                            Text(
                              'home.account_not_approved_title'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'home.account_not_approved_subtitle'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(12.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE9E9), // ✅ neutral/50 background
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFFF7F8F8), // ✅ subtle border (1px)
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.03), // softer shadow for neutral bg
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ==== Top Row: Info + Balance ====
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'home.greeting'.trParams({'name': 'Kamrul'}),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'home.vehicle_info'.trParams({
                                    'number': 'DHA-12–3456',
                                    'type': 'ICU',
                                  }),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Rating: ',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 14.w),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '4.8',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),

                                    // Vertical Divider
                                    Container(
                                      width: 1.w,
                                      height: 14.h,
                                      color: Colors.grey.shade400,
                                    ),
                                    SizedBox(width: 8.w),

                                    Text(
                                      'Trips Today: 3',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// ==== Balance Circle ====
                          Container(
                            width: 84.w,
                            height: 84.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD32F2F),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              '৳500',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      /// ==== Centered Toggle ====
                      Obx(() {
                        final isOnline = controller.isOnline.value;
                        return Center(
                          child: GestureDetector(
                            onTap: controller.toggleOnlineOffline,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: isOnline
                                    ? const Color(0xFF4CAF50) // green
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                switchInCurve: Curves.easeInOut,
                                switchOutCurve: Curves.easeInOut,
                                child: isOnline
                                    ? Row(
                                        key: const ValueKey('online'),
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // ✅ Text first
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
                                          // ✅ Icon last (right side)
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
                                          // ✅ Icon first (left side)
                                          Image.asset(
                                            'assets/icon/home_page_icon/toggle_icon/offline.png',
                                            width: 28.w,
                                            height: 28.w,
                                          ),
                                          SizedBox(width: 12.w),
                                          // ✅ Text after
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.w),
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
                        );
                      })
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: PromoImageSlider(
                  images: const [
                    'assets/slider_image.png',
                    'assets/slider_image.png',
                    'assets/slider_image.png',
                  ],
                  height: 164,
                  cornerRadius: 16,
                  autoPlay: true,
                ),
              ),
              SliverToBoxAdapter(
                child: CenterTitleDivider(title: 'home_upcoming_trips'.tr),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'home_upcoming_trips'.tr,
                  onViewAll: () {},
                ),
              ),
              SliverList.builder(
                itemCount: controller.upcomingTrips.length,
                itemBuilder: (_, i) => UpcomingTripCardWidget(
                  trip: controller.upcomingTrips[i],
                  status: TripCardStatus.upcoming,
                  onTap: controller.onTripTap,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// === Title (outside the card) ===
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
                        child: Text(
                          'down.trip.title'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      /// === Card ===
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8F8),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        clipBehavior:
                            Clip.antiAlias, // ✅ makes image respect radius
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// === Image touching top corners ===
                            Image.asset(
                              'assets/ambulance_written.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 140.h,
                            ),

                            /// === Content section ===
                            Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'down.trip.description'.tr,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  /// === Button ===
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFD32F2F),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 30.w,
                                          vertical: 12.h,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'down.trip.cta'.tr,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
