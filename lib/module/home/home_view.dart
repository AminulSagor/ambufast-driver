import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/service_tile_model.dart';
import '../../widgets/ambu_app_bar_widget.dart';
import '../../widgets/bottom_nav_widget.dart';
import '../../widgets/center_title_divider_widget.dart';
import '../../widgets/donation_banner_widget.dart';
import '../../widgets/promo_image_slider_widget.dart';
import '../../widgets/promo_info_card_widget.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header_widget.dart';
import '../../widgets/service_tile_card_widget.dart';
import '../../widgets/upcoming_trip_card_widget.dart';
import 'home_controller.dart';
import '../../combine_controller/location_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = Get.find<LocationController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),


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





      body: SafeArea(
        child: Obx(() => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SearchBarRow(controller: controller)),
            SliverToBoxAdapter(child: SectionHeader(title: 'home_emergency'.tr, onViewAll: () {})),
            SliverToBoxAdapter(
              child: _GridServices(tiles: controller.emergencyTiles, onTap: controller.onTileTap),
            ),
            SliverToBoxAdapter(child: SectionHeader(title: 'home_non_emergency'.tr, onViewAll: () {})),
            SliverToBoxAdapter(
              child: _GridServices(tiles: controller.nonEmergencyTiles, onTap: controller.onTileTap),
            ),
            SliverToBoxAdapter(child: CenterTitleDivider(title: 'home_upcoming_trips'.tr)),
            SliverToBoxAdapter(child: SectionHeader(title: 'home_upcoming_trips'.tr, onViewAll: () {})),
            SliverList.builder(
              itemCount: controller.upcomingTrips.length,
              itemBuilder: (_, i) => UpcomingTripCardWidget(
                trip: controller.upcomingTrips[i],
                status: TripCardStatus.upcoming,
                onTap: controller.onTripTap,
              ),
            ),

            SliverToBoxAdapter(
              child: PromoImageSlider(
                images: const [
                  'assets/slider_image.png',
                  // add more if you have them:
                  'assets/slider_image.png',
                  'assets/slider_image.png',
                ],
                height: 164, // tweak to your taste
                cornerRadius: 16,
                autoPlay: true,
              ),
            ),
            // 1) Low Cost Intercity (horizontal list)
            SliverToBoxAdapter(child: SectionHeader(title: 'home_low_cost_intracity'.tr, onViewAll: () {})),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180, // ~ image 96 + text + paddings
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.lowCostIntraCity.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final p = controller.lowCostIntraCity[i];
                    return PromoInfoCard.intercity(
                      imageAsset: p.imageAsset,      // or 'assets/ambulance_written.png'
                      title: p.title,
                      subtitle: p.subtitle,          // e.g. "30% discount"
                      bottomLeft: p.dateText,        // e.g. "02 Jul, 10:00 PM" (add this to model if needed)
                      bottomRight: p.meta,           // e.g. "2hour after"
                      onTap: () => controller.onPromoRouteTap(p),
                      width: 220,
                    );
                  },
                ),
              ),
            ),

            // 2) Campaign (2-column grid)
            SliverToBoxAdapter(child: SectionHeader(title: 'home_campaign'.tr, onViewAll: () {})),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.campaigns.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 170, // image 136 + text + paddings
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (_, i) {
                    final c = controller.campaigns[i];
                    return PromoInfoCard.campaign(
                      imageAsset: c.imageAsset,
                      title: c.titleKey.tr,
                      subtitle: c.subtitle,
                      onTap: () => controller.onCampaignTap(c),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SectionHeader(title: 'home_last_ride_title'.tr)),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // 1) Support Now — button LEFT, image RIGHT (same gradient & height)
                  // Support Now — image right (slightly down), button left
                  DonationBanner(
                    body: 'Your donation ensures a dignified final journey for those who cannot afford funeral transport.',
                    buttonText: 'Support Now',
                    imageAsset: 'assets/donation.png',
                    onPressed: controller.onSupportNow,         // << use controller method
                    imageSide: BannerSide.right,
                    imageVAlign: BannerVAlign.bottom,
                    buttonSide: BannerSide.left,
                    buttonVAlign: BannerVAlign.center,
                    height: 150.h,
                    imageScale: 0.78, // tweak if you want a touch larger/smaller
                  ),


                  DonationBanner(
                    body: 'If your family is struggling with funeral transport costs, apply for our donation-based service to ensure a respectful farewell.',
                    buttonText: 'Request Support',
                    imageAsset: 'assets/request_support.png',
                    onPressed: controller.onRequestSupport,     // << use controller method
                    imageSide: BannerSide.left,
                    imageVAlign: BannerVAlign.top,
                    buttonSide: BannerSide.right,
                    buttonVAlign: BannerVAlign.center,
                    height: 150.h,
                    imageScale: 0.60,
                  ),


                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        )),
      ),
      // Bottom nav (matching your assets)
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),

    );
  }
}


class _GridServices extends StatelessWidget {
  final List<ServiceTile> tiles;
  final void Function(ServiceTile) onTap;
  const _GridServices({required this.tiles, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 90,
          crossAxisSpacing: 8,   // match spacing from mock
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, i) {
          final t = tiles[i];
          return ServiceTileCard(
            asset: t.asset,
            title: t.titleKey.tr,
            onTap: () => onTap(t),
          );
        },
      ),
    );
  }
}

