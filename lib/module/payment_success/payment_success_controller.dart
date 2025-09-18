// lib/payment/payment_success_controller.dart
import 'package:get/get.dart';

class PaymentSuccessController extends GetxController {
  late final int amount; // passed from previous page

  @override
  void onInit() {
    final args = (Get.arguments as Map?) ?? const {};
    amount = (args['amount'] as int?) ?? 0;
    super.onInit();
  }

  void goToActivity() {
    // TODO: navigate to your activity/history screen
    // e.g. Get.offAllNamed(Routes.activity);
    Get.back(); // placeholder
  }

  void backHome() {
    // TODO: navigate to home
    // e.g. Get.offAllNamed(Routes.home);
    Get.offAllNamed('/home'); // or Routes.home if defined
  }
}
