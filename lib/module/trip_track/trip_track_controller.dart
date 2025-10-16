import 'dart:async';
import 'package:ambufast_driver/module/trip_track/widgets/trip_confirmation_sheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/user_info.dart';
import '../../routes/app_routes.dart';
import '../trip_request/models/trip_request.dart';
import '../trip_request/widgets/cancel_confirmation_modal.dart';
import 'model/trip_track_state.dart';
import 'widgets/emergency_assist_sheet.dart';

enum ActiveAddress { pickup, drop }

enum TripStage { start, approaching, arrived, inProgress, completed }

class TripTrackController extends GetxController {
  late final TripRequest request;
  late final UserInfo user;

  final _service = TripService();

  final isLoading = true.obs;
  final state = Rxn<TripTrackState>();

  final active = ActiveAddress.pickup.obs;

  // stage + destination ETA
  final stage = TripStage.start.obs;
  final destinationEta = Rxn<DateTime>(); // shows "by 03:24 PM"

  // ETA countdown to pickup
  final remainingSecs = 0.obs;
  Timer? _etaTimer;

  final due = 580.85.obs; // mock due
  final countdownMin = 5.obs; // “5 Min”

  // Timer? _t;

  String formatCurrency(num v, {String symbol = 'BDT '}) {
    final locale = Get.locale?.toLanguageTag() ?? 'en_US';
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    ).format(v);
  }

  @override
  void onInit() {
    super.onInit();
    request = Get.arguments['tripDetails'] as TripRequest;
    user = Get.arguments['userInfo'] as UserInfo;

    // Optional: tick down every minute (mock)
    // _t = Timer.periodic(const Duration(minutes: 1), (t) {
    //   if (countdownMin.value > 0) countdownMin.value--;
    // });

    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    final s = await _service.fetchTrackState(
      request: request,
      user: user,
    );
    state.value = s;
    isLoading.value = false;

    stage.value = TripStage.start;
    _updateHeader(); // rebuild header only

    // // countdown to pickup
    remainingSecs.value = s.etaMinutes * 60;
    _etaTimer?.cancel();
    // _etaTimer = Timer.periodic(const Duration(seconds: 1), (t) {
    //   if (remainingSecs.value <= 0) {
    //     t.cancel();
    //     // Switch to ARRIVED, then auto move to IN_PROGRESS after a short pause (mock)
    //     stage.value = TripStage.arrived;
    //     _updateHeader();
    //     Future.delayed(const Duration(seconds: 3), () {
    //       if (state.value == null) return;
    //       destinationEta.value = DateTime.now().add(
    //         Duration(minutes: state.value!.destinationEtaMinutes),
    //       );
    //       active.value = ActiveAddress.drop;
    //       stage.value = TripStage.inProgress;
    //       _updateHeader();
    //       Future.delayed(const Duration(seconds: 6), () {
    //         if (state.value == null) return;
    //         stage.value = TripStage.completed;
    //         _updateHeader(); // trigger header AnimatedSwitcher
    //         Future.delayed(const Duration(seconds: 5), () {
    //           // if (Get.currentRoute == Routes.tripTrack &&
    //           //     stage.value == TripStage.completed) {
    //           //   Get.toNamed(Routes.tripPayment);
    //           // }
    //         });
    //       });
    //     });
    //   } else {
    //     remainingSecs.value -= 60;
    //   }
    // });
  }

  // Badge text for "approaching" header
  String get remainingBadgeText {
    final m = (remainingSecs.value / 60).ceil();
    return '$m ${'min'.tr}';
  }

  // ---- actions ----
  void onCancelTrip() {
    Get.bottomSheet(const CancelConfirmationModal());
  }

  void onCallUser() =>
      Get.snackbar('Call', 'Wold call driver: ${state.value?.user.phone}');

  // ---- header-only rebuild id ----
  void _updateHeader() => update(['header']);

  @override
  void onClose() {
    // _t?.cancel();
    _etaTimer?.cancel();
    super.onClose();
  }

  String money(num v) {
    final loc = Get.locale?.toLanguageTag() ?? 'en_US';
    return NumberFormat.currency(locale: loc, symbol: 'BDT ', decimalDigits: 2)
        .format(v);
  }

  // void toggle(AddressSelect a) => selected.value = a;

  void onCall() => Get.snackbar('Call', 'Calling passenger (mock)');

  void onSeeDetails() => Get.snackbar('Trip', 'See trip details (mock)');

  void onTripStart() {
    Get.bottomSheet(
      TripConfirmationSheet(
        isStart: true,
        onYes: () {
          final isArrived = stage.value == TripStage.arrived;
          if (isArrived) {
            Get.back();
            _etaTimer?.cancel();
            stage.value = TripStage.inProgress;
            destinationEta.value = DateTime.now().add(
              Duration(minutes: state.value!.destinationEtaMinutes),
            );
            _updateHeader();
          } else {
            Get.back();
            _etaTimer?.cancel();
            stage.value = TripStage.approaching;
            _updateHeader();
            _etaTimer = Timer.periodic(const Duration(seconds: 1), (t) {
              if (remainingSecs.value <= 0) {
                t.cancel();
              } else {
                remainingSecs.value -= 60;
              }
            });
          }
        },
        onNo: () {},
      ),
    );
  }

  void onTripEnd() {
    Get.bottomSheet(
      TripConfirmationSheet(
        isStart: false,
        onYes: () {
          Get.back();
          _etaTimer?.cancel();
          stage.value = TripStage.completed;
          _updateHeader();
        },
        onNo: () {},
      ),
    );
  }

  void onCollectCash() {
    Get.offNamedUntil(
      Routes.tripPayment,
      (route) => route.settings.name == Routes.home,
    );
  }

  void onWaiting() {
    _etaTimer?.cancel();
    remainingSecs.value = 0;
    stage.value = TripStage.arrived;
    _updateHeader();
    active.value = ActiveAddress.drop;
  }

  void openEmergencySheet() {
    final s = state.value!;
    Get.bottomSheet(
      isDismissible: true,
      EmergencyAssistSheet(
        currentLocation: s.pickupAddress, // mock current location
        vehicleDetails: 'Toyota l Dhaka Metro 12 5896',
      ),
      isScrollControlled: true,
    );
  }

  // Called by the sheet
  Future<void> shareMyTrip(String text) async {
    try {
      await Share.share(text);
    } catch (_) {
      Get.snackbar('Share', 'Unable to share (mock)');
    }
  }

  Future<void> call999() async {
    final uri = Uri.parse('tel:999');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar('Call', 'Cannot place call on this device (mock)');
      }
    } catch (_) {
      Get.snackbar('Call', 'Call failed (mock)');
    }
  }
}

/// mock service

class TripService {
  Future<TripTrackState> fetchTrackState({
    required TripRequest request,
    required UserInfo user,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return TripTrackState(
      pickupAddress: request.from,
      dropAddress: request.to,
      dueAmount: request.fare,
      etaMinutes: 5,
      destinationEtaMinutes: 24,
      user: user,
    );
  }
}
