import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class WaitingApprovalController extends GetxController {
  void onExplore() {
    // Go to your app’s main entry (adjust as needed)
    // If you already have a home route, replace with it.
    Get.offAllNamed(Routes.home ?? '/'); // or Routes.home if you have one
  }
}
