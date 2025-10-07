import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../../dialog_box/success_message_dialogbox.dart';
import '../../utils/snackbar_helper.dart';

class ContactSupportController extends GetxController {
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  void sendMessage() {
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      showWarningSnackbar('Please fill in all fields');
      return;
    }



    // Clear form first (good UX)
    subjectController.clear();
    messageController.clear();

    // Show success dialog (barrier not dismissible by tap outside)
    Get.dialog(
      const SuccessMessageDialog(

      ),
      barrierDismissible: false,
    );
  }
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not open $url',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> openTwitter() async {
    final app = Uri.parse('twitter://user?screen_name=AmbuFast');
    final web = Uri.parse('https://x.com/AmbuFast');
    if (await canLaunchUrl(app)) {
      await launchUrl(app);
    } else {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openTelegram() async {
    final app = Uri.parse('tg://resolve?domain=ambufast'); // deep-link to Telegram app
    final web = Uri.parse('https://t.me/ambufast');        // fallback
    if (await canLaunchUrl(app)) {
      await launchUrl(app);
    } else {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> callSupport() async {
    final uri = Uri.parse("tel:09678911911");
    if (!await launchUrl(uri)) {
      Get.snackbar('Error', 'Unable to make a call right now',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
