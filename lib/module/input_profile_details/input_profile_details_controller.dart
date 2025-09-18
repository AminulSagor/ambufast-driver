import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputProfileDetailsController extends GetxController {
  // Text fields
  final fullNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final apartmentCtrl = TextEditingController();

  // 👇 NEW: text controller for DOB
  final dobTextCtrl = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Selections
  final dob = Rxn<DateTime>();
  final gender = RxString(''); // 'male' | 'female' | 'others'
  final bloodGroup = RxString('');
  final country = RxString('');

  // Password visibility
  final hidePassword = true.obs;
  final hideConfirm = true.obs;

  // Photo
  final photoPath = RxString('');

  // Internal flag to avoid feedback loops when we update dobTextCtrl programmatically
  bool _isProgrammaticDobEdit = false;

  // Helpers
  List<String> get bloodGroupList =>
      ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  List<String> get countryList => [
    'Bangladesh',
    'India',
    'Pakistan',
    'Nepal',
    'Bhutan',
    'Sri Lanka',
    'USA',
    'UK',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Japan'
  ];

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  DateTime? _tryParseFlexible(String input) {
    // expects yyyy-MM-dd (flexible 1–2 digits for month/day ok)
    final parts = input.split('-');
    if (parts.length == 3) {
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (year != null && month != null && day != null) {
        try {
          final candidate = DateTime(year, month, day);
          // ensure valid calendar date (no 31/04, etc.)
          if (candidate.year == year &&
              candidate.month == month &&
              candidate.day == day) {
            return candidate;
          }
        } catch (_) {}
      }
    }
    return null;
  }
  String? validatePhoto() =>
      photoPath.value.isEmpty ? 'profile_photo_required'.tr : null;
  /// --- on DOB manual input (no normalization) ---
  void onDobTextChanged(String v) {
    if (_isProgrammaticDobEdit) return; // ignore echoes from our own writes

    final t = v.trim();
    if (t.isEmpty) {
      dob.value = null; // allow clearing
    } else {
      // only parse; do NOT set dobTextCtrl.text here
      dob.value = _tryParseFlexible(t);
    }
    formKey.currentState?.validate();
  }

  /// Set DOB from picker and format text once (explicit user action)
  void setDob(DateTime d) {
    dob.value = d;
    final formatted = _fmt(d);
    if (dobTextCtrl.text != formatted) {
      _isProgrammaticDobEdit = true;
      dobTextCtrl
        ..text = formatted
        ..selection = TextSelection.collapsed(offset: formatted.length);
      _isProgrammaticDobEdit = false;
    }
    formKey.currentState?.validate();
  }

  Future<String?> _showSelectBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> items,
    String? current,
    bool enableSearch = false,
  }) async {
    final RxString query = ''.obs;
    final RxString selected = (current ?? '').obs;

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.70,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCDD2D6),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                if (enableSearch) ...[
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (v) => query.value = v,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Expanded(
                  child: Obx(() {
                    final q = query.value.toLowerCase();
                    final filtered = q.isEmpty
                        ? items
                        : items
                        .where((e) => e.toLowerCase().contains(q))
                        .toList();

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final val = filtered[i];
                        return RadioListTile<String>(
                          value: val,
                          groupValue: selected.value,
                          onChanged: (v) {
                            selected.value = v ?? '';
                            Get.back(result: v);
                          },
                          title:
                          Text(val, style: const TextStyle(fontSize: 16)),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF43023),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Get.back(
                        result:
                        selected.value.isNotEmpty ? selected.value : null),
                    child: const Text(
                      'done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickDOB(BuildContext context) async {
    final now = DateTime.now();
    final first = DateTime(now.year - 100, 1, 1);
    final last = DateTime(now.year - 10, now.month, now.day);
    final initial = dob.value ?? DateTime(now.year - 20, now.month, now.day);

    final result = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );

    if (result != null) {
      setDob(result); // <- format once on pick
    }
  }

  Future<void> chooseBloodGroup(BuildContext context) async {
    final selected = await _showSelectBottomSheet(
      context: context,
      title: 'choose'.tr,
      items: bloodGroupList,
      current: bloodGroup.value,
    );
    if (selected != null && selected.isNotEmpty) {
      bloodGroup.value = selected;
      formKey.currentState?.validate();
    }
  }

  Future<void> chooseCountry(BuildContext context) async {
    final selected = await _showSelectBottomSheet(
      context: context,
      title: 'choose'.tr,
      items: countryList,
      current: country.value,
      enableSearch: true,
    );
    if (selected != null && selected.isNotEmpty) {
      country.value = selected;
      formKey.currentState?.validate();
    }
  }

  Future<void> pickPhoto() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (res != null && res.files.single.path != null) {
      photoPath.value = res.files.single.path!;
    }
  }

  /// --- Validators ---
  String? _req(String? v, String key) =>
      (v == null || v.trim().isEmpty) ? key.tr : null;

  String? validateFullName(String? v) => _req(v, 'validation_full_name');

  // DOB required; make it optional by returning null when dob == null.
  String? validateDOB() => dob.value == null ? 'validation_dob'.tr : null;

  String? validateGender() =>
      gender.value.isEmpty ? 'validation_gender'.tr : null;

  String? validateBlood() =>
      bloodGroup.value.isEmpty ? 'validation_blood'.tr : null;

  String? validatePassword(String? v) {
    if (v == null || v.length < 6) return 'validation_password'.tr;
    return null;
  }

  String? validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'validation_confirm_password'.tr;
    if (v != passwordCtrl.text) return 'validation_password_mismatch'.tr;
    return null;
  }

  String? validateCountry() =>
      country.value.isEmpty ? 'validation_country'.tr : null;
  String? validateZip(String? v) => _req(v, 'validation_zip');
  String? validateState(String? v) => _req(v, 'validation_state');
  String? validateCity(String? v) => _req(v, 'validation_city');
  String? validateStreet(String? v) => _req(v, 'validation_street');

  Map<String, dynamic> toPayload() => {
    'fullName': fullNameCtrl.text.trim(),
    'dob': dob.value?.toIso8601String(),
    'gender': gender.value,
    'bloodGroup': bloodGroup.value,
    'password': passwordCtrl.text,
    'country': country.value,
    'zip': zipCtrl.text.trim(),
    'state': stateCtrl.text.trim(),
    'city': cityCtrl.text.trim(),
    'street': streetCtrl.text.trim(),
    'apartment': apartmentCtrl.text.trim(),
    'photoPath': photoPath.value,
  };

  void submit() {
    final errors = [
      validatePhoto(),
      validateDOB(),
      validateGender(),
      validateBlood(),
      validateCountry(),
    ].whereType<String>().toList();

    if (!(formKey.currentState?.validate() ?? false) || errors.isNotEmpty) {
      Get.snackbar('invalid_title'.tr, 'invalid_msg'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final payload = toPayload();
    Get.toNamed('/profile-address', arguments: payload);
  }

  @override
  void onInit() {
    super.onInit();

    // Keep parsed DOB in sync with what user types (no normalization)
    dobTextCtrl.addListener(() => onDobTextChanged(dobTextCtrl.text));

    // Other live validations
    fullNameCtrl.addListener(() => formKey.currentState?.validate());
    passwordCtrl.addListener(() => formKey.currentState?.validate());
    confirmPasswordCtrl.addListener(() => formKey.currentState?.validate());
    zipCtrl.addListener(() => formKey.currentState?.validate());
    stateCtrl.addListener(() => formKey.currentState?.validate());
    cityCtrl.addListener(() => formKey.currentState?.validate());
    streetCtrl.addListener(() => formKey.currentState?.validate());
    apartmentCtrl.addListener(() => formKey.currentState?.validate());
  }

  @override
  void onClose() {
    dobTextCtrl.dispose();
    fullNameCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    zipCtrl.dispose();
    stateCtrl.dispose();
    cityCtrl.dispose();
    streetCtrl.dispose();
    apartmentCtrl.dispose();
    super.onClose();
  }
}
