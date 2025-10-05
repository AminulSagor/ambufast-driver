import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateSuccessPopup {
  static Future<void> showAndGo({
    Duration delay = const Duration(seconds: 2),
    String profileDetailsRoute = '/profile-details',
  }) async {
    var didNavigate = false;

    void _go() {
      if (didNavigate) return;
      didNavigate = true;
      if (Get.isDialogOpen == true) Get.back(); // ✅ fix
      Get.toNamed(profileDetailsRoute);
    }

    final timer = Timer(delay, _go);

    await Get.dialog(
      const _SuccessCard(),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(.25),
    ).whenComplete(() {
      timer.cancel();
      _go();
    });
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 0.86.sw,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔄 Use your PNG asset instead of the drawn icon
              SizedBox(
                width: 84.w,
                height: 84.w,
                child: Image.asset(
                  'assets/icon/update_icon.png', // <-- your path
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  semanticLabel: 'success_icon',
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'update_success_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111111),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'update_success_body'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF535862),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
