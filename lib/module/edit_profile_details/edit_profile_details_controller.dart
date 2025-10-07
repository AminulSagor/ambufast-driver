// lib/edit_profile_details/edit_profile_details_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:ambufast_driver/module/edit_profile_details/update_profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../combine_service/single_file_upload_service.dart';
import '../../dialog_box/update_success_dialogbox.dart';
import '../../storage/token_storage.dart';
import '../../combine_service/profile_service.dart';


class EditProfileDetailsController extends GetxController {
  // ---- Form & inputs ----
  final formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameCtrl;
  late final TextEditingController dobCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController streetCtrl;
  late final TextEditingController aptCtrl;
  late final TextEditingController cityCtrl;
  late final TextEditingController zipCtrl;

  // ---- Dropdowns ----
  final gender = ''.obs;
  final bloodGroup = ''.obs;
  final state = ''.obs;
  final country = ''.obs;

  // ---- Avatar & DOB ----
  final avatarUrl = ''.obs;
  final localAvatarPath = RxnString();
  final pendingUploadedUrl = ''.obs;
  final dob = Rxn<DateTime>();

  // ---- Options ----
  final genders = const ['Male', 'Female', 'Other'];
  final bloodGroups = const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final states = const [
    'Dhaka','Chattogram','Rajshahi','Khulna','Sylhet','Barishal','Rangpur','Mymensingh'
  ];
  final countries = const ['Bangladesh'];

  // ---- Misc ----
  final isLoading = false.obs;
  final isUploadingAvatar = false.obs;
  final ImagePicker _picker = ImagePicker();
  String? _authToken;
  final _profileService = ProfileService();

  // ---- Realtime validation debounce ----
  Timer? _validateTimer;
  void _validateSoon() {
    _validateTimer?.cancel();
    _validateTimer = Timer(const Duration(milliseconds: 250), () {
      formKey.currentState?.validate();
    });
  }

  void validateNow() => formKey.currentState?.validate();

  @override
  void onInit() {
    super.onInit();

    fullNameCtrl = TextEditingController()..addListener(_validateSoon);

    dobCtrl = TextEditingController()
      ..addListener(() {
        // keep reactive DOB in sync with current text (null when invalid/empty)
        dob.value = _parseDobText(dobCtrl.text);
        _validateSoon();
      });

    emailCtrl  = TextEditingController()..addListener(_validateSoon);
    streetCtrl = TextEditingController()..addListener(_validateSoon);
    aptCtrl    = TextEditingController()..addListener(_validateSoon);
    cityCtrl   = TextEditingController()..addListener(_validateSoon);
    zipCtrl    = TextEditingController()..addListener(_validateSoon);

    _loadAuthToken();
    loadProfile();
  }

  Future<void> _loadAuthToken() async {
    _authToken = await TokenStorage.getAccessToken();
  }

  @override
  void onClose() {
    _validateTimer?.cancel();
    fullNameCtrl.dispose();
    dobCtrl.dispose();
    emailCtrl.dispose();
    streetCtrl.dispose();
    aptCtrl.dispose();
    cityCtrl.dispose();
    zipCtrl.dispose();
    super.onClose();
  }

  // ---- DOB parsing/formatting ----
  DateTime? _parseDobText(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;

    // Accept yyyy-m-d OR d-m-yyyy (single/double digit month/day)
    final ymdFlex = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$');
    final dmyFlex = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$');

    int? y, m, d;
    final a = ymdFlex.firstMatch(t);
    if (a != null) {
      y = int.parse(a.group(1)!);
      m = int.parse(a.group(2)!);
      d = int.parse(a.group(3)!);
    } else {
      final b = dmyFlex.firstMatch(t);
      if (b == null) return null;
      d = int.parse(b.group(1)!);
      m = int.parse(b.group(2)!);
      y = int.parse(b.group(3)!);
    }

    if (m < 1 || m > 12) return null; // ✅ restrict to 12 months
    if (y < 1900 || y > DateTime.now().year) return null;

    final dim = DateUtils.getDaysInMonth(y, m);
    if (d < 1 || d > dim) return null;

    return DateTime(y, m, d);
  }

  String _formatDob(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  // ---- Load initial profile ----
  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final res = await _profileService.getUserInfo(
        profile: true,
        address: true,
        riderinfo: false,
        vehicleinfo: false,
        agentinfo: false,
      );
      final data = res['data'] ?? {};
      final profile = data['profile'] ?? {};
      final addresses = (data['addresses'] ?? []) as List;

      fullNameCtrl.text = (data['fullname'] ?? '').toString();
      emailCtrl.text    = (data['email'] ?? '').toString();

      avatarUrl.value   = (profile['profilephoto'] ?? '').toString();

      final dobParsed = DateTime.tryParse((profile['dob'] ?? '').toString());
      if (dobParsed != null) {
        dob.value = dobParsed;
        dobCtrl.text = _formatDob(dobParsed); // always yyyy-mm-dd
      } else {
        dob.value = null;
        dobCtrl.clear();
      }

      gender.value     = (profile['gender'] ?? 'Male').toString();
      bloodGroup.value = (profile['bloodgroup'] ?? 'A+').toString();

      if (addresses.isNotEmpty) {
        final addr = (addresses.first as Map)
            .map((k, v) => MapEntry(k.toString(), v));
        streetCtrl.text = (addr['street'] ?? '').toString();
        aptCtrl.text    = (addr['apartment'] ?? '').toString();
        cityCtrl.text   = (addr['city'] ?? '').toString();
        state.value     = (addr['state'] ?? states.first).toString();
        zipCtrl.text    = (addr['zipcode'] ?? '').toString();
        country.value   = (addr['country'] ?? countries.first).toString();
      } else {
        state.value = states.first;
        country.value = countries.first;
      }

      localAvatarPath.value = null;
      pendingUploadedUrl.value = '';

      validateNow();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ---- Pickers ----
  Future<void> pickDob(BuildContext context) async {
    final now = DateTime.now();
    final init = dob.value ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      dob.value = picked;
      dobCtrl.text = _formatDob(picked); // keep field in yyyy-mm-dd
      validateNow();
    }
  }

  Future<void> pickPhoto() async {
    try {
      // Let user pick an image
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      // Show the local preview immediately
      localAvatarPath.value = picked.path;

      // Get the token (either from injected _authToken or from storage)
      final token = _authToken ?? await TokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'No access token found.');
        return;
      }

      isUploadingAvatar.value = true;

      // Upload using token-aware service
      final uploader = SingleFileUploadService();

      final uploadedUrl = await uploader.upload(File(picked.path));

      // Success → store URL for later submit
      pendingUploadedUrl.value = uploadedUrl;

      // Optional: show a success toast/snackbar
      Get.snackbar('Uploaded', 'Avatar uploaded successfully.');
      if (kDebugMode) {
        print('✅ Avatar uploaded URL: $uploadedUrl');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Avatar upload error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isUploadingAvatar.value = false;
    }
  }


  // ---- VALIDATION ----
  String? validateRequired(String? v, String label) {
    if (v == null || v.trim().isEmpty) return 'Please enter $label';
    return null;
  }

  String? validateName(String? v) {
    final msg = validateRequired(v, 'full name');
    if (msg != null) return msg;
    final cleaned = v!.trim();
    if (cleaned.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateDOB(String? _) {
    // Parse fresh each time from text field.
    final parsed = _parseDobText(dobCtrl.text);
    if (parsed == null) {
      dob.value = null; // clear stale value so submit won’t send a date
      return 'Please enter a valid date (yyyy-mm-dd)';
    }
    dob.value = parsed;

    final now = DateTime.now();
    final age = now.year - parsed.year -
        ((now.month < parsed.month ||
            (now.month == parsed.month && now.day < parsed.day)) ? 1 : 0);
    if (age < 13) return 'You must be at least 13 years old';
    return null;
  }

  String? validatePhone(String? v) {
    final msg = validateRequired(v, 'phone number');
    if (msg != null) return msg;
    final digits = v!.replaceAll(RegExp(r'[^0-9+]'), '');
    final bd = RegExp(r'^(?:\+?8801[3-9]\d{8}|01[3-9]\d{8})$');
    if (!bd.hasMatch(digits)) return 'Enter a valid Bangladeshi phone number';
    return null;
  }

  String? validateEmailOptional(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null;
    final emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRe.hasMatch(s)) return 'Enter a valid email';
    return null;
  }

  String? validateZip(String? v) {
    final msg = validateRequired(v, 'zip/postal code');
    if (msg != null) return msg;
    if (!RegExp(r'^\d{4,10}$').hasMatch(v!.trim())) {
      return 'Enter a valid zip/postal code';
    }
    return null;
  }

  String? validateSelect(String value, String label) {
    if (value.trim().isEmpty) return 'Please select $label';
    return null;
  }

  // ---- Submit ----
  Future<void> submit() async {
    if (isUploadingAvatar.value) {
      Get.snackbar('Please wait', 'Photo is still uploading…');
      return;
    }
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) return;

    try {
      isLoading.value = true;

      final token = _authToken ?? await TokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found.');
      }

      // Prefer freshly uploaded URL if present.
      final photoUrl = pendingUploadedUrl.value.isNotEmpty
          ? pendingUploadedUrl.value
          : (avatarUrl.value.isNotEmpty ? avatarUrl.value : null);

      final basicInfo = <String, dynamic>{
        'fullname': fullNameCtrl.text.trim(),
        if (dob.value != null) 'dob': _toIsoDateUtcStartOfDay(dob.value!),
        if (gender.value.isNotEmpty) 'gender': gender.value.toUpperCase(),
        if (bloodGroup.value.isNotEmpty) 'bloodgroup': bloodGroup.value,
        if (photoUrl != null) 'profilephoto': photoUrl,
      };

      final addNewAddress = <String, dynamic>{
        'type': 'HOME',
        'street': streetCtrl.text.trim(),
        'apartment': aptCtrl.text.trim().isEmpty ? null : aptCtrl.text.trim(),
        'city': cityCtrl.text.trim(),
        'state': state.value,
        'zipcode': zipCtrl.text.trim(),
        'country': country.value,
      };



      await UpdateProfileService.patchProfile(
        authToken: token,
        basicInfo: basicInfo,
        addNewAddress: addNewAddress,
      );



      if (photoUrl != null) avatarUrl.value = photoUrl;
      localAvatarPath.value = null;
      pendingUploadedUrl.value = '';

      await UpdateSuccessPopup.showAndGo(
        delay: const Duration(seconds: 3),
        profileDetailsRoute: '/profile-details',
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  /// Convert a calendar date to midnight UTC (trailing 'Z'), e.g. 2000-05-05T00:00:00.000Z
  String _toIsoDateUtcStartOfDay(DateTime d) {
    final utcMidnight = DateTime.utc(d.year, d.month, d.day);
    return utcMidnight.toIso8601String();
  }

}
