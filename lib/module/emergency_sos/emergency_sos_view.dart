import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'emergency_sos_controller.dart';

const _kBg = Color(0xFFF7FBF8);
const _kCardBorder = Color(0xFFE5E7EB);
const _kTitle = Color(0xFF111827);
const _kNumber = Color(0xFF1F2937);

class EmergencySosView extends GetView<EmergencySosController> {
  const EmergencySosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _kBg,
        foregroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 18.sp),
          onPressed: Get.back,
          tooltip: 'Back',
        ),
        title: Text(
          'emergency_sos_title'.tr, // “Tap Emergency SOS”
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Obx(() {
        final items = controller.contacts;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Center(
            child: Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: items.map((c) => _SosCard(
                asset: c.asset,
                number: c.number,
                onTap: () => controller.call(c.number),
              )).toList(),
            ),
          ),
        );
      }),
    );
  }
}

class _SosCard extends StatelessWidget {
  final String asset;
  final String number;
  final VoidCallback onTap;

  const _SosCard({required this.asset, required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardWidth = (Get.width - 16.w * 2 - 16.w) / 2; // two cards per row
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _kCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(asset, width: 72.w, height: 72.w, fit: BoxFit.contain),
            SizedBox(height: 12.h),
            Text(
              number,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: _kNumber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
