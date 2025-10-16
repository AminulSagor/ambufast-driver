import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/user_info.dart';
import '../../routes/app_routes.dart';
import 'models/trip_request.dart';
import 'widgets/accept_trip_confirm_sheet.dart';

class TripRequestController extends GetxController {
  final request = const TripRequest(
    when: null,
    contactFor: 'For me',
    ambulanceType: 'Ac Ambulance',
    tripType: 'Single trip',
    category: 'General',
    from: 'Jhigatola Road, Dhaka, Bangladesh',
    to: 'Square Hospital, Panthapath, Dhaka 1205, Bangladesh',
    distanceKm: 35.56,
    etaMins: 60,
    fare: 500,
  ).obs;

  final userInfo = const UserInfo(
    avatarUrl: 'assets/trip/user_image.jpg',
    name: 'Md Kamrul Hasan',
    rating: 5.0,
    ratingCount: 1.2,
    phone: '01812345678',
  ).obs;

  final totalSeconds = 15;
  final left = 60.obs;
  Timer? _t;

  /// Draggable extent and state
  final sheetExtent = 0.74.obs; // live extent (0.0 - 1.0)
  final collapsedSize = 0.45; // collapsed height (screen fraction)
  final expandedSize = 0.74; // expanded height  (screen fraction)

  bool get isExpanded => sheetExtent.value > (collapsedSize + 0.1);

  String _two(int x) => x.toString().padLeft(2, '0');
  String get timerText => '${_two(left.value ~/ 60)}:${_two(left.value % 60)}';

  String money(num v) {
    final loc = Get.locale?.toLanguageTag() ?? 'en_US';
    return NumberFormat.currency(locale: loc, symbol: 'BDT ', decimalDigits: 0)
        .format(v);
  }

  @override
  void onInit() {
    super.onInit();
    left.value = totalSeconds;
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (left.value <= 0) {
        t.cancel();
        update(['cta']);
      } else {
        left.value--;
      }
    });
  }

  @override
  void onClose() {
    _t?.cancel();
    super.onClose();
  }

  void onAccept() {
    if (left.value <= 0) return;
    Get.snackbar('Trip', 'Request accepted (mock)');
  }

  String whenText() {
    if (request.value.when == null) return 'pickup_now'.tr;
    final loc = Get.locale?.toLanguageTag() ?? 'en_US';
    return DateFormat('EEE, MMM d • hh:mm a', loc).format(request.value.when!);
  }

  Future<void> openAcceptConfirm() async {
    await Get.bottomSheet(
      AcceptTripConfirmSheet(onConfirm: _confirmAccept),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _confirmAccept() {
    final r = request.value;
    final user = userInfo.value;
    Get.offNamed(Routes.tripAwaitPayment, arguments: {
      'tripDetails': r,
      'userInfo': user,
    });
  }
}
