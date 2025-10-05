import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../utils/snackbar_helper.dart';

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

  // Contact (API requires either phone or email; optional to collect both)
  final extCtrl   = TextEditingController(text: '880'); // default BD dial code
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  // DOB text controller (shown as yyyy-MM-dd, sent as ISO)
  final dobTextCtrl = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Selections
  final dob = Rxn<DateTime>();
  final gender = RxString('');      // 'male' | 'female' | 'others' from UI
  final bloodGroup = RxString('');
  final country = RxString('');

  // Password visibility
  final hidePassword = true.obs;
  final hideConfirm = true.obs;

  // Photo (local path only; we won’t upload here)
  final photoPath = ''.obs;

  // Legacy/compat
  final photoUrl = ''.obs;
  final isUploadingPhoto = false.obs;

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
    final parts = input.split('-');
    if (parts.length == 3) {
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (year != null && month != null && day != null) {
        try {
          final candidate = DateTime(year, month, day);
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

  String _normalizeGender(String raw) {
    final s = raw.trim().toUpperCase();
    if (s == 'MALE' || s == 'FEMALE' || s == 'OTHER') return s;
    if (s == 'M' || s == 'MALE') return 'MALE';
    if (s == 'F' || s == 'FEMALE' || s == 'WOMAN') return 'FEMALE';
    if (s == 'OTHERS' || s == 'OTHER') return 'OTHER';
    return 'OTHER';
  }

  String? validatePhoto() =>
      photoPath.value.isEmpty ? 'profile_photo_required'.tr : null;

  /// on DOB manual input (no normalization)
  void onDobTextChanged(String v) {
    if (_isProgrammaticDobEdit) return;
    final t = v.trim();
    if (t.isEmpty) {
      dob.value = null;
    } else {
      dob.value = _tryParseFlexible(t);
    }
    formKey.currentState?.validate();
  }

  /// Set DOB from picker and format text once
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

    if (result != null) setDob(result);
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
                        result: selected.value.isNotEmpty
                            ? selected.value
                            : null),
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

  /// Pick photo (do NOT upload here)
  Future<void> pickPhoto() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (res != null && res.files.single.path != null) {
      final path = res.files.single.path!;
      photoPath.value = path;
    }
  }

  // Validators
  String? _req(String? v, String key) =>
      (v == null || v.trim().isEmpty) ? key.tr : null;

  String? validateFullName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'validation_full_name'.tr;         // required
    if (s.runes.length < 3) return 'validation_name_min3'.tr; // at least 3 chars
    return null;
  }


  String? validateDOB() {
    final raw = dobTextCtrl.text.trim();
    if (raw.isEmpty) return 'validation_dob'.tr; // required

    // allow YYYY-M-D or YYYY-MM-DD (hyphen only)
    final looksRight = RegExp(r'^\d{4}-\d{1,2}-\d{1,2}$').hasMatch(raw);
    final parsed = looksRight ? _tryParseFlexible(raw) : null;
    if (parsed == null) return 'validation_invalid_format'.tr;

    // age 10–100
    final now = DateTime.now();
    var age = now.year - parsed.year;
    if (now.month < parsed.month ||
        (now.month == parsed.month && now.day < parsed.day)) {
      age--;
    }
    if (age < 10 || age > 100) return 'validation_dob_range'.tr;

    // normalize text to YYYY-MM-DD and sync state
    final normalized = _fmt(parsed); // zero-padded month/day
    if (dobTextCtrl.text != normalized) {
      _isProgrammaticDobEdit = true;
      dobTextCtrl
        ..text = normalized
        ..selection = TextSelection.collapsed(offset: normalized.length);
      _isProgrammaticDobEdit = false;
    }
    dob.value = parsed;
    return null;
  }


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

  String? validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null; // optional
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
    return ok ? null : 'validation_email'.tr;
  }

  String? validatePhone(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null; // optional
    final ok = RegExp(r'^\d{6,15}$').hasMatch(s);
    return ok ? null : 'validation_phone'.tr;
  }

  /// Build payload with API exact keys/format
  Map<String, dynamic> toPayload() => {
    // Scalars expected by API
    'fullname': fullNameCtrl.text.trim(),
    'dob': dob.value?.toUtc().toIso8601String(), // ISO
    'gender': _normalizeGender(gender.value),     // MALE/FEMALE/OTHER
    'bloodgroup': bloodGroup.value,
    'password': passwordCtrl.text,

    // Contact
    'ext': extCtrl.text.trim(),
    'phone': phoneCtrl.text.trim(),
    'email': emailCtrl.text.trim(),

    // Address parts; Car step will compose the JSON string
    'street': streetCtrl.text.trim(),
    'apartment': apartmentCtrl.text.trim(),
    'city': cityCtrl.text.trim(),
    'state': stateCtrl.text.trim(),
    'zipcode': zipCtrl.text.trim(), // exact key
    'country': country.value,
  };

  void submit() {
    final errors = <String?>[
      validatePhoto(),
      validateDOB(),
      validateGender(),
      validateBlood(),
      validateCountry(),
      validateEmail(emailCtrl.text),
      validatePhone(phoneCtrl.text),
    ].whereType<String>().toList();


    // Require at least one of phone or email
    final hasPhone = phoneCtrl.text.trim().isNotEmpty;
    final hasEmail = emailCtrl.text.trim().isNotEmpty;
    if (!hasPhone && !hasEmail) {
      errors.add('Provide phone or email'); // localizable if you want
    }

    if (!(formKey.currentState?.validate() ?? false) || errors.isNotEmpty) {
      final msg = errors.isEmpty ? 'invalid_msg'.tr : errors.join('\n');
      showErrorSnackbar(msg); // reuse your custom top snackbar
      return;
    }


    final payload = toPayload();

    // ➜ Go to Licence Details page with everything needed
    Get.toNamed(
      Routes.licenceDetails,
      arguments: {
        'payload': payload,
        'photoPath': photoPath.value,
      },
    );
  }

  @override
  void onInit() {
    super.onInit();

    // Prefill from Verify → commonArgs (ext/phone/email)
    final args = Get.arguments as Map<dynamic, dynamic>?;
    final ext   = (args?['ext'] as String?)?.trim();
    final phone = (args?['phone'] as String?)?.trim();
    final email = (args?['email'] as String?)?.trim();
    if (ext != null && ext.isNotEmpty) extCtrl.text = ext;
    if (phone != null && phone.isNotEmpty) phoneCtrl.text = phone;
    if (email != null && email.isNotEmpty) emailCtrl.text = email;

    dobTextCtrl.addListener(() => onDobTextChanged(dobTextCtrl.text));
    fullNameCtrl.addListener(() => formKey.currentState?.validate());
    passwordCtrl.addListener(() => formKey.currentState?.validate());
    confirmPasswordCtrl.addListener(() => formKey.currentState?.validate());
    zipCtrl.addListener(() => formKey.currentState?.validate());
    stateCtrl.addListener(() => formKey.currentState?.validate());
    cityCtrl.addListener(() => formKey.currentState?.validate());
    streetCtrl.addListener(() => formKey.currentState?.validate());
    apartmentCtrl.addListener(() => formKey.currentState?.validate());
    extCtrl.addListener(() => formKey.currentState?.validate());
    phoneCtrl.addListener(() => formKey.currentState?.validate());
    emailCtrl.addListener(() => formKey.currentState?.validate());
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
    extCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
