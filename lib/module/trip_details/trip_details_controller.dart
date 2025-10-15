// lib/modules/trip_details/trip_details_controller.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum TripState { upcoming, scheduled, completed, completedNoRating, cancelled }

class PaymentInfo {
  final String txnId;
  final int amount; // in BDT
  final String method; // e.g., bKash
  final DateTime? paidAt; // null if unpaid
  PaymentInfo({required this.txnId, required this.amount, required this.method, this.paidAt});
  bool get isPaid => paidAt != null;
}

class TripDetailsController extends GetxController {
  // ----- Mock toggle (switch scenario here) -----
  final state = TripState.upcoming.obs;

  // ----- Static demo data (would come from backend) -----
  final tripTime = DateTime.now().add(const Duration(hours: 6)).obs;
  final pickup = 'Gulshan 1, Dhaka, Bangladesh'.obs;
  final drop = 'Urgent care clinic (101 Elm ST)'.obs;
  final distanceKm = 35.56.obs;
  final etaMins = 60.obs;
  final vehicleLine = 'Toyota | Dhaka Metro 12 5896'.obs;
  bool get canCallDriver => state.value == TripState.upcoming;
  // Driver card
  final driverName = 'Md Kamrul Hasan'.obs;
  final driverAvatar =
      'https://images.freejpg.com.ar/900/2106/young-woman-with-hands-painted-blue-in-artistic-expression-F100038922.jpg'
          .obs;
  final driverAvgRating = 5.0.obs;
  final ratingsCount = 1200.obs; // int, for (1.2K ratings)
  String get ratingsCountLabel {
    final locale = Get.locale?.toLanguageTag() ?? 'en';
    final compact = NumberFormat.compact(locale: locale).format(ratingsCount.value);
    final word = ratingsCount.value == 1
        ? 'trip.rating.count.singular'.tr
        : 'trip.rating.count.plural'.tr;
    return '($compact $word)';
  }

  String get callIconAsset => canCallDriver
      ? 'assets/icon/active_call_icon.png'
      : 'assets/icon/not_active_call_icon.png';
  // Status/IDs
  final tripId = 'AMB23071234'.obs;
  final contact = 'trip.misc.forMe'.tr.obs;
  final ambulance = 'Ac ambulance'.obs;
  final tripType = 'trip.misc.single'.tr.obs;

  // Payments
  final advance = PaymentInfo(
    txnId: 'BK124568932',
    amount: 500,
    method: 'bKash',
    paidAt: DateTime(2025, 7, 10, 15, 50),
  ).obs;

  final finalPay = PaymentInfo(
    txnId: 'BK124568932',
    amount: 2000,
    method: 'bKash',
    paidAt: null, // set to DateTime for "Paid"
  ).obs;


  // Rating from this trip (null = no rating)
  final tripRating = Rx<double?>(null);

  // ----- Helpers to compute dynamic UI -----
  String get topActionLabel {
    switch (state.value) {
      case TripState.upcoming:
        return 'trip.actions.go'.tr;
      case TripState.scheduled:
        return 'trip.actions.start'.tr;
      case TripState.completed:
      case TripState.completedNoRating:
      case TripState.cancelled:
        return 'trip.actions.reportIssue'.tr;
    }
  }

  // For testing (e.g., from a debug button or onInit)
  @override
  void onInit() {
    super.onInit();
    // Pick one:
    //setScenario(TripState.upcoming);
    //setScenario(TripState.scheduled);
     setScenario(TripState.completed);
     //setScenario(TripState.completedNoRating);
    //setScenario(TripState.cancelled);
  }


  bool get topActionEnabled {

    return true;
  }

  bool get showCancelLink =>
      state.value == TripState.upcoming || state.value == TripState.scheduled;

  String get tripStatusBadge {
    switch (state.value) {
      case TripState.upcoming:
        return 'trip.badge.upcoming'.tr;
      case TripState.scheduled:
        return 'trip.badge.scheduled'.tr;
      case TripState.completed:
      case TripState.completedNoRating:
        return 'trip.badge.completed'.tr;
      case TripState.cancelled:
        return 'trip.badge.cancelled'.tr;
    }
  }

  bool get advancePaid => advance.value.isPaid;
  bool get finalPaid => finalPay.value.isPaid;

  String formatTime(DateTime dt) => DateFormat('d MMM, h:mm a').format(dt);
  String formatToday(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    return isToday ? 'Today, ${DateFormat('h:mm a').format(dt)}'
        : DateFormat('EEE, d MMM h:mm a').format(dt);
  }

  // Demo: flip scenarios from UI (you can remove in production)
  void setScenario(TripState s) {
    state.value = s;
    if (s == TripState.completed) {
      tripRating.value = 5.0;
      finalPay.value = PaymentInfo(
        txnId: 'BK124568932',
        amount: 2000,
        method: 'bKash',
        paidAt: DateTime(2025, 7, 10, 15, 50),
      );
    } else if (s == TripState.completedNoRating) {
      tripRating.value = null;
      finalPay.value = PaymentInfo(
        txnId: 'BK124568932',
        amount: 2000,
        method: 'bKash',
        paidAt: DateTime(2025, 7, 10, 15, 50),
      );
    } else if (s == TripState.cancelled) {
      tripRating.value = null;
      finalPay.value = PaymentInfo(
        txnId: 'No',
        amount: 2000,
        method: 'No',
        paidAt: null,
      );
    } else {
      tripRating.value = null;
      finalPay.value = PaymentInfo(
        txnId: 'No',
        amount: 2000,
        method: 'No',
        paidAt: null,
      );
    }
  }

  // Actions (wire to services later)
  void onPrimaryAction() => Get.snackbar('OK', topActionLabel);
  void onCancelTrip() => Get.snackbar('Cancel', 'Trip cancel requested');
  void callDriver() => Get.snackbar('Call', 'Dialing driver...');
  void copy(String what) => Get.snackbar('Copied', what);

  // For testing (e.g., from a debug button or onInit)

}
