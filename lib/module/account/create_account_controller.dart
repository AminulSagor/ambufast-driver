// lib/modules/account/create_account_controller.dart

import 'package:ambufast_driver/module/account/profile_creating_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../combine_service/auth_service.dart';
import '../../utils/snackbar_helper.dart';



class CreateAccountController extends GetxController {
  CreateAccountController({AuthService? auth}) : _auth = auth ?? AuthService();
  final AuthService _auth;

  // ===== Payload from Verify screen =====
  String? ext;
  String? phone;
  String? email;

  // ===== Form =====
  final formKey = GlobalKey<FormState>();
  final confirmFieldKey = GlobalKey<FormFieldState<String>>();
  late final VoidCallback _focusListener;

  // Text fields
  final fullNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl  = TextEditingController();

  /// NEW: text field for DOB (dd-MM-yyyy). Kept in sync with [dob].
  final dobTextCtrl  = TextEditingController();

  // Reactive fields
  final dob        = Rxn<DateTime>();   // <-- source of truth for DOB
  final gender     = ''.obs;            // 'male' | 'female' | 'others'
  final bloodGroup = ''.obs;

  // UI state
  final obscurePass    = true.obs;
  final obscureConfirm = true.obs;
  final canSubmit      = false.obs;
  final isSubmitting   = false.obs;

  @override
  void onInit() {
    super.onInit();

    // read args from Verify screen
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    ext   = args['ext'] as String?;
    phone = args['phone'] as String?;
    email = args['email'] as String?;

    fullNameCtrl.addListener(_recompute);
    passwordCtrl.addListener(() {
      _recompute();
      confirmFieldKey.currentState?.validate();
    });

    // OPTIONAL: keep confirm field’s own error state snappy while typing
    confirmCtrl.addListener(() {
      _recompute();
      confirmFieldKey.currentState?.validate();
    });

    // Keep typed DOB in sync with parsed DateTime
    dobTextCtrl.addListener(_onDobTextChanged);

    _focusListener = () {
      // revalidate confirm (cross-field dependency) + whole form recompute
      confirmFieldKey.currentState?.validate();
      _recompute();
    };
    FocusManager.instance.addListener(_focusListener);
  }

  @override
  void onClose() {
    FocusManager.instance.removeListener(_focusListener);
    fullNameCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    dobTextCtrl.dispose();
    super.onClose();
  }

  // ===== Validation helpers =====
  bool get _isDobValid => dob.value != null;

  bool get isFormValid =>
      fullNameCtrl.text.trim().isNotEmpty &&
          _isDobValid &&
          gender.value.isNotEmpty &&
          bloodGroup.value.isNotEmpty &&
          passwordCtrl.text.isNotEmpty &&
          confirmCtrl.text.isNotEmpty &&
          passwordCtrl.text == confirmCtrl.text &&
          passwordCtrl.text.length >= 6;

  void _recompute() {
    // Run form validators for text fields
    final ok = formKey.currentState?.validate() ?? false;

    final extraOk = _isDobValid &&
        gender.value.isNotEmpty &&
        bloodGroup.value.isNotEmpty &&
        passwordCtrl.text == confirmCtrl.text &&
        passwordCtrl.text.length >= 6;

    canSubmit.value = ok && extraOk;
  }

  // ===== DOB helpers =====

  /// Accepts "dd-MM-yyyy" or "dd/MM/yyyy".
  DateTime? _tryParseDob(String? input) {
    if (input == null) return null;
    final s = input.trim();
    if (s.isEmpty) return null;

    final m = RegExp(r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})$').firstMatch(s);
    if (m == null) return null;

    final day   = int.tryParse(m.group(1)!);
    final month = int.tryParse(m.group(2)!);
    final year  = int.tryParse(m.group(3)!);
    if (day == null || month == null || year == null) return null;

    // Construct & validate correct calendar date
    final candidate = DateTime(year, month, day);
    final isSame =
        candidate.year == year && candidate.month == month && candidate.day == day;
    if (!isSame) return null;

    // Must not be in the future
    final now = DateTime.now();
    if (candidate.isAfter(DateTime(now.year, now.month, now.day))) return null;

    // Optional: minimum age 18 (kept because your picker defaulted to 18)
    final age = _ageYears(candidate, now);
    if (age < 18) return null;

    return candidate;
  }

  int _ageYears(DateTime birth, DateTime now) {
    var years = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      years--;
    }
    return years;
  }

  String _fmtDob(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year.toString()}';

  void _onDobTextChanged() {
    // Don’t loop: only parse from text to Rx
    final parsed = _tryParseDob(dobTextCtrl.text);
    dob.value = parsed; // can be null, that’s fine; recompute handles it
    _recompute();
  }

  /// Public API used by calendar picker: sets both fields.
  void setDob(DateTime d) {
    dob.value = d;
    final newText = _fmtDob(d);
    if (dobTextCtrl.text != newText) {
      dobTextCtrl.text = newText; // triggers listener but with same parsed value
      dobTextCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: dobTextCtrl.text.length),
      );
    }
    _recompute();
  }

  // ===== Pickers =====
  Future<void> pickDob(BuildContext context) async {
    final now = DateTime.now();
    final initial = dob.value ??
        DateTime(now.year - 18, now.month, now.day);
    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (selected != null) {
      setDob(selected);
    }
  }

  void chooseGender(String value) {
    gender.value = value; // keep 'male' | 'female' | 'others'
    _recompute();
  }

  Future<void> chooseBloodGroup(BuildContext context) async {
    final List<String> items = ['A+','A-','B+','B-','O+','O-','AB+','AB-'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4.h),
              Container(
                width: 40.w, height: 5.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCDD2D6),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(height: 12.h),
              Text('choose'.tr,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 8.h),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final bg = items[i];
                    return RadioListTile<String>(
                      value: bg,
                      groupValue: bloodGroup.value,
                      onChanged: (v) => Get.back(result: v),
                      title: Text(bg, style: TextStyle(fontSize: 16.sp)),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity, height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43023),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () => Get.back(
                    result: bloodGroup.value.isNotEmpty ? bloodGroup.value : null,
                  ),
                  child: Text(
                    'done'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null && selected.isNotEmpty) {
      bloodGroup.value = selected;
      _recompute();
    }
  }

  // ===== Actions =====
  void onNext(BuildContext context) {
    if (!(formKey.currentState?.validate() ?? false) || !isFormValid) {
      Get.snackbar(
        'invalid_title'.tr,
        'invalid_msg'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withOpacity(.75),
        colorText: Colors.white,
      );
      return;
    }
    _showTermsSheet(context);
  }

  void _showTermsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4.h),
              Container(
                width: 40.w, height: 5.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF535353),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(height: 20.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 18.sp, color: Colors.black87, height: 1.4),
                  children: [
                    TextSpan(text: 'terms_pre_a'.tr),
                    TextSpan(
                      text: 'terms_pre_b'.tr,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: double.infinity, height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43023),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: _submit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => isSubmitting.value
                          ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const SizedBox()),
                      Obx(() => SizedBox(width: isSubmitting.value ? 10 : 0)),
                      Text(
                        'agree_continue'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    try {
      final d = dob.value!; // guaranteed by validation
      final payload = <String, dynamic>{
        'ext'       : ext,
        'phone'     : phone,
        'email'     : email,
        'fullname'  : fullNameCtrl.text.trim(),
        'dob'       : DateTime.utc(d.year, d.month, d.day).toIso8601String(),
        'gender'    : gender.value.toUpperCase(), // MALE/FEMALE/OTHERS
        'bloodgroup': bloodGroup.value,           // e.g. "B+"
        'password'  : passwordCtrl.text,
      };

      await _auth.createUser(payload);

      // ---- Build args to pass forward (email/phone + password) ----
      final usingEmail = (email != null && email!.trim().isNotEmpty);
      final nextArgs = <String, dynamic>{
        'authChannel': usingEmail ? 'email' : 'phone',
        if (usingEmail)
          'email': email
        else ...{
          'ext': ext,
          'phone': phone,
        },
        'password': passwordCtrl.text, // pass the password
      };

      Get.back(); // close terms sheet

      // Navigate to the next step with credentials
      Get.to(() => const ProfileCreatingView(), arguments: nextArgs);

      // Optional: clear secrets locally after handing off
      passwordCtrl.clear();
      confirmCtrl.clear();
    } catch (e) {
      Get.back(); // ensure sheet is closed on error too
      showErrorSnackbar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isSubmitting.value = false;
    }
  }

}
