// lib/modules/rating/rating_controller.dart
import 'package:get/get.dart';

class RatingController extends GetxController {
  String driverName   = 'Md Kamrul Hasan';
  String avatarUrl    = 'https://images.freejpg.com.ar/900/2106/young-woman-with-hands-painted-blue-in-artistic-expression-F100038922.jpg';
  String vehicleLine  = 'Toyota | Dhaka Metro 12 5896';
  double driverRating = 5.0;
  double totalRatings = 1.2;

  // UI state
  final stars = 0.obs;
  final selected = <String>{}.obs;
  final note = ''.obs;
  final submitting = false.obs;

  // dynamic, rendered in the view
  final visibleTags = <String>[].obs;

  // Tag pools (i18n keys)
  static const _tags5 = [
    'rating.tags.safeDriving','rating.tags.politeHelpful','rating.tags.cleanCar',
    'rating.tags.onTimePickup','rating.tags.efficientRoute','rating.tags.comfortableRide',
  ];
  static const _tags4 = [
    'rating.tags.minorDelay','rating.tags.slightDetour','rating.tags.acCouldImprove','rating.tags.priceBitHigh',
  ];
  static const _tags3 = [
    'rating.tags.latePickup','rating.tags.longRoute','rating.tags.unclearCommunication','rating.tags.uncomfortableRide','rating.tags.priceHigh',
  ];
  static const _tags12 = [
    'rating.tags.unsafeDriving','rating.tags.rudeBehavior','rating.tags.dirtyCar',
    'rating.tags.wrongRoute','rating.tags.overcharged','rating.tags.acNotWorking','rating.tags.refusedOrCancelled',
  ];
  static const _others = 'rating.tags.others';

  bool get showOthersField => selected.contains(_others);

  String get subtitleKey {
    switch (stars.value) {
      case 0: return 'rating.sub.rate';
      case 1: return 'rating.sub.1';
      case 2: return 'rating.sub.2';
      case 3: return 'rating.sub.3';
      case 4: return 'rating.sub.4';
      case 5: return 'rating.sub.5';
      default: return 'rating.sub.rate';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _rebuildVisibleTags(); // start with no tags (and no "Others")
  }

  void setStars(int v) {
    stars.value = v.clamp(0, 5);
    _rebuildVisibleTags();
  }

  void toggleTag(String key) =>
      selected.contains(key) ? selected.remove(key) : selected.add(key);

  void _rebuildVisibleTags() {
    List<String> base;
    switch (stars.value) {
      case 5: base = _tags5; break;
      case 4: base = _tags4; break;
      case 3: base = _tags3; break;
      case 2:
      case 1: base = _tags12; break;
      default: base = const []; // 0 stars -> show nothing
    }

    // Only include "Others" AFTER at least one star is chosen
    final next = stars.value == 0 ? base : [...base, _others];

    // drop selections that no longer exist
    selected.removeWhere((k) => !next.contains(k));

    visibleTags.assignAll(next);
  }

  Future<void> submit() async {
    if (stars.value == 0) {
      Get.snackbar('Oops', 'Please select a rating first');
      return;
    }
    submitting.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 650));
      Get.back(result: true);
      Get.snackbar('👍', 'Thanks for your feedback!');
    } finally {
      submitting.value = false;
    }
  }
}
