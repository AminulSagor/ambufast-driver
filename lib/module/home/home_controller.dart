// lib/home/home_controller.dart
import 'package:get/get.dart';
import '../../combine_service/location_service.dart';
import '../../model/low_cost_intercity_model.dart';
import '../../model/service_tile_model.dart';
import '../../model/trip_model.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
 // <-- change
  // --- State
  final upcomingTrips = <Trip>[].obs;
  final emergencyTiles = <ServiceTile>[].obs;
  final nonEmergencyTiles = <ServiceTile>[].obs;
  final campaigns = <Campaign>[].obs;
  final lowCostIntraCity = <PromoRoute>[].obs;

  // --- Lifecycle
  @override
  void onInit() {
    super.onInit();
    _seedStaticData();
  }

  // --- Intent
  void onGoLaterTap() {}

  void onSearchTap() {}

  void onTileTap(ServiceTile tile) {}

  void onTripTap(Trip t) {}

  void onPromoRouteTap(PromoRoute p) {}

  void onCampaignTap(Campaign c) {}

  void onSupportNow() {Get.toNamed(Routes.donateMoney);
  }

  void onRequestSupport() {Get.toNamed(Routes.requestSupport);
  }





  // --- Mock / seed
  void _seedStaticData() {
    emergencyTiles.assignAll([
      ServiceTile('Ac Ambulance',
          'assets/icon/home_page_icon/ambulance_icon.png', 'home_emergency_ac_ambulance'),
      ServiceTile('Non Ac Ambulance',
          'assets/icon/home_page_icon/ambulance_icon.png', 'home_emergency_non_ac_ambulance'),
      ServiceTile('ICU/CCU Ambulance',
          'assets/icon/home_page_icon/ambulance_icon.png', 'home_emergency_icu_ambulance'),
      ServiceTile('Freezing Van',
          'assets/icon/home_page_icon/ambulance_icon.png', 'home_emergency_freezing_van'),
    ]);

    nonEmergencyTiles.assignAll([
      ServiceTile('moto', 'assets/icon/home_page_icon/motorcycle_icon.png',
          'home_non_emergency_motorcycle'),
      ServiceTile('cng', 'assets/icon/home_page_icon/cng_icon.png',
          'home_non_emergency_cng'),
      ServiceTile('micro', 'assets/icon/home_page_icon/moto_saver_icon.png',
          'home_non_emergency_micro'),
      ServiceTile('Freezing Van',
          'assets/icon/home_page_icon/ambulance_icon.png', 'home_emergency_freezing_van'),
    ]);

    upcomingTrips.assignAll([
      Trip(
        title: 'PV urgent care clinic (10 min)',
        dateText: 'Today, 10:00 PM',
        address: 'Gulshan 1, Dhaka, Bangladesh',
        clinicName: 'PV urgent care clinic (10 min)',
        priceText: '580.00 BDT',
        statusBadge: 'home_upcoming',
      ),
      Trip(
        title: 'PV urgent care clinic (10 min)',
        dateText: 'Tomorrow, 03:00 PM',
        address: 'Gulshan 1, Dhaka, Bangladesh',
        clinicName: 'PV urgent care clinic (10 min)',
        priceText: '580.00 BDT',
        statusBadge: 'home_upcoming',
      ),
    ]);

    lowCostIntraCity.assignAll([
      PromoRoute(
        imageAsset: 'assets/ambulance_written.png',
        title: 'Naogaon to Dhaka',
        subtitle: '30% discount',
        dateText: '02 Jul, 10:00 PM',
        meta: '2hour after',
      ),
      PromoRoute(
        imageAsset: 'assets/ambulance_written.png',
        title: 'Naogaon to Dhaka',
        subtitle: '30% discount',
        dateText: '02 Jul, 10:00 PM',
        meta: '2hour after',
      ),
    ]);

    campaigns.assignAll([
      Campaign('assets/pregnant_girl.png', 'home_offer_sub', '30% discount'),
      Campaign('assets/heart_attack.png', 'home_campaign_heart_attack', '30% discount'),
      Campaign('assets/heart_attack.png', 'home_campaign_dialysis', '30% discount'),
      Campaign('assets/heart_attack.png', 'home_campaign_disabled', '30% discount'),
    ]);
  }
}

// simple campaign model (unchanged)
class Campaign {
  final String imageAsset;
  final String titleKey;
  final String subtitle;
  Campaign(this.imageAsset, this.titleKey, this.subtitle);
}
