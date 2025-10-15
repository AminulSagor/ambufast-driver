// lib/module/home/home_controller.dart
import 'package:get/get.dart';
import '../../model/trip_model.dart';
import '../../widgets/online_offline_bottomsheets.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final upcomingTrips = <Trip>[].obs;
  RxBool isOnline = false.obs;
  final isAccountNotApproved = true.obs;

  // === VEHICLE MANAGEMENT ===
  final vehicles = [
    {
      "id": "v001",
      "name": "AC Ambulance",
      "number": "Toyota | Dhaka Metro 12 5896",
      "image": "assets/launch_screen_background.png"
    },
    {
      "id": "v002",
      "name": "Non AC Ambulance",
      "number": "Toyota | Dhaka Metro 12 5897",
      "image": "assets/launch_screen_background.png"
    },
    {
      "id": "v003",
      "name": "ICU Ambulance",
      "number": "Toyota | Dhaka Metro 12 5898",
      "image": "assets/launch_screen_background.png"
    },
    {
      "id": "v004",
      "name": "Freezing Ambulance",
      "number": "Toyota | Dhaka Metro 12 5899",
      "image": "assets/launch_screen_background.png"
    },
    {
      "id": "v005",
      "name": "Cardiac Ambulance",
      "number": "Toyota | Dhaka Metro 13 1234",
      "image": "assets/launch_screen_background.png"
    },
    {
      "id": "v006",
      "name": "Neonatal Ambulance",
      "number": "Toyota | Dhaka Metro 11 4444",
      "image": "assets/launch_screen_background.png"
    },
    {
      "id": "v007",
      "name": "Air Ambulance",
      "number": "Dhaka Airport | Heli 991",
      "image": "assets/launch_screen_background.png"
    },
  ];

  // Reactive states
  RxString searchQuery = ''.obs;
  RxString selectedVehicleId = ''.obs;

  // Filtered list
  List<Map<String, String>> get filteredVehicles {
    if (searchQuery.value.isEmpty) return vehicles;
    return vehicles
        .where((v) =>
    v["name"]!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        v["number"]!.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _seedStaticData();
  }

  void onTripTap(Trip t) {}

  // === ONLINE/OFFLINE TOGGLE ===
  void toggleOnlineOffline() {
    if (isOnline.value) {
      Get.bottomSheet(
        const GoOfflineBottomSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    } else {
      Get.bottomSheet(
        const GoOnlineBottomSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }
  }

  // === CONFIRM ACTIONS ===
  void confirmGoOnline() {
    if (selectedVehicleId.value.isEmpty) {
      Get.snackbar(
        "Select Vehicle",
        "Please select a vehicle before going online.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(10),
      );
      return;
    }
    isOnline.value = true;
    Get.back();
  }

  void confirmGoOffline() {
    isOnline.value = false;
    Get.back();
  }

  // === STATIC TRIPS ===
  void _seedStaticData() {
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
  }
}
