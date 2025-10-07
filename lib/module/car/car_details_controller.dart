// lib/module/car/car_details_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:ambufast_driver/module/car/service_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../combine_service/multi_file_upload_service.dart';
import '../../combine_service/public_services_service.dart';
import '../../combine_service/single_file_upload_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/snackbar_helper.dart';
import '../../vehicles/add_vehicle_service.dart';
import 'create_driver_service.dart';

class CarDetailsController extends GetxController {
  // -------- receive everything from previous steps --------
  late final Map<String, dynamic> basePayload =
      (Get.arguments?['payload'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v)) ??
          {};

  late final String profilePhotoPath =
      (Get.arguments?['photoPath'] as String?) ?? '';

  late final String licenceFrontPath =
      (Get.arguments?['licenceFrontPath'] as String?) ?? '';

  late final String licenceBackPath =
      (Get.arguments?['licenceBackPath'] as String?) ?? '';

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

  // --- uploads (limit: vehicle up to 5, sticker 1, insurance 1) ---
  final vehiclePhotos = <String>[].obs; // max 5
  final regStickerPhotos = <String>[].obs; // max 1 (UI allows replace)
  final insurancePhotos = <String>[].obs; // max 1 (UI allows replace)

  final isSubmitting = false.obs;
  Timer? _debounce;

  // services
  final _svc = PublicServicesService();       // GET public/services
  final _createSvc = CreateDriverService();   // POST create-driver
  final _addVehicleSvc = AddVehicleService();

  late final email    = (basePayload['email'] ?? '').toString().trim();
  late final phone    = (basePayload['phone'] ?? '').toString().trim();
  late final ext      = (basePayload['ext'] ?? '880').toString().trim();
  late final password = (basePayload['password'] ?? '').toString();
  late final authChannel = email.isNotEmpty ? 'email' : 'phone';


  // fetched list
  final services = <VehicleServiceItem>[].obs;

  // options derived from fetched list
  List<String> get vehicleTypes => services.map((e) => e.name).toList();

  // available additional services for the selected vehicle type
  final availableAddServices = <AdditionalService>[].obs;

  // chips read from this (VIEW expects this getter)
  List<String> get extraServices =>
      availableAddServices.map((e) => e.serviceName).toList();

  // call this after user picks a vehicle type (by name)
  void onVehicleTypeSelected(String name) {
    final item = services.firstWhereOrNull((e) => e.name == name);
    availableAddServices
      ..clear()
      ..addAll(item?.additionalServices ?? const []);
    selectedServices.clear(); // reset selection when type changes
  }

  // load on page open
  final isLoadingTypes = false.obs;

  Future<void> loadVehicleTypesAndServices() async {
    try {
      isLoadingTypes.value = true;
      final list = await _svc.fetchServices(
        category: 'EMERGENCY',
        status: 'ACTIVE',
      );
      services.assignAll(list);
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoadingTypes.value = false;
    }
  }

  void onFormChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      formKey.currentState?.validate();
    });
  }


  // VIEW expects these getters
  List<String> get emissionStatuses => 'car_emission_status_list'
      .tr
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  List<String> get insuranceProviders => 'car_ins_providers'
      .tr
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  final selectedServices = <String>{}.obs;
  void toggleService(String s, bool v) =>
      v ? selectedServices.add(s) : selectedServices.remove(s);
  bool isServiceSelected(String s) => selectedServices.contains(s);
  List<String> getSelectedServices() => selectedServices.toList();

  // ---------- COMMON multi picker ----------
  Future<void> _pickManyInto(RxList<String> target, {int max = 5}) async {
    final allowMultiple = max > 1;

    if (max > 1) {
      final remaining = max - target.length;
      if (remaining <= 0) {
        showErrorSnackbar('You can upload maximum $max photos.');
        return;
      }
    }

    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: allowMultiple,
    );
    if (res == null) return;

    final picked = res.files
        .map((f) => f.path)
        .whereType<String>()
        .where((p) => p.isNotEmpty)
        .toList();

    if (picked.isEmpty) return;

    if (max == 1) {
      target
        ..clear()
        ..add(picked.last);
    } else {
      final remaining = max - target.length;
      if (remaining <= 0) return;
      target.addAll(picked.take(remaining));
    }
  }

  // Vehicle photos (up to 5)
  Future<void> pickVehiclePhotos() async => _pickManyInto(vehiclePhotos, max: 5);

  // Registration sticker: only ONE
  Future<void> pickRegStickers() async => _pickManyInto(regStickerPhotos, max: 1);

  // Insurance photo: only ONE
  Future<void> pickInsurancePhotos() async => _pickManyInto(insurancePhotos, max: 1);

  // remove handlers (VIEW uses these)
  void removeVehiclePhotoAt(int index) {
    if (index >= 0 && index < vehiclePhotos.length) {
      vehiclePhotos.removeAt(index);
    }
  }
  void removeRegStickerAt(int index) {
    if (index >= 0 && index < regStickerPhotos.length) {
      regStickerPhotos.removeAt(index);
    }
  }
  void removeInsurancePhotoAt(int index) {
    if (index >= 0 && index < insurancePhotos.length) {
      insurancePhotos.removeAt(index);
    }
  }

  // ---------- dates ----------
  String? validateYmd(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'car_v_date'.tr;

    try {
      final d = DateFormat('yyyy-MM-dd').parseStrict(s);

      // compare date-only (ignore time)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (d.isBefore(today)) {
        return 'v_lic_exp_past'.tr; // 👈 new i18n key below
      }
      return null;
    } catch (_) {
      return 'car_v_date'.tr;
    }
  }


  // VIEW calls this validator for year
  String? validateYear(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'car_v_year'.tr;
    final y = int.tryParse(s);
    final now = DateTime.now().year;
    if (y == null || y < 1980 || y > now + 1) return 'car_v_year'.tr;
    return null;
  }

  Future<void> chooseDate(TextEditingController ctrl, BuildContext ctx) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime initial;
    try {
      initial = DateFormat('yyyy-MM-dd').parseStrict(ctrl.text);
    } catch (_) {
      initial = today;
    }

    final d = await showDatePicker(
      context: ctx,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,                 // 👈 no past dates
      lastDate: DateTime(now.year + 20),
    );

    if (d != null) {
      ctrl.text = DateFormat('yyyy-MM-dd').format(d);
    }
  }


  // ---------- bottom-sheet pickers (VIEW calls these) ----------
  Future<void> pickFromList(
      BuildContext ctx,
      List<String> items,
      TextEditingController ctrl,
      ) async {
    final chosen = await showModalBottomSheet<String>(
      context: ctx,
      builder: (sheetCtx) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E7EB), // subtle grey; or leave null for theme
          ),
          itemBuilder: (_, i) => ListTile(
            title: Text(items[i]),
            onTap: () => Navigator.of(sheetCtx).pop(items[i]),
            dense: true,
          ),
        ),
      ),
    );

    if (chosen != null && chosen.isNotEmpty) {
      ctrl.text = chosen;
      if (ctrl == vehicleTypeCtrl) {
        onVehicleTypeSelected(chosen);
      }
    }
  }


  Future<void> pickVehicleType(BuildContext ctx) async {
    if (isLoadingTypes.value) return;
    if (services.isEmpty) await loadVehicleTypesAndServices();
    if (services.isEmpty) return;

    final names = services.map((e) => e.name).toList();

    double initialFactor(BuildContext c, int count) {
      final f = count * 0.10; // ≈ one row = 10% height
      return f.clamp(0.25, 0.85);
    }

    final chosen = await showModalBottomSheet<String>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        final init = initialFactor(sheetCtx, names.length);
        return DraggableScrollableSheet(
          initialChildSize: (init - 0.05).clamp(0.25, 0.90),
          minChildSize: 0.25,
          maxChildSize: 0.90,
          expand: false,
          builder: (c, scrollCtrl) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SafeArea(
              top: false,
              child: ListView.separated(
                controller: scrollCtrl,
                itemCount: names.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => ListTile(
                  title: Text(names[i]),
                  onTap: () => Navigator.of(sheetCtx).pop(names[i]),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (chosen != null && chosen.isNotEmpty) {
      vehicleTypeCtrl.text = chosen;
      onVehicleTypeSelected(chosen);
    }
  }

  // ---------- helpers for ISO dates ----------
  String _toIsoFromYmd(String ymd) {
    final d = DateFormat('yyyy-MM-dd').parseUtc(ymd); // midnight UTC
    final utcMidnight = DateTime.utc(d.year, d.month, d.day);
    return utcMidnight.toIso8601String(); // e.g. 2027-10-10T00:00:00.000Z
  }

  String _resolveDobIso() {
    // Accept either ISO or yyyy-MM-dd in basePayload['dob']
    final raw = (basePayload['dob'] ?? '').toString();
    if (raw.isEmpty) return '1997-10-10T00:00:00.000Z';
    if (raw.contains('T')) return raw; // already ISO
    return _toIsoFromYmd(raw);
  }

  // ---------- validation before call ----------
  bool _validateUploads() {
    if (vehiclePhotos.isEmpty) {
      showErrorSnackbar('car_v_photo'.tr);
      return false;
    }
    if (regStickerPhotos.isEmpty) {
      showErrorSnackbar('car_v_reg'.tr);
      return false;
    }

    return true;
  }

  // ---------- submit -> POST /v1/user/create-driver ----------
// ---------- submit ----------
  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!_validateUploads()) return;

    isSubmitting.value = true;
    try {
      // Decide flow based on the flag (works even if you didn't store it as a field)
      final fromAddVehicle =
          (Get.arguments?['fromAddVehicle'] as bool?) ?? false;

      if (fromAddVehicle) {
        // Validate required uploads for add-vehicle
        if (regStickerPhotos.isEmpty) {
          showErrorSnackbar('car_v_reg'.tr);
          isSubmitting.value = false;
          return;
        }
        if (vehiclePhotos.isEmpty) {
          showErrorSnackbar('car_v_photo'.tr);
          isSubmitting.value = false;
          return;
        }

        // 1) Ensure URLs (upload local files first; keep http URLs as-is)
        final vehiclePhotoUrls  = await _ensureUrls(vehiclePhotos.toList());
        final regStickerUrl     = await _ensureUrl(regStickerPhotos.first);
        final insuranceUrl      = insurancePhotos.isNotEmpty
            ? await _ensureUrl(insurancePhotos.first)
            : null;

        // 2) Build payload with URLs
        final payload = _buildAddNewVehicleJsonFromUrls(
          vehiclePhotoUrls: vehiclePhotoUrls,
          regStickerUrl: regStickerUrl,
          insuranceUrl: insuranceUrl,
        );

        // 3) Debug prints you asked for
        print('➡️ [AddVehicle] Request payload: $payload');

        try {
          final res = await _addVehicleSvc.addNewVehicle(payload);
          print('✅ [AddVehicle] Success: $res');
          Get.back(result: true); // refresh caller
        } catch (e) {
          print('❌ [AddVehicle] Error: $e');
          showErrorSnackbar(e.toString());
        } finally {
          isSubmitting.value = false;
        }
        return;
      }


      // ---- Original create-driver multipart flow (unchanged) ----
      final address = {
        'street': basePayload['street'] ?? '',
        'apartment': basePayload['apartment'] ?? '',
        'city': basePayload['city'] ?? '',
        'state': basePayload['state'] ?? '',
        'zipcode': basePayload['zip'] ?? basePayload['zipcode'] ?? '',
        'country': basePayload['country'] ?? '',
      };

      final rider = {
        'licenseNumber': basePayload['licenseNumber'] ?? '',
        'licenseExpiry': basePayload['licenseExpiry'] ?? '',
        'licenseCategory': basePayload['licenseCategory'] ?? 'Professional',
      };

      final vehicle = {
        'vehicleNumber': vehicleNumberCtrl.text.trim(),
        'vehicleCategory': 'EMERGENCY',
        'vehicleType': vehicleTypeCtrl.text.trim(),
        'brandAndModel': brandModelCtrl.text.trim(),
        'manufacturingYear': yearCtrl.text.trim(),
        'insuranceProvider': insProviderCtrl.text.trim(),
        'insuranceExpiryDate': _toIsoFromYmd(insExpiryCtrl.text.trim()),
        'fitnessCertExpiryDate': _toIsoFromYmd(fitnessExpiryCtrl.text.trim()),
        'roadPermitExpiryDate': _toIsoFromYmd(roadPermitExpiryCtrl.text.trim()),
        'emissionTestStatus': emissionStatusCtrl.text.trim(),
        'additionalServices': getSelectedServices(),
      };

      await _createSvc.createDriver(
        // ---- simple text fields ----
        ext: (basePayload['ext'] ?? '880').toString(),
        phone: (() {
          final p = (basePayload['phone'] ?? '').toString().trim();
          return p.isEmpty ? null : p;
        })(),
        email: (() {
          final e = (basePayload['email'] ?? '').toString().trim();
          return e.isEmpty ? null : e;
        })(),
        fullname: (basePayload['fullname'] ?? '').toString(),
        dobIso: _resolveDobIso(),
        gender: (basePayload['gender'] ?? 'MALE').toString(),
        bloodgroup: (basePayload['bloodgroup'] ?? '').toString(),
        password: (basePayload['password'] ?? '').toString(),

        // ---- nested json fields ----
        address: address,
        rider: rider,
        vehicle: vehicle,

        // ---- single-file fields (nullable) ----
        profilePhotoPath: profilePhotoPath.isEmpty ? null : profilePhotoPath,
        licenseFrontPath: licenceFrontPath.isEmpty ? null : licenceFrontPath,
        licenseBackPath: licenceBackPath.isEmpty ? null : licenceBackPath,

        // ---- multi-file fields (≤ 5 each; we send 1 for sticker/insurance) ----
        vehiclePhotos: vehiclePhotos.toList(),
        vehicleStickerPhotos: regStickerPhotos.toList(),
        vehicleInsurancePhotos: insurancePhotos.toList(),
      );

      // Navigate as before after create-driver success
      Get.offAllNamed(
        Routes.profileCreating,
        arguments: {
          'authChannel': authChannel, // 'email' | 'phone'
          'email': email,
          'ext': ext,
          'phone': phone,
          'password': password,
        },
      );
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }


  @override
  void onInit() {
    super.onInit();
    loadVehicleTypesAndServices();
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
    _debounce?.cancel();
    super.onClose();
  }



  /// Returns a single URL: if local path => upload; if already URL => return as-is.
  Future<String> _ensureUrl(String path) async {
    if (path.startsWith('http')) return path;
    final uploader = SingleFileUploadService();
    return uploader.upload(File(path));
  }

  /// Returns list of URLs: upload local paths; keep existing URLs.
  Future<List<String>> _ensureUrls(List<String> paths) async {
    if (paths.isEmpty) return const [];
    // If *all* are already URLs, just return them (no network)
    final allAreUrls = paths.every((p) => p.startsWith('http'));
    if (allAreUrls) return paths;

    // Otherwise upload only local ones
    final locals = paths.where((p) => !p.startsWith('http')).map((p) => File(p)).toList();
    final urlsFromUpload = await MultiFileUploadService().uploadMany(locals);

    // Stitch back preserving order: uploaded URLs for locals, original URLs for already-URL entries
    final result = <String>[];
    int uploadIdx = 0;
    for (final p in paths) {
      if (p.startsWith('http')) {
        result.add(p);
      } else {
        result.add(urlsFromUpload[uploadIdx++]);
      }
    }
    return result;
  }

  /// Builds the final JSON for addNewVehicle given URL values.
  Map<String, dynamic> _buildAddNewVehicleJsonFromUrls({
    required List<String> vehiclePhotoUrls,
    required String regStickerUrl,
    String? insuranceUrl,
  }) {
    return {
      "vehicleNumber": vehicleNumberCtrl.text.trim(),
      "vehicleCategory": "EMERGENCY",
      "vehicleType": vehicleTypeCtrl.text.trim(),
      "brandAndModel": brandModelCtrl.text.trim(),
      "manufacturingYear": yearCtrl.text.trim(),
      "insuranceProvider": insProviderCtrl.text.trim(),
      "insuranceExpiryDate": _toIsoFromYmd(insExpiryCtrl.text.trim()),
      "fitnessCertExpiryDate": _toIsoFromYmd(fitnessExpiryCtrl.text.trim()),
      "roadPermitExpiryDate": _toIsoFromYmd(roadPermitExpiryCtrl.text.trim()),
      "emissionTestStatus": emissionStatusCtrl.text.trim(),
      "additionalServices": getSelectedServices(),
      "vehiclePhotos": vehiclePhotoUrls,
      "vehicleInsurance": insuranceUrl,               // nullable → removed below if null
      "vehicleRegistrationSticker": regStickerUrl,    // required
    }..removeWhere((k, v) => v == null);
  }


}
