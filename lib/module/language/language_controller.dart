// lib/modules/language/language_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class LanguageController extends GetxController {
  static const _kLangCode = 'lang_code';

  /// 'en' or 'bn'
  final selectedCode = 'en'.obs;

  @override
  void onInit() {
    _loadSavedLanguage();
    super.onInit();
  }

  Future<void> _loadSavedLanguage() async {
    final sp = await SharedPreferences.getInstance();
    final saved = sp.getString(_kLangCode);
    if (saved != null) {
      selectedCode.value = saved;
      _applyLocale(saved);
    }
  }

  Future<void> select(String code) async {
    selectedCode.value = code;
    _applyLocale(code);
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLangCode, code);
  }

  void _applyLocale(String code) {
    final locale = code == 'bn' ? const Locale('bn', 'BD')
        : const Locale('en', 'US');
    Get.updateLocale(locale);
  }

  /// After user presses Continue
  void continueNext() {
    // Navigate to your launch/home
    Get.offAllNamed(Routes.launch);
  }

  void goBack() => Get.back();
}
