import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../routes/app_routes.dart';

class TripPaymentController extends GetxController {
  final _service = TripPaymentService();

  final isLoading = true.obs;
  final data = Rxn<PaymentBreakdown>();
  final banners = const ['assets/promo_1.jpg', 'assets/promo_2.jpg'];
  final pageIndex = 0.obs;

  String money(num v) {
    final locale = Get.locale?.toLanguageTag() ?? 'en_US';
    return NumberFormat.currency(
      locale: locale,
      symbol: 'BDT ',
      decimalDigits: 2,
    ).format(v);
  }

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      data.value = await _service.fetch();
    } finally {
      isLoading.value = false;
    }
  }

  void onCollect() {
    Get.offNamed(Routes.rating);
  }
}

/// NEED CHANGING LATER - mostly similar with price brekdown
class PaymentBreakdown {
  final double clientWillPay; // big green number
  final double baseFare;
  final double perKmRate;
  final double waitingCharges;
  final double bookingFee;
  final double vatTax;
  final double confirmPayment; // e.g., amount to confirm/advance
  final double due; // final due shown in red

  const PaymentBreakdown({
    required this.clientWillPay,
    required this.baseFare,
    required this.perKmRate,
    required this.waitingCharges,
    required this.bookingFee,
    required this.vatTax,
    required this.confirmPayment,
    required this.due,
  });
}

class TripPaymentService {
  Future<PaymentBreakdown> fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    // Values chosen to match your mock
    return const PaymentBreakdown(
      clientWillPay: 580.00,
      baseFare: 400.00,
      perKmRate: 50.00,
      waitingCharges: 0.00,
      bookingFee: 10.00,
      vatTax: 0.00,
      confirmPayment: 100.00,
      due: 580.00,
    );
  }
}
///-----------------X----------------