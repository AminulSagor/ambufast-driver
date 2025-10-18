import 'dart:async';

import 'package:ambufast_driver/routes/app_routes.dart';
import 'package:get/get.dart';
import 'models/driving_license_model.dart';

enum LicenseStatus { verified, underReview, rejected }

class DrivingLicenseController extends GetxController {
  final isLoading = true.obs;
  final license = Rxn<DrivingLicenseModel>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(seconds: 1));
    license.value = DrivingLicenseModel.mock();
    isLoading.value = false;
  }

  // Current status — start as verified as in your previous UI
  final status = LicenseStatus.verified.obs;

  Timer? _mockTimer;

  /// Call this after the update screen returns success.
  void startUnderReviewThenMockReject() {
    // Clear any previous timers to avoid stacking
    _mockTimer?.cancel();

    // 1) Immediately switch to UNDER REVIEW and hide error card
    status.value = LicenseStatus.underReview;

    // 2) Mock a backoffice decision after 5 seconds
    _mockTimer = Timer(const Duration(seconds: 5), () {
      status.value = LicenseStatus.rejected;
    });
  }

  void onUpdatePressed() {
    Get.toNamed(Routes.updateDrivingLicense);
  }
}
