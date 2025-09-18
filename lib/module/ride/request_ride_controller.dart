// lib/ride/request_ride_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RequestRideController extends GetxController {
  final pickupCtrl = TextEditingController();
  final dropoffCtrl = TextEditingController();

  final needRoundTrip = false.obs;

  // Chip labels (kept as before)
  final whenLabel = 'pickup_now'.tr.obs;
  final whoLabel  = 'for_me'.tr.obs;
  final typeLabel = 'ac_ambulance'.tr.obs;

  // Popular place i18n keys [titleKey, subtitleKey]
  final placesKeys = const [
    ['place_airport_title', 'place_airport_sub'],
    ['place_jfp_title',     'place_jfp_sub'],
    ['place_bcity_title',   'place_bcity_sub'],
  ];

  void toggleRoundTrip(bool? v) => needRoundTrip.value = v ?? false;

  void pickOnMap(bool isPickup) {}
  void openSavedAddresses() {}

  void continueFlow() {
    if (pickupCtrl.text.trim().isEmpty || dropoffCtrl.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter pickup and drop-off');
      return;
    }
  }

  @override
  void onClose() {
    pickupCtrl.dispose();
    dropoffCtrl.dispose();
    super.onClose();
  }
}
