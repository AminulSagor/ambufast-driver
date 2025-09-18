// lib/utils/lang_helper.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LangHelper {
  static bool get isBangla =>
      (Get.locale ?? Get.deviceLocale ?? const Locale('en', 'US'))
          .languageCode ==
          'bn';

  static bool get isEnglish =>
      (Get.locale ?? Get.deviceLocale ?? const Locale('en', 'US'))
          .languageCode ==
          'en';
}
