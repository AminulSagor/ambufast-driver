// lib/module/trip_await_payment/trip_await_payment_controller.dart
import 'dart:async';
import 'package:ambufast_driver/model/user_info.dart';
import 'package:ambufast_driver/module/trip_request/widgets/cancel_confirmation_modal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';
import 'models/trip_request.dart';

class TripAwaitPaymentController extends GetxController {
  late final TripRequest request;
  late final UserInfo user;

  Timer? _autoNav; // <-- added

  @override
  void onInit() {
    super.onInit();
    request = Get.arguments['tripDetails'] as TripRequest;
    user = Get.arguments['userInfo'] as UserInfo;

    // MOCK: auto navigate to Trip Start after 5 seconds
    _autoNav = Timer(
      const Duration(seconds: 5),
      () {
        // Replace screen; pass the same request forward
        if (Get.isOverlaysOpen) {
          Get.back(closeOverlays: true); // just in case any sheets are open
        }
        Get.offNamed(Routes.tripStart, arguments: {
          'tripDetails': request,
          'userInfo': user,
        });
      },
    );
  }

  @override
  void onClose() {
    _autoNav?.cancel(); // clean up if user leaves early
    super.onClose();
  }

  String whenText() {
    if (request.when == null) return 'pickup_now'.tr;
    final loc = Get.locale?.toLanguageTag() ?? 'en_US';
    return DateFormat('EEE, MMM d • hh:mm a', loc).format(request.when!);
  }

  String money(num v) {
    final loc = Get.locale?.toLanguageTag() ?? 'en_US';
    return NumberFormat.currency(locale: loc, symbol: 'BDT ', decimalDigits: 0)
        .format(v);
  }

  void onClosePressed() {
    Get.bottomSheet(
      const CancelConfirmationModal(),
      isScrollControlled: true,
    );
  }

  void onCallPressed() => Get.snackbar('Info', 'Calling client (mock)');
  void onNavigatePressed() =>
      Get.snackbar('Info', 'Navigation disabled until payment (mock)');
}
