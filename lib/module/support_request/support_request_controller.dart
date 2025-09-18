import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../support_request_review/support_request_review_controller.dart';

class SupportRequestController extends GetxController {
  // form fields
  final causes = const [
    'cause_general_fund',
    'cause_ambulance_trip_help',
    'cause_emergency_medical_help',
    'cause_dead_body_transfer',
  ];

  final urgencies = const ['Low', 'Medium', 'High'];

  final selectedCause = RxnString();
  final selectedUrgency = RxnString();
  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  // files
  final docFile = Rxn<File>();
  final nidFront = Rxn<File>();
  final nidBack = Rxn<File>();

  // state
  final agree = false.obs;
  final submitting = false.obs;

  static const int tenMB = 10 * 1024 * 1024;
  static const int twentyFiveMB = 25 * 1024 * 1024;

  @override
  void onClose() {
    amountCtrl.dispose();
    descCtrl.dispose();
    super.onClose();
  }

  bool _isImage(String? path) {
    final p = (path ?? '').toLowerCase();
    return p.endsWith('.jpg') || p.endsWith('.jpeg') || p.endsWith('.png');
  }

  Future<File?> _pickImage({int maxBytes = twentyFiveMB}) async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (res == null || res.files.isEmpty) return null;

    final f = File(res.files.single.path!);
    if (!_isImage(f.path)) {
      Get.snackbar('Error', 'file_type_invalid'.tr);
      return null;
    }
    final size = await f.length();
    if (size > maxBytes) {
      Get.snackbar('Error', 'file_too_large'.tr);
      return null;
    }
    return f;
  }

  Future<void> pickDoc() async {
    final f = await _pickImage(maxBytes: tenMB);
    if (f != null) docFile.value = f;
  }

  Future<void> pickNidFront() async {
    final f = await _pickImage(maxBytes: twentyFiveMB);
    if (f != null) nidFront.value = f;
  }

  Future<void> pickNidBack() async {
    final f = await _pickImage(maxBytes: twentyFiveMB);
    if (f != null) nidBack.value = f;
  }

  bool validate() {
    final amt = int.tryParse(amountCtrl.text.trim());
    if (selectedCause.value == null) {
      _toast('vs_select_cause'); return false;
    }
    if (amt == null || amt <= 0) {
      _toast('vs_amount'); return false;
    }
    if (selectedUrgency.value == null) {
      _toast('vs_urgency'); return false;
    }
    if (descCtrl.text.trim().isEmpty) {
      _toast('vs_desc'); return false;
    }
    if (nidFront.value == null) {
      _toast('vs_nid_front'); return false;
    }
    if (nidBack.value == null) {
      _toast('vs_nid_back'); return false;
    }
    if (!agree.value) {
      _toast('vs_terms'); return false;
    }
    return true;
  }

  void _toast(String key) => Get.snackbar('validation_title'.tr, key.tr);

  Future<void> submit() async {
    if (!validate()) return;

    final args = SupportRequestReviewArgs(
      causeKey: selectedCause.value!,                 // e.g. 'cause_general_fund'
      amount: int.parse(amountCtrl.text.trim()),
      urgencyLabel: selectedUrgency.value ?? 'rr_within_24h'.tr,
      description: descCtrl.text.trim(),
      docFileName: docFile.value?.path.split('/').last,
      nidFrontName: nidFront.value?.path.split('/').last,
      nidBackName: nidBack.value?.path.split('/').last,
    );

    Get.toNamed(Routes.supportRequestReview, arguments: args);
  }
}
