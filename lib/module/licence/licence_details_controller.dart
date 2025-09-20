import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';
import 'package:file_picker/file_picker.dart';

import '../../utils/snackbar_helper.dart';


class LicenceDetailsController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final licNoCtrl = TextEditingController();
  final expCtrl = TextEditingController();
  final catCtrl = TextEditingController();

  final frontPath = RxnString(); // store picked file path / url
  final backPath  = RxnString();


  final isSubmitting = false.obs;

  // simple category list from i18n (comma separated -> list)
  List<String> get categories =>
      (Get.locale?.languageCode == 'bn'
          ? 'lic_cat_list'.tr
          : 'lic_cat_list'.tr)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

  String? validateDate(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'v_lic_exp'.tr;
    try {
      final d = DateFormat('yyyy-MM-dd').parseStrict(v);
      // optional: future date check
      if (d.isBefore(DateTime(1980))) return 'v_lic_exp'.tr;
      return null;
    } catch (_) {
      return 'v_lic_exp'.tr;
    }
  }

  void pickCategory(BuildContext context) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          for (final c in categories)
            ListTile(
              title: Text(c),
              onTap: () => Navigator.pop(context, c),
            ),
        ],
      ),
    );
    if (chosen != null) {
      catCtrl.text = chosen;
    }
  }

  Future<void> pickExpiryDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = _tryParse(expCtrl.text) ?? now;
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1980),
      lastDate: DateTime(now.year + 20),
    );
    if (d != null) {
      expCtrl.text = DateFormat('yyyy-MM-dd').format(d);
    }
  }

  DateTime? _tryParse(String s) {
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(s);
    } catch (_) {
      return null;
    }
  }

  // Mock pickers (replace with your file picker / camera)
  Future<void> pickFront() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'], // allow only images
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      frontPath.value = result.files.single.path!;
    }
  }

  Future<void> pickBack() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'], // allow only images
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      backPath.value = result.files.single.path!;
    }
  }



  bool validateUploads() {
    if (frontPath.value == null) {
      showErrorSnackbar('v_front'.tr); // 👈 reuse helper
      return false;
    }
    if (backPath.value == null) {
      showErrorSnackbar('v_back'.tr); // 👈 reuse helper
      return false;
    }
    return true;
  }


  Future<void> onNext() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!validateUploads()) return;

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 400)); // simulate
    isSubmitting.value = false;

    Get.toNamed(Routes.home); // change to your next page
  }

  @override
  void onClose() {
    licNoCtrl.dispose();
    expCtrl.dispose();
    catCtrl.dispose();
    super.onClose();
  }
}
