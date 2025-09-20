// lib/module/car/car_details_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../routes/app_routes.dart';
import '../../utils/snackbar_helper.dart';

class CarDetailsController extends GetxController {
  // --- form ---
  final formKey = GlobalKey<FormState>();

  // --- text controllers ---
  final vehicleNumberCtrl = TextEditingController();
  final brandModelCtrl = TextEditingController();
  final yearCtrl = TextEditingController();

  // --- selects ---
  final vehicleTypeCtrl = TextEditingController();
  final insProviderCtrl = TextEditingController();
  final emissionStatusCtrl = TextEditingController();

  // --- dates (typed or picked) ---
  final insExpiryCtrl = TextEditingController();
  final fitnessExpiryCtrl = TextEditingController();
  final roadPermitExpiryCtrl = TextEditingController();

  // --- uploads (ALL multi now) ---
  final vehiclePhotos      = <String>[].obs; // max 5
  final regStickerPhotos   = <String>[].obs; // max 5  ⬅️ updated
  final insurancePhotos    = <String>[].obs; // max 5  ⬅️ updated

  final isSubmitting = false.obs;

  // --- lists from i18n ---
  List<String> get vehicleTypes =>
      'car_vehicle_types'.tr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  List<String> get emissionStatuses =>
      'car_emission_status_list'.tr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  List<String> get insuranceProviders =>
      'car_ins_providers'.tr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  // Additional services
  List<String> get extraServices =>
      'car_additional_services_list'.tr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  final selectedServices = <String>{}.obs;
  void toggleService(String s, bool v){ v ? selectedServices.add(s) : selectedServices.remove(s); }
  bool isServiceSelected(String s) => selectedServices.contains(s);
  List<String> getSelectedServices() => selectedServices.toList();

  // ---------- COMMON multi picker ----------
  Future<void> _pickManyInto(RxList<String> target, {int max = 5}) async {
    final remaining = max - target.length;
    if (remaining <= 0) {
      showErrorSnackbar('You can upload maximum $max photos.');
      return;
    }
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg','jpeg','png'],
      allowMultiple: true,
    );
    if (res == null) return;

    final picked = res.files
        .map((f) => f.path)
        .whereType<String>()
        .where((p) => p.isNotEmpty)
        .take(remaining)
        .toList();

    if (picked.isEmpty) return;
    target.addAll(picked);
  }

  // Vehicle photos
  Future<void> pickVehiclePhotos() async => _pickManyInto(vehiclePhotos);
  void removeVehiclePhotoAt(int index) {
    if (index >= 0 && index < vehiclePhotos.length) vehiclePhotos.removeAt(index);
  }

  // ⬇️ Registration stickers (multi)
  Future<void> pickRegStickers() async => _pickManyInto(regStickerPhotos);
  void removeRegStickerAt(int index) {
    if (index >= 0 && index < regStickerPhotos.length) regStickerPhotos.removeAt(index);
  }

  // ⬇️ Insurance photos (multi)
  Future<void> pickInsurancePhotos() async => _pickManyInto(insurancePhotos);
  void removeInsurancePhotoAt(int index) {
    if (index >= 0 && index < insurancePhotos.length) insurancePhotos.removeAt(index);
  }

  // ---------- dates ----------
  String? validateYmd(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'car_v_date'.tr;
    try { DateFormat('yyyy-MM-dd').parseStrict(s); return null; }
    catch (_) { return 'car_v_date'.tr; }
  }

  Future<void> chooseDate(TextEditingController ctrl, BuildContext ctx) async {
    final now = DateTime.now();
    DateTime initial;
    try { initial = DateFormat('yyyy-MM-dd').parseStrict(ctrl.text); }
    catch (_) { initial = now; }
    final d = await showDatePicker(
      context: ctx, initialDate: initial, firstDate: DateTime(1990), lastDate: DateTime(now.year + 20),
    );
    if (d != null) ctrl.text = DateFormat('yyyy-MM-dd').format(d);
  }

  // ---------- dropdown helper ----------
  Future<void> pickFromList(BuildContext ctx, List<String> items, TextEditingController ctrl) async {
    final chosen = await showModalBottomSheet<String>(
      context: ctx,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: items.map((e) => ListTile(title: Text(e), onTap: () => Navigator.pop(ctx, e))).toList(),
        ),
      ),
    );
    if (chosen != null) ctrl.text = chosen;
  }

  // ---------- validation & submit ----------
  bool _validateUploads() {
    if (vehiclePhotos.isEmpty) { showErrorSnackbar('car_v_photo'.tr); return false; }
    if (regStickerPhotos.isEmpty) { showErrorSnackbar('car_v_reg'.tr); return false; }
    if (insurancePhotos.isEmpty) { showErrorSnackbar('car_v_ins_photo'.tr); return false; }
    return true;
  }

  String? validateYear(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'car_v_year'.tr;
    final y = int.tryParse(s);
    final now = DateTime.now().year;
    if (y == null || y < 1980 || y > now + 1) return 'car_v_year'.tr;
    return null;
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!_validateUploads()) return;

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isSubmitting.value = false;

    Get.toNamed(Routes.home);
  }

  @override
  void onClose() {
    vehicleNumberCtrl.dispose();
    brandModelCtrl.dispose();
    yearCtrl.dispose();
    vehicleTypeCtrl.dispose();
    insProviderCtrl.dispose();
    emissionStatusCtrl.dispose();
    insExpiryCtrl.dispose();
    fitnessExpiryCtrl.dispose();
    roadPermitExpiryCtrl.dispose();
    super.onClose();
  }
}
