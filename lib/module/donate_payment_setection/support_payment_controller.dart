// lib/donate_payment_selection/support_payment_controller.dart
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class SupportPaymentController extends GetxController {
  // ← values coming from previous screen
  late final String causeKey; // e.g. 'cause_general_fund'
  late final int amount;      // e.g. 10000

  final selectedMethod = RxnString();

  final methods = const [
    {'id': 'bkash', 'title': 'bkash', 'subtitle': 'pay_bkash', 'icon': 'assets/icon/bkash.png'},
    {'id': 'nagad', 'title': 'nagad', 'subtitle': 'discount_10', 'icon': 'assets/icon/nagad.png'},
    {'id': 'city',  'title': 'city_bank', 'subtitle': 'discount_10', 'icon': 'assets/icon/city_bank.png'},
    {'id': 'card',  'title': 'visa_master', 'subtitle': '', 'icon': 'assets/icon/visa.png'},
    {'id': 'pay_station', 'title': 'pay_station', 'subtitle': '', 'icon': 'assets/icon/pay_station.png'},
  ];

  @override
  void onInit() {
    final args = (Get.arguments as Map?) ?? const {};
    causeKey = (args['causeKey'] as String?) ?? '';     // keep the translation key
    amount   = (args['amount'] as int?) ?? 0;
    super.onInit();
  }

  void selectMethod(String id) => selectedMethod.value = id;

  void onPayNow() {
    if (selectedMethod.value == null) {
      Get.snackbar('validation_title'.tr, 'validation_payment_msg'.tr);
      return;
    }

    if (selectedMethod.value == 'bkash') {
      Get.toNamed(
        Routes.bkashPayment,
        arguments: {
          'merchant': 'ambufast',
          'invoice': '56145656545889', // TODO: generate
          'amount': amount,
        },
      );
      return;
    }

    Get.snackbar('validation_title'.tr, 'This method is not implemented yet.');
  }
}
