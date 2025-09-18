import 'package:get/get.dart';

import '../../routes/app_routes.dart';


class SupportRequestReviewArgs {
  final String causeKey;        // e.g. 'cause_general_fund' (translation key)
  final int amount;             // e.g. 10000
  final String urgencyLabel;    // plain text like 'Within 24 Hours'
  final String description;     // user typed
  final String? docFileName;    // optional
  final String? nidFrontName;   // optional
  final String? nidBackName;    // optional

  const SupportRequestReviewArgs({
    required this.causeKey,
    required this.amount,
    required this.urgencyLabel,
    required this.description,
    this.docFileName,
    this.nidFrontName,
    this.nidBackName,
  });
}

class SupportRequestReviewController extends GetxController {
  late final SupportRequestReviewArgs data;

  final submitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    data = Get.arguments as SupportRequestReviewArgs;
  }

  void tapChange() {
    // Go back to edit screen
    Get.back();
  }

  Future<void> submit() async {
    submitting.value = true;
    try {
      Get.offAllNamed(Routes.requestSubmissionSuccess);

    } finally {
      submitting.value = false;
    }
  }
}
