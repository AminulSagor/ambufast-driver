import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact {
  final String asset; // e.g. assets/sos/999.png
  final String number; // e.g. 999
  EmergencyContact({required this.asset, required this.number});
}

class EmergencySosController extends GetxController {
  final contacts = <EmergencyContact>[
    EmergencyContact(asset: 'assets/sos/999.png',   number: '999'),
    EmergencyContact(asset: 'assets/sos/16163.png', number: '16163'),
  ].obs;

  Future<void> call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('error'.tr, 'call_failed'.tr);
    }
  }
}
