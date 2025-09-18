import 'package:ambufast_driver/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization/app_translations.dart';

Future<Locale> _loadInitialLocale() async {
  final sp = await SharedPreferences.getInstance();
  final code = sp.getString('lang_code') ?? 'en';
  return code == 'bn' ? const Locale('bn', 'BD') : const Locale('en', 'US');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialLocale = await _loadInitialLocale();
  await dotenv.load(fileName: ".env");
  runApp(AmbuFastApp(initialLocale: initialLocale));
}

class AmbuFastApp extends StatelessWidget {
  final Locale initialLocale;
  const AmbuFastApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AmbuFast',
          translations: AppTranslations(),
          locale: initialLocale, // ← uses saved locale
          fallbackLocale: const Locale('en', 'US'),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,

          // 👇 theme only for screen background
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFFAFFFB), // your bg color
          ),
        );
      },
    );
  }
}

