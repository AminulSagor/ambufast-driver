import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../routes/app_routes.dart';
import '../../utils/snackbar_helper.dart';

class LicenceDetailsController extends GetxController {
  final formKey = GlobalKey<FormState>();

  static const int _maxLicenseBytes = 25 * 1024 * 1024; // 25 MB
  // ⬇️ Picked up from previous page (profile step)
  //    We merge these with current page data and pass to CarDetails.
  late final Map<String, dynamic> basePayload =
      (Get.arguments?['payload'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v)) ??
          {};
  late final String profilePhotoPath =
      (Get.arguments?['photoPath'] as String?) ?? '';

  // Text fields on this page
  final licNoCtrl = TextEditingController();
  final expCtrl = TextEditingController();
  final catCtrl = TextEditingController();

  // Local file paths for licence images
  final frontPath = RxnString();
  final backPath = RxnString();

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
    if (v.isEmpty) return 'v_lic_exp'.tr; // required

    try {
      final d = DateFormat('yyyy-MM-dd').parseStrict(v);

      // compare date-only (ignore time)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (d.isBefore(today)) {
        return 'v_lic_exp_past'.tr; // ← new key below
      }

      // (optional) keep a sanity lower bound, though the past check already covers it
      // if (d.isBefore(DateTime(1980))) return 'v_lic_exp'.tr;

      return null;
    } catch (_) {
      return 'v_lic_exp'.tr; // invalid format
    }
  }

  void pickCategory(BuildContext context) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final c = categories[i];
            return ListTile(
              title: Text(c),
              onTap: () => Navigator.pop(ctx, c),
            );
          },
        ),
      ),
    );
    if (chosen != null) {
      catCtrl.text = chosen;
    }
  }


  Future<void> pickExpiryDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final initial = _tryParse(expCtrl.text) ?? today;
    final d = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,                     // 👈 no past dates
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

  // ---- minimal helper to convert yyyy-MM-dd -> ISO Z (what API shows)
  String _ymdToIso(String ymd) {
    final d = DateFormat('yyyy-MM-dd').parseUtc(ymd);
    final z = DateTime.utc(d.year, d.month, d.day);
    return z.toIso8601String(); // e.g. 2027-10-10T00:00:00.000Z
  }

  Future<void> pickFront() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      showErrorSnackbar('err_file_pick'.tr);
      return;
    }

    final file = result.files.single;
    if (file.size > _maxLicenseBytes) {
      showErrorSnackbar('err_over_25mb'.tr);
      return;
    }

    if (file.path != null) {
      frontPath.value = file.path!;
    } else {
      showErrorSnackbar('err_file_pick'.tr);
    }
  }

  Future<void> pickBack() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      showErrorSnackbar('err_file_pick'.tr);
      return;
    }

    final file = result.files.single;
    if (file.size > _maxLicenseBytes) {
      showErrorSnackbar('err_over_25mb'.tr);
      return;
    }

    if (file.path != null) {
      backPath.value = file.path!;
    } else {
      showErrorSnackbar('err_file_pick'.tr);
    }
  }

  bool validateUploads() {
    if (frontPath.value == null) {
      showErrorSnackbar('v_front'.tr);
      return false;
    }
    if (backPath.value == null) {
      showErrorSnackbar('v_back'.tr);
      return false;
    }
    return true;
  }

  Future<void> onNext() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // Run form validators in your View (e.g., TextFormFields with validators)
    if (!(formKey.currentState?.validate() ?? false)) return;

    // Ensure both licence images are picked
    if (!validateUploads()) return;

    // (Optional) light UX feedback
    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 200));
    isSubmitting.value = false;

    // 🔗 Build only THIS page's payload
    // ✨ API expects: licenseNumber, licenseExpiry (ISO), licenseCategory
    final licencePayload = <String, dynamic>{
      'licenseNumber': licNoCtrl.text.trim(),
      'licenseExpiry': _ymdToIso(expCtrl.text.trim()), // convert to ISO
      'licenseCategory': catCtrl.text.trim(),
    };

    // 🧩 Merge with previous step's payload (profile) — nothing overwritten unless same keys
    final combinedPayload = <String, dynamic>{
      ...basePayload,
      ...licencePayload,
    };

    // 🚚 Navigate to CarDetails with EVERYTHING needed
    Get.toNamed(
      Routes.carDetails,
      arguments: {
        'payload': combinedPayload,          // all text fields so far
        'photoPath': profilePhotoPath,       // profile photo from step 1
        'licenceFrontPath': frontPath.value, // licence front image
        'licenceBackPath': backPath.value,   // licence back image
      },
    );
  }

  @override
  void onClose() {
    licNoCtrl.dispose();
    expCtrl.dispose();
    catCtrl.dispose();
    super.onClose();
  }
}
