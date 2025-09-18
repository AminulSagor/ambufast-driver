import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class RequestSubmissionSuccessController extends GetxController {
  void goToActivity() => Get.offAllNamed(Routes.home, arguments: {'tab': 'activity'});
  void backHome() => Get.offAllNamed(Routes.home);
}
